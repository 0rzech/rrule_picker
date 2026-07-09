// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rrule_picker/src/shared/resolved_theme.dart';
import 'package:rrule_picker/theme.dart';

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
      const theme = ResolvedThemeData(
        padding: .all(8),
        headerTheme: .new(),
        dropdownTheme: .new(),
        topDropdownTheme: .new(),
      );
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
      const theme1 = ResolvedThemeData(
        padding: .all(8),
        headerTheme: .new(),
        dropdownTheme: .new(),
        topDropdownTheme: .new(),
      );
      const theme2 = ResolvedThemeData(
        padding: .all(16),
        headerTheme: .new(),
        dropdownTheme: .new(),
        topDropdownTheme: .new(),
      );

      const widget1 = ResolvedTheme(theme: theme1, child: SizedBox.shrink());
      const widget2 = ResolvedTheme(theme: theme2, child: SizedBox.shrink());

      expect(widget2.updateShouldNotify(widget1), true);
    });

    test('updateShouldNotify returns false when theme is the same', () {
      const theme = ResolvedThemeData(
        padding: .all(8),
        headerTheme: .new(),
        dropdownTheme: .new(),
        topDropdownTheme: .new(),
      );

      const widget1 = ResolvedTheme(theme: theme, child: SizedBox.shrink());
      const widget2 = ResolvedTheme(theme: theme, child: SizedBox.shrink());

      expect(widget2.updateShouldNotify(widget1), false);
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
        expect(theme.weekdaySelectionButtonStyle, null);
      });

      test('creates instance with all optional parameters', () {
        const labelStyle = TextStyle(fontSize: 16);
        const padding = EdgeInsets.all(8);
        const headerTheme = RRulePickerHeaderThemeData();
        const dropdownTheme = RRulePickerDropdownThemeData();
        const topDropdownTheme = RRulePickerDropdownThemeData();
        const textFieldTheme = RRulePickerTextFieldThemeData();
        const segmentedButtonStyle = ButtonStyle();
        const weekdaySelectionButtonStyle = ButtonStyle();

        const theme = ResolvedThemeData(
          labelStyle: labelStyle,
          padding: padding,
          headerTheme: headerTheme,
          dropdownTheme: dropdownTheme,
          topDropdownTheme: topDropdownTheme,
          textFieldTheme: textFieldTheme,
          segmentedButtonStyle: segmentedButtonStyle,
          weekdaySelectionButtonStyle: weekdaySelectionButtonStyle,
        );

        expect(theme.labelStyle, labelStyle);
        expect(theme.padding, padding);
        expect(theme.headerTheme, headerTheme);
        expect(theme.dropdownTheme, dropdownTheme);
        expect(theme.topDropdownTheme, topDropdownTheme);
        expect(theme.textFieldTheme, textFieldTheme);
        expect(theme.segmentedButtonStyle, segmentedButtonStyle);
        expect(theme.weekdaySelectionButtonStyle, weekdaySelectionButtonStyle);
      });
    });

    group('defaults()', () {
      test('creates default theme with Material ThemeData', () {
        final defaults = ResolvedThemeData.defaults(.new());

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

        final defaults = ResolvedThemeData.defaults(theme);

        expect(
          defaults.headerTheme.style,
          RRulePickerHeaderThemeData.fallbackStyle,
        );
      });
    });

    group('resolve()', () {
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

      testWidgets('uses global theme from ThemeExtension '
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

      testWidgets('resolves weekdaySelectionButtonStyle '
          'with fallback to segmentedButtonStyle', (tester) async {
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
          resolved.weekdaySelectionButtonStyle,
          resolved.segmentedButtonStyle,
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

      testWidgets('resolves weekdaySelectionButtonStyle from local theme', (
        tester,
      ) async {
        const style = ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.blue),
        );
        const localTheme = RRulePickerThemeData(
          weekdaySelectionButtonStyle: style,
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

        expect(resolved.weekdaySelectionButtonStyle, style);
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

    group('equality', () {
      test('equal instances with same properties are equal', () {
        const theme1 = ResolvedThemeData(
          padding: .all(8),
          headerTheme: .new(),
          dropdownTheme: .new(),
          topDropdownTheme: .new(),
        );
        const theme2 = ResolvedThemeData(
          padding: .all(8),
          headerTheme: .new(),
          dropdownTheme: .new(),
          topDropdownTheme: .new(),
        );

        expect(theme1, theme2);
        expect(theme1.hashCode, theme2.hashCode);
      });

      test('instances with different padding are not equal', () {
        const theme1 = ResolvedThemeData(
          padding: .all(8),
          headerTheme: .new(),
          dropdownTheme: .new(),
          topDropdownTheme: .new(),
        );
        const theme2 = ResolvedThemeData(
          padding: .all(16),
          headerTheme: .new(),
          dropdownTheme: .new(),
          topDropdownTheme: .new(),
        );

        expect(theme1, isNot(theme2));
      });

      test('instances with different labelStyle are not equal', () {
        const theme1 = ResolvedThemeData(
          padding: .all(8),
          labelStyle: .new(fontSize: 16),
          headerTheme: .new(),
          dropdownTheme: .new(),
          topDropdownTheme: .new(),
        );
        const theme2 = ResolvedThemeData(
          padding: .all(8),
          labelStyle: .new(fontSize: 20),
          headerTheme: .new(),
          dropdownTheme: .new(),
          topDropdownTheme: .new(),
        );

        expect(theme1, isNot(theme2));
      });

      test('instances with different headerTheme are not equal', () {
        const theme1 = ResolvedThemeData(
          padding: .all(8),
          headerTheme: .new(showHeader: true),
          dropdownTheme: .new(),
          topDropdownTheme: .new(),
        );
        const theme2 = ResolvedThemeData(
          padding: .all(8),
          headerTheme: .new(showHeader: false),
          dropdownTheme: .new(),
          topDropdownTheme: .new(),
        );

        expect(theme1, isNot(theme2));
      });

      test('instances with different dropdownTheme are not equal', () {
        const theme1 = ResolvedThemeData(
          padding: .all(8),
          headerTheme: .new(),
          dropdownTheme: .new(showUnderline: true),
          topDropdownTheme: .new(),
        );
        const theme2 = ResolvedThemeData(
          padding: .all(8),
          headerTheme: .new(),
          dropdownTheme: .new(showUnderline: false),
          topDropdownTheme: .new(),
        );

        expect(theme1, isNot(theme2));
      });

      test('instances with different topDropdownTheme are not equal', () {
        const theme1 = ResolvedThemeData(
          padding: .all(8),
          headerTheme: .new(),
          dropdownTheme: .new(),
          topDropdownTheme: .new(showUnderline: true),
        );
        const theme2 = ResolvedThemeData(
          padding: .all(8),
          headerTheme: .new(),
          dropdownTheme: .new(),
          topDropdownTheme: .new(showUnderline: false),
        );

        expect(theme1, isNot(theme2));
      });

      test('instances with different textFieldTheme are not equal', () {
        const theme1 = ResolvedThemeData(
          padding: .all(8),
          headerTheme: .new(),
          dropdownTheme: .new(),
          topDropdownTheme: .new(),
          textFieldTheme: .new(decoration: .new()),
        );
        const theme2 = ResolvedThemeData(
          padding: .all(8),
          headerTheme: .new(),
          dropdownTheme: .new(),
          topDropdownTheme: .new(),
          textFieldTheme: .new(decoration: .new(fillColor: Colors.red)),
        );

        expect(theme1, isNot(theme2));
      });

      test('instances with different segmentedButtonStyle are not equal', () {
        const theme1 = ResolvedThemeData(
          padding: .all(8),
          headerTheme: .new(),
          dropdownTheme: .new(),
          topDropdownTheme: .new(),
          segmentedButtonStyle: .new(),
        );
        const theme2 = ResolvedThemeData(
          padding: .all(8),
          headerTheme: .new(),
          dropdownTheme: .new(),
          topDropdownTheme: .new(),
          segmentedButtonStyle: .new(
            backgroundColor: WidgetStatePropertyAll(Colors.red),
          ),
        );

        expect(theme1, isNot(theme2));
      });

      test('instances with different weekdaySelectionButtonStyle '
          'are not equal', () {
        const theme1 = ResolvedThemeData(
          padding: .all(8),
          headerTheme: .new(),
          dropdownTheme: .new(),
          topDropdownTheme: .new(),
          weekdaySelectionButtonStyle: .new(),
        );
        const theme2 = ResolvedThemeData(
          padding: .all(8),
          headerTheme: .new(),
          dropdownTheme: .new(),
          topDropdownTheme: .new(),
          weekdaySelectionButtonStyle: .new(
            backgroundColor: WidgetStatePropertyAll(Colors.blue),
          ),
        );

        expect(theme1, isNot(theme2));
      });

      test('same instance is equal to itself', () {
        const theme = ResolvedThemeData(
          padding: .all(8),
          headerTheme: .new(),
          dropdownTheme: .new(),
          topDropdownTheme: .new(),
        );

        expect(theme, theme);
        expect(theme.hashCode, theme.hashCode);
      });

      test('different types are not equal', () {
        const theme = ResolvedThemeData(
          padding: .all(8),
          headerTheme: .new(),
          dropdownTheme: .new(),
          topDropdownTheme: .new(),
        );

        expect(theme, isNot(isA<String>()));
        expect(theme, isNot(isA<int>()));
        expect(theme, isNot(isA<RRulePickerThemeData>()));
      });
    });

    group('hashCode', () {
      test('same properties produce same hashCode', () {
        const theme1 = ResolvedThemeData(
          padding: .all(8),
          headerTheme: .new(),
          dropdownTheme: .new(),
          topDropdownTheme: .new(),
        );
        const theme2 = ResolvedThemeData(
          padding: .all(8),
          headerTheme: .new(),
          dropdownTheme: .new(),
          topDropdownTheme: .new(),
        );

        expect(theme1.hashCode, theme2.hashCode);
      });

      test('different properties produce different hashCode', () {
        const theme1 = ResolvedThemeData(
          padding: .all(8),
          headerTheme: .new(),
          dropdownTheme: .new(),
          topDropdownTheme: .new(),
        );
        const theme2 = ResolvedThemeData(
          padding: .all(16),
          headerTheme: .new(),
          dropdownTheme: .new(),
          topDropdownTheme: .new(),
        );

        expect(theme1.hashCode, isNot(equals(theme2.hashCode)));
      });
    });
  });
}
