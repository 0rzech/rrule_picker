// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:kiri_check/kiri_check.dart';
import 'package:rrule_picker/src/monthly.dart';
import 'package:rrule_picker/src/shared/interval.dart';
import 'package:rrule_picker/src/shared/parsing.dart';
import 'package:rrule_picker/src/shared/resolved_theme.dart';
import 'package:spot/spot.dart';

import '../helpers.dart';

void main() {
  group(MonthlyPicker, () {
    const theme = ResolvedThemeData(
      padding: .all(8),
      headerTheme: .new(),
      dropdownTheme: .new(),
      topDropdownTheme: .new(),
      labelStyle: .new(color: Colors.cyan),
    );

    late MonthlyPickerController controller;
    late int listenerCallCount;

    setUpAll(() async {
      if (!kIsWeb) {
        await loadAppFonts();
      }
      Intl.defaultLocale = 'en';
      initializeDateFormatting();
    });

    setUp(() {
      controller = MonthlyPickerController(listener: () => ++listenerCallCount);
      listenerCallCount = 0;
    });

    tearDown(() => controller.dispose.callIgnoringErrors());

    testWidgets('renders IntervalPicker with correct localizations', (
      tester,
    ) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: MonthlyPicker(controller: controller),
        ),
      );

      spot<IntervalPicker>().existsOnce();
      final l = tester.localizations<MonthlyPicker>();
      spotText(
        l.rrulePickerEveryMonthly(defaultInterval),
        exact: true,
      ).existsOnce();
      spotText(
        l.rrulePickerMonths(defaultInterval),
        exact: true,
      ).existsAtLeastOnce();
    });

    testWidgets('renders 2 interval segment types (precise and relative)', (
      tester,
    ) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: MonthlyPicker(controller: controller),
        ),
      );

      final buttons = spot<SegmentedButton<IntervalPickerSegmentType>>()
          .existsOnce()
          .widget
          .segments
          .map((segment) => segment.value);

      expect(
        buttons,
        orderedEquals(<IntervalPickerSegmentType>[.precise, .relative]),
      );
    });

    testWidgets('renders day of month dropdown when precise is selected', (
      tester,
    ) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: MonthlyPicker(controller: controller),
        ),
      );

      final l = tester.localizations<MonthlyPicker>();
      spot<DropdownButton<int>>().existsOnce();
      spotText(l.rrulePickerDayOfMonth, exact: true).existsOnce();
    });

    testWidgets('renders day of week dropdowns when relative is selected', (
      tester,
    ) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: MonthlyPicker(controller: controller),
        ),
      );

      final l = tester.localizations<MonthlyPicker>();
      final button = spot<SegmentedButton<IntervalPickerSegmentType>>()
          .spotText(l.rrulePickerDayOfWeek, exact: true);

      await act.tap(button);
      await tester.pump();

      spot<DropdownButton<DayOfWeekOrdinal>>().existsOnce();
      spot<DropdownButton<DayOfWeek>>().existsOnce();
      spotText(l.rrulePickerDayOfWeek, exact: true).existsOnce();
    });

    testWidgets('uses provided controller', (tester) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: MonthlyPicker(controller: controller),
        ),
      );

      await act.enterText(spot<TextField>(), '222');

      expect(controller.getIntervalValue(), 222);
    });

    testWidgets('applies ResolvedTheme when provided', (tester) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: MonthlyPicker(controller: controller),
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
          child: MonthlyPicker(controller: controller),
        ),
      );

      final button = spot<SegmentedButton<IntervalPickerSegmentType>>()
          .existsOnce();

      expect(button.widget.style, theme.segmentedButtonStyle);
    });

    testWidgets('renders last day option in day of month dropdown', (
      tester,
    ) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: MonthlyPicker(controller: controller),
        ),
      );

      final items = spot<DropdownButton<int>>().existsOnce().widget.items;

      expect(items?.length, byMonthDayMax);
      expect(items?.last.value, byMonthDayMax);
    });

    testWidgets('changes interval segment type '
        'when tapping segments', (tester) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: MonthlyPicker(controller: controller),
        ),
      );

      expect(controller.intervalSegmentType.value, const {
        IntervalPickerSegmentType.precise,
      });

      await act.tap(
        spot<SegmentedButton<IntervalPickerSegmentType>>().spotText(
          tester.localizations<MonthlyPicker>().rrulePickerDayOfWeek,
          exact: true,
        ),
      );
      await tester.pumpAndSettle();

      expect(controller.intervalSegmentType.value, const {
        IntervalPickerSegmentType.relative,
      });

      await act.tap(
        spot<SegmentedButton<IntervalPickerSegmentType>>().spotText(
          tester.localizations<MonthlyPicker>().rrulePickerDayOfMonth,
          exact: true,
        ),
      );
      await tester.pumpAndSettle();

      expect(controller.intervalSegmentType.value, const {
        IntervalPickerSegmentType.precise,
      });
    });

    testWidgets('updates dayOfMonth when selecting from dropdown', (
      tester,
    ) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: MonthlyPicker(controller: controller),
        ),
      );

      await act.tap(spot<DropdownButton<int>>());
      await tester.pumpAndSettle();

      await act.tap(
        spot<DropdownMenuItem<int>>().whereWidgetProp(
          widgetProp('value', (widget) => widget.value),
          (value) => value == 5,
        ),
      );
      await tester.pumpAndSettle();

      expect(controller.dayOfMonth.value, 5);
    });

    testWidgets('updates dayOfWeekOrdinal when selecting from dropdown', (
      tester,
    ) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: MonthlyPicker(controller: controller),
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

    testWidgets('updates dayOfWeek when selecting from dropdown', (
      tester,
    ) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: MonthlyPicker(controller: controller),
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
          child: MonthlyPicker(controller: controller, firstDayOfWeek: .friday),
        ),
      );

      expect(controller.daysOfWeek.value.first.$1, DayOfWeek.friday);
    });

    testWidgets('updates daysOfWeek when locale changes', (tester) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: MonthlyPicker(controller: controller),
        ),
      );

      expect(controller.dayOfWeekFormatter.locale.toString(), 'en');
      final daysOfWeek = controller.daysOfWeek.value;

      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: MonthlyPicker(controller: controller),
        ),
        locale: const Locale('pl'),
      );

      expect(controller.dayOfWeekFormatter.locale.toString(), 'pl');
      expect(controller.daysOfWeek.value, isNot(unorderedEquals(daysOfWeek)));
    });

    testWidgets('updates daysOfWeek when firstDayOfWeek and locale change', (
      tester,
    ) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: MonthlyPicker(controller: controller),
        ),
      );

      expect(controller.dayOfWeekFormatter.locale.toString(), 'en');
      expect(
        controller.daysOfWeek.value.map((t) => t.$1),
        orderedEquals(DayOfWeek.values),
      );

      final daysOfWeekEn = controller.daysOfWeek.value.map((t) => t.$2);

      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: MonthlyPicker(controller: controller, firstDayOfWeek: .sunday),
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
    });
  });

  group(MonthlyPickerController, () {
    late MonthlyPickerController controller;

    setUpAll(() {
      Intl.defaultLocale = 'en';
      initializeDateFormatting();
    });

    setUp(() => controller = MonthlyPickerController(listener: () {}));
    tearDown(() => controller.dispose());

    group('constructor', () {
      test('initializes with default interval when initialRRule is empty', () {
        final controller = MonthlyPickerController(listener: () {});

        expect(controller.getIntervalValue(), defaultInterval);
        expect(controller.intervalNotifier.value, defaultInterval);
        expect(controller.intervalController.text, defaultInterval.toString());
        expect(controller.dayOfMonth.value, defaultByMonthDay);
        expect(controller.intervalSegmentType.value, const {
          IntervalPickerSegmentType.precise,
        });

        addTearDown(controller.dispose);
      });

      property('initializes with firstDayOfWeek when provided', () {
        late MonthlyPickerController controller;

        forAll(dayOfWeek(), (day) {
          controller = MonthlyPickerController(
            firstDayOfWeek: day,
            listener: () {},
          );

          expect(controller.dayOfWeek.value, day);
          expect(controller.daysOfWeek.value.first.$1, day);
        }, tearDown: () => controller.dispose());
      });

      property('initializes from valid rrule with INTERVAL and BYMONTHDAY', () {
        late MonthlyPickerController controller;

        forAll(
          combine2(
            interval(),
            byMonthDay(),
          ).map((t) => (interval: t.$1, day: t.$2)),
          (t) {
            controller = MonthlyPickerController(
              initialRRule:
                  'FREQ=MONTHLY;INTERVAL=${t.interval};'
                  'BYMONTHDAY=${t.day < byMonthDayMax ? t.day : -1}',
              listener: () {},
            );

            expect(controller.getIntervalValue(), t.interval);
            expect(controller.intervalNotifier.value, t.interval);
            expect(controller.intervalController.text, t.interval.toString());
            expect(controller.dayOfMonth.value, t.day);
          },
          tearDown: () => controller.dispose(),
        );
      });

      property('initializes from valid rrule '
          'with INTERVAL, BYDAY and BYSETPOS', () {
        late MonthlyPickerController controller;

        forAll(
          combine3(
            interval(),
            dayOfWeek(),
            dayOfWeekOrdinal(),
          ).map((t) => (interval: t.$1, day: t.$2, ordinal: t.$3)),
          (t) {
            controller = MonthlyPickerController(
              initialRRule:
                  'FREQ=MONTHLY;INTERVAL=${t.interval};'
                  'BYDAY=${t.day.rruleName};BYSETPOS=${t.ordinal.rruleValue}',
              listener: () {},
            );

            expect(controller.getIntervalValue(), t.interval);
            expect(controller.intervalNotifier.value, t.interval);
            expect(controller.intervalController.text, t.interval.toString());
            expect(controller.dayOfWeek.value, t.day);
            expect(controller.dayOfWeekOrdinal.value, t.ordinal);
          },
          tearDown: () => controller.dispose(),
        );
      });

      test('initializes with default interval when INTERVAL is missing', () {
        final controller = MonthlyPickerController(
          initialRRule: 'FREQ=MONTHLY;BYMONTHDAY=15',
          listener: () {},
        );

        expect(controller.getIntervalValue(), defaultInterval);
        expect(controller.dayOfMonth.value, 15);

        addTearDown(controller.dispose);
      });

      property('initializes with precise segment type for BYMONTHDAY', () {
        late MonthlyPickerController controller;

        forAll(byMonthDay(), (day) {
          controller = MonthlyPickerController(
            initialRRule: 'FREQ=MONTHLY;BYMONTHDAY=$day',
            listener: () {},
          );

          expect(controller.intervalSegmentType.value, const {
            IntervalPickerSegmentType.precise,
          });
        }, tearDown: () => controller.dispose());
      });

      property('initializes with relative segment type for BYDAY', () {
        late MonthlyPickerController controller;

        forAll(dayOfWeek(), (day) {
          controller = MonthlyPickerController(
            initialRRule: 'FREQ=MONTHLY;BYDAY=${day.rruleName};BYSETPOS=1',
            listener: () {},
          );

          expect(controller.intervalSegmentType.value, const {
            IntervalPickerSegmentType.relative,
          });
        }, tearDown: () => controller.dispose());
      });

      test('initializes with default dayOfWeekOrdinal', () {
        final controller = MonthlyPickerController(
          initialRRule: 'FREQ=MONTHLY;BYDAY=MO',
          listener: () {},
        );

        expect(controller.dayOfWeekOrdinal.value, defaultBySetPosNthWeekDay);

        addTearDown(controller.dispose);
      });

      property('initializes with parsed dayOfMonth from rrule', () {
        late MonthlyPickerController controller;

        forAll(
          integer(min: byMonthDayMin, max: byMonthDayMax - 1),
          (day) {
            controller = MonthlyPickerController(
              initialRRule: 'FREQ=MONTHLY;BYMONTHDAY=$day',
              listener: () {},
            );

            expect(controller.dayOfMonth.value, day);
          },
          tearDown: () => controller.dispose(),
        );
      });

      property('initializes with parsed dayOfWeek from rrule', () {
        late MonthlyPickerController controller;

        forAll(dayOfWeek(), (day) {
          controller = MonthlyPickerController(
            initialRRule: 'FREQ=MONTHLY;BYDAY=${day.rruleName};BYSETPOS=1',
            listener: () {},
          );

          expect(controller.dayOfWeek.value, day);
        }, tearDown: () => controller.dispose());
      });

      property('initializes with parsed dayOfWeekOrdinal from rrule', () {
        late MonthlyPickerController controller;

        forAll(dayOfWeekOrdinal(), (ordinal) {
          controller = MonthlyPickerController(
            initialRRule:
                'FREQ=MONTHLY;BYDAY=MO;BYSETPOS=${ordinal.rruleValue}',
            listener: () {},
          );

          expect(controller.dayOfWeekOrdinal.value, ordinal);
        }, tearDown: () => controller.dispose());
      });
    });

    group('setRRule', () {
      property('updates from rrule with INTERVAL and BYMONTHDAY', () {
        late MonthlyPickerController controller;

        forAll(
          combine2(
            interval(),
            byMonthDay(),
          ).map((t) => (interval: t.$1, day: t.$2)),
          (t) {
            controller.setRRule(
              'FREQ=MONTHLY;INTERVAL=${t.interval};'
              'BYMONTHDAY=${t.day < byMonthDayMax ? t.day : -1}',
            );

            expect(controller.intervalNotifier.value, t.interval);
            expect(controller.intervalController.text, t.interval.toString());
            expect(controller.dayOfMonth.value, t.day);
          },
          setUp: () => controller = MonthlyPickerController(listener: () {}),
          tearDown: () => controller.dispose(),
        );
      });

      property('updates from rrule with INTERVAL, BYDAY and BYSETPOS', () {
        late MonthlyPickerController controller;

        forAll(
          combine3(
            interval(),
            dayOfWeek(),
            dayOfWeekOrdinal(),
          ).map((t) => (interval: t.$1, day: t.$2, ordinal: t.$3)),
          (t) {
            controller.setRRule(
              'FREQ=MONTHLY;INTERVAL=${t.interval};'
              'BYDAY=${t.day.rruleName};BYSETPOS=${t.ordinal.rruleValue}',
            );

            expect(controller.getIntervalValue(), t.interval);
            expect(controller.intervalNotifier.value, t.interval);
            expect(controller.intervalController.text, t.interval.toString());
            expect(controller.dayOfWeek.value, t.day);
            expect(controller.dayOfWeekOrdinal.value, t.ordinal);
          },
          setUp: () => controller = MonthlyPickerController(listener: () {}),
          tearDown: () => controller.dispose(),
        );
      });

      test('sets segment type to precise for BYMONTHDAY', () {
        controller.setRRule('FREQ=MONTHLY;BYMONTHDAY=15');

        expect(controller.intervalSegmentType.value, const {
          IntervalPickerSegmentType.precise,
        });
      });

      test('sets segment type to relative for BYDAY', () {
        controller.setRRule('FREQ=MONTHLY;BYDAY=MO;BYSETPOS=1');

        expect(controller.intervalSegmentType.value, const {
          IntervalPickerSegmentType.relative,
        });
      });

      test('uses default interval for empty rrule', () {
        controller.setRRule('');

        expect(controller.intervalNotifier.value, defaultInterval);
        expect(controller.intervalController.text, defaultInterval.toString());
        expect(controller.dayOfMonth.value, defaultByMonthDay);
        expect(controller.intervalSegmentType.value, const {
          IntervalPickerSegmentType.precise,
        });
      });

      test('uses default values for invalid rrule', () {
        controller.setRRule('INVALID_RRULE');

        expect(controller.intervalNotifier.value, defaultInterval);
        expect(controller.intervalController.text, defaultInterval.toString());
        expect(controller.dayOfMonth.value, defaultByMonthDay);
        expect(controller.intervalSegmentType.value, const {
          IntervalPickerSegmentType.precise,
        });
      });

      test('uses default interval for empty INTERVAL value', () {
        controller.setRRule('FREQ=MONTHLY;INTERVAL=;BYMONTHDAY=15');

        expect(controller.intervalNotifier.value, defaultInterval);
        expect(controller.intervalController.text, defaultInterval.toString());
      });

      test('uses default dayOfMonth when BYMONTHDAY is missing', () {
        controller.setRRule('FREQ=MONTHLY;INTERVAL=1');

        expect(controller.dayOfMonth.value, defaultByMonthDay);
      });

      test('uses default dayOfWeek and ordinal'
          ' when BYDAY and BYSETPOS are missing', () {
        controller.setRRule('FREQ=MONTHLY;INTERVAL=1', .wednesday);

        expect(controller.dayOfWeek.value, DayOfWeek.wednesday);
        expect(controller.dayOfWeekOrdinal.value, defaultBySetPosNthWeekDay);
      });

      property('updates with custom firstDayOfWeek', () {
        late MonthlyPickerController controller;

        forAll(
          combine2(
            dayOfWeek(),
            dayOfWeek(),
          ).map((t) => (selected: t.$1, first: t.$2)),
          (t) {
            controller.setRRule(
              'FREQ=MONTHLY;INTERVAL=1;'
              'BYDAY=${t.selected.rruleName};BYSETPOS=1',
              t.first,
            );

            expect(controller.dayOfWeek.value, t.selected);
            expect(controller.daysOfWeek.value.first.$1, t.first);
          },
          setUp: () => controller = MonthlyPickerController(listener: () {}),
          tearDown: () => controller.dispose(),
        );
      });

      test('handles complex rrule with BYDAY and BYSETPOS', () {
        controller.setRRule(
          'FREQ=MONTHLY;INTERVAL=2;BYDAY=FR;BYSETPOS=-1;DTSTART:20260101',
        );

        expect(controller.intervalNotifier.value, 2);
        expect(controller.dayOfWeek.value, DayOfWeek.friday);
        expect(controller.dayOfWeekOrdinal.value, DayOfWeekOrdinal.last);
        expect(controller.intervalSegmentType.value, const {
          IntervalPickerSegmentType.relative,
        });
      });

      test('handles complex rrule with BYMONTHDAY', () {
        controller.setRRule(
          'FREQ=MONTHLY;INTERVAL=3;BYMONTHDAY=25;DTSTART:20260101',
        );

        expect(controller.intervalNotifier.value, 3);
        expect(controller.dayOfMonth.value, 25);
        expect(controller.intervalSegmentType.value, const {
          IntervalPickerSegmentType.precise,
        });
      });

      test('parses lowercase rrule with BYMONTHDAY', () {
        controller.setRRule('freq=monthly;interval=2;bymonthday=15');

        expect(controller.getIntervalValue(), 2);
        expect(controller.dayOfMonth.value, 15);
        expect(controller.intervalSegmentType.value, const {
          IntervalPickerSegmentType.precise,
        });
      });

      test('parses lowercase rrule with byday and bysetpos', () {
        controller.setRRule('freq=monthly;byday=mo;bysetpos=1');

        expect(controller.getIntervalValue(), defaultInterval);
        expect(controller.dayOfWeek.value, DayOfWeek.monday);
        expect(controller.dayOfWeekOrdinal.value, DayOfWeekOrdinal.first);
        expect(controller.intervalSegmentType.value, const {
          IntervalPickerSegmentType.relative,
        });
      });

      test('parses mixed case rrule', () {
        controller.setRRule('Freq=Monthly;Interval=3;ByMonthDay=25');

        expect(controller.getIntervalValue(), 3);
        expect(controller.dayOfMonth.value, 25);
      });

      test('prioritizes BYDAY when both BYMONTHDAY and BYDAY are present', () {
        controller.setRRule(
          'FREQ=MONTHLY;INTERVAL=1;BYMONTHDAY=15;BYDAY=MO;BYSETPOS=1',
        );

        expect(controller.getIntervalValue(), 1);
        expect(controller.dayOfWeek.value, DayOfWeek.monday);
        expect(controller.dayOfWeekOrdinal.value, DayOfWeekOrdinal.first);
        expect(controller.intervalSegmentType.value, const {
          IntervalPickerSegmentType.relative,
        });
      });

      test('handles extra parameters in rrule', () {
        controller.setRRule(
          'FREQ=MONTHLY;INTERVAL=2;BYMONTHDAY=10;'
          'DTSTART:20260101;UNTIL:20270101',
        );

        expect(controller.getIntervalValue(), 2);
        expect(controller.dayOfMonth.value, 10);
      });

      test('handles whitespace in rrule', () {
        controller.setRRule('FREQ=MONTHLY;  INTERVAL=2;  BYMONTHDAY=15');

        expect(controller.getIntervalValue(), 2);
        expect(controller.dayOfMonth.value, 15);
      });

      test('uses firstDayOfWeek in setRRule', () {
        controller.setRRule(
          'FREQ=MONTHLY;INTERVAL=1;BYDAY=MO;BYSETPOS=1',
          .friday,
        );

        expect(controller.dayOfWeek.value, DayOfWeek.monday);
        expect(controller.daysOfWeek.value.first.$1, DayOfWeek.friday);
      });
    });

    group('buildRRulePart', () {
      test('builds correct rrule string with default values', () {
        final sb = StringBuffer();

        controller.buildRRulePart(sb);

        expect(
          sb.toString(),
          'FREQ=MONTHLY;INTERVAL=$defaultInterval;'
          'BYMONTHDAY=$defaultByMonthDay',
        );
      });

      property('builds correct rrule string with custom precise', () {
        final sb = StringBuffer();
        late MonthlyPickerController controller;

        forAll(
          combine2(
            interval(),
            byMonthDay(),
          ).map((t) => (interval: t.$1, day: t.$2)),
          (t) {
            controller.setIntervalValue(t.interval);
            controller.dayOfMonth.value = t.day;

            controller.buildRRulePart(sb);

            expect(
              sb.toString(),
              'FREQ=MONTHLY;INTERVAL=${t.interval};'
              'BYMONTHDAY=${t.day < byMonthDayMax ? t.day : -1}',
            );
          },
          setUp: () => controller = MonthlyPickerController(listener: () {}),
          tearDown: () {
            sb.clear();
            controller.dispose();
          },
        );
      });

      property('builds correct rrule string with custom relative', () {
        final sb = StringBuffer();
        late MonthlyPickerController controller;

        forAll(
          combine3(
            interval(),
            dayOfWeek(),
            dayOfWeekOrdinal(),
          ).map((t) => (interval: t.$1, day: t.$2, ordinal: t.$3)),
          (t) {
            controller.intervalSegmentType.value = const {.relative};
            controller.setIntervalValue(t.interval);
            controller.dayOfWeek.value = t.day;
            controller.dayOfWeekOrdinal.value = t.ordinal;

            controller.buildRRulePart(sb);

            expect(
              sb.toString(),
              'FREQ=MONTHLY;INTERVAL=${t.interval};'
              'BYDAY=${t.day.rruleName};BYSETPOS=${t.ordinal.rruleValue}',
            );
          },
          setUp: () => controller = MonthlyPickerController(listener: () {}),
          tearDown: () {
            controller.dispose();
            sb.clear();
          },
        );
      });
    });

    test('disposes all notifiers', () {
      final controller = MonthlyPickerController(listener: () {});

      ChangeNotifier.debugAssertNotDisposed(controller.intervalNotifier);
      ChangeNotifier.debugAssertNotDisposed(controller.intervalSegmentType);
      ChangeNotifier.debugAssertNotDisposed(controller.dayOfMonth);
      ChangeNotifier.debugAssertNotDisposed(controller.dayOfWeekOrdinal);
      ChangeNotifier.debugAssertNotDisposed(controller.dayOfWeek);
      ChangeNotifier.debugAssertNotDisposed(controller.daysOfWeek);

      controller.dispose();

      expect(() {
        ChangeNotifier.debugAssertNotDisposed(controller.intervalNotifier);
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
