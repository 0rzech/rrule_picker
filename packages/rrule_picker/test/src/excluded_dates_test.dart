// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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

      spot<OutlinedButton>().existsOnce();
      spotIcon(Icons.add).existsOnce();
      final text = tester.localizations<ExcludedDates>().rrulePickerSkip;
      spotText(text, exact: true).existsOnce();
    });

    testWidgets('shows date picker when add button is pressed', (tester) async {
      await tester.pumpWrapped(ExcludedDates(controller: controller));

      await act.tap(spot<OutlinedButton>());
      await tester.pumpAndSettle();

      spot<DatePickerDialog>().existsOnce();
    });

    testWidgets('adds date to list when date is selected', (tester) async {
      await tester.pumpWrapped(ExcludedDates(controller: controller));

      await act.tap(spot<OutlinedButton>());
      await tester.pumpAndSettle();

      await act.tap(
        spot<DatePickerDialog>().spot<TextButton>().spotText('OK', exact: true),
      );
      await tester.pumpAndSettle();

      spot<ListTile>().existsOnce();
      spot<IconButton>().spotIcon(Icons.delete).existsOnce();
    });

    testWidgets('removes date when delete button is pressed', (tester) async {
      controller.addDate(DateTime(2059, 11, 01));
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
        DateTime(2956, 11, 12),
        DateTime(2059, 11, 01),
        DateTime(2087, 05, 10),
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
      final rrule = 'FREQ=DAILY;EXDATE;VALUE=DATE:20561112,20591101';
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
            'VALUE=DATE:20870510';

        final controller = ExcludedDatesController(initialRRule: rrule);

        expect(controller.timeZone, 'America/Argentina/Buenos_Aires');

        addTearDown(controller.dispose);
      });

      test('parses timeZone from lower-case rrule', () {
        const rrule =
            'freq=daily;exdate;tzid=america/argentina/buenos_aires;'
            'value=date:20561112';

        final controller = ExcludedDatesController(initialRRule: rrule);

        expect(controller.timeZone, 'america/argentina/buenos_aires');

        addTearDown(controller.dispose);
      });

      test('parses timeZone from mixed-case rrule', () {
        const rrule =
            'FrEQ=Daily;EXDATE;TZID=America/Argentina/Buenos_Aires;'
            'VALUE=Date:20591101';

        final controller = ExcludedDatesController(initialRRule: rrule);

        expect(controller.timeZone, 'America/Argentina/Buenos_Aires');

        addTearDown(controller.dispose);
      });

      property('parses dates from rrule', () {
        late ExcludedDatesController controller;

        forAll(stringDateSet(), (t) {
          final rrule = 'FREQ=DAILY;EXDATE;VALUE=DATE:${t.string}';

          controller = ExcludedDatesController(initialRRule: rrule);

          expect(controller.value, t.dates);
        }, tearDown: () => controller.dispose());
      });

      property('parses dates from lower-case rrule', () {
        late ExcludedDatesController controller;

        forAll(stringDateSet(), (t) {
          final rrule = 'freq=daily;exdate;value=date:${t.string}';

          controller = ExcludedDatesController(initialRRule: rrule);

          expect(controller.value, t.dates);
        }, tearDown: () => controller.dispose());
      });

      property('parses dates from mixed-case rrule', () {
        late ExcludedDatesController controller;

        forAll(stringDateSet(), (t) {
          final rrule = 'FREQ=Daily;EXdATE;Value=Date:${t.string}';

          controller = ExcludedDatesController(initialRRule: rrule);

          expect(controller.value, t.dates);
        }, tearDown: () => controller.dispose());
      });

      test('uses default timeZone when rrule has no timeZone', () {
        const rrule = 'FREQ=DAILY;EXDATE;VALUE=DATE:20870510';
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

        forAll(standardSet(date()), (dates) {
          controller = ExcludedDatesController();

          dates.forEach(controller.addDate);

          expect(controller.value, dates);
        }, tearDown: () => controller.dispose());
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
          standardSet(date()),
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
          set(date(), minLength: 2, maxLength: 10).map((dates) {
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
          standardSet(date()),
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
          standardSet(date().filter((date) => date != testDate)),
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
          standardSet(date()).map((dates) {
            final controller = ExcludedDatesController()
              ..addListener(() => ++listenerCallCount);
            dates.forEach(controller.addDate);
            return (month: controller, dates: dates);
          }),
          (t) {
            t.dates.forEach(t.month.removeDate);

            expect(listenerCallCount, t.dates.length);

            t.month.dispose();
          },
          setUp: () {
            listenerCallCount = 0;
          },
        );
      });

      property('does not notify listeners '
          'when non-existent date is removed', () {
        final testDate = DateTime.now();
        late ExcludedDatesController controller;
        late int listenerCallCount;

        forAll(
          standardSet(date().filter((date) => date != testDate)),
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
      });
    });

    group('setRRule', () {
      property('updates timeZone and dates from rrule', () {
        forAll(stringDateSet(), (t) {
          final rrule =
              'FREQ=DAILY;EXDATE;TZID=Europe/Warsaw;VALUE=DATE:${t.string}';

          controller.setRRule(rrule);

          expect(controller.timeZone, 'Europe/Warsaw');
          expect(controller.value, t.dates);
        });
      });

      property('uses default timeZone when rrule has no timeZone', () {
        forAll(stringDateSet(), (t) {
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
          combine2(standardSet(date()), standardSet(date())).map((t) {
            return (
              oldDates: t.$1,
              newString: t.$2.map(exdateFormatter.format).join(','),
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
        forAll(stringDateSet(), (t) {
          final rrule =
              'FREQ=WEEKLY;BYDAY=MO,TU,WE;'
              'EXDATE;TZID=America/Los_Angeles;VALUE=DATE:${t.string}';

          controller.setRRule(rrule);

          expect(controller.timeZone, 'America/Los_Angeles');
          expect(controller.value, t.dates);
        });
      });

      property('parses complex rrule '
          'with multiple components in lower-case', () {
        forAll(stringDateSet(), (t) {
          final rrule =
              'freq=weekly;byday=mo,tu,we;'
              'exdate;tzid=america/los_angeles;value=date:${t.string}';

          controller.setRRule(rrule);

          expect(controller.timeZone, 'america/los_angeles');
          expect(controller.value, t.dates);
        });
      });

      property('parses complex rrule '
          'with multiple components in mixed-case', () {
        forAll(stringDateSet(), (t) {
          final rrule =
              'freq=wEEkly;bydaY=Mo,tu,we;'
              'eXdAte;tZiD=america/los_angeles;ValuE=date:${t.string}';

          controller.setRRule(rrule);

          expect(controller.timeZone, 'america/los_angeles');
          expect(controller.value, t.dates);
        });
      });

      test('notifies listeners when called with different value', () {
        var listenerCallCount = 0;
        controller.addListener(() => ++listenerCallCount);

        controller.setRRule('EXDATE;VALUE=DATE:20260703');

        expect(listenerCallCount, 1);
      });

      test('does not notify listeners when called with the same value', () {
        var listenerCallCount = 0;
        controller.addListener(() => ++listenerCallCount);

        controller.setRRule('');

        expect(listenerCallCount, 0);
      });
    });

    group('buildRRulePart', () {
      test('builds empty string when no dates', () {
        final sb = StringBuffer();

        controller.buildRRulePart(sb);

        expect(sb.toString(), '');
      });

      test('builds correct rrule with single date', () {
        controller.addDate(DateTime(2087, 05, 10));
        final sb = StringBuffer();

        controller.buildRRulePart(sb);

        expect(sb.toString(), ';EXDATE;VALUE=DATE:20870510');
      });

      property('builds correct rrule with multiple dates', () {
        final sb = StringBuffer();
        late ExcludedDatesController controller;

        forAll(
          stringDateSet().map((t) {
            return (
              string: (t.string.split(',')..sort()).join(','),
              dates: t.dates,
            );
          }),
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
          'VALUE=DATE:20561112',
        );
        controller.addDate(DateTime(2059, 11, 01));
        final sb = StringBuffer();

        controller.buildRRulePart(sb);

        expect(
          sb.toString(),
          ';EXDATE;TZID=Europe/Warsaw;VALUE=DATE:20561112,20591101',
        );
      });

      test('formats month and day with leading zeros', () {
        controller.addDate(DateTime(2026, 1, 5));
        controller.addDate(DateTime(2026, 3, 3));
        controller.addDate(DateTime(2026, 12, 25));
        final sb = StringBuffer();

        controller.buildRRulePart(sb);

        expect(sb.toString(), ';EXDATE;VALUE=DATE:20260105,20260303,20261225');
      });

      property('maintains date order in output', () {
        final sb = StringBuffer();
        late ExcludedDatesController controller;

        forAll(
          stringDateSet().map((t) {
            return (
              string: (t.string.split(',')..sort()).join(','),
              dates: t.dates,
            );
          }),
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
        controller.addDate(DateTime(2056, 11, 12));
        final value = controller.value;

        expect(() => value.add(DateTime(2059, 11, 01)), throwsUnsupportedError);
        expect(
          () => value.remove(DateTime(2056, 11, 12)),
          throwsUnsupportedError,
        );
      });

      test('reflects changes to underlying dates', () {
        expect(controller.value.length, 0);

        controller.addDate(DateTime(2056, 11, 12));
        expect(controller.value.length, 1);

        controller.removeDate(DateTime(2056, 11, 12));
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
          'VALUE=DATE:20840330';

      final (timeZone, dates) = parseRRule(rrule, 'UTC');

      expect(timeZone, 'America/Argentina/Buenos_Aires');
    });

    test('parses timeZone and dates from rrule', () {
      const rrule =
          'FREQ=DAILY;EXDATE;TZID=Europe/Warsaw;VALUE=DATE:20561112,20591101';
      final (timeZone, dates) = parseRRule(rrule, 'UTC');

      expect(timeZone, 'Europe/Warsaw');
      expect(dates, [DateTime(2056, 11, 12), DateTime(2059, 11, 01)]);
    });

    test('uses default timeZone when no timeZone in rrule', () {
      const rrule = 'FREQ=DAILY;EXDATE;VALUE=DATE:20840330';
      const defaultTimeZone = 'America/Chicago';
      final (timeZone, dates) = parseRRule(rrule, defaultTimeZone);

      expect(timeZone, defaultTimeZone);
      expect(dates.length, 1);
    });

    test('handles timeZone at different positions in rrule', () {
      const rrule = 'FREQ=DAILY;TZID=Asia/Tokyo;EXDATE;VALUE=DATE:20840330';
      final (timeZone, dates) = parseRRule(rrule, 'UTC');

      expect(timeZone, 'Asia/Tokyo');
      expect(dates.length, 1);
    });

    test('handles timeZone at end of rrule', () {
      const rrule =
          'FREQ=DAILY;EXDATE;VALUE=DATE:20840330;TZID=Pacific/Auckland';
      final (timeZone, dates) = parseRRule(rrule, 'UTC');

      expect(timeZone, 'Pacific/Auckland');
    });

    test('ignores EXDATE with malformed date entries', () {
      const rrule = 'FREQ=DAILY;EXDATE;VALUE=DATE:20591101,invalid,20561112';

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
          'VALUE=DATE:20591101,20840330,20870510;DTSTART:20561112';
      final (timeZone, dates) = parseRRule(
        rrule,
        'America/Argentina/Buenos_Aires',
      );

      expect(timeZone, 'UTC');
      expect(dates, [
        DateTime(2059, 11, 01),
        DateTime(2084, 03, 30),
        DateTime(2087, 05, 10),
      ]);
    });

    test('parses rrule with complex structure in lower-case', () {
      const rrule =
          'freq=monthly;bymonth=1,2,3;exdate;tzid=utc;'
          'value=date:20840330,20870510;dtstart:20561112';
      final (timeZone, dates) = parseRRule(
        rrule,
        'America/Argentina/Buenos_Aires',
      );

      expect(timeZone, 'utc');
      expect(dates, [DateTime(2084, 03, 30), DateTime(2087, 05, 10)]);
    });

    test('parses rrule with complex structure in mixed-case', () {
      const rrule =
          'fREq=montHly;bymonth=1,2,3;exdAte;tzId=utc;'
          'vaLUE=Date:20840330,20870510;dTstart:20591101';
      final (timeZone, dates) = parseRRule(
        rrule,
        'America/Argentina/Buenos_Aires',
      );

      expect(timeZone, 'utc');
      expect(dates, [DateTime(2084, 03, 30), DateTime(2087, 05, 10)]);
    });

    test('handles timeZone with special characters', () {
      const rrule =
          'FREQ=DAILY;EXDATE;TZID=America/Argentina/Buenos_Aires;'
          'VALUE=DATE:20840330';
      final (timeZone, dates) = parseRRule(rrule, 'UTC');

      expect(timeZone, 'America/Argentina/Buenos_Aires');
    });

    property('parses valid dates correctly', () {
      forAll(stringDateSet(), (t) {
        final rrule = 'FREQ=DAILY;EXDATE;VALUE=DATE:${t.string}';

        final (_, dates) = parseRRule(rrule, 'UTC');

        expect(dates, t.dates);
      });
    });

    property('returns empty dates for rrule without dates', () {
      forAll(
        asciiString(
          maxLength: 50,
        ).filter((rrule) => !rrule.contains('VALUE=DATE:')),
        (rrule) {
          final (_, dates) = parseRRule(rrule, 'UTC');
          expect(dates.length, 0);
        },
      );
    });
  });
}
