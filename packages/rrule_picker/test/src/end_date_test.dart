// Copyright 2026 Piotr Mieczysław Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:kiri_check/kiri_check.dart';
import 'package:material_ui/material_ui.dart';
import 'package:rrule_picker/rrule_picker.dart';
import 'package:rrule_picker/src/end_date.dart';
import 'package:rrule_picker/src/shared/labeled_switch.dart';
import 'package:rrule_picker/src/shared/resolved_theme.dart';
import 'package:spot/spot.dart';

import '../helpers.dart';

void main() {
  group(EndDate, () {
    final theme = testResolvedTheme();
    late EndDateController controller;

    setUpAll(() async {
      if (!kIsWeb) {
        await loadAppFonts();
      }
    });

    setUp(() => controller = EndDateController());
    tearDown(() => controller.dispose());

    testWidgets('renders $LabeledSwitch with correct label', (tester) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: EndDate(controller: controller),
        ),
      );

      spot<LabeledSwitch>().existsOnce();
      final l = tester.localizations<EndDate>();
      spotText(l.rrulePickerEndAfterDate, whole: true).existsOnce();
    });

    testWidgets('renders date button with formatted date', (tester) async {
      final labelFormatter = DateFormat.yMMMMEEEEd();

      var date = DateTime(2026, 07, 25);
      final controller = EndDateController(
        initialRRule: 'UNTIL=${formatter.format(date)}',
      );

      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: EndDate(controller: controller),
        ),
      );

      expect(
        spot<OutlinedButton>().spot<Text>().existsOnce().widget.data,
        labelFormatter.format(date),
      );

      date = DateTime(2026, 07, 28);
      controller.date = date;

      await tester.pump();

      expect(
        spot<OutlinedButton>().spot<Text>().existsOnce().widget.data,
        labelFormatter.format(date),
      );

      addTearDown(controller.dispose);
    });

    testWidgets('date button is enabled '
        'when end date is enabled', (tester) async {
      controller.enabled = true;

      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: EndDate(controller: controller),
        ),
      );

      expect(spot<OutlinedButton>().existsOnce().widget.onPressed, isNotNull);
    });

    testWidgets('date button is disabled '
        'when end date is disabled', (tester) async {
      controller.enabled = false;

      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: EndDate(controller: controller),
        ),
      );

      expect(spot<OutlinedButton>().existsOnce().widget.onPressed, null);
    });

    testWidgets('tapping switch toggles enabled state', (tester) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: EndDate(controller: controller),
        ),
      );
      expect(controller.value.enabled, false);

      await act.tap(spot<LabeledSwitch>());

      expect(controller.value.enabled, true);
    });

    testWidgets('applies $ResolvedTheme.outlinedContentButtonStyle '
        'when provided', (tester) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: EndDate(controller: controller),
        ),
      );

      expect(
        spot<OutlinedButton>().existsOnce().widget.style,
        theme.outlinedContentButtonStyle,
      );
    });

    testWidgets('uses $Column layout with correct spacing '
        'for narrow screens', (tester) async {
      const spacing = RRulePickerSpacing(row: 5, column: 10);

      await tester.pumpWrapped(
        SizedBox(
          width: RRulePicker.defaultNarrowLayoutBreakpoint - 10,
          child: Builder(
            builder: (context) {
              return ResolvedTheme(
                theme: .resolve(context, const .new(spacing: spacing)),
                child: EndDate(controller: controller),
              );
            },
          ),
        ),
      );

      spot<Row>()
          .whereWidget((w) => w.spacing != spacing.row, description: 'spacing')
          .doesNotExist();

      spot<Column>()
          .whereWidget(
            (w) => w.spacing != spacing.column,
            description: 'spacing',
          )
          .doesNotExist();
    });

    testWidgets('uses $Row layout with correct spacing '
        'for wide screens', (tester) async {
      const spacing = RRulePickerSpacing(row: 5, column: 10);

      await tester.pumpWrapped(
        SizedBox(
          width: RRulePicker.defaultNarrowLayoutBreakpoint + 10,
          child: Builder(
            builder: (context) {
              return ResolvedTheme(
                theme: .resolve(context, const .new(spacing: spacing)),
                child: EndDate(controller: controller),
              );
            },
          ),
        ),
      );

      spot<Row>()
          .whereWidget((w) => w.spacing != spacing.row, description: 'spacing')
          .doesNotExist();
      spot<Column>().doesNotExist();
    });

    testWidgets('picks date from date picker', (tester) async {
      final date = DateTime(2026, 01, 01);
      controller.enabled = true;
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: EndDate(controller: controller),
        ),
      );

      await act.tap(spot<OutlinedButton>());
      await act.tap(spot<IconButton>().spotIcon(Icons.edit_outlined));
      await act.enterText(spot<TextField>(), DateFormat.yMd().format(date));
      await act.tap(spotText('OK', whole: true));

      expect(controller.value.date, date);
    });
  });

  group(EndDateController, () {
    late EndDateController controller;

    setUp(() => controller = EndDateController());
    tearDown(() => controller.dispose());

    group('initialization', () {
      test('has disabled state and current date for empty rrule', () {
        final controller = EndDateController(initialRRule: '');
        expect(controller.value.enabled, false);
        final now = DateTime.now();

        expect(controller.value.date.year, now.year);
        expect(controller.value.date.month, now.month);
        expect(controller.value.date.day, now.day);

        addTearDown(controller.dispose);
      });

      property('has enabled state and parsed date for valid UNTIL', () {
        late EndDateController controller;

        forAll(date(), (date) {
          final rrule = 'RRULE:FREQ=DAILY;UNTIL=${formatter.format(date)}';

          controller = EndDateController(initialRRule: rrule);

          expect(controller.value.enabled, true);
          expect(controller.value.date.year, date.year);
          expect(controller.value.date.month, date.month);
          expect(controller.value.date.day, date.day);
        }, tearDown: () => controller.dispose());
      });

      test('has disabled state for invalid UNTIL format', () {
        final controller = EndDateController(
          initialRRule: 'RRULE:FREQ=DAILY;UNTIL=INVALID',
        );

        expect(controller.value.enabled, false);

        addTearDown(controller.dispose);
      });

      test('has disabled state when UNTIL is missing', () {
        final controller = EndDateController(initialRRule: 'RRULE:FREQ=DAILY');

        expect(controller.value.enabled, false);

        addTearDown(controller.dispose);
      });
    });

    group('setRRule', () {
      property('updates state for valid UNTIL', () {
        late EndDateController controller;

        forAll(
          date(),
          (date) {
            final rrule = 'RRULE:FREQ=WEEKLY;UNTIL=${formatter.format(date)}';

            controller.setRRule(rrule);

            expect(controller.value.enabled, true);
            expect(controller.value.date.year, date.year);
            expect(controller.value.date.month, date.month);
            expect(controller.value.date.day, date.day);
          },
          setUp: () => controller = EndDateController(),
          tearDown: () => controller.dispose(),
        );
      });

      test('sets disabled state for empty rrule', () {
        controller.setRRule('');

        expect(controller.value.enabled, false);
      });

      test('sets disabled state for rrule without UNTIL', () {
        controller.setRRule('RRULE:FREQ=DAILY');

        expect(controller.value.enabled, false);
      });
    });

    group('buildRRulePart', () {
      test('adds nothing to buffer when disabled', () {
        controller.enabled = false;
        controller.date = DateTime.now();
        final sb = StringBuffer();

        controller.buildRRulePart(sb);

        expect(sb.toString(), '');
      });

      property('adds UNTIL with formatted date when enabled', () {
        forAll(date(), (date) {
          controller.enabled = true;
          controller.date = date;

          final sb = StringBuffer();
          controller.buildRRulePart(sb);

          expect(sb.toString(), ';UNTIL=${formatter.format(date)}');
        });
      });
    });

    test('enabled setter updates enabled state and notifies listeners', () {
      var listenerCallCount = 0;
      controller.addListener(() => ++listenerCallCount);

      controller.enabled = true;

      expect(controller.value.enabled, true);
      expect(listenerCallCount, 1);
    });

    property('date setter updates date and notifies listeners', () {
      var listenerCallCount = 0;
      controller.addListener(() => ++listenerCallCount);

      forAll(date(), (date) {
        controller.date = date;

        expect(controller.value.date, date);
        expect(listenerCallCount, 1);
      }, tearDown: () => listenerCallCount = 0);
    });

    property('value getter returns current state', () {
      forAll(date(), (date) {
        controller.enabled = true;
        controller.date = date;

        final state = controller.value;

        expect(state.enabled, true);
        expect(state.date, date);
      });
    });
  });

  group('parseRRule', () {
    test('returns disabled state with current date for empty rrule', () {
      final result = parseRRule('');

      expect(result.enabled, false);
      expect(result.date.year, DateTime.now().year);
    });

    property('returns enabled state with parsed date for valid UNTIL', () {
      forAll(date(), (date) {
        final rrule = 'RRULE:FREQ=DAILY;UNTIL=${formatter.format(date)}';

        final result = parseRRule(rrule);

        expect(result.enabled, true);
        expect(result.date, date);
      });
    });

    test('returns disabled state for rrule without UNTIL', () {
      final result = parseRRule('RRULE:FREQ=DAILY');

      expect(result.enabled, false);
    });

    test('returns disabled state for malformed UNTIL', () {
      final result = parseRRule('RRULE:FREQ=DAILY;UNTIL=INVALID');

      expect(result.enabled, false);
    });

    property('parses UNTIL at the end of string', () {
      forAll(date(), (date) {
        final rrule = 'RRULE:FREQ=DAILY;UNTIL=${formatter.format(date)}';

        final result = parseRRule(rrule);

        expect(result.enabled, true);
        expect(result.date, date);
      });
    });

    property('parses UNTIL followed by semicolon', () {
      forAll(date(), (date) {
        final rrule = 'RRULE:FREQ=DAILY;UNTIL=${formatter.format(date)};';

        final result = parseRRule(rrule);

        expect(result.enabled, true);
        expect(result.date, date);
      });
    });

    property('parses UNTIL in the middle of rrule', () {
      forAll(date(), (date) {
        final rrule =
            'RRULE:FREQ=DAILY;UNTIL=${formatter.format(date)};INTERVAL=2';

        final result = parseRRule(rrule);

        expect(result.enabled, true);
        expect(result.date, date);
      });
    });

    property('parses case-insensitive UNTIL', () {
      forAll(date(), (date) {
        final rrule = 'RRULE:FREQ=DAILY;uNtIl=${formatter.format(date)}';
        final result = parseRRule(rrule);

        expect(result.enabled, true);
        expect(result.date, date);
      });
    });

    property('returns disabled state for UNTIL with partial date', () {
      forAll(
        date().map((d) {
          final string = formatter.format(d);
          return string.substring(0, string.length - 2);
        }),
        (date) {
          final result = parseRRule('RRULE:FREQ=DAILY;UNTIL=$date');

          expect(result.enabled, false);
        },
      );
    });

    property('returns disabled state for UNTIL with extra digits', () {
      forAll(
        combine2(date(), integer(min: 0)).map((t) {
          return '${formatter.format(t.$1)}${t.$2}';
        }),
        (date) {
          final result = parseRRule('RRULE:FREQ=DAILY;UNTIL=$date');

          expect(result.enabled, false);
        },
      );
    });

    property('returns disabled for arbitrary invalid date strings', () {
      final re = RegExp(r'^\d{8}$');

      forAll(asciiString().filter((s) => !re.hasMatch(s)), (invalidDate) {
        final result = parseRRule('RRULE:FREQ=DAILY;UNTIL=$invalidDate');

        expect(result.enabled, false);
      });
    });
  });
}

final formatter = DateFormat('yyyyMMdd');
