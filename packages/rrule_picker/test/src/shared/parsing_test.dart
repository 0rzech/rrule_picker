// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter_test/flutter_test.dart';
import 'package:kiri_check/kiri_check.dart';
import 'package:rrule_picker/src/shared/parsing.dart';

import '../../helpers.dart';

void main() {
  group('parseInterval', () {
    property('returns parsed value for valid positive integers', () {
      forAll(interval(), (interval) {
        expect(parseInterval(interval.toString()), interval);
      });
    });

    property('returns default value when value is null', () {
      expect(parseInterval(null), defaultInterval);

      forAll(interval(), (interval) {
        expect(parseInterval(null, interval), interval);
      });
    });

    property('returns default value for non-positive integers', () {
      forAll(integer(max: 0), (interval) {
        expect(parseInterval(interval.toString()), defaultInterval);
      });
    });

    property('returns default value for non-numeric ascii strings', () {
      forAll(
        asciiString().filter((value) => int.tryParse(value) == null),
        (interval) => expect(parseInterval(interval), defaultInterval),
      );
    });

    property('returns default value for non-numeric utf-8 strings', () {
      forAll(
        utf8String().filter((value) => int.tryParse(value) == null),
        (interval) => expect(parseInterval(interval), defaultInterval),
      );
    });

    test('returns proper value for edge cases', () {
      for (final (input, expected) in const [
        ('', defaultInterval),
        ('0', defaultInterval),
        ('0.0', defaultInterval),
        ('1.0', 1),
        ('+1', 1),
        ('001', 1),
        ('-001', 1),
      ]) {
        expect(parseInterval(input), expected, reason: 'input: <$input>');
      }
    });
  });

  group('parseByMonth', () {
    property('returns default value when value is null', () {
      expect(parseByMonth(null), defaultByMonth);

      forAll(month(), (month) {
        expect(parseByMonth(null, month), month);
      });
    });

    test('returns correct Month for valid month strings', () {
      for (final (value, month) in const <(String, Month)>[
        ('1', .january),
        ('2', .february),
        ('3', .march),
        ('4', .april),
        ('5', .may),
        ('6', .june),
        ('7', .july),
        ('8', .august),
        ('9', .september),
        ('10', .october),
        ('11', .november),
        ('12', .december),
      ]) {
        expect(parseByMonth(value), month);
      }
    });

    property('returns default value for values smaller than valid range', () {
      forAll(integer(max: 0), (month) {
        expect(parseByMonth(month.toString()), defaultByMonth);
      });
    });

    property('returns default value for values greater than valid range', () {
      forAll(integer(min: Month.values.length + 1), (month) {
        expect(parseByMonth(month.toString()), defaultByMonth);
      });
    });

    property('returns default value for non-month ascii strings', () {
      forAll(
        asciiString(minLength: 0).filter(
          (month) => switch (int.tryParse(month)) {
            null || < 1 || > 12 => true,
            _ => false,
          },
        ),
        (month) => expect(parseByMonth(month), defaultByMonth),
      );
    });

    property('returns default value for non-month utf-8 strings', () {
      forAll(
        utf8String(minLength: 0).filter(
          (month) => switch (int.tryParse(month)) {
            null || < 1 || > 12 => true,
            _ => false,
          },
        ),
        (month) => expect(parseByMonth(month), defaultByMonth),
      );
    });
  });

  group('parseByMonthDay', () {
    property('returns default value when value is null', () {
      expect(parseByMonthDay(null), defaultByMonthDay);

      forAll(byMonthDay(), (day) {
        expect(parseByMonthDay(null, defaultValue: day), day);
      });
    });

    property('returns parsed value for valid day values', () {
      forAll(
        byMonthDay().map((day) {
          return (string: '${day < byMonthDayMax ? day : -1}', value: day);
        }),
        (t) {
          expect(parseByMonthDay(t.string), t.value);
        },
      );
    });

    property('returns default value for values smaller than valid range', () {
      forAll(integer(max: 0).filter((day) => day != -1), (day) {
        expect(parseByMonthDay(day.toString()), defaultByMonthDay);
      });
    });

    property('returns default value '
        'for values greater than default valid range', () {
      forAll(integer(min: byMonthDayMax), (day) {
        expect(parseByMonthDay(day.toString()), defaultByMonthDay);
      });
    });

    property('returns default value '
        'for values greater than custom valid range', () {
      forAll(
        month().flatMap((month) {
          return combine2(
            integer(min: month.maxDay + 1),
            constant(month.maxDay),
          ).map((t) => (day: t.$1.toString(), maxValue: t.$2));
        }),
        (t) {
          expect(
            parseByMonthDay(t.day, maxValue: t.maxValue),
            defaultByMonthDay,
          );
        },
      );
    });

    property('returns default value for non-day ascii strings', () {
      forAll(
        asciiString().filter((day) {
          return switch (int.tryParse(day)) {
            null || < byMonthDayMin || > byMonthDayMax => true,
            _ => false,
          };
        }),
        (day) => expect(parseByMonthDay(day), defaultByMonthDay),
      );
    });

    property('returns default value for non-day utf-8 strings', () {
      forAll(
        utf8String().filter((day) {
          return switch (int.tryParse(day)) {
            null || < byMonthDayMin || > byMonthDayMax => true,
            _ => false,
          };
        }),
        (day) => expect(parseByMonthDay(day), defaultByMonthDay),
      );
    });
  });

  group('parseByDaySingle', () {
    property('returns default value when value is null', () {
      expect(parseByDaySingle(null), defaultByDaySingle);

      forAll(dayOfWeek(), (day) {
        expect(parseByDaySingle(null, day), day);
      });
    });

    test('returns correct DayOfWeek for valid codes', () {
      expect(parseByDaySingle('MO'), DayOfWeek.monday);
      expect(parseByDaySingle('TU'), DayOfWeek.tuesday);
      expect(parseByDaySingle('WE'), DayOfWeek.wednesday);
      expect(parseByDaySingle('TH'), DayOfWeek.thursday);
      expect(parseByDaySingle('FR'), DayOfWeek.friday);
      expect(parseByDaySingle('SA'), DayOfWeek.saturday);
      expect(parseByDaySingle('SU'), DayOfWeek.sunday);
    });

    test('handles case-insensitive input', () {
      expect(parseByDaySingle('mo'), DayOfWeek.monday);
      expect(parseByDaySingle('Mo'), DayOfWeek.monday);
      expect(parseByDaySingle('MO'), DayOfWeek.monday);
      expect(parseByDaySingle('tu'), DayOfWeek.tuesday);
      expect(parseByDaySingle('Tu'), DayOfWeek.tuesday);
    });

    test('returns default value for invalid edge cases', () {
      expect(parseByDaySingle(''), defaultByDaySingle);
      expect(parseByDaySingle('1'), defaultByDaySingle);
      expect(parseByDaySingle('XX'), defaultByDaySingle);
    });

    property('returns default value for invalid ascii codes', () {
      forAll(
        asciiString().filter((day) {
          return switch (day.toUpperCase()) {
            'MO' || 'TU' || 'WE' || 'TH' || 'FR' || 'SA' || 'SU' => false,
            _ => true,
          };
        }),
        (day) => expect(parseByDaySingle(day), defaultByDaySingle),
      );
    });

    property('returns default value for invalid utf-8 codes', () {
      forAll(
        utf8String().filter((day) {
          return switch (day.toUpperCase()) {
            'MO' || 'TU' || 'WE' || 'TH' || 'FR' || 'SA' || 'SU' => false,
            _ => true,
          };
        }),
        (day) => expect(parseByDaySingle(day), defaultByDaySingle),
      );
    });
  });

  group('parseByDayMulti', () {
    property('returns default value when value is null', () {
      expect(parseByDayMulti(null), defaultByDayMulti);

      forAll(
        dayOfWeekSet().map((days) {
          return (
            strings: days.map((day) => day.rruleName).join(','),
            values: days,
          );
        }),
        (t) {
          expect(parseByDayMulti(t.strings), t.values);
        },
      );
    });

    property('returns set with single DayOfWeek', () {
      forAll(dayOfWeek(), (day) {
        expect(parseByDayMulti(day.rruleName), {day});
      });
    });

    property('returns set with multiple DayOfWeek values', () {
      forAll(
        dayOfWeekSet().map((days) {
          return (
            strings: days.map((day) => day.rruleName).join(','),
            values: days,
          );
        }),
        (t) {
          expect(parseByDayMulti(t.strings), t.values);
        },
      );
    });

    test('returns default value when no valid days are parsed', () {
      expect(parseByDayMulti('XX,YY,ZZ'), defaultByDayMulti);
    });

    test('filters out invalid entries from comma-separated list', () {
      expect(parseByDayMulti('MO,XX,TU,YY'), {
        DayOfWeek.monday,
        DayOfWeek.tuesday,
      });
    });

    test('handles empty string', () {
      expect(parseByDayMulti(''), defaultByDayMulti);
    });

    test('handles trailing and leading commas', () {
      expect(parseByDayMulti(',MO,TU,'), {DayOfWeek.monday, DayOfWeek.tuesday});
    });

    test('returns default value when spaces around commas', () {
      expect(parseByDayMulti('MO, TU, WE'), defaultByDayMulti);
    });

    test('handles case-insensitive input', () {
      expect(parseByDayMulti('mo,tu,we'), {
        DayOfWeek.monday,
        DayOfWeek.tuesday,
        DayOfWeek.wednesday,
      });
    });

    test('handles duplicate entries', () {
      expect(parseByDayMulti('MO,MO,TU'), {
        DayOfWeek.monday,
        DayOfWeek.tuesday,
      });
    });

    property('uses custom default value', () {
      forAll(dayOfWeekSet(), (days) {
        expect(parseByDayMulti('XX', days), days);
      });
    });
  });

  group('parseBySetPosNthWeekDay', () {
    property('returns default value when value is null', () {
      expect(parseBySetPosNthWeekDay(null), defaultBySetPosNthWeekDay);

      forAll(dayOfWeekOrdinal(), (ordinal) {
        expect(parseBySetPosNthWeekDay(null, ordinal), ordinal);
      });
    });

    test('returns correct DayOfWeekOrdinal for valid values', () {
      expect(parseBySetPosNthWeekDay('1'), DayOfWeekOrdinal.first);
      expect(parseBySetPosNthWeekDay('2'), DayOfWeekOrdinal.second);
      expect(parseBySetPosNthWeekDay('3'), DayOfWeekOrdinal.third);
      expect(parseBySetPosNthWeekDay('4'), DayOfWeekOrdinal.fourth);
      expect(parseBySetPosNthWeekDay('-1'), DayOfWeekOrdinal.last);
    });

    test('returns default value for invalid edge cases', () {
      expect(parseBySetPosNthWeekDay(''), defaultBySetPosNthWeekDay);
      expect(parseBySetPosNthWeekDay('-2'), defaultBySetPosNthWeekDay);
      expect(parseBySetPosNthWeekDay('5'), defaultBySetPosNthWeekDay);
    });

    property('returns default value for values smaller than valid range', () {
      forAll(integer(max: 0).filter((ordinal) => ordinal != -1), (ordinal) {
        expect(
          parseBySetPosNthWeekDay(ordinal.toString()),
          defaultBySetPosNthWeekDay,
        );
      });
    });

    property('returns default value for values greater than valid range', () {
      forAll(integer(min: DayOfWeekOrdinal.values.length), (ordinal) {
        expect(
          parseBySetPosNthWeekDay(ordinal.toString()),
          defaultBySetPosNthWeekDay,
        );
      });
    });

    property('returns default value for non-day ascii strings', () {
      forAll(
        asciiString().filter((ordinal) {
          return switch (int.tryParse(ordinal)) {
            null || < -1 || > 3 => true,
            _ => false,
          };
        }),
        (ordinal) =>
            expect(parseBySetPosNthWeekDay(ordinal), defaultBySetPosNthWeekDay),
      );
    });

    property('returns default value for non-day utf-8 strings', () {
      forAll(
        utf8String().filter((ordinal) {
          return switch (int.tryParse(ordinal)) {
            null || < -1 || > 3 => true,
            _ => false,
          };
        }),
        (ordinal) {
          expect(parseBySetPosNthWeekDay(ordinal), defaultBySetPosNthWeekDay);
        },
      );
    });
  });

  group(DayOfWeek, () {
    group('tryParse', () {
      test('returns correct DayOfWeek for valid codes', () {
        expect(DayOfWeek.tryParse('MO'), DayOfWeek.monday);
        expect(DayOfWeek.tryParse('TU'), DayOfWeek.tuesday);
        expect(DayOfWeek.tryParse('WE'), DayOfWeek.wednesday);
        expect(DayOfWeek.tryParse('TH'), DayOfWeek.thursday);
        expect(DayOfWeek.tryParse('FR'), DayOfWeek.friday);
        expect(DayOfWeek.tryParse('SA'), DayOfWeek.saturday);
        expect(DayOfWeek.tryParse('SU'), DayOfWeek.sunday);
      });

      test('returns null for invalid codes', () {
        expect(DayOfWeek.tryParse(''), isNull);
        expect(DayOfWeek.tryParse('1'), isNull);
        expect(DayOfWeek.tryParse('XX'), isNull);
      });

      property('returns null for invalid ascii codes', () {
        forAll(
          asciiString().filter((day) {
            return switch (day.toUpperCase()) {
              'MO' || 'TU' || 'WE' || 'TH' || 'FR' || 'SA' || 'SU' => false,
              _ => true,
            };
          }),
          (day) => expect(DayOfWeek.tryParse(day), null),
        );
      });

      property('returns null for invalid utf-8 codes', () {
        forAll(
          utf8String().filter((day) {
            return switch (day.toUpperCase()) {
              'MO' || 'TU' || 'WE' || 'TH' || 'FR' || 'SA' || 'SU' => false,
              _ => true,
            };
          }),
          (day) => expect(DayOfWeek.tryParse(day), null),
        );
      });

      test('is case-insensitive', () {
        expect(DayOfWeek.tryParse('mo'), DayOfWeek.monday);
        expect(DayOfWeek.tryParse('MO'), DayOfWeek.monday);
        expect(DayOfWeek.tryParse('Mo'), DayOfWeek.monday);
      });
    });

    test('rruleName property returns correct values', () {
      expect(DayOfWeek.monday.rruleName, 'MO');
      expect(DayOfWeek.tuesday.rruleName, 'TU');
      expect(DayOfWeek.wednesday.rruleName, 'WE');
      expect(DayOfWeek.thursday.rruleName, 'TH');
      expect(DayOfWeek.friday.rruleName, 'FR');
      expect(DayOfWeek.saturday.rruleName, 'SA');
      expect(DayOfWeek.sunday.rruleName, 'SU');
    });

    test('values are in correct order', () {
      expect(DayOfWeek.values[0], DayOfWeek.monday);
      expect(DayOfWeek.values[1], DayOfWeek.tuesday);
      expect(DayOfWeek.values[2], DayOfWeek.wednesday);
      expect(DayOfWeek.values[3], DayOfWeek.thursday);
      expect(DayOfWeek.values[4], DayOfWeek.friday);
      expect(DayOfWeek.values[5], DayOfWeek.saturday);
      expect(DayOfWeek.values[6], DayOfWeek.sunday);
    });

    test('compare function compares by index', () {
      expect(DayOfWeek.compare(DayOfWeek.monday, DayOfWeek.tuesday), -1);
      expect(DayOfWeek.compare(DayOfWeek.tuesday, DayOfWeek.monday), 1);
      expect(DayOfWeek.compare(DayOfWeek.monday, DayOfWeek.monday), 0);
    });
  });

  group(DayOfWeekOrdinal, () {
    group('tryParse', () {
      test('returns correct DayOfWeekOrdinal for valid values', () {
        expect(DayOfWeekOrdinal.tryParse('1'), DayOfWeekOrdinal.first);
        expect(DayOfWeekOrdinal.tryParse('2'), DayOfWeekOrdinal.second);
        expect(DayOfWeekOrdinal.tryParse('3'), DayOfWeekOrdinal.third);
        expect(DayOfWeekOrdinal.tryParse('4'), DayOfWeekOrdinal.fourth);
        expect(DayOfWeekOrdinal.tryParse('-1'), DayOfWeekOrdinal.last);
      });

      test('returns null for invalid edge cases', () {
        expect(DayOfWeekOrdinal.tryParse(''), null);
        expect(DayOfWeekOrdinal.tryParse('-2'), null);
        expect(DayOfWeekOrdinal.tryParse('0'), null);
        expect(
          DayOfWeekOrdinal.tryParse(DayOfWeekOrdinal.values.length.toString()),
          null,
        );
      });

      property('returns null for values smaller than valid range', () {
        forAll(integer(max: 0).filter((ordinal) => ordinal != -1), (ordinal) {
          expect(DayOfWeekOrdinal.tryParse(ordinal.toString()), null);
        });
      });

      property('returns null for values greater than valid range', () {
        forAll(integer(min: DayOfWeekOrdinal.values.length), (ordinal) {
          expect(DayOfWeekOrdinal.tryParse(ordinal.toString()), null);
        });
      });

      property('returns null for non-day ascii strings', () {
        forAll(
          asciiString().filter((ordinal) {
            return switch (int.tryParse(ordinal)) {
              null || < -1 || > 4 => true,
              _ => false,
            };
          }),
          (ordinal) => expect(DayOfWeekOrdinal.tryParse(ordinal), null),
        );
      });

      property('returns null for non-day utf-8 strings', () {
        forAll(
          utf8String().filter((ordinal) {
            return switch (int.tryParse(ordinal)) {
              null || < -1 || > 3 => true,
              _ => false,
            };
          }),
          (ordinal) => expect(DayOfWeekOrdinal.tryParse(ordinal), null),
        );
      });
    });

    test('rruleValue property returns correct values', () {
      expect(DayOfWeekOrdinal.first.rruleValue, 1);
      expect(DayOfWeekOrdinal.second.rruleValue, 2);
      expect(DayOfWeekOrdinal.third.rruleValue, 3);
      expect(DayOfWeekOrdinal.fourth.rruleValue, 4);
      expect(DayOfWeekOrdinal.last.rruleValue, -1);
    });
  });

  group(Month, () {
    group('tryParse', () {
      test('returns correct Month for valid values', () {
        expect(Month.tryParse('1'), Month.january);
        expect(Month.tryParse('2'), Month.february);
        expect(Month.tryParse('3'), Month.march);
        expect(Month.tryParse('4'), Month.april);
        expect(Month.tryParse('5'), Month.may);
        expect(Month.tryParse('6'), Month.june);
        expect(Month.tryParse('7'), Month.july);
        expect(Month.tryParse('8'), Month.august);
        expect(Month.tryParse('9'), Month.september);
        expect(Month.tryParse('10'), Month.october);
        expect(Month.tryParse('11'), Month.november);
        expect(Month.tryParse('12'), Month.december);
      });

      property('returns null for values smaller than valid range', () {
        forAll(integer(max: 0), (month) {
          expect(Month.tryParse(month.toString()), null);
        });
      });

      property('returns null for values greater than valid range', () {
        forAll(integer(min: Month.values.length + 1), (month) {
          expect(Month.tryParse(month.toString()), null);
        });
      });

      property('returns null for non-month ascii strings', () {
        forAll(
          asciiString(minLength: 0).filter((month) {
            return switch (int.tryParse(month)) {
              null || < 1 || > 12 => true,
              _ => false,
            };
          }),
          (month) => expect(Month.tryParse(month), null),
        );
      });

      property('returns null for non-month utf-8 strings', () {
        forAll(
          utf8String(minLength: 0).filter((month) {
            return switch (int.tryParse(month)) {
              null || < 1 || > 12 => true,
              _ => false,
            };
          }),
          (month) => expect(Month.tryParse(month), null),
        );
      });
    });

    test('rruleValue property returns correct values', () {
      expect(Month.january.rruleValue, '1');
      expect(Month.february.rruleValue, '2');
      expect(Month.march.rruleValue, '3');
      expect(Month.april.rruleValue, '4');
      expect(Month.may.rruleValue, '5');
      expect(Month.june.rruleValue, '6');
      expect(Month.july.rruleValue, '7');
      expect(Month.august.rruleValue, '8');
      expect(Month.september.rruleValue, '9');
      expect(Month.october.rruleValue, '10');
      expect(Month.november.rruleValue, '11');
      expect(Month.december.rruleValue, '12');
    });

    test('maxDay property returns correct values', () {
      expect(Month.january.maxDay, 31);
      expect(Month.february.maxDay, 29);
      expect(Month.march.maxDay, 31);
      expect(Month.april.maxDay, 30);
      expect(Month.may.maxDay, 31);
      expect(Month.june.maxDay, 30);
      expect(Month.july.maxDay, 31);
      expect(Month.august.maxDay, 31);
      expect(Month.september.maxDay, 30);
      expect(Month.october.maxDay, 31);
      expect(Month.november.maxDay, 30);
      expect(Month.december.maxDay, 31);
    });
  });

  group('Constants', () {
    test('intervalMin is 1', () {
      expect(intervalMin, 1);
    });

    test('defaultInterval is 1', () {
      expect(defaultInterval, 1);
    });

    test('defaultByMonth is Month.january', () {
      expect(defaultByMonth, Month.january);
    });

    test('byMonthDayMin is 1', () {
      expect(byMonthDayMin, 1);
    });

    test('byMonthDayMax is 32', () {
      expect(byMonthDayMax, 32);
    });

    test('defaultByMonthDay is 1', () {
      expect(defaultByMonthDay, 1);
    });

    test('defaultByDaySingle is DayOfWeek.monday', () {
      expect(defaultByDaySingle, DayOfWeek.monday);
    });

    test('defaultByDayMulti is {DayOfWeek.monday}', () {
      expect(defaultByDayMulti, {DayOfWeek.monday});
    });

    test('defaultBySetPosNthWeekDay is DayOfWeekOrdinal.first', () {
      expect(defaultBySetPosNthWeekDay, DayOfWeekOrdinal.first);
    });
  });
}
