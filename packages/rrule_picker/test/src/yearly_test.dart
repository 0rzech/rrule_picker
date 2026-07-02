// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:kiri_check/kiri_check.dart';
import 'package:rrule_picker/src/shared/interval.dart';
import 'package:rrule_picker/src/shared/parsing.dart';
import 'package:rrule_picker/src/shared/resolved_theme.dart';
import 'package:rrule_picker/src/yearly.dart';
import 'package:spot/spot.dart';

import '../helpers.dart';

void main() {
  group(YearlyPicker, () {
    const theme = ResolvedThemeData(
      padding: .all(8),
      headerTheme: .new(),
      dropdownTheme: .new(),
      topDropdownTheme: .new(),
      labelStyle: .new(color: Colors.cyan),
    );

    late YearlyPickerController controller;
    late int listenerCallCount;

    setUpAll(() async {
      if (!kIsWeb) {
        await loadAppFonts();
      }
      Intl.defaultLocale = 'en';
      initializeDateFormatting();
    });

    setUp(() {
      controller = YearlyPickerController(listener: () => ++listenerCallCount);
      listenerCallCount = 0;
    });

    tearDown(() => controller.dispose.callIgnoringErrors());

    testWidgets('renders SegmentedButton with correct localizations', (
      tester,
    ) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: YearlyPicker(controller: controller),
        ),
      );

      spot<SegmentedButton<IntervalPickerSegmentType>>().existsOnce();
      final l = tester.localizations<YearlyPicker>();
      spotText(l.rrulePickerDayOfMonth, exact: true).existsOnce();
      spotText(l.rrulePickerDayOfWeek, exact: true).existsOnce();
    });

    testWidgets('renders 2 interval segment types (precise and relative)', (
      tester,
    ) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: YearlyPicker(controller: controller),
        ),
      );

      final buttons = spot<SegmentedButton<IntervalPickerSegmentType>>()
          .existsOnce()
          .widget
          .segments
          .map((segment) => segment.value);

      expect(buttons, const <IntervalPickerSegmentType>[.precise, .relative]);
    });

    testWidgets('renders month dropdown '
        'when precise is selected', (tester) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: YearlyPicker(controller: controller),
        ),
      );

      spot<DropdownButton<Month>>().existsOnce();
    });

    testWidgets('renders month and day of month dropdowns '
        'when precise is selected', (tester) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: YearlyPicker(controller: controller),
        ),
      );

      spot<DropdownButton<Month>>().existsOnce();
      spot<DropdownButton<int>>().existsOnce();
    });

    testWidgets('renders month, dayOfWeekOrdinal and dayOfWeek dropdowns '
        'when relative is selected', (tester) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: YearlyPicker(controller: controller),
        ),
      );

      final text = tester.localizations<YearlyPicker>().rrulePickerDayOfWeek;
      final button = spot<SegmentedButton<IntervalPickerSegmentType>>()
          .spotText(text, exact: true);

      await act.tap(button);
      await tester.pumpAndSettle();

      spot<DropdownButton<Month>>().existsOnce();
      spot<DropdownButton<DayOfWeekOrdinal>>().existsOnce();
      spot<DropdownButton<DayOfWeek>>().existsOnce();
    });

    testWidgets('uses provided controller', (tester) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: YearlyPicker(controller: controller),
        ),
      );

      await act.enterText(spot<TextField>(), '222');

      expect(controller.getIntervalValue(), 222);
    });

    testWidgets('applies ResolvedTheme when provided', (tester) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: YearlyPicker(controller: controller),
        ),
      );

      spot<Text>()
          .whereWidgetProp(
            widgetProp('style', (widget) => widget.style),
            (style) => style?.color == theme.labelStyle?.color,
          )
          .existsAtLeastOnce();
    });

    testWidgets('applies ResolvedTheme to SegmentedButton', (tester) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: YearlyPicker(controller: controller),
        ),
      );

      final button = spot<SegmentedButton<IntervalPickerSegmentType>>()
          .existsOnce()
          .widget
          .style;

      expect(button, theme.segmentedButtonStyle);
    });

    testWidgets('renders all months in month dropdown', (tester) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: YearlyPicker(controller: controller),
        ),
      );

      final months = spot<DropdownButton<Month>>()
          .existsOnce()
          .widget
          .items
          ?.map((item) => item.value);

      expect(months, Month.values);
    });

    testWidgets('renders correct number of day of month options '
        'based on selected month', (tester) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: YearlyPicker(controller: controller),
        ),
      );

      await act.tap(spot<DropdownButton<Month>>());
      await tester.pumpAndSettle();

      await act.tap(
        spot<DropdownMenuItem<Month>>().whereWidgetProp(
          widgetProp('value', (widget) => widget.value),
          (value) => value == .february,
        ),
      );
      await tester.pumpAndSettle();

      expect(
        spot<DropdownButton<int>>().existsOnce().widget.items?.length,
        Month.february.maxDay,
      );
    });

    testWidgets('updates dayOfMonth to max day '
        'when month changes to shorter month', (tester) async {
      controller.month.value = .march;
      controller.dayOfMonth.value = 30;

      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: YearlyPicker(controller: controller),
        ),
      );

      await act.tap(spot<DropdownButton<Month>>());
      await tester.pumpAndSettle();

      await act.tap(
        spot<DropdownMenuItem<Month>>().whereWidgetProp(
          widgetProp('value', (widget) => widget.value),
          (value) => value == .february,
        ),
      );
      await tester.pumpAndSettle();

      expect(controller.dayOfMonth.value, 29);
    });

    testWidgets('updates month when selecting from dropdown', (tester) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: YearlyPicker(controller: controller),
        ),
      );

      await act.tap(spot<DropdownButton<Month>>());
      await tester.pumpAndSettle();

      await act.tap(
        spot<DropdownMenuItem<Month>>().whereWidgetProp(
          widgetProp('value', (widget) => widget.value),
          (value) => value == Month.march,
        ),
      );
      await tester.pumpAndSettle();

      expect(controller.month.value, Month.march);
    });

    testWidgets('updates dayOfMonth when selecting from dropdown', (
      tester,
    ) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: YearlyPicker(controller: controller),
        ),
      );

      await act.tap(spot<DropdownButton<int>>());
      await tester.pumpAndSettle();

      await act.dragUntilVisible(
        dragStart: spot<DropdownMenuItem<int>>().whereWidgetProp(
          widgetProp('value', (widget) => widget.value),
          (value) => value == 5,
        ),
        dragTarget: spot<DropdownMenuItem<int>>().whereWidgetProp(
          widgetProp('value', (widget) => widget.value),
          (value) => value == 20,
        ),
      );
      await tester.pumpAndSettle();

      await act.tap(
        spot<DropdownMenuItem<int>>().whereWidgetProp(
          widgetProp('value', (widget) => widget.value),
          (value) => value == 15,
        ),
      );
      await tester.pumpAndSettle();

      expect(controller.dayOfMonth.value, 15);
    });

    testWidgets('updates dayOfWeekOrdinal '
        'when selecting from dropdown in relative mode', (tester) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: YearlyPicker(controller: controller),
        ),
      );

      final button = spot<SegmentedButton<IntervalPickerSegmentType>>()
          .spot<TextButton>()
          .atIndex(1);
      await act.tap(button);
      await tester.pumpAndSettle();

      await act.tap(spot<DropdownButton<DayOfWeekOrdinal>>());
      await tester.pumpAndSettle();

      final item = spot<DropdownMenuItem<DayOfWeekOrdinal>>().whereWidgetProp(
        widgetProp('value', (widget) => widget.value),
        (value) => value == .second,
      );
      await act.tap(item);
      await tester.pumpAndSettle();

      expect(controller.dayOfWeekOrdinal.value, DayOfWeekOrdinal.second);
    });

    testWidgets('updates dayOfWeek '
        'when selecting from dropdown in relative mode', (tester) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: YearlyPicker(controller: controller),
        ),
      );

      final button = spot<SegmentedButton<IntervalPickerSegmentType>>()
          .spot<TextButton>()
          .atIndex(1);
      await act.tap(button);
      await tester.pumpAndSettle();

      await act.tap(spot<DropdownButton<DayOfWeek>>());
      await tester.pumpAndSettle();

      final item = spot<DropdownMenuItem<DayOfWeek>>().whereWidgetProp(
        widgetProp('value', (widget) => widget.value),
        (value) => value == .wednesday,
      );
      await act.tap(item);
      await tester.pumpAndSettle();

      expect(controller.dayOfWeek.value, DayOfWeek.wednesday);
    });

    testWidgets('updates daysOfWeek when firstDayOfWeek changes', (
      tester,
    ) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: YearlyPicker(controller: controller, firstDayOfWeek: .friday),
        ),
      );

      expect(controller.daysOfWeek.value.first.$1, DayOfWeek.friday);
    });

    testWidgets('updates daysOfWeek when locale changes', (tester) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: YearlyPicker(controller: controller),
        ),
      );

      expect(controller.dayOfWeekFormatter.locale.toString(), 'en');
      final daysOfWeek = controller.daysOfWeek.value;

      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: YearlyPicker(controller: controller),
        ),
        locale: const Locale('pl'),
      );

      expect(controller.dayOfWeekFormatter.locale.toString(), 'pl');
      expect(controller.daysOfWeek.value, isNot(unorderedEquals(daysOfWeek)));
    });

    testWidgets('changes interval segment type '
        'when tapping segments', (tester) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: YearlyPicker(controller: controller),
        ),
      );

      expect(controller.intervalSegmentType.value, const {
        IntervalPickerSegmentType.precise,
      });

      final l = tester.localizations<YearlyPicker>();
      await act.tap(
        spot<SegmentedButton<IntervalPickerSegmentType>>().spotText(
          l.rrulePickerDayOfWeek,
          exact: true,
        ),
      );
      await tester.pumpAndSettle();

      expect(controller.intervalSegmentType.value, const {
        IntervalPickerSegmentType.relative,
      });

      await act.tap(
        spot<SegmentedButton<IntervalPickerSegmentType>>().spotText(
          l.rrulePickerDayOfMonth,
          exact: true,
        ),
      );
      await tester.pumpAndSettle();

      expect(controller.intervalSegmentType.value, const {
        IntervalPickerSegmentType.precise,
      });
    });

    testWidgets('updates daysOfWeek when firstDayOfWeek changes', (
      tester,
    ) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: YearlyPicker(controller: controller, firstDayOfWeek: .friday),
        ),
      );

      expect(controller.daysOfWeek.value.first.$1, DayOfWeek.friday);
    });

    testWidgets('updates daysOfWeek and month name '
        'when locale changes', (tester) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: YearlyPicker(controller: controller),
        ),
      );

      expect(controller.dayOfWeekFormatter.locale.toString(), 'en');
      expect(controller.monthFormatter.locale.toString(), 'en');
      final daysOfWeek = controller.daysOfWeek.value;
      final month = spot<DropdownMenuItem<Month>>()
          .spot<Text>()
          .existsOnce()
          .widget
          .data;

      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: YearlyPicker(controller: controller),
        ),
        locale: const Locale('pl'),
      );

      expect(controller.dayOfWeekFormatter.locale.toString(), 'pl');
      expect(controller.daysOfWeek.value, isNot(unorderedEquals(daysOfWeek)));
      expect(controller.monthFormatter.locale.toString(), 'pl');
      expect(
        spot<DropdownMenuItem<Month>>().spot<Text>().existsOnce().widget.data,
        isNot(month),
      );
    });

    testWidgets('updates daysOfWeek and month name '
        'when firstDayOfWeek and locale change', (tester) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: YearlyPicker(controller: controller),
        ),
      );

      expect(controller.dayOfWeekFormatter.locale.toString(), 'en');
      expect(
        controller.daysOfWeek.value.map((t) => t.$1),
        orderedEquals(DayOfWeek.values),
      );
      expect(controller.monthFormatter.locale.toString(), 'en');

      final daysOfWeekEn = controller.daysOfWeek.value.map((t) => t.$2);
      final monthEn = spot<DropdownMenuItem<Month>>()
          .spot<Text>()
          .existsOnce()
          .widget
          .data;

      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: YearlyPicker(controller: controller, firstDayOfWeek: .sunday),
        ),
        locale: const Locale('pl'),
      );

      expect(controller.dayOfWeekFormatter.locale.toString(), 'pl');
      expect(
        controller.daysOfWeek.value.map((t) => t.$1),
        orderedEquals(const <DayOfWeek>[
          .sunday,
          .monday,
          .tuesday,
          .wednesday,
          .thursday,
          .friday,
          .saturday,
        ]),
      );
      expect(
        controller.daysOfWeek.value.map((t) => t.$2),
        isNot(unorderedEquals(daysOfWeekEn)),
      );
      expect(controller.monthFormatter.locale.toString(), 'pl');
      expect(
        spot<DropdownMenuItem<Month>>().spot<Text>().existsOnce().widget.data,
        isNot(monthEn),
      );
    });
  });

  group(YearlyPickerController, () {
    late YearlyPickerController controller;

    setUpAll(() {
      Intl.defaultLocale = 'en';
      initializeDateFormatting();
    });

    setUp(() => controller = YearlyPickerController(listener: () {}));
    tearDown(() => controller.dispose());

    test('listener is called when state changes', () {
      var callCount = 0;
      final controller = YearlyPickerController(listener: () => ++callCount);

      controller.month.value = Month.february;

      expect(callCount, 1);

      addTearDown(controller.dispose);
    });

    group('constructor', () {
      test('initializes with default month when initialRRule is empty', () {
        expect(controller.month.value, Month.january);
        expect(controller.dayOfMonth.value, defaultByMonthDay);
        expect(controller.intervalSegmentType.value, const {
          IntervalPickerSegmentType.precise,
        });
      });

      property('initializes with firstDayOfWeek when provided', () {
        late YearlyPickerController controller;

        forAll(dayOfWeek(), (day) {
          controller = YearlyPickerController(
            firstDayOfWeek: day,
            listener: () {},
          );

          expect(controller.dayOfWeek.value, day);
          expect(controller.daysOfWeek.value.first.$1, day);
        }, tearDown: () => controller.dispose());
      });

      property('initializes from valid rrule with BYMONTH and BYMONTHDAY', () {
        late YearlyPickerController controller;

        forAll(
          month().flatMap((month) {
            return combine2(
              constant(month),
              integer(min: byMonthDayMin, max: month.maxDay),
            ).map((t) => (month: t.$1, day: t.$2));
          }),
          (t) {
            controller = YearlyPickerController(
              initialRRule:
                  'FREQ=YEARLY;'
                  'BYMONTH=${t.month.rruleValue};BYMONTHDAY=${t.day}',
              listener: () {},
            );

            expect(controller.month.value, t.month);
            expect(controller.dayOfMonth.value, t.day);
            expect(controller.intervalSegmentType.value, const {
              IntervalPickerSegmentType.precise,
            });
          },
          tearDown: () => controller.dispose(),
        );
      });

      property('initializes from valid rrule '
          'with INTERVAL, BYMONTH, and BYMONTHDAY', () {
        late YearlyPickerController controller;

        forAll(
          month().flatMap((month) {
            return combine3(
              interval(),
              constant(month),
              integer(min: byMonthDayMin, max: month.maxDay),
            ).map((t) => (interval: t.$1, month: t.$2, day: t.$3));
          }),
          (t) {
            controller = YearlyPickerController(
              initialRRule:
                  'FREQ=YEARLY;INTERVAL=${t.interval};'
                  'BYMONTH=${t.month.rruleValue};BYMONTHDAY=${t.day}',
              listener: () {},
            );

            expect(controller.getIntervalValue(), t.interval);
            expect(controller.month.value, t.month);
            expect(controller.dayOfMonth.value, t.day);
            expect(controller.intervalSegmentType.value, const {
              IntervalPickerSegmentType.precise,
            });
          },
          tearDown: () => controller.dispose(),
        );
      });

      property('initializes from valid rrule '
          'with INTERVAL, BYMONTH, BYDAY and BYSETPOS', () {
        late YearlyPickerController controller;

        forAll(
          combine4(
            interval(),
            month(),
            dayOfWeek(),
            dayOfWeekOrdinal(),
          ).map((t) => (interval: t.$1, month: t.$2, day: t.$3, ordinal: t.$4)),
          (t) {
            controller = YearlyPickerController(
              initialRRule:
                  'FREQ=YEARLY;INTERVAL=${t.interval};'
                  'BYMONTH=${t.month.rruleValue};'
                  'BYDAY=${t.day.rruleName};BYSETPOS=${t.ordinal.rruleValue}',
              listener: () {},
            );

            expect(controller.getIntervalValue(), t.interval);
            expect(controller.intervalNotifier.value, t.interval);
            expect(controller.month.value, t.month);
            expect(controller.dayOfWeek.value, t.day);
            expect(controller.dayOfWeekOrdinal.value, t.ordinal);
            expect(controller.intervalSegmentType.value, const {
              IntervalPickerSegmentType.relative,
            });
          },
          tearDown: () => controller.dispose(),
        );
      });

      test('initializes with precise segment type for BYMONTHDAY', () {
        final controller = YearlyPickerController(
          initialRRule: 'FREQ=YEARLY;BYMONTH=1;BYMONTHDAY=15',
          listener: () {},
        );

        expect(controller.intervalSegmentType.value, const {
          IntervalPickerSegmentType.precise,
        });

        addTearDown(controller.dispose);
      });

      test('initializes with relative segment type for BYDAY', () {
        final controller = YearlyPickerController(
          initialRRule: 'FREQ=YEARLY;BYMONTH=1;BYDAY=MO;BYSETPOS=1',
          listener: () {},
        );

        expect(controller.intervalSegmentType.value, const {
          IntervalPickerSegmentType.relative,
        });

        addTearDown(controller.dispose);
      });

      test('initializes with default dayOfWeekOrdinal', () {
        final controller = YearlyPickerController(
          initialRRule: 'FREQ=YEARLY;BYMONTH=1;BYDAY=MO',
          listener: () {},
        );

        expect(controller.dayOfWeekOrdinal.value, defaultBySetPosNthWeekDay);

        addTearDown(controller.dispose);
      });

      property('initializes with parsed month from rrule', () {
        late YearlyPickerController controller;

        forAll(month(), (month) {
          controller = YearlyPickerController(
            initialRRule:
                'FREQ=YEARLY;BYMONTH=${month.rruleValue};BYMONTHDAY=1',
            listener: () {},
          );

          expect(controller.month.value, month);
        }, tearDown: () => controller.dispose());
      });

      property('initializes with parsed dayOfMonth from rrule', () {
        late YearlyPickerController controller;

        forAll(
          integer(min: byMonthDayMin, max: byMonthDayMax - 1),
          (day) {
            controller = YearlyPickerController(
              initialRRule: 'FREQ=YEARLY;BYMONTH=1;BYMONTHDAY=$day',
              listener: () {},
            );

            expect(controller.dayOfMonth.value, day);
          },
          tearDown: () => controller.dispose(),
        );
      });

      property('initializes with parsed dayOfWeek from rrule', () {
        late YearlyPickerController controller;

        forAll(dayOfWeek(), (day) {
          controller = YearlyPickerController(
            initialRRule:
                'FREQ=YEARLY;BYMONTH=1;BYDAY=${day.rruleName};BYSETPOS=1',
            listener: () {},
          );

          expect(controller.dayOfWeek.value, day);
        }, tearDown: () => controller.dispose());
      });

      property('initializes with parsed dayOfWeekOrdinal from rrule', () {
        late YearlyPickerController controller;

        forAll(dayOfWeekOrdinal(), (ordinal) {
          controller = YearlyPickerController(
            initialRRule:
                'FREQ=YEARLY;BYMONTH=1;'
                'BYDAY=MO;BYSETPOS=${ordinal.rruleValue}',
            listener: () {},
          );

          expect(controller.dayOfWeekOrdinal.value, ordinal);
        }, tearDown: () => controller.dispose());
      });
    });

    group('setRRule', () {
      property('updates from rrule with BYMONTH and BYMONTHDAY', () {
        late YearlyPickerController controller;

        forAll(
          combine2(month(), byMonthDay()).map((t) => (month: t.$1, day: t.$2)),
          (t) {
            final maxDay = t.month.maxDay;
            final day = t.day <= maxDay ? t.day : maxDay;
            controller.setRRule(
              'FREQ=YEARLY;BYMONTH=${t.month.rruleValue};BYMONTHDAY=$day',
            );

            expect(controller.month.value, t.month);
            expect(controller.dayOfMonth.value, day);
            expect(controller.intervalSegmentType.value, const {
              IntervalPickerSegmentType.precise,
            });
          },
          setUp: () => controller = YearlyPickerController(listener: () {}),
          tearDown: () => controller.dispose(),
        );
      });

      property('updates from rrule '
          'with INTERVAL, BYMONTH, BYDAY and BYSETPOS', () {
        late YearlyPickerController controller;

        forAll(
          combine4(
            interval(),
            month(),
            dayOfWeek(),
            dayOfWeekOrdinal(),
          ).map((t) => (interval: t.$1, month: t.$2, day: t.$3, ordinal: t.$4)),
          (t) {
            controller.setRRule(
              'FREQ=YEARLY;INTERVAL=${t.interval};'
              'BYMONTH=${t.month.rruleValue};'
              'BYDAY=${t.day.rruleName};BYSETPOS=${t.ordinal.rruleValue}',
            );

            expect(controller.month.value, t.month);
            expect(controller.dayOfWeek.value, t.day);
            expect(controller.dayOfWeekOrdinal.value, t.ordinal);
            expect(controller.intervalSegmentType.value, const {
              IntervalPickerSegmentType.relative,
            });
          },
          setUp: () => controller = YearlyPickerController(listener: () {}),
          tearDown: () => controller.dispose(),
        );
      });

      test('sets segment type to precise for BYMONTHDAY', () {
        controller.setRRule('FREQ=YEARLY;BYMONTH=1;BYMONTHDAY=15');

        expect(controller.intervalSegmentType.value, const {
          IntervalPickerSegmentType.precise,
        });
      });

      test('sets segment type to relative for BYDAY', () {
        controller.setRRule('FREQ=YEARLY;BYMONTH=1;BYDAY=MO;BYSETPOS=1');

        expect(controller.intervalSegmentType.value, const {
          IntervalPickerSegmentType.relative,
        });
      });

      test('uses default values for empty rrule', () {
        controller.setRRule('');

        expect(controller.month.value, Month.january);
        expect(controller.dayOfMonth.value, defaultByMonthDay);
        expect(controller.intervalSegmentType.value, const {
          IntervalPickerSegmentType.precise,
        });
      });

      test('uses default values for invalid rrule', () {
        controller.setRRule('INVALID_RRULE');

        expect(controller.month.value, Month.january);
        expect(controller.dayOfMonth.value, defaultByMonthDay);
        expect(controller.intervalSegmentType.value, const {
          IntervalPickerSegmentType.precise,
        });
      });

      test('uses default dayOfMonth when BYMONTHDAY is missing', () {
        controller.setRRule('FREQ=YEARLY;BYMONTH=1');

        expect(controller.dayOfMonth.value, defaultByMonthDay);
      });

      property('uses default dayOfWeek and ordinal'
          ' when BYDAY and BYSETPOS are missing', () {
        late YearlyPickerController controller;

        forAll(
          dayOfWeek(),
          (day) {
            controller.setRRule('FREQ=YEARLY;BYMONTH=1', day);

            expect(controller.dayOfWeek.value, day);
            expect(
              controller.dayOfWeekOrdinal.value,
              defaultBySetPosNthWeekDay,
            );
          },
          setUp: () => controller = YearlyPickerController(listener: () {}),
          tearDown: () => controller.dispose(),
        );
      });

      property('updates with custom firstDayOfWeek', () {
        late YearlyPickerController controller;

        forAll(
          combine2(
            dayOfWeek(),
            dayOfWeek(),
          ).map((t) => (selected: t.$1, first: t.$2)),
          (t) {
            controller.setRRule(
              'FREQ=YEARLY;BYMONTH=1;BYDAY=${t.selected.rruleName};BYSETPOS=1',
              t.first,
            );

            expect(controller.dayOfWeek.value, t.selected);
            expect(controller.daysOfWeek.value.first.$1, t.first);
          },
          setUp: () => controller = YearlyPickerController(listener: () {}),
          tearDown: () => controller.dispose(),
        );
      });

      test('handles complex rrule with BYDAY and BYSETPOS', () {
        controller.setRRule(
          'FREQ=YEARLY;BYMONTH=12;BYDAY=FR;BYSETPOS=-1;DTSTART:20260101',
        );

        expect(controller.month.value, Month.december);
        expect(controller.dayOfWeek.value, DayOfWeek.friday);
        expect(controller.dayOfWeekOrdinal.value, DayOfWeekOrdinal.last);
        expect(controller.intervalSegmentType.value, const {
          IntervalPickerSegmentType.relative,
        });
      });

      test('handles complex rrule with BYMONTHDAY', () {
        controller.setRRule(
          'FREQ=YEARLY;BYMONTH=6;BYMONTHDAY=25;DTSTART:20260101',
        );

        expect(controller.month.value, Month.june);
        expect(controller.dayOfMonth.value, 25);
        expect(controller.intervalSegmentType.value, const {
          IntervalPickerSegmentType.precise,
        });
      });

      test('parses lowercase rrule with BYMONTHDAY', () {
        controller.setRRule('freq=yearly;bymonth=1;bymonthday=15');

        expect(controller.month.value, Month.january);
        expect(controller.dayOfMonth.value, 15);
        expect(controller.intervalSegmentType.value, const {
          IntervalPickerSegmentType.precise,
        });
      });

      test('parses lowercase rrule with byday and bysetpos', () {
        controller.setRRule('freq=yearly;bymonth=1;byday=mo;bysetpos=1');

        expect(controller.month.value, Month.january);
        expect(controller.dayOfWeek.value, DayOfWeek.monday);
        expect(controller.dayOfWeekOrdinal.value, DayOfWeekOrdinal.first);
        expect(controller.intervalSegmentType.value, const {
          IntervalPickerSegmentType.relative,
        });
      });

      test('parses mixed case rrule', () {
        controller.setRRule('Freq=Yearly;ByMonth=3;ByMonthDay=25');

        expect(controller.month.value, Month.march);
        expect(controller.dayOfMonth.value, 25);
      });

      test('prioritizes BYDAY when both BYMONTHDAY and BYDAY are present', () {
        controller.setRRule(
          'FREQ=YEARLY;BYMONTH=1;BYMONTHDAY=15;BYDAY=MO;BYSETPOS=1',
        );

        expect(controller.dayOfWeek.value, DayOfWeek.monday);
        expect(controller.dayOfWeekOrdinal.value, DayOfWeekOrdinal.first);
        expect(controller.intervalSegmentType.value, const {
          IntervalPickerSegmentType.relative,
        });
      });

      test('handles extra parameters in rrule', () {
        controller.setRRule(
          'FREQ=YEARLY;INTERVAL=5;BYMONTH=1;BYMONTHDAY=10;'
          'DTSTART:20260101;UNTIL:20270101',
        );

        expect(controller.month.value, Month.january);
        expect(controller.dayOfMonth.value, 10);
      });

      test('handles whitespace in rrule', () {
        controller.setRRule('FREQ=YEARLY;  BYMONTH=1;  BYMONTHDAY=15');

        expect(controller.month.value, Month.january);
        expect(controller.dayOfMonth.value, 15);
      });

      test('uses firstDayOfWeek in setRRule', () {
        controller.setRRule(
          'FREQ=YEARLY;BYMONTH=1;BYDAY=MO;BYSETPOS=1',
          .friday,
        );

        expect(controller.dayOfWeek.value, DayOfWeek.monday);
        expect(controller.daysOfWeek.value.first.$1, DayOfWeek.friday);
      });

      test('handles leap day (February 29)', () {
        controller.setRRule('FREQ=YEARLY;BYMONTH=2;BYMONTHDAY=29');

        expect(controller.month.value, Month.february);
        expect(controller.dayOfMonth.value, 29);
        expect(controller.intervalSegmentType.value, const {
          IntervalPickerSegmentType.precise,
        });
      });

      property('handles invalid BYMONTH values by defaulting to January', () {
        forAll(integer().filter((month) => month < 1 || month > 12), (month) {
          controller.setRRule('FREQ=YEARLY;BYMONTH=$month;BYMONTHDAY=15');

          expect(controller.month.value, Month.january);
        });
      });

      property('handles invalid BYMONTHDAY for month', () {
        forAll(
          month().flatMap((month) {
            return combine2(
              constant(month),
              integer(min: month.maxDay + 1),
            ).map((t) => (month: t.$1, day: t.$2));
          }),
          (t) {
            controller.setRRule(
              'FREQ=YEARLY;BYMONTH=${t.month.rruleValue};BYMONTHDAY=${t.day}',
            );

            expect(controller.month.value, t.month);
            expect(controller.dayOfMonth.value, defaultByMonthDay);
          },
        );
      });

      test('handles missing BYMONTH parameter', () {
        controller.setRRule('FREQ=YEARLY;BYMONTHDAY=15');

        expect(controller.month.value, Month.january);
        expect(controller.dayOfMonth.value, 15);
      });
    });

    group('buildRRulePart', () {
      test('builds correct rrule string with default values', () {
        final sb = StringBuffer();

        controller.buildRRulePart(sb);

        expect(
          sb.toString(),
          'FREQ=YEARLY;INTERVAL=1;BYMONTH=1;BYMONTHDAY=$defaultByMonthDay',
        );
      });

      property('builds correct rrule string with custom precise', () {
        final sb = StringBuffer();
        late YearlyPickerController controller;

        forAll(
          month().flatMap((month) {
            return combine3(
              interval(),
              constant(month),
              integer(min: byMonthDayMin, max: month.maxDay),
            ).map((t) => (interval: t.$1, month: t.$2, day: t.$3));
          }),
          (t) {
            controller.setRRule(
              'FREQ=YEARLY;INTERVAL=${t.interval};'
              'BYMONTH=${t.month.rruleValue};BYMONTHDAY=${t.day}',
            );

            controller.buildRRulePart(sb);

            final maxDay = t.month.maxDay;
            final day = t.day <= maxDay ? t.day : maxDay;
            expect(
              sb.toString(),
              'FREQ=YEARLY;INTERVAL=${t.interval};'
              'BYMONTH=${t.month.rruleValue};BYMONTHDAY=$day',
            );
          },
          setUp: () => controller = YearlyPickerController(listener: () {}),
          tearDown: () {
            controller.dispose();
            sb.clear();
          },
        );
      });

      property('builds correct rrule string with custom relative', () {
        final sb = StringBuffer();
        late YearlyPickerController controller;

        forAll(
          combine4(
            interval(),
            month(),
            dayOfWeek(),
            dayOfWeekOrdinal(),
          ).map((t) => (interval: t.$1, month: t.$2, day: t.$3, ordinal: t.$4)),
          (t) {
            controller.setRRule(
              'FREQ=YEARLY;INTERVAL=${t.interval};'
              'BYMONTH=${t.month.rruleValue};'
              'BYDAY=${t.day.rruleName};BYSETPOS=${t.ordinal.rruleValue}',
            );

            sb.clear();
            controller.buildRRulePart(sb);

            expect(
              sb.toString(),
              'FREQ=YEARLY;INTERVAL=${t.interval};'
              'BYMONTH=${t.month.rruleValue};'
              'BYDAY=${t.day.rruleName};BYSETPOS=${t.ordinal.rruleValue}',
            );
          },
          setUp: () => controller = YearlyPickerController(listener: () {}),
          tearDown: () {
            controller.dispose();
            sb.clear();
          },
        );
      });
    });

    test('disposes all notifiers', () {
      final controller = YearlyPickerController(listener: () {});

      ChangeNotifier.debugAssertNotDisposed(controller.month);
      ChangeNotifier.debugAssertNotDisposed(controller.intervalSegmentType);
      ChangeNotifier.debugAssertNotDisposed(controller.dayOfMonth);
      ChangeNotifier.debugAssertNotDisposed(controller.dayOfWeekOrdinal);
      ChangeNotifier.debugAssertNotDisposed(controller.dayOfWeek);
      ChangeNotifier.debugAssertNotDisposed(controller.daysOfWeek);

      controller.dispose();

      expect(() {
        ChangeNotifier.debugAssertNotDisposed(controller.month);
      }, throwsFlutterError);
      expect(() {
        ChangeNotifier.debugAssertNotDisposed(controller.intervalSegmentType);
      }, throwsFlutterError);
      expect(() {
        ChangeNotifier.debugAssertNotDisposed(controller.dayOfMonth);
      }, throwsFlutterError);
      expect(() {
        ChangeNotifier.debugAssertNotDisposed(controller.dayOfWeekOrdinal);
      }, throwsFlutterError);
      expect(() {
        ChangeNotifier.debugAssertNotDisposed(controller.dayOfWeek);
      }, throwsFlutterError);
      expect(() {
        ChangeNotifier.debugAssertNotDisposed(controller.daysOfWeek);
      }, throwsFlutterError);
    });
  });
}
