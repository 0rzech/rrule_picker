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

    group('constructor', () {
      test('initializes with default interval when initialRRule is empty', () {
        final controller = DailyPickerController(listener: () {});

        expect(controller.getIntervalValue(), defaultInterval);
        expect(controller.intervalNotifier.value, defaultInterval);
        expect(controller.intervalController.text, defaultInterval.toString());

        addTearDown(controller.dispose);
      });

      property('initializes with correct interval from valid interval', () {
        late DailyPickerController controller;

        forAll(integer(min: intervalMin), (interval) {
          controller = DailyPickerController(
            initialRRule: 'FREQ=DAILY;INTERVAL=$interval',
            listener: () {},
          );

          expect(controller.getIntervalValue(), interval);
          expect(controller.intervalNotifier.value, interval);
          expect(controller.intervalController.text, interval.toString());
        }, tearDown: () => controller.dispose());
      });

      test('initializes with default interval when interval is missing', () {
        final controller = DailyPickerController(
          initialRRule: 'FREQ=DAILY',
          listener: () {},
        );

        expect(controller.getIntervalValue(), defaultInterval);

        addTearDown(controller.dispose);
      });

      property('initializes with default interval '
          'when interval is invalid', () {
        late DailyPickerController controller;

        forAll(
          string(
            minLength: 1,
            maxLength: 5,
          ).filter((v) => int.tryParse(v) == null),
          (interval) {
            controller = DailyPickerController(
              initialRRule: 'FREQ=DAILY;INTERVAL=$interval',
              listener: () {},
            );

            expect(controller.getIntervalValue(), defaultInterval);
          },
          tearDown: () => controller.dispose(),
        );
      });

      test('initializes with default interval when interval is 0', () {
        final controller = DailyPickerController(
          initialRRule: 'FREQ=DAILY;INTERVAL=0',
          listener: () {},
        );

        expect(controller.getIntervalValue(), defaultInterval);

        addTearDown(controller.dispose);
      });

      property('initializes with default interval '
          'when interval is negative', () {
        late DailyPickerController controller;

        forAll(integer(max: -1), (interval) {
          controller = DailyPickerController(
            initialRRule: 'FREQ=DAILY;INTERVAL=$interval',
            listener: () {},
          );

          expect(controller.getIntervalValue(), defaultInterval);
        }, tearDown: () => controller.dispose());
      });
    });

    group('dispose', () {
      test('disposes intervalNotifier and intervalController', () {
        final controller = DailyPickerController(listener: () {});

        ChangeNotifier.debugAssertNotDisposed(controller.intervalNotifier);
        ChangeNotifier.debugAssertNotDisposed(controller.intervalController);

        controller.dispose();

        expect(
          () => ChangeNotifier.debugAssertNotDisposed(
            controller.intervalNotifier,
          ),
          throwsFlutterError,
        );
        expect(
          () => ChangeNotifier.debugAssertNotDisposed(
            controller.intervalController,
          ),
          throwsFlutterError,
        );
      });
    });

    group('setRRule', () {
      property('updates interval from rrule', () {
        forAll(integer(min: intervalMin), (interval) {
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
      test('builds correct RRULE string with default interval', () {
        final sb = StringBuffer();

        controller.buildRRulePart(sb);

        expect(sb.toString(), 'FREQ=DAILY;INTERVAL=$defaultInterval');
      });

      test('builds correct RRULE string with intervalMin', () {
        // ignore: invalid_use_of_protected_member
        controller.setIntervalValue(intervalMin);
        final sb = StringBuffer();

        controller.buildRRulePart(sb);

        expect(sb.toString(), 'FREQ=DAILY;INTERVAL=$intervalMin');
      });

      property('builds correct RRULE string with custom interval', () {
        forAll(integer(min: intervalMin), (interval) {
          // ignore: invalid_use_of_protected_member
          controller.setIntervalValue(interval);
          final sb = StringBuffer();

          controller.buildRRulePart(sb);

          expect(sb.toString(), 'FREQ=DAILY;INTERVAL=$interval');
        });
      });
    });

    group('setIntervalValue', () {
      property('updates notifier and controller', () {
        forAll(integer(min: intervalMin), (interval) {
          // ignore: invalid_use_of_protected_member
          controller.setIntervalValue(interval);

          expect(controller.intervalNotifier.value, interval);
          expect(controller.intervalController.text, interval.toString());
        });
      });

      property('works for all valid intervals', () {
        late DailyPickerController controller;

        forAll(
          integer(min: intervalMin),
          (interval) {
            // ignore: invalid_use_of_protected_member
            controller.setIntervalValue(interval);

            expect(controller.intervalNotifier.value, interval);
            expect(controller.intervalController.text, interval.toString());
          },
          setUp: () => controller = DailyPickerController(listener: () {}),
          tearDown: () => controller.dispose(),
        );
      });
    });

    group('getIntervalValue', () {
      property('returns current interval value', () {
        forAll(integer(min: intervalMin), (interval) {
          // ignore: invalid_use_of_protected_member
          controller.setIntervalValue(interval);

          expect(controller.getIntervalValue(), interval);
        });
      });

      property('returns default value when below default min', () {
        forAll(integer(max: intervalMin - 1), (interval) {
          // ignore: invalid_use_of_protected_member
          controller.setIntervalValue(interval);

          expect(controller.getIntervalValue(), defaultInterval);
        });
      });

      property('returns custom default value when below default min', () {
        forAll(
          combine2(
            integer(max: intervalMin - 1),
            integer(min: intervalMin),
          ).map((t) => (currentValue: t.$1, defaultValue: t.$2)),
          (t) {
            // ignore: invalid_use_of_protected_member
            controller.setIntervalValue(t.currentValue);

            final result = controller.getIntervalValue(
              defaultValue: t.defaultValue,
            );

            expect(result, t.defaultValue);
          },
        );
      });

      property('returns default value when below custom min', () {
        forAll(
          combine2(
            integer(max: intervalMin),
            integer(min: intervalMin + 1),
          ).map((t) => (currentValue: t.$1, minValue: t.$2)),
          (t) {
            // ignore: invalid_use_of_protected_member
            controller.setIntervalValue(t.currentValue);

            final result = controller.getIntervalValue(minValue: t.minValue);

            expect(result, intervalMin);
          },
        );
      });

      property('returns custom default value when below custom min', () {
        forAll(
          combine3(
            integer(max: intervalMin),
            integer(min: intervalMin + 1),
            integer(),
          ).map((t) {
            return (currentValue: t.$1, minValue: t.$2, defaultValue: t.$3);
          }),
          (t) {
            // ignore: invalid_use_of_protected_member
            controller.setIntervalValue(t.currentValue);

            final result = controller.getIntervalValue(
              minValue: t.minValue,
              defaultValue: t.defaultValue,
            );

            expect(result, t.defaultValue);
          },
        );
      });
    });

    property('listener is called when interval changes', () async {
      late DailyPickerController controller;
      late int callCount;

      forAll(
        combine2(
          integer(min: intervalMin + 1),
          integer(min: intervalMin + 1),
        ).filter((t) => t.$1 != t.$2),
        (intervals) {
          // ignore: invalid_use_of_protected_member
          controller.setIntervalValue(intervals.$1);
          expect(callCount, 1);

          // ignore: invalid_use_of_protected_member
          controller.setIntervalValue(intervals.$2);
          expect(callCount, 2);
        },
        setUp: () {
          controller = DailyPickerController(listener: () => ++callCount);
          callCount = 0;
        },
        tearDown: () => controller.dispose(),
      );
    });

    property('listener is not called when '
        'setRRule is called with same value', () {
      late DailyPickerController controller;
      late int callCount;

      forAll(
        integer(min: intervalMin),
        (interval) {
          controller = DailyPickerController(
            initialRRule: 'FREQ=DAILY;INTERVAL=$interval',
            listener: () => ++callCount,
          );

          controller.setRRule('FREQ=DAILY;INTERVAL=$interval');
          expect(callCount, 0);
        },
        setUp: () => callCount = 0,
        tearDown: () => controller.dispose(),
      );
    });
  });

  group('parseRRule', () {
    test('returns defaultInterval for empty string', () {
      final result = parseRRule('');
      expect(result, defaultInterval);
    });

    property('returns correct interval for valid interval', () {
      forAll(integer(min: intervalMin), (interval) {
        expect(parseRRule('FREQ=DAILY;INTERVAL=$interval'), interval);
      });
    });

    test('returns defaultInterval when interval is missing', () {
      expect(parseRRule('FREQ=DAILY'), defaultInterval);
    });

    property('returns defaultInterval '
        'when interval is not a number (ascii)', () {
      forAll(
        string(
          minLength: 1,
          maxLength: 5,
          characterSet: .all(.ascii),
        ).filter((v) => v.isNotEmpty && int.tryParse(v) == null),
        (interval) => expect(
          parseRRule('FREQ=DAILY;INTERVAL=$interval'),
          defaultInterval,
        ),
      );
    });

    property('returns defaultInterval '
        'when interval is not a number (utf-8)', () {
      forAll(
        string(
          minLength: 1,
          maxLength: 5,
          characterSet: .all(.utf8),
        ).filter((v) => v != '' && int.tryParse(v) == null),
        (interval) => expect(
          parseRRule('FREQ=DAILY;INTERVAL=$interval'),
          defaultInterval,
        ),
      );
    });

    test('returns defaultInterval when interval is 0', () {
      expect(parseRRule('FREQ=DAILY;INTERVAL=0'), defaultInterval);
    });

    property('returns defaultInterval when interval is negative', () {
      forAll(integer(max: -1), (interval) {
        expect(parseRRule('FREQ=DAILY;INTERVAL=$interval'), defaultInterval);
      });
    });

    property('extracts interval from complex rrule', () {
      forAll(integer(min: intervalMin), (interval) {
        expect(
          parseRRule('FREQ=DAILY;INTERVAL=$interval;DTSTART:20240101'),
          interval,
        );
      });
    });

    test('returns defaultInterval when interval value is empty', () {
      expect(parseRRule('FREQ=DAILY;INTERVAL='), defaultInterval);
    });

    property('parses interval with leading zeros', () {
      forAll(integer(min: intervalMin), (interval) {
        expect(parseRRule('FREQ=DAILY;INTERVAL=00$interval'), interval);
      });
    });

    property('parses lowercase RRULE', () {
      forAll(integer(min: intervalMin), (interval) {
        expect(parseRRule('freq=daily;interval=$interval'), defaultInterval);
      });
    });
  });
}
