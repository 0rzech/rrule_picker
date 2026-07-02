// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:kiri_check/kiri_check.dart';
import 'package:rrule_picker/src/excluded_dates.dart';
import 'package:spot/spot.dart';

import '../helpers.dart';

void main() {
  group(ExcludedDates, () {
    late ExcludedDatesController controller;

    setUpAll(() async {
      if (!kIsWeb) {
        await loadAppFonts();
      }
    });

    setUp(() => controller = ExcludedDatesController());
    tearDown(() => controller.dispose());

    testWidgets('renders add button with correct localization', (tester) async {
      await tester.pumpWrapped(ExcludedDates(controller: controller));

      spot<ElevatedButton>().existsOnce();
      spotIcon(Icons.add).existsOnce();
      final text = tester.localizations<ExcludedDates>().rrulePickerSkip;
      spotText(text, exact: true).existsOnce();
    });

    testWidgets('shows date picker when add button is pressed', (tester) async {
      await tester.pumpWrapped(ExcludedDates(controller: controller));

      await act.tap(spot<ElevatedButton>());
      await tester.pumpAndSettle();

      spot<DatePickerDialog>().existsOnce();
    });

    testWidgets('adds date to list when date is selected', (tester) async {
      await tester.pumpWrapped(ExcludedDates(controller: controller));

      await act.tap(spot<ElevatedButton>());
      await tester.pumpAndSettle();

      await act.tap(
        spot<DatePickerDialog>().spot<TextButton>().spotText('OK', exact: true),
      );
      await tester.pumpAndSettle();

      spot<ListTile>().existsOnce();
      spot<IconButton>().spotIcon(Icons.delete).existsOnce();
    });

    testWidgets('removes date when delete button is pressed', (tester) async {
      controller.addDate(DateTime(2024, 1, 15));
      await tester.pumpWrapped(ExcludedDates(controller: controller));
      await tester.pumpAndSettle();
      expect(controller.value.length, 1);

      await act.tap(spot<IconButton>().spotIcon(Icons.delete));
      await tester.pumpAndSettle();

      expect(controller.value.length, 0);
      spot<ListTile>().doesNotExist();
    });

    testWidgets('displays multiple dates in list', (tester) async {
      final dates = [
        DateTime(2024, 1, 15),
        DateTime(2024, 2, 20),
        DateTime(2024, 3, 25),
      ]..forEach(controller.addDate);

      await tester.pumpWrapped(ExcludedDates(controller: controller));
      await tester.pumpAndSettle();

      spot<ListTile>().existsExactlyNTimes(dates.length);
      spot<IconButton>()
          .spotIcon(Icons.delete)
          .existsExactlyNTimes(dates.length);
    });

    testWidgets('updates ui when controller value changes', (tester) async {
      await tester.pumpWrapped(ExcludedDates(controller: controller));
      expect(controller.value.length, 0);
      spot<ListTile>().doesNotExist();
      final date = DateTime.now();

      controller.addDate(date);
      await tester.pumpAndSettle();

      expect(controller.value.length, 1);
      spot<ListTile>().existsOnce();
    });

    testWidgets('respects initial rrule with excluded dates', (tester) async {
      final rrule = 'FREQ=DAILY;EXDATE;VALUE=DATE:20240115,20240220';
      final controller = ExcludedDatesController(initialRRule: rrule);

      await tester.pumpWrapped(ExcludedDates(controller: controller));
      await tester.pumpAndSettle();

      spot<ListTile>().existsExactlyNTimes(2);

      addTearDown(controller.dispose);
    });
  });

  group(ExcludedDatesController, () {
    late ExcludedDatesController controller;

    setUp(() => controller = ExcludedDatesController());
    tearDown(() => controller.dispose());

    group('constructor', () {
      test('initializes with empty dates when no rrule provided', () {
        expect(controller.value.length, 0);
        expect(controller.timeZone, '');
      });

      test('initializes with default timeZone when rrule is empty', () {
        const defaultTimeZone = 'Europe/Warsaw';
        final controller = ExcludedDatesController(
          initialRRule: '',
          defaultTimeZone: defaultTimeZone,
        );

        expect(controller.timeZone, defaultTimeZone);
        expect(controller.value.length, 0);

        addTearDown(controller.dispose);
      });

      test('parses timeZone from rrule', () {
        const rrule =
            'FREQ=DAILY;EXDATE;TZID=America/Argentina/Buenos_Aires;'
            'VALUE=DATE:20240115';

        final controller = ExcludedDatesController(initialRRule: rrule);

        expect(controller.timeZone, 'America/Argentina/Buenos_Aires');

        addTearDown(controller.dispose);
      });

      property('parses dates from rrule', () {
        late ExcludedDatesController controller;

        forAll(stringDateArbitrary(), (t) {
          final rrule = 'FREQ=DAILY;EXDATE;VALUE=DATE:${t.string}';

          controller = ExcludedDatesController(initialRRule: rrule);

          expect(controller.value, t.dates);
        }, tearDown: () => controller.dispose());
      });

      test('uses default timeZone when rrule has no timeZone', () {
        const rrule = 'FREQ=DAILY;EXDATE;VALUE=DATE:20240115';
        const defaultTimeZone = 'Europe/Warsaw';

        final controller = ExcludedDatesController(
          initialRRule: rrule,
          defaultTimeZone: defaultTimeZone,
        );

        expect(controller.timeZone, defaultTimeZone);
        expect(controller.value.length, 1);

        addTearDown(controller.dispose);
      });
    });

    group('addDate', () {
      property('adds date to dates set', () {
        late ExcludedDatesController controller;

        forAll(
          set(dateArbitrary(), minLength: 1, maxLength: 5),
          (dates) {
            controller = ExcludedDatesController();

            dates.forEach(controller.addDate);

            expect(controller.value, dates);
          },
          tearDown: () => controller.dispose(),
        );
      });

      test('does not add duplicate date', () {
        final testDate = DateTime.now();

        for (var i = 0; i < 3; ++i) {
          controller.addDate(testDate);
        }

        expect(controller.value.length, 1);
      });

      property('notifies listeners when date is added', () {
        late ExcludedDatesController controller;
        late int listenerCallCount;

        forAll(
          set(dateArbitrary(), minLength: 1, maxLength: 5),
          (dates) {
            dates.forEach(controller.addDate);

            expect(listenerCallCount, dates.length);
          },
          setUp: () {
            controller = ExcludedDatesController()
              ..addListener(() => ++listenerCallCount);
            listenerCallCount = 0;
          },
          tearDown: () => controller.dispose(),
        );
      });

      test('does not notify listeners when duplicate date is added', () {
        var listenerCallCount = 0;
        controller.addListener(() => ++listenerCallCount);
        final testDate = DateTime.now();

        for (var i = 0; i < 3; ++i) {
          controller.addDate(testDate);
        }

        expect(listenerCallCount, 1);
      });

      property('maintains sorted order', () {
        late ExcludedDatesController controller;

        forAll(
          set(dateArbitrary(), minLength: 2, maxLength: 10).map((dates) {
            return (
              random: dates,
              sorted: dates.toList(growable: false)..sort(),
            );
          }),
          (t) {
            t.random.forEach(controller.addDate);

            expect(controller.value, orderedEquals(t.sorted));
          },
          setUp: () => controller = ExcludedDatesController(),
          tearDown: () => controller.dispose(),
        );
      });
    });

    group('removeDate', () {
      property('removes date from dates set', () {
        late ExcludedDatesController controller;

        forAll(
          set(dateArbitrary(), minLength: 1, maxLength: 5),
          (dates) {
            dates.forEach(controller.addDate);
            dates.forEach(controller.removeDate);

            expect(controller.value, UnmodifiableSetView({}));
          },
          setUp: () => controller = ExcludedDatesController(),
          tearDown: () => controller.dispose(),
        );
      });

      property('does nothing when date is not present', () {
        final testDate = DateTime.now();
        late ExcludedDatesController controller;

        forAll(
          set(
            dateArbitrary().filter((date) => date != testDate),
            minLength: 1,
            maxLength: 5,
          ),
          (dates) {
            controller.removeDate(testDate);

            expect(controller.value.length, 0);
          },
          setUp: () {
            controller = ExcludedDatesController()..addDate(testDate);
          },
          tearDown: () => controller.dispose(),
        );
      });

      property('notifies listeners when date is removed', () {
        late int listenerCallCount;

        forAll(
          set(dateArbitrary(), minLength: 1, maxLength: 5).map((dates) {
            final controller = ExcludedDatesController()
              ..addListener(() => ++listenerCallCount);
            dates.forEach(controller.addDate);
            return (controller: controller, dates: dates);
          }),
          (t) {
            t.dates.forEach(t.controller.removeDate);

            expect(listenerCallCount, t.dates.length);

            t.controller.dispose();
          },
          setUp: () {
            listenerCallCount = 0;
          },
        );
      });

      property(
        'does not notify listeners when non-existent date is removed',
        () {
          final testDate = DateTime.now();
          late ExcludedDatesController controller;
          late int listenerCallCount;

          forAll(
            set(
              dateArbitrary().filter((date) => date != testDate),
              minLength: 1,
              maxLength: 5,
            ),
            (dates) {
              dates.forEach(controller.removeDate);

              expect(listenerCallCount, 0);
            },
            setUp: () {
              controller = ExcludedDatesController()
                ..addListener(() => ++listenerCallCount)
                ..addDate(testDate);
              listenerCallCount = 0;
            },
            tearDown: () => controller.dispose(),
          );
        },
      );
    });

    group('setRRule', () {
      property('updates timeZone and dates from rrule', () {
        forAll(stringDateArbitrary(), (t) {
          final rrule =
              'FREQ=DAILY;EXDATE;TZID=Europe/Warsaw;VALUE=DATE:${t.string}';

          controller.setRRule(rrule);

          expect(controller.timeZone, 'Europe/Warsaw');
          expect(controller.value, t.dates);
        });
      });

      property('uses default timeZone when rrule has no timeZone', () {
        forAll(stringDateArbitrary(), (t) {
          final rrule = 'FREQ=DAILY;EXDATE;VALUE=DATE:${t.string}';
          const defaultTimeZone = 'Europe/Warsaw';
          controller.setRRule(rrule, defaultTimeZone);

          expect(controller.timeZone, defaultTimeZone);
          expect(controller.value, t.dates);
        });
      });

      test('clears dates when rrule is empty', () {
        controller.addDate(DateTime.now());

        controller.setRRule('');

        expect(controller.value.length, 0);
      });

      property('replaces existing dates with new ones from rrule', () {
        forAll(
          combine2(
            set(dateArbitrary(), minLength: 1, maxLength: 5),
            set(dateArbitrary(), minLength: 1, maxLength: 5),
          ).map((t) {
            return (
              oldDates: t.$1,
              newString: t.$2.map(formatter.format).join(','),
              newDates: t.$2,
            );
          }),
          (t) {
            t.oldDates.forEach(controller.addDate);
            final rrule = 'FREQ=DAILY;EXDATE;VALUE=DATE:${t.newString}';

            controller.setRRule(rrule);

            expect(controller.value, t.newDates);
          },
        );
      });

      property('parses complex rrule with multiple components', () {
        forAll(stringDateArbitrary(), (t) {
          final rrule =
              'FREQ=WEEKLY;BYDAY=MO,TU,WE;'
              'EXDATE;TZID=America/Los_Angeles;VALUE=DATE:${t.string}';

          controller.setRRule(rrule);

          expect(controller.timeZone, 'America/Los_Angeles');
          expect(controller.value, t.dates);
        });
      });
    });

    group('buildRRulePart', () {
      test('builds empty string when no dates', () {
        final sb = StringBuffer();

        controller.buildRRulePart(sb);

        expect(sb.toString(), '');
      });

      test('builds correct rrule with single date', () {
        controller.addDate(DateTime(2024, 1, 15));
        final sb = StringBuffer();

        controller.buildRRulePart(sb);

        expect(sb.toString(), ';EXDATE;VALUE=DATE:20240115');
      });

      property('builds correct rrule with multiple dates', () {
        final sb = StringBuffer();
        late ExcludedDatesController controller;

        forAll(
          stringDateArbitrary().map(
            (t) => (
              string: (t.string.split(',')..sort()).join(','),
              dates: t.dates,
            ),
          ),
          (t) {
            controller = ExcludedDatesController();
            t.dates.forEach(controller.addDate);

            controller.buildRRulePart(sb);

            expect(sb.toString(), ';EXDATE;VALUE=DATE:${t.string}');
          },
          tearDown: () {
            controller.dispose();
            sb.clear();
          },
        );
      });

      test('includes timeZone when set', () {
        controller.setRRule(
          'FREQ=DAILY;EXDATE;TZID=Europe/Warsaw;'
          'VALUE=DATE:20240115',
        );
        controller.addDate(DateTime(2024, 2, 20));
        final sb = StringBuffer();

        controller.buildRRulePart(sb);

        expect(
          sb.toString(),
          ';EXDATE;TZID=Europe/Warsaw;VALUE=DATE:20240115,20240220',
        );
      });

      test('formats month and day with leading zeros', () {
        controller.addDate(DateTime(2024, 1, 5));
        controller.addDate(DateTime(2024, 3, 3));
        controller.addDate(DateTime(2024, 12, 25));
        final sb = StringBuffer();

        controller.buildRRulePart(sb);

        expect(sb.toString(), ';EXDATE;VALUE=DATE:20240105,20240303,20241225');
      });

      property('maintains date order in output', () {
        final sb = StringBuffer();
        late ExcludedDatesController controller;

        forAll(
          stringDateArbitrary().map(
            (t) => (
              string: (t.string.split(',')..sort()).join(','),
              dates: t.dates,
            ),
          ),
          (t) {
            controller = ExcludedDatesController();
            t.dates.forEach(controller.addDate);

            controller.buildRRulePart(sb);

            expect(sb.toString(), ';EXDATE;VALUE=DATE:${t.string}');
          },
          tearDown: () {
            controller.dispose();
            sb.clear();
          },
        );
      });
    });

    group('value getter', () {
      test('returns unmodifiable view of dates', () {
        controller.addDate(DateTime(2024, 1, 15));
        final value = controller.value;

        expect(() => value.add(DateTime(2024, 2, 20)), throwsUnsupportedError);
        expect(
          () => value.remove(DateTime(2024, 1, 15)),
          throwsUnsupportedError,
        );
      });

      test('reflects changes to underlying dates', () {
        expect(controller.value.length, 0);

        controller.addDate(DateTime(2024, 1, 15));
        expect(controller.value.length, 1);

        controller.removeDate(DateTime(2024, 1, 15));
        expect(controller.value.length, 0);
      });
    });
  });

  group('parseRRule', () {
    test('returns default timeZone and empty dates for empty rrule', () {
      const defaultTimeZone = 'Europe/Warsaw';
      final (timeZone, dates) = parseRRule('', defaultTimeZone);

      expect(timeZone, defaultTimeZone);
      expect(dates.length, 0);
    });

    test('parses timeZone from rrule', () {
      const rrule =
          'FREQ=DAILY;EXDATE;TZID=America/Argentina/Buenos_Aires;'
          'VALUE=DATE:20240115';

      final (timeZone, dates) = parseRRule(rrule, 'UTC');

      expect(timeZone, 'America/Argentina/Buenos_Aires');
    });

    test('parses timeZone and dates from rrule', () {
      const rrule =
          'FREQ=DAILY;EXDATE;TZID=Europe/Warsaw;VALUE=DATE:20240115,20240220';
      final (timeZone, dates) = parseRRule(rrule, 'UTC');

      expect(timeZone, 'Europe/Warsaw');
      expect(dates, [DateTime(2024, 1, 15), DateTime(2024, 2, 20)]);
    });

    test('uses default timeZone when no timeZone in rrule', () {
      const rrule = 'FREQ=DAILY;EXDATE;VALUE=DATE:20240115';
      const defaultTimeZone = 'America/Chicago';
      final (timeZone, dates) = parseRRule(rrule, defaultTimeZone);

      expect(timeZone, defaultTimeZone);
      expect(dates.length, 1);
    });

    test('handles timeZone at different positions in rrule', () {
      const rrule = 'FREQ=DAILY;TZID=Asia/Tokyo;EXDATE;VALUE=DATE:20240115';
      final (timeZone, dates) = parseRRule(rrule, 'UTC');

      expect(timeZone, 'Asia/Tokyo');
      expect(dates.length, 1);
    });

    test('handles timeZone at end of rrule', () {
      const rrule =
          'FREQ=DAILY;EXDATE;VALUE=DATE:20240115;TZID=Pacific/Auckland';
      final (timeZone, dates) = parseRRule(rrule, 'UTC');

      expect(timeZone, 'Pacific/Auckland');
    });

    test('ignores EXDATE with malformed date entries', () {
      const rrule = 'FREQ=DAILY;EXDATE;VALUE=DATE:20240115,invalid,20240220';

      final (timeZone, dates) = parseRRule(rrule, 'UTC');

      expect(dates, SplayTreeSet<DateTime>());
    });

    test('handles rrule with no EXDATE component', () {
      const rrule = 'FREQ=DAILY;INTERVAL=2';
      final (timeZone, dates) = parseRRule(rrule, 'Europe/Warsaw');

      expect(timeZone, 'Europe/Warsaw');
      expect(dates.length, 0);
    });

    test('parses rrule with complex structure', () {
      const rrule =
          'FREQ=MONTHLY;BYMONTH=1,2,3;EXDATE;TZID=UTC;'
          'VALUE=DATE:20240101,20240201,20240301;DTSTART:20240101';
      final (timeZone, dates) = parseRRule(
        rrule,
        'America/Argentina/Buenos_Aires',
      );

      expect(timeZone, 'UTC');
      expect(dates, [
        DateTime(2024, 1, 1),
        DateTime(2024, 2, 1),
        DateTime(2024, 3, 1),
      ]);
    });

    test('handles timeZone with special characters', () {
      const rrule =
          'FREQ=DAILY;EXDATE;TZID=America/Argentina/Buenos_Aires;'
          'VALUE=DATE:20240115';
      final (timeZone, dates) = parseRRule(rrule, 'UTC');

      expect(timeZone, 'America/Argentina/Buenos_Aires');
    });

    property('parses valid dates correctly', () {
      forAll(stringDateArbitrary(), (t) {
        final rrule = 'FREQ=DAILY;EXDATE;VALUE=DATE:${t.string}';

        final (_, dates) = parseRRule(rrule, 'UTC');

        expect(dates, t.dates);
      });
    });

    property('returns empty dates for rrule without dates', () {
      forAll(
        string(
          minLength: 1,
          maxLength: 50,
          characterSet: .all(.ascii),
        ).filter((rrule) => !rrule.contains('VALUE=DATE:')),
        (rrule) {
          final (_, dates) = parseRRule(rrule, 'UTC');
          expect(dates.length, 0);
        },
      );
    });
  });
}

Arbitrary<DateTime> dateArbitrary({DateTime? min, DateTime? max}) {
  final minimum = min ?? DateTime(0000, 01, 01);
  final maximum = max ?? DateTime(5000, 12, 31);

  return combine3(
    integer(min: minimum.year, max: maximum.year),
    integer(min: minimum.month, max: maximum.month),
    integer(min: minimum.day, max: maximum.day),
  ).map((t) {
    return DateTime(t.$1, t.$2, switch (t.$2) {
      4 || 6 || 9 || 11 => math.min(t.$3, 30),
      2 => math.min(t.$3, 28),
      _ => t.$3,
    });
  });
}

Arbitrary<({String string, Set<DateTime> dates})> stringDateArbitrary({
  DateTime? min,
  DateTime? max,
  int minLength = 1,
  int maxLength = 5,
}) {
  return set(
    dateArbitrary(min: min, max: max),
    minLength: minLength,
    maxLength: maxLength,
  ).map((dates) {
    return (string: dates.map(formatter.format).join(','), dates: dates);
  });
}

final formatter = DateFormat('yyyyMMdd');
