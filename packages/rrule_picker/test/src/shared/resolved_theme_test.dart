// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rrule_picker/src/shared/resolved_theme.dart';
import 'package:rrule_picker/theme.dart';

import '../../helpers.dart';

class MockThemeData extends Mock implements ThemeData {
  @override
  String toString({DiagnosticLevel minLevel = .info}) => 'MockThemeData';
}

class MockTextTheme extends Mock implements TextTheme {
  @override
  String toString({DiagnosticLevel minLevel = .info}) => 'MockTextTheme';
}

void main() {
  group(ResolvedTheme, () {
    testWidgets('of() returns theme when context is wrapped', (tester) async {
      final theme = testResolvedTheme();
      late ResolvedThemeData resolved;

      await tester.pumpWidget(
        ResolvedTheme(
          theme: theme,
          child: Builder(
            builder: (context) {
              resolved = ResolvedTheme.of(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(resolved, theme);
    });

    testWidgets('of() throws Exception when not wrapped', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              ResolvedTheme.of(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(
        tester.takeException(),
        isException.having(
          (e) => e.toString(),
          'toString',
          contains(
            'RRulePicker child widgets must be wrapped in a RRulePickerTheme',
          ),
        ),
      );
    });

    test('updateShouldNotify returns true when theme changes', () {
      final widgetA = ResolvedTheme(
        theme: testResolvedTheme(),
        child: const SizedBox.shrink(),
      );
      final widgetB = ResolvedTheme(
        theme: testResolvedTheme(padding: const .all(16)),
        child: const SizedBox.shrink(),
      );

      expect(widgetB.updateShouldNotify(widgetA), true);
    });

    test('updateShouldNotify returns false when theme is the same', () {
      final widgetA = ResolvedTheme(
        theme: testResolvedTheme(),
        child: const SizedBox.shrink(),
      );
      final widgetB = ResolvedTheme(
        theme: testResolvedTheme(),
        child: const SizedBox.shrink(),
      );

      expect(widgetB.updateShouldNotify(widgetA), false);
    });
  });

  group(ResolvedThemeData, () {
    group('constructor', () {
      test('creates instance with all required parameters', () {
        const padding = EdgeInsets.all(8);
        const headerTheme = RRulePickerHeaderThemeData();
        const dropdownTheme = RRulePickerDropdownThemeData();
        const topDropdownTheme = RRulePickerDropdownThemeData();

        const theme = ResolvedThemeData(
          padding: padding,
          headerTheme: headerTheme,
          dropdownTheme: dropdownTheme,
          topDropdownTheme: topDropdownTheme,
        );

        expect(theme.labelStyle, null);
        expect(theme.padding, padding);
        expect(theme.headerTheme, headerTheme);
        expect(theme.dropdownTheme, dropdownTheme);
        expect(theme.topDropdownTheme, topDropdownTheme);
        expect(theme.textFieldTheme, null);
        expect(theme.segmentedButtonStyle, null);
        expect(theme.splitSegmentedButtonStyle, null);
        expect(theme.outlinedContentButtonStyle, null);
      });

      test('creates instance with all optional parameters', () {
        const labelStyle = TextStyle(fontSize: 16);
        const padding = EdgeInsets.all(8);
        const headerTheme = RRulePickerHeaderThemeData();
        const dropdownTheme = RRulePickerDropdownThemeData();
        const topDropdownTheme = RRulePickerDropdownThemeData();
        const textFieldTheme = RRulePickerTextFieldThemeData();
        const segmentedButtonStyle = ButtonStyle();
        const splitSegmentedButtonStyle = ButtonStyle();
        const outlinedContentButtonStyle = ButtonStyle();

        const theme = ResolvedThemeData(
          labelStyle: labelStyle,
          padding: padding,
          headerTheme: headerTheme,
          dropdownTheme: dropdownTheme,
          topDropdownTheme: topDropdownTheme,
          textFieldTheme: textFieldTheme,
          segmentedButtonStyle: segmentedButtonStyle,
          splitSegmentedButtonStyle: splitSegmentedButtonStyle,
          outlinedContentButtonStyle: outlinedContentButtonStyle,
        );

        expect(theme.labelStyle, labelStyle);
        expect(theme.padding, padding);
        expect(theme.headerTheme, headerTheme);
        expect(theme.dropdownTheme, dropdownTheme);
        expect(theme.topDropdownTheme, topDropdownTheme);
        expect(theme.textFieldTheme, textFieldTheme);
        expect(theme.segmentedButtonStyle, segmentedButtonStyle);
        expect(theme.splitSegmentedButtonStyle, splitSegmentedButtonStyle);
        expect(theme.outlinedContentButtonStyle, outlinedContentButtonStyle);
      });
    });

    group('defaults', () {
      test('creates default theme with Material $ThemeData', () {
        final theme = ThemeData();
        final defaults = ResolvedThemeData.defaults(theme);

        expect(defaults.labelStyle, null);
        expect(defaults.padding, RRulePickerThemeData.defaultPadding);
        expect(
          defaults.headerTheme.showHeader,
          RRulePickerHeaderThemeData.defaultShowHeader,
        );
        expect(
          defaults.headerTheme.style,
          isA<TextStyle>()
              .having(
                (style) => style.fontSize,
                'fontSize',
                RRulePickerHeaderThemeData.defaultFontSize,
              )
              .having(
                (style) => style.fontWeight,
                'fontWeight',
                RRulePickerHeaderThemeData.defaultFontWeight,
              ),
        );
        expect(
          defaults.dropdownTheme.showUnderline,
          RRulePickerDropdownThemeData.defaultShowUnderline,
        );
        expect(
          defaults.topDropdownTheme.showUnderline,
          RRulePickerDropdownThemeData.defaultTopShowUnderline,
        );
        expect(
          defaults.textFieldTheme,
          isA<RRulePickerTextFieldThemeData>().having(
            (theme) => theme.decoration,
            'decoration',
            RRulePickerTextFieldThemeData.defaultDecoration,
          ),
        );
        expect(
          defaults.segmentedButtonStyle,
          RRulePickerThemeData.defaultSegmentedButtonStyle,
        );
        expect(
          defaults.splitSegmentedButtonStyle,
          isA<ButtonStyle>()
              .having(
                (style) => style.padding,
                'padding',
                const WidgetStatePropertyAll(
                  RRulePickerThemeData.defaultPadding,
                ),
              )
              .having(
                (style) => style.shape,
                'shape',
                isA<WidgetStatePropertyAll>().having(
                  (p) => p.value,
                  'value',
                  RRulePickerThemeData.defaultSplitSegmentedButtonSegmentShape,
                ),
              )
              .having(
                (style) => style.side,
                'side',
                WidgetStatePropertyAll(
                  BorderSide(color: theme.colorScheme.outline),
                ),
              )
              .having(
                (style) => style.fixedSize,
                'fixedSize',
                const WidgetStatePropertyAll(
                  RRulePickerThemeData.defaultSplitSegmentedButtonSegmentSize,
                ),
              )
              .having(
                (style) => style.foregroundColor?.resolve(const {.selected}),
                'selected foregroundColor',
                theme.colorScheme.onSecondaryContainer,
              )
              .having(
                (style) => style.foregroundColor?.resolve(const {}),
                'foregroundColor',
                theme.colorScheme.onSurface,
              )
              .having(
                (style) => style.backgroundColor?.resolve(const {.selected}),
                'selected backgroundColor',
                theme.colorScheme.secondaryContainer,
              )
              .having(
                (style) => style.backgroundColor?.resolve(const {}),
                'backgroundColor',
                Colors.transparent,
              ),
        );
        expect(
          defaults.outlinedContentButtonStyle,
          RRulePickerThemeData.defaultOutlinedContentButtonStyle,
        );
      });

      test('header style uses theme textTheme when available', () {
        final theme = ThemeData(
          textTheme: const .new(
            titleSmall: .new(
              fontSize: 20,
              fontWeight: .normal,
              backgroundColor: Colors.cyan,
            ),
          ),
        );

        final defaults = ResolvedThemeData.defaults(theme);

        expect(
          defaults.headerTheme.style?.fontSize,
          RRulePickerHeaderThemeData.defaultFontSize,
        );
        expect(
          defaults.headerTheme.style?.fontWeight,
          RRulePickerHeaderThemeData.defaultFontWeight,
        );
        expect(defaults.headerTheme.style?.backgroundColor, Colors.cyan);
      });

      test('header style uses fallback '
          'when theme textTheme.titleSmall is null', () {
        final theme = MockThemeData();
        when(() => theme.textTheme).thenReturn(MockTextTheme());
        ColorScheme colorScheme() => theme.colorScheme;
        when(colorScheme).thenReturn(.fromSeed(seedColor: Colors.cyan));

        final defaults = ResolvedThemeData.defaults(theme);

        expect(
          defaults.headerTheme.style,
          RRulePickerHeaderThemeData.fallbackStyle,
        );
      });
    });

    group('resolve', () {
      testWidgets('uses defaults '
          'when no local or global theme', (tester) async {
        late ResolvedThemeData resolved;
        late ResolvedThemeData defaults;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                resolved = .resolve(context);
                defaults = .defaults(Theme.of(context));
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(resolved.padding, defaults.padding);
        expect(resolved.headerTheme, defaults.headerTheme);
        expect(resolved.dropdownTheme, defaults.dropdownTheme);
        expect(resolved.topDropdownTheme, defaults.topDropdownTheme);
        expect(resolved.textFieldTheme, defaults.textFieldTheme);
        expect(resolved.segmentedButtonStyle, defaults.segmentedButtonStyle);
        expect(
          resolved.outlinedContentButtonStyle,
          defaults.outlinedContentButtonStyle,
        );
      });

      testWidgets('uses local theme when provided', (tester) async {
        const padding = EdgeInsets.all(100);
        const theme = RRulePickerThemeData(padding: padding);
        late ResolvedThemeData resolved;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                resolved = .resolve(context, theme);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(resolved.padding, padding);
      });

      testWidgets('uses global theme from $ThemeExtension '
          'when provided', (tester) async {
        const padding = EdgeInsets.all(100);
        const theme = RRulePickerThemeData(padding: padding);
        late ResolvedThemeData resolved;

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(extensions: [theme]),
            home: Builder(
              builder: (context) {
                resolved = .resolve(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(resolved.padding, padding);
      });

      testWidgets('local theme takes precedence '
          'over global theme', (tester) async {
        const localPadding = EdgeInsets.all(100);
        const globalPadding = EdgeInsets.all(200);
        const localTheme = RRulePickerThemeData(padding: localPadding);
        const globalTheme = RRulePickerThemeData(padding: globalPadding);
        late ResolvedThemeData resolved;

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(extensions: [globalTheme]),
            home: Builder(
              builder: (context) {
                resolved = .resolve(context, localTheme);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(resolved.padding, localPadding);
      });

      testWidgets('resolves dropdown theme '
          'with fallback to defaults', (tester) async {
        late ResolvedThemeData resolved;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                resolved = .resolve(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(
          resolved.dropdownTheme.showUnderline,
          RRulePickerDropdownThemeData.defaultShowUnderline,
        );
      });

      testWidgets('resolves topDropdownTheme '
          'with fallback from dropdownTheme', (tester) async {
        late ResolvedThemeData resolved;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                resolved = .resolve(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(
          resolved.topDropdownTheme.showUnderline,
          RRulePickerDropdownThemeData.defaultTopShowUnderline,
        );
        expect(resolved.topDropdownTheme.style, resolved.dropdownTheme.style);
        expect(
          resolved.topDropdownTheme.decoration,
          resolved.dropdownTheme.decoration,
        );
        expect(
          resolved.topDropdownTheme.menuItemStyle,
          resolved.dropdownTheme.decoration,
        );
        expect(
          resolved.topDropdownTheme.menuItemDecoration,
          resolved.dropdownTheme.decoration,
        );
      });

      testWidgets('resolves textFieldTheme '
          'with fallback to defaults', (tester) async {
        late ResolvedThemeData resolved;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                resolved = .resolve(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(resolved.textFieldTheme, isNotNull);
        expect(resolved.textFieldTheme?.style, null);
        expect(resolved.textFieldTheme?.decoration, isNotNull);
      });

      testWidgets('resolves splitSegmentedButtonStyle '
          'with fallback to defaults', (tester) async {
        late ThemeData theme;
        late ResolvedThemeData resolved;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                theme = Theme.of(context);
                resolved = .resolve(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(
          resolved.splitSegmentedButtonStyle?.backgroundColor?.resolve(
            selectedState,
          ),
          theme.colorScheme.secondaryContainer,
        );
      });

      testWidgets('resolves segmentedButtonStyle from global theme', (
        tester,
      ) async {
        const segmentedButtonStyle = ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.red),
        );
        const theme = RRulePickerThemeData(
          segmentedButtonStyle: segmentedButtonStyle,
        );
        late ResolvedThemeData resolved;

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(extensions: [theme]),
            home: Builder(
              builder: (context) {
                resolved = .resolve(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(resolved.segmentedButtonStyle, segmentedButtonStyle);
      });

      testWidgets('resolves labelStyle from local theme', (tester) async {
        const labelStyle = TextStyle(fontSize: 20, color: Colors.blue);
        const theme = RRulePickerThemeData(labelStyle: labelStyle);
        late ResolvedThemeData resolved;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                resolved = .resolve(context, theme);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(resolved.labelStyle, labelStyle);
      });

      testWidgets('resolves headerTheme from global theme', (tester) async {
        const headerTheme = RRulePickerHeaderThemeData(
          showHeader: false,
          style: .new(fontSize: 42),
        );
        const theme = RRulePickerThemeData(headerTheme: headerTheme);
        late ResolvedThemeData resolved;

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(extensions: [theme]),
            home: Builder(
              builder: (context) {
                resolved = .resolve(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(resolved.headerTheme.showHeader, false);
        expect(resolved.headerTheme.style?.fontSize, 42);
      });

      testWidgets('resolves nested theme properties correctly', (tester) async {
        const dropdownDecoration = BoxDecoration(color: Colors.red);
        const menuItemDecoration = BoxDecoration(color: Colors.blue);
        const localTheme = RRulePickerThemeData(
          dropdownTheme: .new(
            decoration: dropdownDecoration,
            menuItemDecoration: menuItemDecoration,
          ),
        );
        late ResolvedThemeData resolved;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                resolved = .resolve(context, localTheme);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(resolved.dropdownTheme.decoration, dropdownDecoration);
        expect(resolved.dropdownTheme.menuItemDecoration, menuItemDecoration);
      });

      testWidgets('resolves topDropdownTheme.decoration '
          'with fallback to dropdownTheme', (tester) async {
        const decoration = BoxDecoration(color: Colors.red);
        const localTheme = RRulePickerThemeData(
          dropdownTheme: .new(decoration: decoration),
        );
        late ResolvedThemeData resolved;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                resolved = .resolve(context, localTheme);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(resolved.topDropdownTheme.decoration, decoration);
      });

      testWidgets('resolves textFieldTheme from local theme', (tester) async {
        const style = TextStyle(fontSize: 40);
        const localTheme = RRulePickerThemeData(
          textFieldTheme: .new(style: style),
        );
        late ResolvedThemeData resolved;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                resolved = .resolve(context, localTheme);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(resolved.textFieldTheme?.style, style);
      });

      testWidgets('resolves splitSegmentedButtonStyle '
          'from local theme', (tester) async {
        const color = WidgetStatePropertyAll(Colors.blue);
        const localTheme = RRulePickerThemeData(
          splitSegmentedButtonStyle: .new(backgroundColor: color),
        );
        late ResolvedThemeData resolved;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                resolved = .resolve(context, localTheme);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(resolved.splitSegmentedButtonStyle?.backgroundColor, color);
      });

      testWidgets('resolves labelStyle from global theme', (tester) async {
        const labelStyle = TextStyle(fontSize: 20, color: Colors.green);
        const globalTheme = RRulePickerThemeData(labelStyle: labelStyle);
        late ResolvedThemeData resolved;

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(extensions: [globalTheme]),
            home: Builder(
              builder: (context) {
                resolved = .resolve(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(resolved.labelStyle, labelStyle);
      });

      testWidgets('resolves outlinedContentButtonStyle '
          'from global theme', (tester) async {
        const outlinedContentButtonStyle = ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.red),
        );
        const theme = RRulePickerThemeData(
          outlinedContentButtonStyle: outlinedContentButtonStyle,
        );
        late ResolvedThemeData resolved;

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(extensions: [theme]),
            home: Builder(
              builder: (context) {
                resolved = .resolve(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(resolved.outlinedContentButtonStyle, outlinedContentButtonStyle);
      });

      testWidgets('resolves outlinedContentButtonStyle '
          'from local theme', (tester) async {
        const outlinedContentButtonStyle = ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.red),
        );
        const theme = RRulePickerThemeData(
          outlinedContentButtonStyle: outlinedContentButtonStyle,
        );
        late ResolvedThemeData resolved;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                resolved = .resolve(context, theme);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(resolved.outlinedContentButtonStyle, outlinedContentButtonStyle);
      });

      testWidgets('local theme takes precedence over global '
          'for nested dropdown properties', (tester) async {
        const localDecoration = BoxDecoration(color: Colors.red);
        const globalDecoration = BoxDecoration(color: Colors.blue);
        const localTheme = RRulePickerThemeData(
          dropdownTheme: .new(decoration: localDecoration),
        );
        const globalTheme = RRulePickerThemeData(
          dropdownTheme: .new(decoration: globalDecoration),
        );
        late ResolvedThemeData resolved;

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(extensions: [globalTheme]),
            home: Builder(
              builder: (context) {
                resolved = .resolve(context, localTheme);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(resolved.dropdownTheme.decoration, localDecoration);
      });
    });

    group('equality operator', () {
      test('returns true for identical instances', () {
        final theme = testResolvedTheme();

        expect(theme == theme, true);
      });

      test('returns true for equal instances', () {
        final themeA = testResolvedTheme();
        final themeB = testResolvedTheme();

        expect(themeA == themeB, true);
      });

      test('returns false when padding differs', () {
        final themeA = testResolvedTheme(padding: const .all(10));
        final themeB = testResolvedTheme(padding: const .all(5));

        expect(themeA == themeB, false);
      });

      test('returns false when labelStyle differs', () {
        final themeA = testResolvedTheme(labelStyle: const .new(fontSize: 16));
        final themeB = testResolvedTheme(labelStyle: const .new(fontSize: 20));

        expect(themeA == themeB, false);
      });

      test('returns false when headerTheme differs', () {
        final themeA = testResolvedTheme(
          headerTheme: const .new(showHeader: true),
        );
        final themeB = testResolvedTheme(
          headerTheme: const .new(showHeader: false),
        );

        expect(themeA == themeB, false);
      });

      test('returns false when dropdownTheme differs', () {
        final themeA = testResolvedTheme(
          dropdownTheme: const .new(showUnderline: true),
        );
        final themeB = testResolvedTheme(
          dropdownTheme: const .new(showUnderline: false),
        );

        expect(themeA == themeB, false);
      });

      test('returns false when topDropdownTheme differs', () {
        final themeA = testResolvedTheme(
          topDropdownTheme: const .new(showUnderline: true),
        );
        final themeB = testResolvedTheme(
          topDropdownTheme: const .new(showUnderline: false),
        );

        expect(themeA == themeB, false);
      });

      test('returns false when textFieldTheme differs', () {
        final themeA = testResolvedTheme(
          textFieldTheme: const .new(decoration: .new()),
        );
        final themeB = testResolvedTheme(
          textFieldTheme: const .new(decoration: .new(fillColor: Colors.red)),
        );

        expect(themeA == themeB, false);
      });

      test('returns false when segmentedButtonStyle differs', () {
        final themeA = testResolvedTheme(segmentedButtonStyle: const .new());
        final themeB = testResolvedTheme(
          segmentedButtonStyle: const .new(
            backgroundColor: WidgetStatePropertyAll(Colors.red),
          ),
        );

        expect(themeA == themeB, false);
      });

      test('returns false when splitSegmentedButtonStyle differs', () {
        final themeA = testResolvedTheme(
          splitSegmentedButtonStyle: const .new(),
        );
        final themeB = testResolvedTheme(
          splitSegmentedButtonStyle: const .new(
            backgroundColor: WidgetStatePropertyAll(Colors.blue),
          ),
        );

        expect(themeA == themeB, false);
      });

      test('returns false when outlinedContentButtonStyle differs', () {
        final themeA = testResolvedTheme(
          outlinedContentButtonStyle: const .new(),
        );
        final themeB = testResolvedTheme(
          outlinedContentButtonStyle: const .new(
            backgroundColor: WidgetStatePropertyAll(Colors.blue),
          ),
        );

        expect(themeA == themeB, false);
      });

      test('returns false when themes are of different type', () {
        final theme = testResolvedTheme();

        expect(theme, isNot(isA<String>()));
        expect(theme, isNot(isA<int>()));
        expect(theme, isNot(isA<RRulePickerThemeData>()));
      });
    });

    group('hashCode', () {
      test('returns consistent value for identical instances', () {
        final theme = testResolvedTheme();

        expect(theme.hashCode, theme.hashCode);
      });

      test('returns same values for equal instances', () {
        final themeA = testResolvedTheme();
        final themeB = testResolvedTheme();

        expect(themeA.hashCode, themeB.hashCode);
      });

      test('returns different values when padding differs', () {
        final theme1 = testResolvedTheme(padding: const .all(8));
        final theme2 = testResolvedTheme(padding: const .all(16));

        expect(theme1.hashCode, isNot(theme2.hashCode));
      });
    });
  });
}

const selectedState = {WidgetState.selected};
const unselectedState = <WidgetState>{};
