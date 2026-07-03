// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rrule_picker/rrule_picker.dart';
import 'package:rrule_picker/src/daily.dart';
import 'package:rrule_picker/src/excluded_dates.dart';
import 'package:rrule_picker/src/monthly.dart';
import 'package:rrule_picker/src/weekly.dart';
import 'package:rrule_picker/src/yearly.dart';
import 'package:spot/spot.dart';

import 'helpers.dart';

void main() {
  group(RRulePicker, () {
    setUpAll(() async {
      if (!kIsWeb) {
        await loadAppFonts();
      }
    });

    group('rendering', () {
      testWidgets('renders with default constructor', (tester) async {
        await tester.pumpWrapped(const RRulePicker());

        spot<DropdownButton<RecurrenceType>>().existsOnce();
      });

      testWidgets('renders with initialRRule parameter', (tester) async {
        const rrule = 'RRULE:FREQ=DAILY';

        await tester.pumpWrapped(const RRulePicker(initialRRule: rrule));

        spot<DailyPicker>().existsOnce();
      });

      testWidgets('renders with timeZone parameter', (tester) async {
        await tester.pumpWrapped(const RRulePicker(timeZone: 'Europe/Warsaw'));

        spot<RRulePicker>().existsOnce();
      });

      testWidgets('renders with enableExcludedDates=false', (tester) async {
        await tester.pumpWrapped(const RRulePicker(enableExcludedDates: false));

        spot<ExcludedDates>().doesNotExist();
      });

      testWidgets('renders with onRRuleChanged callback', (tester) async {
        await tester.pumpWrapped(RRulePicker(onRRuleChanged: (_) {}));

        spot<DropdownButton<RecurrenceType>>().existsOnce();
      });

      testWidgets('renders with custom controller', (tester) async {
        final controller = RRulePickerController();

        await tester.pumpWrapped(RRulePicker(controller: controller));

        spot<DropdownButton<RecurrenceType>>().existsOnce();
      });

      testWidgets('renders with custom theme', (tester) async {
        const theme = RRulePickerThemeData(padding: .all(16));

        await tester.pumpWrapped(const RRulePicker(theme: theme));

        spot<DropdownButton<RecurrenceType>>().existsOnce();
      });

      testWidgets('renders with all parameters set', (tester) async {
        const theme = RRulePickerThemeData(padding: .all(16));
        final controller = RRulePickerController();

        await tester.pumpWrapped(
          RRulePicker(
            initialRRule: 'RRULE:FREQ=DAILY',
            timeZone: 'Europe/Warsaw',
            enableExcludedDates: true,
            onRRuleChanged: (_) {},
            controller: controller,
            theme: theme,
          ),
        );

        spot<DropdownButton<RecurrenceType>>().existsOnce();
      });
    });

    group('initial state', () {
      testWidgets('displays with empty recurrence', (tester) async {
        await tester.pumpWrapped(const RRulePicker(initialRRule: ''));

        spot<DropdownButton<RecurrenceType>>()
            .whereWidgetProp(
              widgetProp('value', (widget) => widget.value),
              (value) => value == .never,
            )
            .existsOnce();
      });

      testWidgets('displays with DAILY recurrence', (tester) async {
        const rrule = 'RRULE:FREQ=DAILY';

        await tester.pumpWrapped(const RRulePicker(initialRRule: rrule));

        spot<DropdownButton<RecurrenceType>>()
            .whereWidgetProp(
              widgetProp('value', (widget) => widget.value),
              (value) => value == .daily,
            )
            .existsOnce();
      });

      testWidgets('displays with WEEKLY recurrence', (tester) async {
        const rrule = 'RRULE:FREQ=WEEKLY';

        await tester.pumpWrapped(const RRulePicker(initialRRule: rrule));

        spot<DropdownButton<RecurrenceType>>()
            .whereWidgetProp(
              widgetProp('value', (widget) => widget.value),
              (value) => value == .weekly,
            )
            .existsOnce();
      });

      testWidgets('displays with MONTHLY recurrence', (tester) async {
        const rrule = 'RRULE:FREQ=MONTHLY';

        await tester.pumpWrapped(const RRulePicker(initialRRule: rrule));

        spot<DropdownButton<RecurrenceType>>()
            .whereWidgetProp(
              widgetProp('value', (widget) => widget.value),
              (value) => value == .monthly,
            )
            .existsOnce();
      });

      testWidgets('displays with YEARLY recurrence', (tester) async {
        const rrule = 'RRULE:FREQ=YEARLY';

        await tester.pumpWrapped(const RRulePicker(initialRRule: rrule));

        spot<DropdownButton<RecurrenceType>>()
            .whereWidgetProp(
              widgetProp('value', (widget) => widget.value),
              (value) => value == .yearly,
            )
            .existsOnce();
      });

      testWidgets('prefers initialRRule from controller'
          ' over widget parameter', (tester) async {
        const weekly = 'RRULE:FREQ=WEEKLY;INTERVAL=8;BYDAY=FR';
        final controller = RRulePickerController(initialRRule: weekly);

        await tester.pumpWrapped(
          RRulePicker(initialRRule: 'RRULE:FREQ=DAILY', controller: controller),
        );

        expect(controller.value, weekly);
        spot<DropdownButton<RecurrenceType>>()
            .whereWidgetProp(
              widgetProp('value', (widget) => widget.value),
              (value) => value == .weekly,
            )
            .existsOnce();
      });

      testWidgets('prefers timeZone from controller '
          'over widget parameter', (tester) async {
        final warsaw = 'Europe/Warsaw';
        final controller = RRulePickerController(defaultTimeZone: warsaw);

        await tester.pumpWrapped(
          RRulePicker(timeZone: 'Europe/Budapest', controller: controller),
        );

        await act.tap(spot<DropdownButton<RecurrenceType>>());
        await tester.pumpAndSettle();
        await act.tap(
          spot<DropdownMenuItem<RecurrenceType>>().whereWidgetProp(
            widgetProp('value', (widget) => widget.value),
            (value) => value == .daily,
          ),
        );

        await act.tap(spot<ElevatedButton>());
        await tester.pumpAndSettle();
        await act.tap(spot<DatePickerDialog>().spotText('OK'));
        await tester.pumpAndSettle();

        expect(controller.value, contains(warsaw));
      });

      testWidgets('prefers enableExcludedDates from controller'
          ' over widget parameter', (tester) async {
        final controller = RRulePickerController(enableExcludedDates: false);

        await tester.pumpWrapped(RRulePicker(controller: controller));

        expect(controller.excludedDatesEnabled, false);
        spot<ExcludedDates>().doesNotExist();
      });
    });

    group('widget layout and structure', () {
      testWidgets('dropdown button exists and is expanded', (tester) async {
        await tester.pumpWrapped(const RRulePicker());

        final dropdown = spot<DropdownButton<RecurrenceType>>()
            .existsOnce()
            .widget;

        expect(dropdown.isExpanded, true);
      });

      testWidgets('all recurrence type options'
          ' are present in dropdown', (tester) async {
        await tester.pumpWrapped(const RRulePicker());

        final dropdown = spot<DropdownButton<RecurrenceType>>()
            .existsOnce()
            .widget;

        expect(dropdown.items?.length, RecurrenceType.values.length);
      });

      testWidgets('dropdown shows correct initial value', (tester) async {
        await tester.pumpWrapped(
          const RRulePicker(initialRRule: 'RRULE:FREQ=DAILY'),
        );

        final dropdown = spot<DropdownButton<RecurrenceType>>()
            .existsOnce()
            .widget;

        expect(dropdown.value, RecurrenceType.daily);
      });

      testWidgets('shows no recurrence '
          'when initial RRULE is empty', (tester) async {
        await tester.pumpWrapped(const RRulePicker(initialRRule: ''));

        spot<DailyPicker>().doesNotExist();
        spot<WeeklyPicker>().doesNotExist();
        spot<MonthlyPicker>().doesNotExist();
        spot<YearlyPicker>().doesNotExist();
      });

      testWidgets('shows no recurrence '
          'when initial RRULE is invalid', (tester) async {
        const rrule = 'INVALID_RRULE';

        await tester.pumpWrapped(const RRulePicker(initialRRule: rrule));

        spot<DailyPicker>().doesNotExist();
        spot<WeeklyPicker>().doesNotExist();
        spot<MonthlyPicker>().doesNotExist();
        spot<YearlyPicker>().doesNotExist();
      });

      testWidgets('shows daily recurrence '
          'when initial RRULE is DAILY', (tester) async {
        const rrule = 'RRULE:FREQ=DAILY';

        await tester.pumpWrapped(const RRulePicker(initialRRule: rrule));

        spot<DailyPicker>().existsOnce();
        spot<WeeklyPicker>().doesNotExist();
        spot<MonthlyPicker>().doesNotExist();
        spot<YearlyPicker>().doesNotExist();
      });

      testWidgets('shows weekly recurrence '
          'when initial RRULE is WEEKLY', (tester) async {
        const rrule = 'RRULE:FREQ=WEEKLY';

        await tester.pumpWrapped(const RRulePicker(initialRRule: rrule));

        spot<DailyPicker>().doesNotExist();
        spot<WeeklyPicker>().existsOnce();
        spot<MonthlyPicker>().doesNotExist();
        spot<YearlyPicker>().doesNotExist();
      });

      testWidgets('shows weekly recurrence '
          'when initial RRULE is MONTHLY', (tester) async {
        const rrule = 'RRULE:FREQ=MONTHLY';

        await tester.pumpWrapped(const RRulePicker(initialRRule: rrule));

        spot<DailyPicker>().doesNotExist();
        spot<WeeklyPicker>().doesNotExist();
        spot<MonthlyPicker>().existsOnce();
        spot<YearlyPicker>().doesNotExist();
      });

      testWidgets('shows weekly recurrence '
          'when initial RRULE is YEARLY', (tester) async {
        const rrule = 'RRULE:FREQ=YEARLY';

        await tester.pumpWrapped(const RRulePicker(initialRRule: rrule));

        spot<DailyPicker>().doesNotExist();
        spot<WeeklyPicker>().doesNotExist();
        spot<MonthlyPicker>().doesNotExist();
        spot<YearlyPicker>().existsOnce();
      });

      testWidgets('$ExcludedDates widget is shown '
          'when enabled and type != .never', (tester) async {
        await tester.pumpWrapped(
          const RRulePicker(
            initialRRule: 'RRULE:FREQ=DAILY',
            enableExcludedDates: true,
          ),
        );

        spot<ExcludedDates>().existsOnce();
      });

      testWidgets('$ExcludedDates widget is not shown '
          'when disabled', (tester) async {
        await tester.pumpWrapped(
          const RRulePicker(
            initialRRule: 'RRULE:FREQ=DAILY',
            enableExcludedDates: false,
          ),
        );

        spot<ExcludedDates>().doesNotExist();
      });

      testWidgets('$ExcludedDates widget is not shown '
          'when type == .never', (tester) async {
        await tester.pumpWrapped(
          const RRulePicker(initialRRule: '', enableExcludedDates: true),
        );

        spot<ExcludedDates>().doesNotExist();
      });

      testWidgets('header is shown '
          'when theme.headerTheme.showHeaderOrDefault is true', (tester) async {
        const headerTheme = RRulePickerHeaderThemeData(showHeader: true);
        const theme = RRulePickerThemeData(headerTheme: headerTheme);

        await tester.pumpWrapped(const RRulePicker(theme: theme));

        final l = tester.localizations<RRulePicker>();
        spotText(l.rrulePickerTitle, exact: true).existsOnce();
      });

      testWidgets('header is not shown '
          'when theme.headerTheme.showHeaderOrDefault is false', (
        tester,
      ) async {
        const headerTheme = RRulePickerHeaderThemeData(showHeader: false);
        const theme = RRulePickerThemeData(headerTheme: headerTheme);

        await tester.pumpWrapped(const RRulePicker(theme: theme));

        final l = tester.localizations<RRulePicker>();
        spotText(l.rrulePickerTitle, exact: true).doesNotExist();
      });

      testWidgets('padding is applied from theme', (tester) async {
        const theme = RRulePickerThemeData(padding: .all(16));

        await tester.pumpWrapped(const RRulePicker(theme: theme));

        spot<Padding>()
            .whereWidgetProp(
              widgetProp('padding', (widget) => widget.padding),
              (value) => value == theme.padding,
            )
            .existsOnce();
      });

      testWidgets('$Column has crossAxisAlignment == .start', (tester) async {
        await tester.pumpWrapped(const RRulePicker());

        final column = spot<Column>().existsOnce().widget;

        expect(column.crossAxisAlignment, CrossAxisAlignment.start);
      });
    });

    group('user interactions', () {
      testWidgets('dropdown onChanged updates displayed picker widget', (
        tester,
      ) async {
        await tester.pumpWrapped(const RRulePicker());

        await act.tap(spot<DropdownButton<RecurrenceType>>());
        await tester.pumpAndSettle();

        await act.tap(
          spot<DropdownMenuItem<RecurrenceType>>().whereWidgetProp(
            widgetProp('value', (widget) => widget.value),
            (value) => value == .yearly,
          ),
        );
        await tester.pumpAndSettle();

        spot<DropdownButton<RecurrenceType>>()
            .whereWidgetProp(
              widgetProp('value', (widget) => widget.value),
              (value) => value == .yearly,
            )
            .existsOnce();
      });

      testWidgets('changing recurrence type '
          'updates the displayed picker widget', (tester) async {
        final controller = RRulePickerController();
        await tester.pumpWrapped(RRulePicker(controller: controller));

        controller.setRRule('RRULE:FREQ=DAILY');
        await tester.pumpAndSettle();

        spot<DailyPicker>().existsOnce();

        controller.setRRule('RRULE:FREQ=WEEKLY');
        await tester.pumpAndSettle();

        spot<WeeklyPicker>().existsOnce();
      });

      testWidgets('onRRuleChanged callback is called '
          'when RRULE changes', (tester) async {
        String? receivedRRule;
        await tester.pumpWrapped(
          RRulePicker(
            initialRRule: 'RRULE:FREQ=MONTHLY',
            onRRuleChanged: (rrule) => receivedRRule = rrule,
          ),
        );

        await act.enterText(spot<TextField>(), '7');
        await tester.pumpAndSettle();

        expect(receivedRRule, 'RRULE:FREQ=MONTHLY;INTERVAL=7;BYMONTHDAY=1');
      });
    });

    group('controller integration', () {
      testWidgets('widget uses provided controller', (tester) async {
        const rrule = 'RRULE:FREQ=DAILY';
        final controller = RRulePickerController(initialRRule: rrule);

        await tester.pumpWrapped(RRulePicker(controller: controller));

        spot<DailyPicker>().existsOnce();
      });

      testWidgets('widget initializes provided controller '
          'with initialRRule if empty', (tester) async {
        final controller = RRulePickerController();
        final rrule = 'RRULE:FREQ=WEEKLY;INTERVAL=30;BYDAY=MO,WE,SU';

        await tester.pumpWrapped(
          RRulePicker(initialRRule: rrule, controller: controller),
        );

        expect(controller.value, rrule);
      });

      testWidgets('widget does not dispose provided controller', (
        tester,
      ) async {
        final controller = RRulePickerController();

        await tester.pumpWrapped(RRulePicker(controller: controller));

        ChangeNotifier.debugAssertNotDisposed(controller);
      });
    });

    group('didUpdateWidget', () {
      testWidgets('handles controller change '
          'from external to external', (tester) async {
        var controller = RRulePickerController();
        await tester.pumpWrapped(RRulePicker(controller: controller));

        controller = RRulePickerController();
        await tester.pumpWrapped(RRulePicker(controller: controller));

        expect(tester.takeException(), null);
      });

      testWidgets('handles controller change '
          'from external to internal', (tester) async {
        final controller = RRulePickerController();
        await tester.pumpWrapped(RRulePicker(controller: controller));

        await tester.pumpWrapped(const RRulePicker());

        expect(tester.takeException(), null);
      });

      testWidgets('handles controller change '
          'from internal to external', (tester) async {
        await tester.pumpWrapped(const RRulePicker());

        final controller = RRulePickerController();
        await tester.pumpWrapped(RRulePicker(controller: controller));

        expect(tester.takeException(), null);
      });

      testWidgets('handles no external controller change', (tester) async {
        final controller = RRulePickerController();

        await tester.pumpWrapped(RRulePicker(controller: controller));

        await tester.pumpWrapped(
          RRulePicker(timeZone: 'Europe/Warsaw', controller: controller),
        );

        expect(tester.takeException(), null);
      });

      testWidgets('handles no internal controller change', (tester) async {
        await tester.pumpWrapped(const RRulePicker());

        await tester.pumpWrapped(const RRulePicker(timeZone: 'Europe/Warsaw'));

        expect(tester.takeException(), null);
      });

      testWidgets('handles enableExcludedDates updates', (tester) async {
        final controller = RRulePickerController();

        await tester.pumpWrapped(
          RRulePicker(controller: controller, enableExcludedDates: true),
        );

        expect(controller.excludedDatesEnabled, true);

        await tester.pumpWrapped(
          RRulePicker(controller: controller, enableExcludedDates: false),
        );

        expect(controller.excludedDatesEnabled, false);
      });
    });
  });

  group(RRulePickerController, () {
    group('constructor', () {
      test('sets correct default values', () {
        final controller = RRulePickerController();

        expect(controller.value, '');
        expect(controller.excludedDatesEnabled, true);

        addTearDown(controller.dispose);
      });

      test('handles initialRRule', () {
        final controller = RRulePickerController(
          initialRRule: 'RRULE:FREQ=DAILY;INTERVAL=3',
        );

        expect(controller.value, 'RRULE:FREQ=DAILY;INTERVAL=3');

        addTearDown(controller.dispose);
      });

      test('handles enableExcludedDates', () {
        final controller = RRulePickerController(enableExcludedDates: false);

        expect(controller.excludedDatesEnabled, false);

        addTearDown(controller.dispose);
      });

      test('handles all parameters', () {
        final controller = RRulePickerController(
          initialRRule:
              'RRULE:FREQ=WEEKLY;INTERVAL=9;BYDAY=SU;'
              'EXDATE;VALUE=DATE:20260703',
          defaultTimeZone: 'Europe/Warsaw',
          enableExcludedDates: true,
        );

        expect(
          controller.value,
          'RRULE:FREQ=WEEKLY;INTERVAL=9;BYDAY=SU;'
          'EXDATE;TZID=Europe/Warsaw;VALUE=DATE:20260703',
        );
        expect(controller.excludedDatesEnabled, true);

        addTearDown(controller.dispose);
      });
    });

    test('excludedDatesEnabled setter updates the value', () {
      final controller = RRulePickerController();

      expect(controller.excludedDatesEnabled, true);

      controller.excludedDatesEnabled = false;
      expect(controller.excludedDatesEnabled, false);

      controller.excludedDatesEnabled = true;
      expect(controller.excludedDatesEnabled, true);

      addTearDown(controller.dispose);
    });

    group('setRRule', () {
      test('handles empty string', () {
        final controller = RRulePickerController(
          initialRRule: 'RRULE:FREQ=DAILY',
        );

        controller.setRRule('');

        expect(controller.value, '');

        addTearDown(controller.dispose);
      });

      test('handles DAILY rrule', () {
        final controller = RRulePickerController();

        controller.setRRule('RRULE:FREQ=DAILY;INTERVAL=3');

        expect(controller.value, 'RRULE:FREQ=DAILY;INTERVAL=3');

        addTearDown(controller.dispose);
      });

      test('handles WEEKLY rrule', () {
        final controller = RRulePickerController();

        controller.setRRule('RRULE:FREQ=WEEKLY;INTERVAL=2;BYDAY=MO,WE,FR');

        expect(controller.value, 'RRULE:FREQ=WEEKLY;INTERVAL=2;BYDAY=MO,WE,FR');

        addTearDown(controller.dispose);
      });

      test('handles MONTHLY rrule', () {
        final controller = RRulePickerController();

        controller.setRRule('RRULE:FREQ=MONTHLY;INTERVAL=5;BYMONTHDAY=15');

        expect(controller.value, 'RRULE:FREQ=MONTHLY;INTERVAL=5;BYMONTHDAY=15');

        addTearDown(controller.dispose);
      });

      test('handles YEARLY rrule', () {
        final controller = RRulePickerController();

        controller.setRRule(
          'RRULE:FREQ=YEARLY;INTERVAL=10;BYMONTH=1;BYMONTHDAY=1',
        );

        expect(
          controller.value,
          'RRULE:FREQ=YEARLY;INTERVAL=10;BYMONTH=1;BYMONTHDAY=1',
        );

        addTearDown(controller.dispose);
      });

      test('handles defaultTimeZone', () {
        final controller = RRulePickerController();

        controller.setRRule(
          'RRULE:FREQ=DAILY;INTERVAL=1;EXDATE;VALUE=DATE:20260703',
          defaultTimeZone: 'Europe/Warsaw',
        );

        expect(
          controller.value,
          'RRULE:FREQ=DAILY;INTERVAL=1;'
          'EXDATE;TZID=Europe/Warsaw;VALUE=DATE:20260703',
        );

        addTearDown(controller.dispose);
      });

      test('does not notify when set to the same value', () {
        var listenerCallCount = 0;
        final controller = RRulePickerController(
          initialRRule: 'RRULE:FREQ=DAILY;INTERVAL=2',
        )..addListener(() => ++listenerCallCount);

        controller.setRRule('RRULE:FREQ=DAILY;INTERVAL=2');

        expect(listenerCallCount, 0);

        addTearDown(controller.dispose);
      });

      test('notifies on change', () {
        var listenerCallCount = 0;
        final controller = RRulePickerController()
          ..addListener(() => ++listenerCallCount);

        controller.setRRule('RRULE:FREQ=DAILY');
        expect(listenerCallCount, greaterThan(0));

        addTearDown(controller.dispose);
      });

      test('handles malformed RRULE strings', () {
        final controller = RRulePickerController();

        controller.setRRule('INVALID_RRULE');

        expect(controller.value, '');

        addTearDown(controller.dispose);
      });
    });

    test('dispose works', () {
      final controller = RRulePickerController();

      ChangeNotifier.debugAssertNotDisposed(controller);

      expect(() => controller.dispose(), returnsNormally);

      expect(
        () => ChangeNotifier.debugAssertNotDisposed(controller),
        throwsFlutterError,
      );
    });

    test('value includes excluded dates when enabled', () {
      final controller = RRulePickerController(
        initialRRule:
            'RRULE:FREQ=DAILY;INTERVAL=4;'
            'EXDATE;TZID=UTC;VALUE=DATE:20260703',
        enableExcludedDates: true,
      );

      expect(
        controller.value,
        'RRULE:FREQ=DAILY;INTERVAL=4;'
        'EXDATE;TZID=UTC;VALUE=DATE:20260703',
      );

      addTearDown(controller.dispose);
    });

    test('value does not include excluded dates when disabled', () {
      final controller = RRulePickerController(
        initialRRule:
            'RRULE:FREQ=DAILY;INTERVAL=4;'
            'EXDATE;TZID=UTC;VALUE=DATE:20260703',
        enableExcludedDates: false,
      );

      expect(controller.value, 'RRULE:FREQ=DAILY;INTERVAL=4');

      addTearDown(controller.dispose);
    });
  });

  group(RecurrenceType, () {
    test('parses DAILY RRULE correctly', () {
      const rrule = 'RRULE:FREQ=DAILY;INTERVAL=2';
      final type = RecurrenceType.fromRRule(rrule);
      expect(type, RecurrenceType.daily);
    });

    test('parses lower-case freq=daily RRULE correctly', () {
      const rrule = 'RRULE:freq=daily;INTERVAL=2';
      final type = RecurrenceType.fromRRule(rrule);
      expect(type, RecurrenceType.daily);
    });

    test('parses mixed-case FREQ=Daily RRULE correctly', () {
      const rrule = 'RRULE:FREQ=Daily;INTERVAL=2';
      final type = RecurrenceType.fromRRule(rrule);
      expect(type, RecurrenceType.daily);
    });

    test('parses WEEKLY RRULE correctly', () {
      const rrule = 'RRULE:FREQ=WEEKLY;BYDAY=MO,WE,FR';
      final type = RecurrenceType.fromRRule(rrule);
      expect(type, RecurrenceType.weekly);
    });

    test('parses lower-case freq=weekly RRULE correctly', () {
      const rrule = 'RRULE:freq=weekly;BYDAY=MO,WE,FR';
      final type = RecurrenceType.fromRRule(rrule);
      expect(type, RecurrenceType.weekly);
    });

    test('parses mixed-case FREQ=Weekly RRULE correctly', () {
      const rrule = 'RRULE:FREQ=Weekly;BYDAY=MO,WE,FR';
      final type = RecurrenceType.fromRRule(rrule);
      expect(type, RecurrenceType.weekly);
    });

    test('parses MONTHLY RRULE correctly', () {
      const rrule = 'RRULE:FREQ=MONTHLY;BYMONTHDAY=15';
      final type = RecurrenceType.fromRRule(rrule);
      expect(type, RecurrenceType.monthly);
    });

    test('parses lower-case freq=monthly RRULE correctly', () {
      const rrule = 'RRULE:freq=monthly;BYMONTHDAY=15';
      final type = RecurrenceType.fromRRule(rrule);
      expect(type, RecurrenceType.monthly);
    });

    test('parses mixed-case FREQ=Monthly RRULE correctly', () {
      const rrule = 'RRULE:FREQ=Monthly;BYMONTHDAY=15';
      final type = RecurrenceType.fromRRule(rrule);
      expect(type, RecurrenceType.monthly);
    });

    test('parses YEARLY RRULE correctly', () {
      const rrule = 'RRULE:FREQ=YEARLY;BYMONTH=1;BYMONTHDAY=1';
      final type = RecurrenceType.fromRRule(rrule);
      expect(type, RecurrenceType.yearly);
    });

    test('parses lower-case freq=yearly RRULE correctly', () {
      const rrule = 'RRULE:freq=yearly;BYMONTH=1;BYMONTHDAY=1';
      final type = RecurrenceType.fromRRule(rrule);
      expect(type, RecurrenceType.yearly);
    });

    test('parses mixed-case FREQ=Yearly RRULE correctly', () {
      const rrule = 'RRULE:FREQ=Yearly;BYMONTH=1;BYMONTHDAY=1';
      final type = RecurrenceType.fromRRule(rrule);
      expect(type, RecurrenceType.yearly);
    });

    test('returns .never for empty RRULE', () {
      const rrule = '';
      final type = RecurrenceType.fromRRule(rrule);
      expect(type, RecurrenceType.never);
    });

    test('returns .never for invalid RRULE', () {
      const rrule = 'INVALID_RRULE';
      final type = RecurrenceType.fromRRule(rrule);
      expect(type, RecurrenceType.never);
    });

    test('returns .never for RRULE with no FREQ', () {
      const rrule = 'RRULE:INTERVAL=2';
      final type = RecurrenceType.fromRRule(rrule);
      expect(type, RecurrenceType.never);
    });

    test('handles complex DAILY RRULE with EXDATE', () {
      const rrule = 'RRULE:FREQ=DAILY;INTERVAL=1;EXDATE;VALUE=DATE:20260703';
      final type = RecurrenceType.fromRRule(rrule);
      expect(type, RecurrenceType.daily);
    });

    test('handles complex WEEKLY RRULE with multiple BYDAY', () {
      const rrule = 'RRULE:FREQ=WEEKLY;INTERVAL=2;BYDAY=MO,WE,FR,SU';
      final type = RecurrenceType.fromRRule(rrule);
      expect(type, RecurrenceType.weekly);
    });

    test('handles complex MONTHLY RRULE with BYMONTHDAY', () {
      const rrule = 'RRULE:FREQ=MONTHLY;INTERVAL=3;BYMONTHDAY=1,15';
      final type = RecurrenceType.fromRRule(rrule);
      expect(type, RecurrenceType.monthly);
    });

    test('handles complex YEARLY RRULE with BYMONTH and BYMONTHDAY', () {
      const rrule = 'RRULE:FREQ=YEARLY;INTERVAL=5;BYMONTH=1,6;BYMONTHDAY=1';
      final type = RecurrenceType.fromRRule(rrule);
      expect(type, RecurrenceType.yearly);
    });
  });
}
