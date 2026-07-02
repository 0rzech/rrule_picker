// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kiri_check/kiri_check.dart';
import 'package:rrule_picker/src/daily.dart';
import 'package:rrule_picker/src/shared/interval.dart';
import 'package:rrule_picker/src/shared/parsing.dart';
import 'package:rrule_picker/src/shared/resolved_theme.dart';
import 'package:spot/spot.dart';

import '../helpers.dart';

void main() {
  group(DailyPicker, () {
    const theme = ResolvedThemeData(
      padding: .all(8),
      headerTheme: .new(),
      dropdownTheme: .new(),
      topDropdownTheme: .new(),
      labelStyle: .new(color: Colors.cyan),
    );

    late DailyPickerController controller;

    setUpAll(() async {
      if (!kIsWeb) {
        await loadAppFonts();
      }
    });

    setUp(() => controller = DailyPickerController(listener: () {}));

    tearDown(() => controller.dispose());

    testWidgets('renders IntervalPicker with correct localizations', (
      tester,
    ) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: DailyPicker(controller: controller),
        ),
      );

      spot<IntervalPicker>().existsOnce();
      spotText('Every', exact: true).existsOnce();
      spotText('day', exact: true).existsOnce();
    });

    testWidgets('uses provided controller', (tester) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: DailyPicker(controller: controller),
        ),
      );

      await act.enterText(spot<TextField>(), '222');

      expect(controller.getIntervalValue(), 222);
    });

    testWidgets('applies ResolvedTheme when provided', (tester) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: theme,
          child: DailyPicker(controller: controller),
        ),
      );

      spot<Text>()
          .whereWidgetProp(
            widgetProp('style', (widget) => widget.style),
            (style) => style?.color == theme.labelStyle?.color,
          )
          .existsAtLeastOnce();
    });
  });

  group(DailyPickerController, () {
    late DailyPickerController controller;

    setUp(() => controller = DailyPickerController(listener: () {}));
    tearDown(() => controller.dispose());

    group('setRRule', () {
      property('updates interval from rrule', () {
        forAll(interval(), (interval) {
          controller.setRRule('FREQ=DAILY;INTERVAL=$interval');

          expect(controller.intervalNotifier.value, interval);
          expect(controller.intervalController.text, interval.toString());
        });
      });

      test('uses default interval for empty rrule', () {
        controller.setRRule('');

        expect(controller.intervalNotifier.value, defaultInterval);
        expect(controller.intervalController.text, defaultInterval.toString());
      });

      test('uses default interval for invalid rrule', () {
        controller.setRRule('INVALID_RRULE');

        expect(controller.intervalNotifier.value, defaultInterval);
        expect(controller.intervalController.text, defaultInterval.toString());
      });

      test('uses default interval for empty INTERVAL value', () {
        controller.setRRule('INTERVAL=');

        expect(controller.intervalNotifier.value, defaultInterval);
        expect(controller.intervalController.text, defaultInterval.toString());
      });
    });

    group('buildRRulePart', () {
      test('builds correct rrule string with default interval', () {
        final sb = StringBuffer();

        controller.buildRRulePart(sb);

        expect(sb.toString(), 'FREQ=DAILY;INTERVAL=$defaultInterval');
      });

      test('builds correct rrule string with intervalMin', () {
        controller.setIntervalValue(intervalMin);
        final sb = StringBuffer();

        controller.buildRRulePart(sb);

        expect(sb.toString(), 'FREQ=DAILY;INTERVAL=$intervalMin');
      });

      property('builds correct rrule string with custom interval', () {
        forAll(interval(), (interval) {
          controller.setIntervalValue(interval);
          final sb = StringBuffer();

          controller.buildRRulePart(sb);

          expect(sb.toString(), 'FREQ=DAILY;INTERVAL=$interval');
        });
      });
    });
  });

  group('parseRRule', () {
    test('returns defaultInterval for empty string', () {
      final result = parseRRule('');
      expect(result, defaultInterval);
    });

    property('returns correct interval for valid INTERVAL', () {
      forAll(interval(), (interval) {
        expect(parseRRule('FREQ=DAILY;INTERVAL=$interval'), interval);
      });
    });

    test('returns defaultInterval when INTERVAL is missing', () {
      expect(parseRRule('FREQ=DAILY'), defaultInterval);
    });

    property('returns defaultInterval '
        'when INTERVAL is not a number (ascii)', () {
      forAll(
        asciiString().filter((v) => v.isNotEmpty && int.tryParse(v) == null),
        (interval) => expect(
          parseRRule('FREQ=DAILY;INTERVAL=$interval'),
          defaultInterval,
        ),
      );
    });

    property('returns defaultInterval '
        'when INTERVAL is not a number (utf-8)', () {
      forAll(
        utf8String().filter((v) => v != '' && int.tryParse(v) == null),
        (interval) => expect(
          parseRRule('FREQ=DAILY;INTERVAL=$interval'),
          defaultInterval,
        ),
      );
    });

    test('returns defaultInterval when INTERVAL is 0', () {
      expect(parseRRule('FREQ=DAILY;INTERVAL=0'), defaultInterval);
    });

    property('returns defaultInterval when INTERVAL is negative', () {
      forAll(integer(max: -1), (interval) {
        expect(parseRRule('FREQ=DAILY;INTERVAL=$interval'), defaultInterval);
      });
    });

    property('extracts INTERVAL from complex rrule', () {
      forAll(interval(), (interval) {
        expect(
          parseRRule('FREQ=DAILY;INTERVAL=$interval;DTSTART:20260101'),
          interval,
        );
      });
    });

    test('returns defaultInterval when INTERVAL value is empty', () {
      expect(parseRRule('FREQ=DAILY;INTERVAL='), defaultInterval);
    });

    property('parses INTERVAL with leading zeros', () {
      forAll(interval(), (interval) {
        expect(parseRRule('FREQ=DAILY;INTERVAL=00$interval'), interval);
      });
    });

    property('parses lowercase rrule', () {
      forAll(interval(), (interval) {
        expect(parseRRule('freq=daily;interval=$interval'), interval);
      });
    });
  });
}
