// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kiri_check/kiri_check.dart';
import 'package:rrule_picker/src/shared/interval.dart';
import 'package:rrule_picker/src/shared/parsing.dart';
import 'package:rrule_picker/src/shared/resolved_theme.dart';
import 'package:spot/spot.dart';

import '../../helpers.dart';

class TestIntervalPickerState with IntervalPickerState {}

class TestIntervalPickerSegmentTypeState with IntervalPickerSegmentTypeState {}

void main() {
  group(IntervalPicker, () {
    late ThemeData theme;
    late TextEditingController controller;
    late ValueNotifier<int> notifier;

    setUpAll(() async {
      if (!kIsWeb) {
        await loadAppFonts();
      }
    });

    setUp(() {
      theme = ThemeData();
      notifier = ValueNotifier(1);
      controller = TextEditingController(text: notifier.value.toString());
    });

    tearDown(() {
      controller.dispose();
      notifier.dispose();
    });

    testWidgets('renders everyLabel, countField, and daysLabel', (
      tester,
    ) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: .defaults(theme),
          child: IntervalPicker(
            everyUnitText: (_) => 'Every',
            intervalUnitText: (_) => 'days',
            intervalController: controller,
            intervalNotifier: notifier,
          ),
        ),
      );

      spotText('Every', exact: true).existsOnce();
      spot<TextField>().existsOnce();
      spotText('days', exact: true).existsOnce();
    });

    testWidgets('displays correct initial interval value in text field', (
      tester,
    ) async {
      const initialValue = 5;
      controller.text = initialValue.toString();
      notifier.value = initialValue;

      await tester.pumpWrapped(
        ResolvedTheme(
          theme: .defaults(theme),
          child: IntervalPicker(
            everyUnitText: (_) => 'Every',
            intervalUnitText: (_) => 'days',
            intervalController: controller,
            intervalNotifier: notifier,
          ),
        ),
      );

      spotText(initialValue.toString(), exact: true).existsOnce();
    });

    testWidgets(
      'updates controller and notifier when text field value changes',
      (tester) async {
        await tester.pumpWrapped(
          ResolvedTheme(
            theme: .defaults(theme),
            child: IntervalPicker(
              everyUnitText: (_) => 'Every',
              intervalUnitText: (_) => 'days',
              intervalController: controller,
              intervalNotifier: notifier,
            ),
          ),
        );

        await act.enterText(spot<TextField>(), '10');

        expect(controller.text, '10');
        expect(notifier.value, 10);
      },
    );

    testWidgets('updates controller to empty string and '
        'does not update notifier on invalid input', (tester) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: .defaults(theme),
          child: IntervalPicker(
            everyUnitText: (_) => 'Every',
            intervalUnitText: (_) => 'days',
            intervalController: controller,
            intervalNotifier: notifier,
          ),
        ),
      );

      await act.enterText(spot<TextField>(), 'abc');

      expect(controller.text, '');
      expect(notifier.value, 1);
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
            intervalController: controller,
            intervalNotifier: notifier,
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
            intervalController: controller,
            intervalNotifier: notifier,
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
            intervalController: controller,
            intervalNotifier: notifier,
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
            intervalController: controller,
            intervalNotifier: notifier,
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
            intervalController: controller,
            intervalNotifier: notifier,
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
            intervalController: controller,
            intervalNotifier: notifier,
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
      forAll(integer(min: intervalMin).map((v) => v.toString()), (interval) {
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
      forAll(
        string(
          minLength: 1,
          maxLength: 5,
          characterSet: .all(.ascii),
        ).filter((v) => v != '' && int.tryParse(v) == null),
        (interval) {
          final newValue = TextEditingValue(text: interval);

          final result = formatter.formatEditUpdate(intervalMinValue, newValue);

          expect(result.text, intervalMinValue.text);
        },
      );
    });

    property('rejects non-numeric utf-8 string', () {
      forAll(
        string(
          minLength: 1,
          maxLength: 5,
          characterSet: .all(.utf8),
        ).filter((v) => v != '' && int.tryParse(v) == null),
        (interval) {
          final newValue = TextEditingValue(text: interval);

          final result = formatter.formatEditUpdate(intervalMinValue, newValue);

          expect(result.text, intervalMinValue.text);
        },
      );
    });
  });

  group('$IntervalPickerState mixin', () {
    late IntervalPickerState state;

    setUp(() => state = TestIntervalPickerState());

    tearDown(() {
      state.disposeIntervalState.callIgnoringErrors();
    });

    test('initIntervalState initializes with default value', () {
      state.initIntervalState(listener: () {});

      expect(state.initialIntervalValue, defaultInterval);
      expect(state.intervalNotifier.value, defaultInterval);
      expect(state.intervalController.text, defaultInterval.toString());
    });

    property('initIntervalState initializes with custom value', () {
      late IntervalPickerState state;

      forAll(
        integer(min: defaultInterval),
        (interval) {
          state.initIntervalState(initialValue: interval, listener: () {});

          expect(state.initialIntervalValue, interval);
          expect(state.intervalNotifier.value, interval);
          expect(state.intervalController.text, interval.toString());
        },
        setUp: () => state = TestIntervalPickerState(),
        tearDown: () => state.disposeIntervalState(),
      );
    });

    test('initIntervalState adds listener to notifier', () {
      var callCount = 0;

      state.initIntervalState(initialValue: 1, listener: () => ++callCount);

      state.intervalNotifier.value = 2;

      expect(callCount, 1);
    });

    test('setIntervalValue updates controller and notifier', () {
      state.initIntervalState(listener: () {});

      state.setIntervalValue(10);

      expect(state.intervalController.text, '10');
      expect(state.intervalNotifier.value, 10);
    });

    test('getIntervalValue returns notifier value when valid', () {
      state.initIntervalState(listener: () {});

      state.setIntervalValue(5);

      expect(state.getIntervalValue(), 5);
    });

    property('getIntervalValue returns defaultValue '
        'when value is below min', () {
      state.initIntervalState(initialValue: 0, listener: () {});

      forAll(integer(max: 4), (interval) {
        state.setIntervalValue(interval);

        final result = state.getIntervalValue(minValue: 5, defaultValue: 10);

        expect(result, 10);
      });
    });

    property('getIntervalValue returns initialIntervalValue '
        'when value is below minValue and no defaultValue', () {
      state.initIntervalState(initialValue: 10, listener: () {});

      forAll(integer(max: 4), (interval) {
        state.setIntervalValue(interval);

        final result = state.getIntervalValue(minValue: 5);

        expect(result, 10);
      });
    });

    property('getIntervalValue returns defaultValue '
        'when value is below minValue', () {
      state.initIntervalState(initialValue: 3, listener: () {});

      forAll(integer(max: 4), (interval) {
        state.setIntervalValue(interval);

        final result = state.getIntervalValue(minValue: 5, defaultValue: 10);

        expect(result, 10);
      });
    });

    property('getIntervalValue returns value when equal to minValue', () {
      state.initIntervalState(listener: () {});

      forAll(integer(), (interval) {
        state.setIntervalValue(interval);

        final result = state.getIntervalValue(minValue: interval);

        expect(result, interval);
      });
    });

    property(
      'getIntervalValue returns initialIntervalValue '
      'when value is below minValue and initialIntervalValue >= minValue',
      () {
        state.initIntervalState(initialValue: -1111, listener: () {});

        forAll(integer(min: -1000), (interval) {
          state.setIntervalValue(interval - 1);

          final result = state.getIntervalValue(minValue: interval);

          expect(result, -1111);
        });
      },
    );

    test('disposeIntervalState disposes controller and notifier', () {
      state.initIntervalState(listener: () {});

      ChangeNotifier.debugAssertNotDisposed(state.intervalController);
      ChangeNotifier.debugAssertNotDisposed(state.intervalNotifier);

      state.disposeIntervalState();

      expect(
        () => ChangeNotifier.debugAssertNotDisposed(state.intervalController),
        throwsFlutterError,
      );
      expect(
        () => ChangeNotifier.debugAssertNotDisposed(state.intervalNotifier),
        throwsFlutterError,
      );
    });
  });

  group('IntervalPickerSegmentTypeState', () {
    late IntervalPickerSegmentTypeState state;

    setUp(() => state = TestIntervalPickerSegmentTypeState());

    tearDown(() {
      state.disposeIntervalSegmentTypeState.callIgnoringErrors();
    });

    test('initIntervalSegmentTypeState initializes '
        'with precise segment type', () {
      state.initIntervalSegmentTypeState(listener: () {});

      expect(state.intervalSegmentType.value, {
        IntervalPickerSegmentType.precise,
      });
    });

    test('initIntervalSegmentTypeState initializes '
        'with custom segment type', () {
      state.initIntervalSegmentTypeState(
        initialSegmentType: {.relative},
        listener: () {},
      );

      expect(state.intervalSegmentType.value, {
        IntervalPickerSegmentType.relative,
      });
    });

    test('initIntervalSegmentTypeState initializes '
        'with multiple segment types', () {
      state.initIntervalSegmentTypeState(
        initialSegmentType: {.precise, .relative},
        listener: () {},
      );

      expect(state.intervalSegmentType.value, {
        IntervalPickerSegmentType.precise,
        IntervalPickerSegmentType.relative,
      });
    });

    test('initIntervalSegmentTypeState adds listener to notifier', () {
      var callCount = 0;

      state.initIntervalSegmentTypeState(listener: () => ++callCount);

      state.intervalSegmentType.value = {.relative};

      expect(callCount, 1);
    });

    test('setIntervalSegmentTypeValue updates notifier value', () {
      state.initIntervalSegmentTypeState(listener: () {});

      state.setIntervalSegmentTypeValue({.relative});

      expect(state.intervalSegmentType.value, {
        IntervalPickerSegmentType.relative,
      });
    });

    test('disposeIntervalSegmentTypeState disposes notifier', () {
      state.initIntervalSegmentTypeState(listener: () {});

      ChangeNotifier.debugAssertNotDisposed(state.intervalSegmentType);

      state.disposeIntervalSegmentTypeState();

      expect(
        () => ChangeNotifier.debugAssertNotDisposed(state.intervalSegmentType),
        throwsFlutterError,
      );
    });
  });
}
