// Copyright 2026 Piotr Mieczysław Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kiri_check/kiri_check.dart';
import 'package:material_ui/material_ui.dart';
import 'package:rrule_picker/src/shared/parsing.dart';
import 'package:rrule_picker/src/shared/resolved_theme.dart';
import 'package:rrule_picker/src/shared/split_segmented_button.dart';
import 'package:spot/spot.dart';

import '../../helpers.dart';

void main() {
  group(SplitSegmentedButton, () {
    setUpAll(() async {
      if (!kIsWeb) {
        await loadAppFonts();
      }
    });

    testWidgets('renders all segments correctly', (tester) async {
      const segments = [
        SplitButtonSegment(value: 1, text: 'Option 1'),
        SplitButtonSegment(value: 2, text: 'Option 2'),
        SplitButtonSegment(value: 3, text: 'Option 3'),
      ];

      await tester.pumpWrapped(
        ResolvedTheme(
          theme: testResolvedTheme(),
          child: SplitSegmentedButton<int, SplitButtonSegment<int>>(
            selected: const {1, 2},
            onSelectionChanged: (_) {},
            segmentInput: segments,
            segmentMapper: (v) => v,
          ),
        ),
      );

      final buttons = spot<SplitButton<int>>().existsExactlyNTimes(
        segments.length,
      );
      final values = buttons.widgets
          .whereType<SplitButton<int>>()
          .map((widget) => widget.value)
          .toList(growable: false);
      final texts = buttons.selector
          .spot<Text>()
          .existsAtLeastOnce()
          .widgets
          .whereType<Text>()
          .map((widget) => widget.data)
          .whereType<String>()
          .toList(growable: false);
      expect(
        List.generate(segments.length, (i) => (values[i], texts[i])),
        segments.map((segment) => (segment.value, segment.text)),
      );
    });

    group('onSelectionChanged', () {
      testWidgets('is called when tapping unselected segment', (tester) async {
        Set<int>? selected;
        var listenerCallCount = 0;

        await tester.pumpWrapped(
          ResolvedTheme(
            theme: testResolvedTheme(),
            child: SplitSegmentedButton<int, SplitButtonSegment<int>>(
              selected: const {1},
              onSelectionChanged: (s) {
                selected = s;
                ++listenerCallCount;
              },
              segmentInput: const [
                SplitButtonSegment(value: 1, text: 'Option 1'),
                SplitButtonSegment(value: 2, text: 'Option 2'),
              ],
              segmentMapper: (v) => v,
            ),
          ),
        );

        await act.tap(
          spot<SplitButton<int>>().spotText('Option 2', whole: true),
        );

        expect(selected, const {1, 2});
        expect(listenerCallCount, 1);
      });

      testWidgets('is called when tapping selected segment '
          'with multiple selections', (tester) async {
        Set<int>? selection;
        var listenerCallCount = 0;

        await tester.pumpWrapped(
          ResolvedTheme(
            theme: testResolvedTheme(),
            child: SplitSegmentedButton<int, SplitButtonSegment<int>>(
              selected: const {1, 2},
              onSelectionChanged: (s) {
                selection = s;
                ++listenerCallCount;
              },
              segmentInput: const [
                SplitButtonSegment(value: 1, text: 'Option 1'),
                SplitButtonSegment(value: 2, text: 'Option 2'),
              ],
              segmentMapper: (v) => v,
            ),
          ),
        );

        await act.tap(spot<SplitButton<int>>().spotText('Option 1'));
        await tester.pump();

        expect(selection, const {2});
        expect(listenerCallCount, 1);
      });

      testWidgets('is not called '
          'when tapping the only selected segment', (tester) async {
        Set<int>? selection;
        var listenerCallCount = 0;

        await tester.pumpWrapped(
          ResolvedTheme(
            theme: testResolvedTheme(),
            child: SplitSegmentedButton<int, SplitButtonSegment<int>>(
              selected: const {1},
              onSelectionChanged: (s) {
                selection = s;
                ++listenerCallCount;
              },
              segmentInput: const [
                SplitButtonSegment(value: 1, text: 'Option 1'),
                SplitButtonSegment(value: 2, text: 'Option 2'),
              ],
              segmentMapper: (v) => v,
            ),
          ),
        );

        await act.tap(
          spot<SplitButton<int>>().spotText('Option 1', whole: true),
        );

        expect(selection, null);
        expect(listenerCallCount, 0);
      });
    });

    testWidgets('uses correct theme style', (tester) async {
      const selectedFontSize = 48.0;
      const unselectedFontSize = 24.0;

      await tester.pumpWrapped(
        ResolvedTheme(
          theme: testResolvedTheme(
            splitSegmentedButtonStyle: .new(
              textStyle: WidgetStateProperty.resolveWith((states) {
                return TextStyle(
                  fontSize: states.contains(WidgetState.selected)
                      ? selectedFontSize
                      : unselectedFontSize,
                );
              }),
              shape: const WidgetStatePropertyAll(StadiumBorder()),
            ),
          ),
          child: SplitSegmentedButton<int, SplitButtonSegment<int>>(
            selected: const {1},
            onSelectionChanged: (_) {},
            segmentInput: const [
              SplitButtonSegment(value: 1, text: 'Option 1'),
              SplitButtonSegment(value: 2, text: 'Option 2'),
            ],
            segmentMapper: (v) => v,
          ),
        ),
      );

      final splitButtons = spot<SplitButton<int>>();
      splitButtons
          .spotText('Option 1', whole: true)
          .whereWidgetProp(
            widgetProp('textStyle.fontSize', (widget) {
              return widget.textStyle?.fontSize;
            }),
            (fontSize) => fontSize == selectedFontSize,
          )
          .existsOnce();
      splitButtons
          .spotText('Option 2', whole: true)
          .whereWidgetProp(
            widgetProp('textStyle.fontSize', (widget) {
              return widget.textStyle?.fontSize;
            }),
            (fontSize) => fontSize == unselectedFontSize,
          )
          .existsOnce();
    });

    testWidgets('handles responsive rendering ', (tester) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: testResolvedTheme(),
          child: SplitSegmentedButton<int, SplitButtonSegment<int>>(
            selected: const {1},
            onSelectionChanged: (_) {},
            segmentInput: List.generate(20, (i) {
              return SplitButtonSegment(value: i, text: 'Option $i');
            }),
            segmentMapper: (v) => v,
          ),
        ),
      );

      spot<SplitSegmentedButton<int, SplitButtonSegment<int>>>().existsOnce();
    });
  });

  group(SplitButtonSegment, () {
    property('creates segment with value and text', () {
      forAll(
        combine2(integer(), string()).map((t) => (value: t.$1, text: t.$2)),
        (t) {
          final segment = SplitButtonSegment(value: t.value, text: t.text);

          expect(segment.value, t.value);
          expect(segment.text, t.text);
        },
      );
    });

    test('supports any type of value', () {
      const stringSegment = SplitButtonSegment(value: 'hello', text: 'String');
      const intSegment = SplitButtonSegment(value: 123, text: 'Integer');
      const enumSegment = SplitButtonSegment(
        value: DayOfWeek.monday,
        text: 'Monday',
      );

      expect(stringSegment.value, 'hello');
      expect(stringSegment.text, 'String');
      expect(intSegment.value, 123);
      expect(intSegment.text, 'Integer');
      expect(enumSegment.value, DayOfWeek.monday);
      expect(enumSegment.text, 'Monday');
    });

    group('equals', () {
      property('returns true for identical segments', () {
        forAll(integer(), (i) {
          final segmentA = SplitButtonSegment(value: i, text: 'Option $i');

          expect(segmentA == segmentA, true);
        });
      });

      property('returns true for equal segments', () {
        forAll(integer(), (i) {
          final segmentA = SplitButtonSegment(value: i, text: 'Option $i');
          final segmentB = SplitButtonSegment(value: i, text: 'Option $i');

          expect(segmentA == segmentB, true);
        });
      });

      property('returns false for segments with different values', () {
        forAll(combine2(integer(), integer()).filter((i) => i.$1 != i.$2), (i) {
          final (i1, i2) = i;
          final segmentA = SplitButtonSegment(value: i1, text: 'Option $i1');
          final segmentB = SplitButtonSegment(value: i2, text: 'Option $i1');

          expect(segmentA == segmentB, false);
        });
      });

      property('returns false for segments with different texts', () {
        forAll(combine2(integer(), integer()).filter((i) => i.$1 != i.$2), (i) {
          final (i1, i2) = i;
          final segmentA = SplitButtonSegment(value: i1, text: 'Option $i1');
          final segmentB = SplitButtonSegment(value: i1, text: 'Option $i2');

          expect(segmentA == segmentB, false);
        });
      });
    });

    group('hashCode', () {
      property('returns same value for identical segments', () {
        forAll(integer(), (i) {
          final segmentA = SplitButtonSegment(value: i, text: 'Option $i');

          expect(segmentA.hashCode, segmentA.hashCode);
        });
      });

      property('returns same value for equal segments', () {
        forAll(integer(), (i) {
          final segmentA = SplitButtonSegment(value: i, text: 'Option $i');
          final segmentB = SplitButtonSegment(value: i, text: 'Option $i');

          expect(segmentA.hashCode, segmentB.hashCode);
        });
      });

      property('returns different values '
          'for segments with different values', () {
        forAll(combine2(integer(), integer()).filter((i) => i.$1 != i.$2), (i) {
          final (i1, i2) = i;
          final segmentA = SplitButtonSegment(value: i1, text: 'Option $i1');
          final segmentB = SplitButtonSegment(value: i2, text: 'Option $i1');

          expect(segmentA.hashCode, isNot(segmentB.hashCode));
        });
      });

      property('returns different values '
          'for segments with different texts', () {
        forAll(combine2(integer(), integer()).filter((i) => i.$1 != i.$2), (i) {
          final (i1, i2) = i;
          final segmentA = SplitButtonSegment(value: i1, text: 'Option $i1');
          final segmentB = SplitButtonSegment(value: i1, text: 'Option $i2');

          expect(segmentA.hashCode, isNot(segmentB.hashCode));
        });
      });
    });
  });

  group(SplitButton, () {
    setUpAll(() async {
      if (!kIsWeb) {
        await loadAppFonts();
      }
    });

    testWidgets('renders with selected state', (tester) async {
      await tester.pumpWrapped(
        ResolvedTheme(theme: testResolvedTheme(), child: testSplitButton),
      );

      expect(spot<SplitButton<int>>().existsOnce().widget.isSelected, true);
    });

    testWidgets('renders with unselected state', (tester) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: testResolvedTheme(),
          child: const SplitButton(
            isSelected: false,
            value: 1,
            onSelected: noop,
            child: Text('Test'),
          ),
        ),
      );

      expect(spot<SplitButton<int>>().existsOnce().widget.isSelected, false);
    });

    testWidgets('renders with non-$Text child', (tester) async {
      await tester.pumpWrapped(
        ResolvedTheme(
          theme: testResolvedTheme(),
          child: const SplitButton(
            isSelected: true,
            value: 1,
            onSelected: noop,
            child: Icon(Icons.check),
          ),
        ),
      );

      spotIcon(Icons.check).existsOnce();
    });

    testWidgets('calls onTap with correct value when tapped', (tester) async {
      int? value;
      var listenerCallCount = 0;

      await tester.pumpWrapped(
        ResolvedTheme(
          theme: testResolvedTheme(),
          child: SplitButton(
            isSelected: false,
            value: 42,
            onSelected: (v) {
              value = v;
              ++listenerCallCount;
            },
            child: const Text('Test'),
          ),
        ),
      );

      await act.tap(spot<SplitButton<int>>());

      expect(value, 42);
      expect(listenerCallCount, 1);
    });

    testWidgets('uses $ResolvedTheme'
        '.splitSegmentedButtonStyle', (tester) async {
      const style = ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(Colors.pink),
      );

      await tester.pumpWrapped(
        ResolvedTheme(
          theme: testResolvedTheme(splitSegmentedButtonStyle: style),
          child: testSplitButton,
        ),
      );

      expect(spot<OutlinedButton>().existsOnce().widget.style, style);
    });
  });
}

const testSplitButton = SplitButton<int>(
  isSelected: true,
  value: 1,
  onSelected: noop,
  child: Text('Test'),
);

void noop(int _) {}
