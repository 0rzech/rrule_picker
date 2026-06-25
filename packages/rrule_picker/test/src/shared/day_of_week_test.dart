// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:kiri_check/kiri_check.dart';
import 'package:rrule_picker/localizations/localizations_en.dart';
import 'package:rrule_picker/localizations/localizations_pl.dart';
import 'package:rrule_picker/src/shared/day_of_week.dart';
import 'package:rrule_picker/src/shared/parsing.dart';

import '../../helpers.dart';

class TestDayOfWeekState with DayOfWeekState {}

void main() {
  group(DayOfWeekState, () {
    late DayOfWeekState state;
    late int listenerCallCount;
    late DayOfWeek? lastListenerDayOfWeek;
    late DayOfWeekOrdinal? lastListenerDayOfWeekOrdinal;

    setUpAll(() async {
      Intl.defaultLocale = 'en';
      initializeDateFormatting();
    });

    setUp(() {
      state = TestDayOfWeekState();
      listenerCallCount = 0;
      lastListenerDayOfWeek = null;
      lastListenerDayOfWeekOrdinal = null;
    });

    tearDown(() => state.disposeDayOfWeekState.callIgnoringErrors());

    group('initDayOfWeekState', () {
      test('initializes with default values', () {
        state.initDayOfWeekState(listener: () {});

        expect(state.dayOfWeekOrdinal.value, DayOfWeekOrdinal.first);
        expect(state.dayOfWeek.value, DayOfWeek.monday);
        expect(state.dayOfWeekFormatter.locale.toString(), 'en');
      });

      property('initializes with custom initial values', () {
        late TestDayOfWeekState state;

        forAll(
          combine2(
            integer(min: 0, max: DayOfWeekOrdinal.values.length - 1),
            integer(min: 0, max: DayOfWeek.values.length - 1),
          ).map(
            (indices) => (
              ordinal: DayOfWeekOrdinal.values[indices.$1],
              day: DayOfWeek.values[indices.$2],
            ),
          ),
          (t) {
            state.initDayOfWeekState(
              initialDayOfWeekOrdinal: t.ordinal,
              initialDayOfWeek: t.day,
              listener: () {},
            );

            expect(state.dayOfWeekOrdinal.value, t.ordinal);
            expect(state.dayOfWeek.value, t.day);
          },
          setUp: () => state = TestDayOfWeekState(),
          tearDown: () => state.disposeDayOfWeekState(),
        );
      });

      test('initializes daysOfWeek with custom initialDayOfWeek', () {
        state.initDayOfWeekState(initialDayOfWeek: .friday, listener: () {});

        expect(state.daysOfWeek.value.first.$1, DayOfWeek.friday);
        expect(
          state.daysOfWeek.value.map((t) => t.$1),
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

      test('listener is called when ordinal value changes', () {
        state.initDayOfWeekState(
          listener: () {
            ++listenerCallCount;
            lastListenerDayOfWeekOrdinal = state.dayOfWeekOrdinal.value;
          },
        );

        state.dayOfWeekOrdinal.value = .second;

        expect(listenerCallCount, 1);
        expect(lastListenerDayOfWeekOrdinal, DayOfWeekOrdinal.second);
      });

      test('listener is called when day of week value changes', () {
        state.initDayOfWeekState(
          listener: () {
            ++listenerCallCount;
            lastListenerDayOfWeek = state.dayOfWeek.value;
          },
        );

        state.dayOfWeek.value = .tuesday;

        expect(listenerCallCount, 1);
        expect(lastListenerDayOfWeek, DayOfWeek.tuesday);
      });
    });

    group('disposeDayOfWeekState', () {
      test('disposes all ValueNotifiers', () {
        state.initDayOfWeekState(listener: () {});

        ChangeNotifier.debugAssertNotDisposed(state.dayOfWeekOrdinal);
        ChangeNotifier.debugAssertNotDisposed(state.dayOfWeek);
        ChangeNotifier.debugAssertNotDisposed(state.daysOfWeek);

        state.disposeDayOfWeekState();

        expect(
          () => ChangeNotifier.debugAssertNotDisposed(state.dayOfWeekOrdinal),
          throwsFlutterError,
        );
        expect(
          () => ChangeNotifier.debugAssertNotDisposed(state.dayOfWeek),
          throwsFlutterError,
        );
        expect(
          () => ChangeNotifier.debugAssertNotDisposed(state.daysOfWeek),
          throwsFlutterError,
        );
      });
    });

    group('updateDayOfWeekState', () {
      test('updates dayOfWeekFormatter when localizations provided', () {
        state.initDayOfWeekState(listener: () {});
        final localizations = RRulePickerLocalizationsPl();

        state.updateDayOfWeekState(localizations: localizations);

        expect(state.dayOfWeekFormatter.locale.toString(), 'pl');
      });

      test('updates daysOfWeek when firstDayOfWeek provided', () {
        state.initDayOfWeekState(listener: () {});

        state.updateDayOfWeekState(firstDayOfWeek: .friday);

        expect(state.daysOfWeek.value.first.$1, DayOfWeek.friday);
        expect(
          state.daysOfWeek.value.map((t) => t.$1),
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
        state.initDayOfWeekState(listener: () {});

        state.updateDayOfWeekState(firstDayOfWeek: .monday);

        expect(state.dayOfWeekFormatter.locale.toString(), 'en');
      });

      test('does not update daysOfWeek when firstDayOfWeek is null', () {
        state.initDayOfWeekState(listener: () {});
        final localizations = RRulePickerLocalizationsEn();

        state.updateDayOfWeekState(localizations: localizations);

        expect(state.daysOfWeek.value.first.$1, DayOfWeek.monday);
      });

      test('listener is called when daysOfWeek provided', () {
        state.initDayOfWeekState(listener: () => ++listenerCallCount);

        state.updateDayOfWeekState(firstDayOfWeek: .friday);

        expect(listenerCallCount, 1);
      });

      test('listener is not called when only localizations provided', () {
        state.initDayOfWeekState(listener: () => ++listenerCallCount);
        final localizations = RRulePickerLocalizationsEn();

        state.updateDayOfWeekState(localizations: localizations);

        expect(listenerCallCount, 0);
      });

      test('daysOfWeek formatted strings are not empty', () {
        state.initDayOfWeekState(listener: () {});

        expect(
          state.daysOfWeek.value.map((t) => t.$2),
          everyElement(isNotEmpty),
        );
      });
    });

    group('setDayOfWeekValue', () {
      test('sets both day of week ordinal and day of week values', () {
        state.initDayOfWeekState(listener: () {});

        state.setDayOfWeekValue(.third, .wednesday);

        expect(state.dayOfWeekOrdinal.value, DayOfWeekOrdinal.third);
        expect(state.dayOfWeek.value, DayOfWeek.wednesday);
      });

      property('sets any valid day of week ordinal and day of week', () {
        state.initDayOfWeekState(listener: () {});

        forAll(
          combine2(
            integer(min: 0, max: DayOfWeekOrdinal.values.length - 1),
            integer(min: 0, max: DayOfWeek.values.length - 1),
          ).map(
            (indices) => (
              ordinal: DayOfWeekOrdinal.values[indices.$1],
              day: DayOfWeek.values[indices.$2],
            ),
          ),
          (t) {
            state.setDayOfWeekValue(t.ordinal, t.day);

            expect(state.dayOfWeekOrdinal.value, t.ordinal);
            expect(state.dayOfWeek.value, t.day);
          },
        );
      });

      test('notifies listeners when value changes', () {
        state.initDayOfWeekState(
          listener: () {
            ++listenerCallCount;
            lastListenerDayOfWeekOrdinal = state.dayOfWeekOrdinal.value;
            lastListenerDayOfWeek = state.dayOfWeek.value;
          },
        );

        state.setDayOfWeekValue(.second, .tuesday);

        expect(listenerCallCount, 2); // both ordinal and day notifiers trigger
        expect(lastListenerDayOfWeekOrdinal, DayOfWeekOrdinal.second);
        expect(lastListenerDayOfWeek, DayOfWeek.tuesday);
      });

      test('can set ordinal to first', () {
        state.initDayOfWeekState(
          initialDayOfWeekOrdinal: .last,
          listener: () {},
        );

        state.setDayOfWeekValue(.first, .monday);

        expect(state.dayOfWeekOrdinal.value, DayOfWeekOrdinal.first);
      });

      test('can set ordinal to last', () {
        state.initDayOfWeekState(listener: () {});

        state.setDayOfWeekValue(.last, .sunday);

        expect(state.dayOfWeekOrdinal.value, DayOfWeekOrdinal.last);
      });
    });

    group('dayOfWeekOrdinal values', () {
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

    group('DayOfWeek values', () {
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
