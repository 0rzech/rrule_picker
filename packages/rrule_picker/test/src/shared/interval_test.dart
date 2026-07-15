// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:kiri_check/kiri_check.dart';
import 'package:rrule_picker/l10n/l10n_en.dart';
import 'package:rrule_picker/l10n/l10n_pl.dart';
import 'package:rrule_picker/src/shared/interval.dart';
import 'package:rrule_picker/src/shared/parsing.dart';
import 'package:rrule_picker/src/shared/resolved_theme.dart';
import 'package:spot/spot.dart';

import '../../helpers.dart';

class TestIntervalPickerController extends IntervalPickerController {
  TestIntervalPickerController({
    super.initialInterval = defaultInterval,
    VoidCallback? listener,
  }) : super(listener: listener ?? () {});

  @override
  void buildRRulePart(StringBuffer sb) => throw UnimplementedError();

  @override
  void setRRule(String rrule) => throw UnimplementedError();
}

class TestIntervalPickerSegmentController
    extends IntervalPickerSegmentController {
  TestIntervalPickerSegmentController({
    super.initialInterval,
    super.initialSegmentType,
    super.initialDayOfMonth,
    super.dayOfMonthFormat,
    super.initialDayOfWeekOrdinal,
    super.initialDayOfWeek,
    VoidCallback? listener,
  }) : super(listener: listener ?? () {});

  @override
  void buildRRulePart(StringBuffer sb) => throw UnimplementedError();

  @override
  void setRRule(String rrule) => throw UnimplementedError();
}

void main() {
  group(IntervalPicker, () {
    late ThemeData theme;
    late IntervalPickerController controller;

    setUpAll(() async {
      if (!kIsWeb) {
        await loadAppFonts();
      }
    });

    setUp(() {
      theme = ThemeData();
      controller = TestIntervalPickerController();
    });

    tearDown(() => controller.dispose());

    testWidgets('renders everyLabel, countField, and daysLabel', (
      tester,
    ) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: .defaults(theme),
          child: IntervalPicker(
            everyUnitText: (_) => 'Every',
            intervalUnitText: (_) => 'days',
            controller: controller,
          ),
        ),
      );

      spotText('Every', exact: true).existsOnce();
      spot<TextField>().existsOnce();
      spotText('days', exact: true).existsOnce();
    });

    testWidgets('displays correct initial interval value '
        'in text field', (tester) async {
      const initialValue = 5;
      controller.intervalController.text = initialValue.toString();
      controller.intervalNotifier.value = initialValue;

      await tester.pumpWrapped(
        ResolvedTheme(
          theme: .defaults(theme),
          child: IntervalPicker(
            everyUnitText: (_) => 'Every',
            intervalUnitText: (_) => 'days',
            controller: controller,
          ),
        ),
      );

      spotText(initialValue.toString(), exact: true).existsOnce();
    });

    testWidgets('updates controller and notifier '
        'when text field value changes', (tester) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: .defaults(theme),
          child: IntervalPicker(
            everyUnitText: (_) => 'Every',
            intervalUnitText: (_) => 'days',
            controller: controller,
          ),
        ),
      );

      await act.enterText(spot<TextField>(), '10');

      expect(controller.intervalController.text, '10');
      expect(controller.intervalNotifier.value, 10);
    });

    testWidgets('updates controller to empty string and '
        'does not update notifier on invalid input', (tester) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: .defaults(theme),
          child: IntervalPicker(
            everyUnitText: (_) => 'Every',
            intervalUnitText: (_) => 'days',
            controller: controller,
          ),
        ),
      );

      await act.enterText(spot<TextField>(), 'abc');

      expect(controller.intervalController.text, '');
      expect(controller.intervalNotifier.value, 1);
    });

    testWidgets('updates labels when notifier value changes', (tester) async {
      late int everyUnitValue;
      late int intervalUnitValue;

      await tester.pumpWrapped(
        ResolvedTheme(
          theme: .defaults(theme),
          child: IntervalPicker(
            everyUnitText: (value) {
              everyUnitValue = value;
              return 'Every $value';
            },
            intervalUnitText: (value) {
              intervalUnitValue = value;
              return '$value days';
            },
            controller: controller,
          ),
        ),
      );

      await act.enterText(spot<TextField>(), '10');

      expect(everyUnitValue, 10);
      expect(intervalUnitValue, 10);
      spotText('Every 10', exact: true).existsOnce();
      spotText('10 days', exact: true).existsOnce();

      await act.enterText(spot<TextField>(), '20');

      expect(everyUnitValue, 20);
      expect(intervalUnitValue, 20);
      spotText('Every 20', exact: true).existsOnce();
      spotText('20 days', exact: true).existsOnce();
    });

    testWidgets('applies theme textFieldTheme style', (tester) async {
      const style = TextStyle(fontSize: 40, color: Colors.blue);
      const theme = ResolvedThemeData(
        padding: .all(8),
        headerTheme: .new(),
        dropdownTheme: .new(),
        topDropdownTheme: .new(),
        textFieldTheme: .new(style: style),
      );

      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: IntervalPicker(
            everyUnitText: (_) => 'Every',
            intervalUnitText: (_) => 'days',
            controller: controller,
          ),
        ),
      );

      spot<TextField>().withStyle(style).existsOnce();
    });

    testWidgets('applies theme textFieldTheme decoration', (tester) async {
      const decoration = InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Interval',
      );
      const theme = ResolvedThemeData(
        padding: .all(8),
        headerTheme: .new(),
        dropdownTheme: .new(),
        topDropdownTheme: .new(),
        textFieldTheme: .new(decoration: decoration),
      );

      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: IntervalPicker(
            everyUnitText: (_) => 'Every',
            intervalUnitText: (_) => 'days',
            controller: controller,
          ),
        ),
      );

      spot<TextField>().withDecoration(decoration).existsOnce();
    });

    testWidgets('applies theme labelStyle to labels', (tester) async {
      const labelStyle = TextStyle(fontSize: 40, fontWeight: .bold);
      const theme = ResolvedThemeData(
        labelStyle: labelStyle,
        padding: .all(8),
        headerTheme: .new(),
        dropdownTheme: .new(),
        topDropdownTheme: .new(),
      );

      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: IntervalPicker(
            everyUnitText: (_) => 'Every',
            intervalUnitText: (_) => 'days',
            controller: controller,
          ),
        ),
      );

      spot<Text>()
          .withEffectiveTextStyleMatching((style) {
            style.fontSize.equals(40);
            style.fontWeight.equals(.bold);
          })
          .existsExactlyNTimes(2);
    });

    testWidgets('text field has digitsOnly input formatter', (tester) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: .defaults(theme),
          child: IntervalPicker(
            everyUnitText: (_) => 'Every',
            intervalUnitText: (_) => 'days',
            controller: controller,
          ),
        ),
      );

      expect(
        spot<TextField>().existsOnce().widget.inputFormatters,
        containsAll([
          isA<FilteringTextInputFormatter>(),
          isA<IntervalPickerValueInputFormatter>(),
        ]),
      );
    });

    testWidgets('text field has number keyboard type', (tester) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: .defaults(theme),
          child: IntervalPicker(
            everyUnitText: (_) => 'Every',
            intervalUnitText: (_) => 'days',
            controller: controller,
          ),
        ),
      );

      spot<TextField>().withKeyboardType(.number).existsOnce();
    });
  });

  group(IntervalPickerValueInputFormatter, () {
    final intervalMinValue = TextEditingValue(text: intervalMin.toString());
    late IntervalPickerValueInputFormatter formatter;

    setUp(() => formatter = const IntervalPickerValueInputFormatter());

    test('allows value equal to intervalMin', () {
      final oldValue = const TextEditingValue(text: '');

      final result = formatter.formatEditUpdate(oldValue, intervalMinValue);

      expect(result.text, intervalMin.toString());
    });

    property('allows values greater than or equal to intervalMin', () {
      forAll(interval().map((v) => v.toString()), (interval) {
        final oldValue = const TextEditingValue(text: '');
        final newValue = TextEditingValue(text: interval);

        final result = formatter.formatEditUpdate(oldValue, newValue);

        expect(result.text, interval.toString());
      });
    });

    property('rejects values less than intervalMin', () {
      forAll(integer(max: intervalMin - 1).map((v) => v.toString()), (
        interval,
      ) {
        final newValue = TextEditingValue(text: interval);

        final result = formatter.formatEditUpdate(intervalMinValue, newValue);

        expect(result.text, intervalMinValue.text);
      });
    });

    test('allows empty string', () {
      final newValue = const TextEditingValue(text: '');

      final result = formatter.formatEditUpdate(intervalMinValue, newValue);

      expect(result.text, '');
    });

    property('rejects non-numeric ascii string', () {
      forAll(asciiString().filter((v) => v != '' && int.tryParse(v) == null), (
        interval,
      ) {
        final newValue = TextEditingValue(text: interval);

        final result = formatter.formatEditUpdate(intervalMinValue, newValue);

        expect(result.text, intervalMinValue.text);
      });
    });

    property('rejects non-numeric utf-8 string', () {
      forAll(utf8String().filter((v) => v != '' && int.tryParse(v) == null), (
        interval,
      ) {
        final newValue = TextEditingValue(text: interval);

        final result = formatter.formatEditUpdate(intervalMinValue, newValue);

        expect(result.text, intervalMinValue.text);
      });
    });
  });

  group(IntervalPickerController, () {
    late IntervalPickerController controller;

    setUp(() => controller = TestIntervalPickerController());
    tearDown(() => controller.dispose());

    group('constructor', () {
      test('initializes with default value', () {
        expect(controller.initialInterval, defaultInterval);
        expect(controller.intervalNotifier.value, defaultInterval);
        expect(controller.intervalController.text, defaultInterval.toString());
      });

      property('initializes with custom value', () {
        late IntervalPickerController controller;

        forAll(interval(), (interval) {
          controller = TestIntervalPickerController(initialInterval: interval);

          expect(controller.initialInterval, interval);
          expect(controller.intervalNotifier.value, interval);
          expect(controller.intervalController.text, interval.toString());
        }, tearDown: () => controller.dispose());
      });

      test('adds listener to notifier', () {
        var listenerCallCount = 0;
        final controller = TestIntervalPickerController(
          initialInterval: 1,
          listener: () => ++listenerCallCount,
        );

        controller.intervalNotifier.value = 2;

        expect(listenerCallCount, 1);

        addTearDown(controller.dispose);
      });
    });

    test('setIntervalValue updates controller and notifier', () {
      controller.setIntervalValue(10);

      expect(controller.intervalController.text, '10');
      expect(controller.intervalNotifier.value, 10);
    });

    group('getIntervalValue', () {
      test('returns notifier value when valid', () {
        controller.setIntervalValue(5);

        expect(controller.getIntervalValue(), 5);
      });

      property('returns defaultValue when value is below min', () {
        final controller = TestIntervalPickerController(initialInterval: 0);

        forAll(integer(max: 4), (interval) {
          controller.setIntervalValue(interval);

          final result = controller.getIntervalValue(
            minValue: 5,
            defaultValue: 10,
          );

          expect(result, 10);
        });

        addTearDown(controller.dispose);
      });

      property('returns initialIntervalValue '
          'when value is below minValue and no defaultValue', () {
        final controller = TestIntervalPickerController(initialInterval: 10);

        forAll(integer(max: 4), (interval) {
          controller.setIntervalValue(interval);

          final result = controller.getIntervalValue(minValue: 5);

          expect(result, 10);
        });

        addTearDown(controller.dispose);
      });

      property('returns defaultValue when value is below minValue', () {
        final controller = TestIntervalPickerController(initialInterval: 3);

        forAll(integer(max: 4), (interval) {
          controller.setIntervalValue(interval);

          final result = controller.getIntervalValue(
            minValue: 5,
            defaultValue: 10,
          );

          expect(result, 10);
        });

        addTearDown(controller.dispose);
      });

      property('returns value when equal to minValue', () {
        forAll(integer(), (interval) {
          controller.setIntervalValue(interval);

          final result = controller.getIntervalValue(minValue: interval);

          expect(result, interval);
        });
      });

      property('returns initialIntervalValue '
          'when value is below minValue '
          'and initialIntervalValue >= minValue', () {
        final controller = TestIntervalPickerController(initialInterval: -1111);

        forAll(integer(min: -1000), (interval) {
          controller.setIntervalValue(interval - 1);

          final result = controller.getIntervalValue(minValue: interval);

          expect(result, -1111);
        });

        addTearDown(controller.dispose);
      });
    });

    test('disposes notifier and controller', () {
      final controller = TestIntervalPickerController();

      ChangeNotifier.debugAssertNotDisposed(controller.intervalController);
      ChangeNotifier.debugAssertNotDisposed(controller.intervalNotifier);

      controller.dispose();

      expect(
        () => ChangeNotifier.debugAssertNotDisposed(
          controller.intervalController,
        ),
        throwsFlutterError,
      );
      expect(
        () =>
            ChangeNotifier.debugAssertNotDisposed(controller.intervalNotifier),
        throwsFlutterError,
      );
    });
  });

  group(IntervalPickerSegmentController, () {
    late IntervalPickerSegmentController controller;

    setUp(() => controller = TestIntervalPickerSegmentController());
    tearDown(() => controller.dispose());

    group('interval segment type', () {
      group('constructor', () {
        test('initializes with precise segment type', () {
          expect(controller.intervalSegmentType.value, {
            IntervalSegmentType.precise,
          });
        });

        test('initializes with custom segment type', () {
          final controller = TestIntervalPickerSegmentController(
            initialSegmentType: {.relative},
          );

          expect(controller.intervalSegmentType.value, {
            IntervalSegmentType.relative,
          });

          addTearDown(controller.dispose);
        });

        test('initializes with multiple segment types', () {
          final controller = TestIntervalPickerSegmentController(
            initialSegmentType: {.precise, .relative},
          );

          expect(controller.intervalSegmentType.value, {
            IntervalSegmentType.precise,
            IntervalSegmentType.relative,
          });

          addTearDown(controller.dispose);
        });

        test('adds listener to notifier', () {
          var listenerCallCount = 0;
          final controller = TestIntervalPickerSegmentController(
            listener: () => ++listenerCallCount,
          );

          controller.intervalSegmentType.value = {.relative};

          expect(listenerCallCount, 1);

          addTearDown(controller.dispose);
        });
      });

      test('setIntervalSegmentTypeValue updates notifier value', () {
        controller.setIntervalSegmentTypeValue({.relative});

        expect(controller.intervalSegmentType.value, {
          IntervalSegmentType.relative,
        });
      });

      test('disposes notifier', () {
        final controller = TestIntervalPickerSegmentController();

        ChangeNotifier.debugAssertNotDisposed(controller.intervalSegmentType);

        controller.dispose();

        expect(
          () => ChangeNotifier.debugAssertNotDisposed(
            controller.intervalSegmentType,
          ),
          throwsFlutterError,
        );
      });
    });
  });

  group('day of month', () {
    late IntervalPickerSegmentController controller;
    late int listenerCallCount;

    setUp(() {
      controller = TestIntervalPickerSegmentController(
        listener: () => ++listenerCallCount,
      );
      listenerCallCount = 0;
    });

    tearDown(() => controller.dispose());

    group('constructor', () {
      test('initializes with default day of month value', () {
        expect(controller.dayOfMonth.value, defaultByMonthDay);
      });

      property('initializes with custom initial day of month', () {
        late TestIntervalPickerSegmentController controller;

        forAll(integer(), (day) {
          controller = TestIntervalPickerSegmentController(
            initialDayOfMonth: day,
          );

          expect(controller.dayOfMonth.value, day);
        }, tearDown: () => controller.dispose());
      });

      test('initializes with custom number format', () {
        final controller = TestIntervalPickerSegmentController(
          dayOfMonthFormat: '000',
        );

        expect(controller.dayOfMonthFormatter.format(5), '005');

        addTearDown(controller.dispose);
      });

      test('listener is called when value changes', () {
        controller.dayOfMonth.value = 10;

        expect(listenerCallCount, 1);
      });

      test('uses default number format (00) when not specified', () {
        expect(controller.dayOfMonthFormatter.format(5), '05');
        expect(controller.dayOfMonthFormatter.format(15), '15');
      });
    });

    test('disposes notifier', () {
      final controller = TestIntervalPickerSegmentController();

      ChangeNotifier.debugAssertNotDisposed(controller.dayOfMonth);

      controller.dispose();

      expect(
        () => ChangeNotifier.debugAssertNotDisposed(controller.dayOfMonth),
        throwsFlutterError,
      );
    });

    group('setDayOfMonthValue', () {
      property('sets the day of month value', () {
        forAll(integer(), (day) {
          controller.setDayOfMonthValue(day);

          expect(controller.dayOfMonth.value, day);
        });
      });

      test('notifies listeners when value changes', () {
        controller.setDayOfMonthValue(10);
        expect(listenerCallCount, 1);

        controller.setDayOfMonthValue(20);
        expect(listenerCallCount, 2);
      });

      test('can set value to minimum', () {
        final controller = TestIntervalPickerSegmentController(
          initialDayOfMonth: 30,
        );

        controller.setDayOfMonthValue(byMonthDayMin);

        expect(controller.dayOfMonth.value, byMonthDayMin);

        addTearDown(controller.dispose);
      });

      test('can set value to maximum', () {
        controller.setDayOfMonthValue(31);

        expect(controller.dayOfMonth.value, 31);
      });
    });

    group('dayOfMonthFormatter', () {
      property('formats single digit with leading zero '
          'using default format', () {
        forAll(integer(min: 0, max: 9), (day) {
          final result = controller.dayOfMonthFormatter.format(day);

          expect(result, '0$day');
        });
      });

      property('formats double digits without leading zero '
          'using default format', () {
        forAll(integer(min: 10, max: 99), (day) {
          final result = controller.dayOfMonthFormatter.format(day);

          expect(result, day.toString());
        });
      });

      property('formats with custom format when specified', () {
        final controller = TestIntervalPickerSegmentController(
          dayOfMonthFormat: '#',
        );

        forAll(integer(min: 0, max: 9), (day) {
          final result = controller.dayOfMonthFormatter.format(day);

          expect(result, day.toString());
        });

        addTearDown(controller.dispose);
      });
    });
  });

  group('day of week', () {
    late IntervalPickerSegmentController controller;
    late int listenerCallCount;

    setUpAll(() async {
      Intl.defaultLocale = 'en';
      initializeDateFormatting();
    });

    setUp(() {
      controller = TestIntervalPickerSegmentController(
        listener: () => ++listenerCallCount,
      );
      listenerCallCount = 0;
    });

    tearDown(() => controller.dispose());

    group('constructor', () {
      test('initializes with default values', () {
        expect(controller.dayOfWeekOrdinal.value, DayOfWeekOrdinal.first);
        expect(controller.dayOfWeek.value, DayOfWeek.monday);
        expect(controller.dayOfWeekFormatter.locale.toString(), 'en');
      });

      property('initializes with custom initial values', () {
        late IntervalPickerSegmentController controller;

        forAll(
          combine2(
            dayOfWeekOrdinal(),
            dayOfWeek(),
          ).map((t) => (ordinal: t.$1, day: t.$2)),
          (t) {
            controller = TestIntervalPickerSegmentController(
              initialDayOfWeekOrdinal: t.ordinal,
              initialDayOfWeek: t.day,
            );

            expect(controller.dayOfWeekOrdinal.value, t.ordinal);
            expect(controller.dayOfWeek.value, t.day);
          },
          tearDown: () => controller.dispose(),
        );
      });

      property('initializes daysOfWeek with custom initialDayOfWeek', () {
        late IntervalPickerSegmentController controller;

        forAll(dayOfWeek(), (day) {
          controller = TestIntervalPickerSegmentController(
            initialDayOfWeek: day,
          );

          expect(
            controller.daysOfWeek.value.map((t) => t.$1),
            orderedEquals(
              List.generate(DayOfWeek.values.length, (i) {
                final index = (day.index + i) % DayOfWeek.values.length;
                return DayOfWeek.values[index];
              }),
            ),
          );
        }, tearDown: () => controller.dispose());
      });

      property('listener is called when ordinal value changes', () {
        late IntervalPickerSegmentController controller;
        late int listenerCallCount;

        forAll(
          combine2(dayOfWeekOrdinal(), dayOfWeekOrdinal())
              .filter((t) => t.$1 != t.$2)
              .map((t) => (initial: t.$1, target: t.$2)),
          (t) {
            controller = TestIntervalPickerSegmentController(
              initialDayOfWeekOrdinal: t.initial,
              listener: () => ++listenerCallCount,
            );

            controller.dayOfWeekOrdinal.value = t.target;

            expect(listenerCallCount, 1);
          },
          setUp: () => listenerCallCount = 0,
          tearDown: () => controller.dispose(),
        );
      });

      property('listener is called when day of week value changes', () {
        late IntervalPickerSegmentController controller;
        late int listenerCallCount;

        forAll(
          combine2(dayOfWeek(), dayOfWeek())
              .filter((t) => t.$1 != t.$2)
              .map((t) => (initial: t.$1, target: t.$2)),
          (t) {
            controller = TestIntervalPickerSegmentController(
              initialDayOfWeek: t.initial,
              listener: () => ++listenerCallCount,
            );

            controller.dayOfWeek.value = t.target;

            expect(listenerCallCount, 1);
          },
          setUp: () => listenerCallCount = 0,
          tearDown: () => controller.dispose(),
        );
      });
    });

    test('disposes notifiers', () {
      final controller = TestIntervalPickerSegmentController();

      ChangeNotifier.debugAssertNotDisposed(controller.dayOfWeekOrdinal);
      ChangeNotifier.debugAssertNotDisposed(controller.dayOfWeek);
      ChangeNotifier.debugAssertNotDisposed(controller.daysOfWeek);

      controller.dispose();

      expect(
        () =>
            ChangeNotifier.debugAssertNotDisposed(controller.dayOfWeekOrdinal),
        throwsFlutterError,
      );
      expect(
        () => ChangeNotifier.debugAssertNotDisposed(controller.dayOfWeek),
        throwsFlutterError,
      );
      expect(
        () => ChangeNotifier.debugAssertNotDisposed(controller.daysOfWeek),
        throwsFlutterError,
      );
    });

    group('updateDayOfWeekState', () {
      test('updates dayOfWeekFormatter when localizations provided', () {
        final localizations = RRulePickerLocalizationsPl();

        controller.updateDayOfWeekState(localizations: localizations);

        expect(controller.dayOfWeekFormatter.locale.toString(), 'pl');
      });

      test('updates daysOfWeek when firstDayOfWeek provided', () {
        controller.updateDayOfWeekState(firstDayOfWeek: .friday);

        expect(
          controller.daysOfWeek.value.map((t) => t.$1),
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

      test('does not update dateFormatter when localizations is null', () {
        controller.updateDayOfWeekState(firstDayOfWeek: .monday);

        expect(controller.dayOfWeekFormatter.locale.toString(), 'en');
      });

      test('does not update daysOfWeek when firstDayOfWeek is null', () {
        final localizations = RRulePickerLocalizationsEn();

        controller.updateDayOfWeekState(localizations: localizations);

        expect(controller.daysOfWeek.value.first.$1, DayOfWeek.monday);
      });

      test('listener is called when daysOfWeek provided', () {
        controller.updateDayOfWeekState(firstDayOfWeek: .friday);

        expect(listenerCallCount, 1);
      });

      test('listener is not called when only localizations provided', () {
        final localizations = RRulePickerLocalizationsEn();

        controller.updateDayOfWeekState(localizations: localizations);

        expect(listenerCallCount, 0);
      });

      test('daysOfWeek formatted strings are not empty', () {
        expect(
          controller.daysOfWeek.value.map((t) => t.$2),
          everyElement(isNotEmpty),
        );
      });
    });

    group('setDayOfWeekValue', () {
      test('sets both day of week ordinal and day of week values', () {
        controller.setDayOfWeekValue(.third, .wednesday);

        expect(controller.dayOfWeekOrdinal.value, DayOfWeekOrdinal.third);
        expect(controller.dayOfWeek.value, DayOfWeek.wednesday);
      });

      property('sets any valid day of week ordinal and day of week', () {
        forAll(
          combine2(
            dayOfWeekOrdinal(),
            dayOfWeek(),
          ).map((t) => (ordinal: t.$1, day: t.$2)),
          (t) {
            controller.setDayOfWeekValue(t.ordinal, t.day);

            expect(controller.dayOfWeekOrdinal.value, t.ordinal);
            expect(controller.dayOfWeek.value, t.day);
          },
        );
      });

      property('sets daysOfWeek when firstDayOfWeek provided', () {
        forAll(dayOfWeek(), (firstDay) {
          controller.setDayOfWeekValue(.first, .monday, firstDay);

          expect(
            controller.daysOfWeek.value.map((t) => t.$1),
            orderedEquals(
              DayOfWeek.buildWeek(
                firstDay,
                controller.dayOfWeekFormatter,
              ).map((t) => t.$1),
            ),
          );
        });
      });

      test('notifies listeners when value changes', () {
        controller.setDayOfWeekValue(.second, .tuesday);

        expect(listenerCallCount, 2); // both ordinal and day notifiers trigger
      });

      test('can set ordinal to first', () {
        final controller = TestIntervalPickerSegmentController(
          initialDayOfWeekOrdinal: .last,
        );

        controller.setDayOfWeekValue(.first, .monday);

        expect(controller.dayOfWeekOrdinal.value, DayOfWeekOrdinal.first);

        addTearDown(controller.dispose);
      });

      test('can set ordinal to last', () {
        controller.setDayOfWeekValue(.last, .sunday);

        expect(controller.dayOfWeekOrdinal.value, DayOfWeekOrdinal.last);
      });
    });

    group('$DayOfWeekOrdinal values', () {
      test('first has rruleValue of 1', () {
        expect(DayOfWeekOrdinal.first.rruleValue, 1);
      });

      test('second has rruleValue of 2', () {
        expect(DayOfWeekOrdinal.second.rruleValue, 2);
      });

      test('third has rruleValue of 3', () {
        expect(DayOfWeekOrdinal.third.rruleValue, 3);
      });

      test('fourth has rruleValue of 4', () {
        expect(DayOfWeekOrdinal.fourth.rruleValue, 4);
      });

      test('last has rruleValue of -1', () {
        expect(DayOfWeekOrdinal.last.rruleValue, -1);
      });
    });

    group('$DayOfWeek values', () {
      test('all days have correct rruleName', () {
        expect(DayOfWeek.monday.rruleName, 'MO');
        expect(DayOfWeek.tuesday.rruleName, 'TU');
        expect(DayOfWeek.wednesday.rruleName, 'WE');
        expect(DayOfWeek.thursday.rruleName, 'TH');
        expect(DayOfWeek.friday.rruleName, 'FR');
        expect(DayOfWeek.saturday.rruleName, 'SA');
        expect(DayOfWeek.sunday.rruleName, 'SU');
      });
    });
  });
}
