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
import 'package:rrule_picker/src/weekly.dart';
import 'package:spot/spot.dart';

import '../helpers.dart';

void main() {
  group(WeeklyPicker, () {
    const theme = ResolvedThemeData(
      padding: .all(8),
      headerTheme: .new(),
      dropdownTheme: .new(),
      topDropdownTheme: .new(),
      labelStyle: .new(color: Colors.cyan),
    );

    late WeeklyPickerController controller;
    late int listenerCallCount;

    setUpAll(() async {
      if (!kIsWeb) {
        await loadAppFonts();
      }
      Intl.defaultLocale = 'en';
      initializeDateFormatting();
    });

    setUp(() {
      controller = WeeklyPickerController(listener: () => ++listenerCallCount);
      listenerCallCount = 0;
    });

    tearDown(() => controller.dispose.callIgnoringErrors());

    testWidgets('renders IntervalPicker '
        'with correct localizations', (tester) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: WeeklyPicker(controller: controller),
        ),
      );

      spot<IntervalPicker>().existsOnce();
      final l = tester.localizations<WeeklyPicker>();
      spotText(
        l.rrulePickerEveryWeekly(defaultInterval),
        exact: true,
      ).existsOnce();
      spotText(
        l.rrulePickerWeeks(defaultInterval),
        exact: true,
      ).existsAtLeastOnce();
    });

    testWidgets('renders SegmentedButton '
        'for day of week selection', (tester) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: WeeklyPicker(controller: controller),
        ),
      );

      spot<SegmentedButton<DayOfWeek>>().existsOnce();
    });

    testWidgets('renders 7 day of week segments', (tester) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: WeeklyPicker(controller: controller),
        ),
      );

      final button = spot<SegmentedButton<DayOfWeek>>().existsOnce();

      expect(
        button.widget.segments.map((segment) => segment.value),
        orderedEquals(DayOfWeek.values),
      );
    });

    testWidgets('uses provided controller', (tester) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: WeeklyPicker(controller: controller),
        ),
      );

      await act.enterText(spot<TextField>(), '222');

      expect(controller.getIntervalValue(), 222);
    });

    testWidgets('applies ResolvedTheme when provided', (tester) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: WeeklyPicker(controller: controller),
        ),
      );

      spot<Text>()
          .whereWidgetProp(
            widgetProp('style', (widget) => widget.style),
            (style) => style?.color == theme.labelStyle?.color,
          )
          .existsAtLeastOnce();
    });

    testWidgets('updates selected days when clicking segments', (tester) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: WeeklyPicker(controller: controller),
        ),
      );

      expect(controller.selectedDaysOfWeek.value, const {DayOfWeek.monday});

      final segments = spot<TextButton>();

      await act.tap(segments.atIndex(0));
      await act.tap(segments.atIndex(3));
      await act.tap(segments.atIndex(6));

      await tester.pump();

      expect(controller.selectedDaysOfWeek.value, const <DayOfWeek>{
        .monday,
        .thursday,
        .sunday,
      });
    });

    testWidgets('updates daysOfWeek when firstDayOfWeek changes', (
      tester,
    ) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: WeeklyPicker(controller: controller, firstDayOfWeek: .friday),
        ),
      );

      final button = spot<SegmentedButton<DayOfWeek>>().existsOnce();

      expect(button.widget.segments.first.value, DayOfWeek.friday);
    });

    testWidgets('applies ResolvedTheme to SegmentedButton', (tester) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: WeeklyPicker(controller: controller),
        ),
      );

      final button = spot<SegmentedButton<DayOfWeek>>().existsOnce();

      expect(button.widget.style, theme.segmentedButtonStyle);
    });

    testWidgets('updates dayOfWeekFormat when locale changes', (tester) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: WeeklyPicker(controller: controller),
        ),
      );

      expect(controller.dayOfWeekFormat.locale.toString(), 'en');

      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: WeeklyPicker(controller: controller),
        ),
        locale: const Locale('pl'),
      );

      expect(controller.dayOfWeekFormat.locale.toString(), 'pl');
    });

    testWidgets('updates daysOfWeek when locale changes', (tester) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: WeeklyPicker(controller: controller),
        ),
      );

      expect(
        controller.daysOfWeek.map((t) => t.$1),
        orderedEquals(DayOfWeek.values),
      );

      final daysOfWeekEn = controller.daysOfWeek.map((t) => t.$2);

      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: WeeklyPicker(controller: controller),
        ),
        locale: const Locale('pl'),
      );

      expect(
        controller.daysOfWeek.map((t) => t.$2),
        isNot(unorderedEquals(daysOfWeekEn)),
      );
    });

    testWidgets('updates daysOfWeek '
        'when firstDayOfWeek changes', (tester) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: WeeklyPicker(controller: controller),
        ),
      );

      expect(
        controller.daysOfWeek.map((t) => t.$1),
        orderedEquals(DayOfWeek.values),
      );

      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: WeeklyPicker(controller: controller, firstDayOfWeek: .friday),
        ),
      );

      expect(
        controller.daysOfWeek.map((t) => t.$1),
        orderedEquals(const <DayOfWeek>[
          .friday,
          .saturday,
          .sunday,
          .monday,
          .tuesday,
          .wednesday,
          .thursday,
        ]),
      );
    });

    testWidgets('updates both dateFormatter and daysOfWeek', (tester) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: WeeklyPicker(controller: controller),
        ),
      );

      expect(controller.dayOfWeekFormat.locale, 'en');
      expect(
        controller.daysOfWeek.map((t) => t.$1),
        orderedEquals(DayOfWeek.values),
      );

      final daysOfWeekEn = controller.daysOfWeek.map((t) => t.$2);

      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: WeeklyPicker(controller: controller, firstDayOfWeek: .sunday),
        ),
        locale: const Locale('pl'),
      );

      expect(controller.dayOfWeekFormat.locale, 'pl');
      expect(
        controller.daysOfWeek.map((t) => t.$1),
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
        controller.daysOfWeek.map((t) => t.$2),
        isNot(unorderedEquals(daysOfWeekEn)),
      );
    });

    testWidgets('daysOfWeek formatted strings are not empty', (tester) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: WeeklyPicker(controller: controller),
        ),
      );

      expect(controller.daysOfWeek.map((t) => t.$2), everyElement(isNotEmpty));
    });
  });

  group(WeeklyPickerController, () {
    late WeeklyPickerController controller;

    setUpAll(() {
      Intl.defaultLocale = 'en';
      initializeDateFormatting();
    });

    setUp(() => controller = WeeklyPickerController(listener: () {}));
    tearDown(() => controller.dispose());

    group('constructor', () {
      test('initializes with firstDayOfWeek when provided', () {
        final controller = WeeklyPickerController(
          firstDayOfWeek: .friday,
          listener: () {},
        );

        expect(controller.selectedDaysOfWeek.value, const {DayOfWeek.friday});

        addTearDown(controller.dispose);
      });

      property('initializes with parsed BYDAY from rrule', () {
        late WeeklyPickerController controller;

        forAll(
          combine2(interval(), dayOfWeekSet()).map(
            (t) => (
              interval: t.$1,
              daysOfWeek: t.$2.map((d) => d.rruleName),
              expected: t.$2,
            ),
          ),
          (t) {
            controller = WeeklyPickerController(
              initialRRule:
                  'FREQ=WEEKLY;INTERVAL=${t.interval};'
                  'BYDAY=${t.daysOfWeek.join(',')}',
              listener: () {},
            );

            expect(controller.selectedDaysOfWeek.value, t.expected);
          },
          tearDown: () => controller.dispose(),
        );
      });
    });

    group('dispose', () {
      test('disposes selectedDaysOfWeek', () {
        final controller = WeeklyPickerController(listener: () {});

        ChangeNotifier.debugAssertNotDisposed(controller.selectedDaysOfWeek);

        controller.dispose();

        expect(
          () => ChangeNotifier.debugAssertNotDisposed(
            controller.selectedDaysOfWeek,
          ),
          throwsFlutterError,
        );
      });
    });

    group('setRRule', () {
      test('updates selected BYDAY from rrule', () {
        controller.setRRule('FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,TU,WE');

        expect(controller.selectedDaysOfWeek.value, <DayOfWeek>{
          .monday,
          .tuesday,
          .wednesday,
        });
      });

      test('uses default day when BYDAY is missing', () {
        controller.setRRule('FREQ=WEEKLY;INTERVAL=1');

        expect(controller.selectedDaysOfWeek.value, const {DayOfWeek.monday});
      });

      property('updates with custom firstDayOfWeek', () {
        forAll(
          combine2(
            dayOfWeek(),
            dayOfWeek(),
          ).map((t) => (selected: t.$1, first: t.$2)),
          (t) {
            controller.setRRule(
              'FREQ=WEEKLY;INTERVAL=1;BYDAY=${t.selected.rruleName}',
              t.first,
            );

            expect(controller.selectedDaysOfWeek.value, {t.selected});
            expect(controller.daysOfWeek.first.$1, t.first);
          },
        );
      });
    });

    group('buildRRulePart', () {
      test('builds correct rrule string with default interval and monday', () {
        final sb = StringBuffer();

        controller.buildRRulePart(sb);

        expect(sb.toString(), 'FREQ=WEEKLY;INTERVAL=$defaultInterval;BYDAY=MO');
      });

      test('builds correct rrule string with intervalMin', () {
        controller.setIntervalValue(intervalMin);
        final sb = StringBuffer();

        controller.buildRRulePart(sb);

        expect(sb.toString(), 'FREQ=WEEKLY;INTERVAL=$intervalMin;BYDAY=MO');
      });

      property('builds correct rrule string with custom interval', () {
        forAll(interval(), (interval) {
          controller.setIntervalValue(interval);
          final sb = StringBuffer();

          controller.buildRRulePart(sb);

          expect(sb.toString(), 'FREQ=WEEKLY;INTERVAL=$interval;BYDAY=MO');
        });
      });

      test('builds correct rrule string with multiple BYDAY sorted', () {
        controller.setIntervalValue(1);
        controller.selectedDaysOfWeek.value = <DayOfWeek>{
          .wednesday,
          .monday,
          .friday,
        };
        final sb = StringBuffer();

        controller.buildRRulePart(sb);

        expect(sb.toString(), 'FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,WE,FR');
      });

      test('builds correct rrule string with all BYDAY', () {
        controller.setIntervalValue(2);
        controller.selectedDaysOfWeek.value = DayOfWeek.values.toSet();
        final sb = StringBuffer();

        controller.buildRRulePart(sb);

        expect(
          sb.toString(),
          'FREQ=WEEKLY;INTERVAL=2;BYDAY=MO,TU,WE,TH,FR,SA,SU',
        );
      });

      test('builds correct rrule string with single day', () {
        controller.setIntervalValue(3);
        controller.selectedDaysOfWeek.value = const {DayOfWeek.sunday};
        final sb = StringBuffer();

        controller.buildRRulePart(sb);

        expect(sb.toString(), 'FREQ=WEEKLY;INTERVAL=3;BYDAY=SU');
      });
    });

    property('listener is called when selectedDaysOfWeek is set', () async {
      late WeeklyPickerController controller;
      late int callCount;

      forAll(
        combine3(
          interval(),
          dayOfWeek(),
          dayOfWeek(),
        ).map((t) => (interval: t.$1, oldDay: t.$2, newDay: t.$3)),
        (t) {
          controller = WeeklyPickerController(
            initialRRule: 'INTERVAL=${t.interval};BYDAY=${t.oldDay.rruleName}',
            listener: () => ++callCount,
          );

          controller.selectedDaysOfWeek.value = {t.newDay};

          expect(callCount, 1);
        },
        setUp: () => callCount = 0,
        tearDown: () => controller.dispose(),
      );
    });
  });

  group('parseRRule', () {
    test('returns default interval and firstDayOfWeek for empty string', () {
      final (interval, daysOfWeek) = parseRRule('', .monday);
      expect(interval, defaultInterval);
      expect(daysOfWeek, const {DayOfWeek.monday});
    });

    property('returns default interval and custom firstDayOfWeek '
        'for empty string', () {
      forAll(dayOfWeek(), (day) {
        final (interval, daysOfWeek) = parseRRule('', day);

        expect(interval, defaultInterval);
        expect(daysOfWeek, {day});
      });
    });

    property('returns correct interval for valid INTERVAL', () {
      forAll(interval(), (expectedInterval) {
        final (interval, daysOfWeek) = parseRRule(
          'FREQ=WEEKLY;INTERVAL=$expectedInterval;BYDAY=MO',
          .monday,
        );
        expect(interval, expectedInterval);
      });
    });

    test('returns defaultInterval when INTERVAL is missing', () {
      final (interval, daysOfWeek) = parseRRule(
        'FREQ=WEEKLY;BYDAY=MO',
        .monday,
      );

      expect(interval, defaultInterval);
    });

    property('parses single day', () {
      forAll(dayOfWeek(), (day) {
        final (interval, daysOfWeek) = parseRRule(
          'FREQ=WEEKLY;INTERVAL=1;BYDAY=${day.rruleName}',
          .monday,
        );

        expect(interval, 1);
        expect(daysOfWeek, {day});
      });
    });

    test('parses multiple BYDAY', () {
      final (interval, daysOfWeek) = parseRRule(
        'FREQ=WEEKLY;INTERVAL=2;BYDAY=MO,TU,WE',
        .monday,
      );

      expect(interval, 2);
      expect(daysOfWeek, <DayOfWeek>{.monday, .tuesday, .wednesday});
    });

    test('parses all BYDAY', () {
      final (interval, daysOfWeek) = parseRRule(
        'FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,TU,WE,TH,FR,SA,SU',
        .monday,
      );
      expect(interval, 1);
      expect(daysOfWeek, DayOfWeek.values.toSet());
    });

    property('returns defaultInterval when INTERVAL is not a number', () {
      forAll(
        utf8String().filter((v) => v.isNotEmpty && int.tryParse(v) == null),
        (interval) {
          final (intervalResult, daysOfWeek) = parseRRule(
            'FREQ=WEEKLY;INTERVAL=$interval;BYDAY=MO',
            .monday,
          );
          expect(intervalResult, defaultInterval);
        },
      );
    });

    test('returns defaultInterval when INTERVAL is 0', () {
      final (interval, daysOfWeek) = parseRRule(
        'FREQ=WEEKLY;INTERVAL=0;BYDAY=MO',
        .monday,
      );
      expect(interval, defaultInterval);
    });

    property('returns defaultInterval when INTERVAL is negative', () {
      forAll(integer(max: -1), (interval) {
        final (intervalResult, daysOfWeek) = parseRRule(
          'FREQ=WEEKLY;INTERVAL=$interval;BYDAY=MO',
          .monday,
        );
        expect(intervalResult, defaultInterval);
      });
    });

    property('extracts INTERVAL and BYDAY from complex rrule', () {
      forAll(
        combine2(interval(), dayOfWeekSet()).map(
          (t) => (
            interval: t.$1,
            days: t.$2.map((d) => d.rruleName).join(','),
            expected: t.$2,
          ),
        ),
        (t) {
          final (interval, daysOfWeek) = parseRRule(
            'FREQ=WEEKLY;INTERVAL=${t.interval};'
            'BYDAY=${t.days};DTSTART:20260101',
            .monday,
          );

          expect(interval, t.interval);
          expect(daysOfWeek, t.expected);
        },
      );
    });

    property('returns defaultInterval when INTERVAL value is empty', () {
      forAll(
        standardSet(
          dayOfWeek().map((d) => d.rruleName),
          maxLength: DayOfWeek.values.length,
        ),
        (daysOfWeek) {
          final (interval, daysOfWeekResult) = parseRRule(
            'FREQ=WEEKLY;INTERVAL=;BYDAY=${daysOfWeek.join(',')}',
            .monday,
          );
          expect(interval, defaultInterval);
        },
      );
    });

    property('parses INTERVAL with leading zeros', () {
      forAll(interval(), (interval) {
        final (intervalResult, daysOfWeek) = parseRRule(
          'FREQ=WEEKLY;INTERVAL=00$interval;BYDAY=MO',
          DayOfWeek.monday,
        );
        expect(intervalResult, interval);
      });
    });

    test('uses firstDayOfWeek as default when BYDAY is missing', () {
      final (interval, daysOfWeek) = parseRRule(
        'FREQ=WEEKLY;INTERVAL=1',
        .wednesday,
      );
      expect(interval, 1);
      expect(daysOfWeek, const {DayOfWeek.wednesday});
    });

    property('returns default daysOfWeek when invalid BYDAY', () {
      final upper = DayOfWeek.values
          .map((d) => d.rruleName)
          .toList(growable: false);
      final lower = upper.map((d) => d.toLowerCase()).toList(growable: false);
      final excluded = [...upper, ...lower];

      forAll(utf8String().filter((v) => !excluded.contains(v)), (invalid) {
        final (interval, daysOfWeek) = parseRRule(
          'FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,$invalid,WE',
          .monday,
        );

        expect(interval, 1);
        expect(daysOfWeek, const {DayOfWeek.monday});
      });
    });

    test('returns default day when BYDAY contains only invalid days', () {
      final (interval, daysOfWeek) = parseRRule(
        'FREQ=WEEKLY;INTERVAL=1;BYDAY=INVALID1,INVALID2',
        .monday,
      );

      expect(interval, 1);
      expect(daysOfWeek, const {DayOfWeek.monday});
    });

    property('extracts INTERVAL and BYDAY from complex lowercase rrule', () {
      forAll(
        combine2(interval(), dayOfWeekSet()).map(
          (t) => (
            interval: t.$1,
            days: t.$2.map((d) => d.rruleName.toLowerCase()).join(','),
            expected: t.$2,
          ),
        ),
        (t) {
          final (interval, daysOfWeek) = parseRRule(
            'freq=weekly;interval=${t.interval};'
            'byday=${t.days};dtstart:20260101',
            .monday,
          );

          expect(interval, t.interval);
          expect(daysOfWeek, t.expected);
        },
      );
    });

    test('parses mixed case day names', () {
      final (interval, daysOfWeek) = parseRRule(
        'FREQ=WEEKLY;INTERVAL=1;BYDAY=mo,Tu,we',
        .monday,
      );
      expect(interval, 1);
      expect(daysOfWeek, <DayOfWeek>{.monday, .tuesday, .wednesday});
    });
  });
}
