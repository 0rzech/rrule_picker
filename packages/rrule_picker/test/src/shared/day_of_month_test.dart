// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kiri_check/kiri_check.dart';
import 'package:rrule_picker/src/shared/day_of_month.dart';
import 'package:rrule_picker/src/shared/parsing.dart';

import '../../helpers.dart';

class TestDayOfMonthState with DayOfMonthState {}

void main() {
  group(DayOfMonthState, () {
    late TestDayOfMonthState state;
    late int listenerCallCount;
    late int? lastListenerValue;

    setUp(() {
      listenerCallCount = 0;
      lastListenerValue = null;
      state = TestDayOfMonthState();
    });

    tearDown(() {
      state.disposeDayOfMonthState.callIgnoringErrors();
    });

    group('initDayOfMonthState', () {
      test('initializes with default day of month value', () {
        state.initDayOfMonthState(listener: () {});

        expect(state.dayOfMonth.value, defaultByMonthDay);
      });

      property('initializes with custom initial day of month', () {
        late DayOfMonthState state;

        forAll(
          integer(),
          (day) {
            state.initDayOfMonthState(initialDayOfMonth: day, listener: () {});

            expect(state.dayOfMonth.value, day);
          },
          setUp: () => state = TestDayOfMonthState(),
          tearDown: () => state.disposeDayOfMonthState(),
        );
      });

      test('initializes with custom number format', () {
        state.initDayOfMonthState(numberFormat: '000', listener: () {});

        // The formatter should be created with the custom format
        // We can verify it works by formatting a value
        expect(state.dayOfMonthFormatter.format(5), '005');
      });

      test('listener is called when value changes', () {
        state.initDayOfMonthState(
          listener: () {
            listenerCallCount++;
            lastListenerValue = state.dayOfMonth.value;
          },
        );

        state.dayOfMonth.value = 10;

        expect(listenerCallCount, 1);
        expect(lastListenerValue, 10);
      });

      test('uses default number format (00) when not specified', () {
        state.initDayOfMonthState(listener: () {});

        expect(state.dayOfMonthFormatter.format(5), '05');
        expect(state.dayOfMonthFormatter.format(15), '15');
      });
    });

    group('disposeDayOfMonthState', () {
      test('disposes the ValueNotifier', () {
        state.initDayOfMonthState(listener: () {});

        ChangeNotifier.debugAssertNotDisposed(state.dayOfMonth);

        state.disposeDayOfMonthState();

        expect(
          () => ChangeNotifier.debugAssertNotDisposed(state.dayOfMonth),
          throwsFlutterError,
        );
      });
    });

    group('setDayOfMonthValue', () {
      property('sets the day of month value', () {
        state.initDayOfMonthState(listener: () {});

        forAll(integer(), (day) {
          state.setDayOfMonthValue(day);

          expect(state.dayOfMonth.value, day);
        });
      });

      test('notifies listeners when value changes', () {
        state.initDayOfMonthState(
          listener: () {
            listenerCallCount++;
            lastListenerValue = state.dayOfMonth.value;
          },
        );

        state.setDayOfMonthValue(10);

        expect(listenerCallCount, 1);
        expect(lastListenerValue, 10);

        state.setDayOfMonthValue(20);

        expect(listenerCallCount, 2);
        expect(lastListenerValue, 20);
      });

      test('can set value to 1 (minimum)', () {
        state.initDayOfMonthState(initialDayOfMonth: 30, listener: () {});

        state.setDayOfMonthValue(byMonthDayMin);

        expect(state.dayOfMonth.value, byMonthDayMin);
      });

      test('can set value to 31 (maximum valid)', () {
        state.initDayOfMonthState(listener: () {});

        state.setDayOfMonthValue(31);

        expect(state.dayOfMonth.value, 31);
      });
    });

    group('dayOfMonthFormatter', () {
      property('formats single digit with leading zero '
          'using default format', () {
        state.initDayOfMonthState(listener: () {});

        forAll(integer(min: 0, max: 9), (day) {
          final result = state.dayOfMonthFormatter.format(day);

          expect(result, '0$day');
        });
      });

      property('formats double digits without leading zero '
          'using default format', () {
        state.initDayOfMonthState(listener: () {});

        forAll(integer(min: 10, max: 99), (day) {
          final result = state.dayOfMonthFormatter.format(day);

          expect(result, day.toString());
        });
      });

      property('formats with custom format when specified', () {
        state.initDayOfMonthState(numberFormat: '#', listener: () {});

        forAll(integer(min: 0, max: 9), (day) {
          final result = state.dayOfMonthFormatter.format(day);

          expect(result, day.toString());
        });
      });
    });
  });
}
