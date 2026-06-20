// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rrule_picker/localizations/localizations_en.dart';
import 'package:rrule_picker/src/shared/extensions.dart';
import 'package:rrule_picker/src/shared/parsing.dart';
import 'package:rrule_picker/theme.dart';
import 'package:spot/spot.dart';

void main() {
  group('ByDayOfWeek extension', () {
    final localizations = RRulePickerLocalizationsEn();

    test('rrulePickerDayOfWeekOrdinal '
        'returns correct ordinals for all days', () {
      for (final (ordinal, expected) in const <(DayOfWeekOrdinal, String)>[
        (.first, 'first'),
        (.second, 'second'),
        (.third, 'third'),
        (.fourth, 'fourth'),
        (.last, 'last'),
      ]) {
        for (final day in DayOfWeek.values) {
          expect(
            localizations.rrulePickerDayOfWeekOrdinal(ordinal, day),
            expected,
            reason: 'Input: $ordinal, $day',
          );
        }
      }
    });
  });

  group('ChildDecoration extension', () {
    const dummyWidget = SizedBox.shrink();

    setUpAll(() async {
      if (!kIsWeb) {
        await loadAppFonts();
      }
    });

    group('dropdownDecorators', () {
      testWidgets('returns correct decorators with default theme', (
        tester,
      ) async {
        const theme = RRulePickerDropdownThemeData();
        final decorate = dummyWidget.dropdownDecorators(theme);
        final dropdown = decorate.dropdown(
          DropdownButton<String>(
            items: [.new(child: decorate.dropdownMenuItem(const Text('abc')))],
            onChanged: (_) {},
          ),
        );

        await tester.pumpWrapped(dropdown);

        spot<DropdownButtonHideUnderline>().doesNotExist();
        spot<DropdownButton<String>>()
            .spot<DropdownMenuItem<String>>()
            .spotText('abc', exact: true)
            .existsOnce();
      });

      testWidgets('returns correct decorators with showUnderline=false', (
        tester,
      ) async {
        const theme = RRulePickerDropdownThemeData(showUnderline: false);
        final decorate = dummyWidget.dropdownDecorators(theme);
        final dropdown = decorate.dropdown(
          DropdownButton<String>(
            items: [.new(child: decorate.dropdownMenuItem(const Text('abc')))],
            onChanged: (_) {},
          ),
        );

        await tester.pumpWrapped(dropdown);

        spot<DropdownButtonHideUnderline>()
            .spot<DropdownButton<String>>()
            .spot<DropdownMenuItem<String>>()
            .spotText('abc', exact: true)
            .existsOnce();
      });

      testWidgets('returns correct decorators with decoration', (tester) async {
        const decoration = BoxDecoration(color: Colors.red);
        const theme = RRulePickerDropdownThemeData(decoration: decoration);
        final decorate = dummyWidget.dropdownDecorators(theme);
        final dropdown = decorate.dropdown(
          DropdownButton<String>(
            items: [.new(child: decorate.dropdownMenuItem(const Text('abc')))],
            onChanged: (_) {},
          ),
        );

        await tester.pumpWrapped(dropdown);

        spot<DecoratedBox>()
            .withChild(spot<DropdownButton<String>>())
            .existsOnce()
            .hasWidgetProp(
              prop: widgetProp('decoration', (widget) => widget.decoration),
              match: (value) => value.equals(decoration),
            );
      });

      testWidgets('returns correct decorators with menuItemDecoration', (
        tester,
      ) async {
        const decoration = BoxDecoration(color: Colors.green);
        const theme = RRulePickerDropdownThemeData(
          menuItemDecoration: decoration,
        );
        final decorate = dummyWidget.dropdownDecorators(theme);
        final dropdown = decorate.dropdown(
          DropdownButton<String>(
            items: [.new(child: decorate.dropdownMenuItem(const Text('abc')))],
            onChanged: (_) {},
          ),
        );

        await tester.pumpWrapped(dropdown);

        final button = spot<DropdownButton<String>>();
        spot<DecoratedBox>().withChild(button).doesNotExist();
        button
            .spot<DropdownMenuItem<String>>()
            .spot<DecoratedBox>()
            .withChild(spotText('abc', exact: true))
            .existsOnce()
            .hasWidgetProp(
              prop: widgetProp('decoration', (widget) => widget.decoration),
              match: (value) => value.equals(decoration),
            );
      });

      testWidgets('combines decoration and underline correctly', (
        tester,
      ) async {
        const decoration = BoxDecoration(color: Colors.blue);
        const theme = RRulePickerDropdownThemeData(
          showUnderline: false,
          decoration: decoration,
        );
        final decorate = dummyWidget.dropdownDecorators(theme);
        final dropdown = decorate.dropdown(
          DropdownButton<String>(
            items: [.new(child: decorate.dropdownMenuItem(const Text('abc')))],
            onChanged: (_) {},
          ),
        );

        await tester.pumpWrapped(dropdown);

        spot<DecoratedBox>()
            .withChild(spot<DropdownButtonHideUnderline>())
            .existsOnce()
            .hasWidgetProp(
              prop: widgetProp('decoration', (widget) => widget.decoration),
              match: (value) => value.equals(decoration),
            );
      });

      testWidgets('combines all decorators correctly', (tester) async {
        const decoration = BoxDecoration(color: Colors.yellow);
        const menuItemDecoration = BoxDecoration(color: Colors.purple);
        const theme = RRulePickerDropdownThemeData(
          showUnderline: false,
          decoration: decoration,
          menuItemDecoration: menuItemDecoration,
        );
        final decorate = dummyWidget.dropdownDecorators(theme);
        final dropdown = decorate.dropdown(
          DropdownButton<String>(
            items: [.new(child: decorate.dropdownMenuItem(const Text('abc')))],
            onChanged: (_) {},
          ),
        );

        await tester.pumpWrapped(dropdown);

        final box = spot<DecoratedBox>().withChild(
          spot<DropdownButtonHideUnderline>(),
        );
        box.existsOnce().hasWidgetProp(
          prop: widgetProp('decoration', (widget) => widget.decoration),
          match: (value) => value.equals(decoration),
        );
        box
            .spot<DropdownMenuItem<String>>()
            .spot<DecoratedBox>()
            .withChild(spotText('abc', exact: true))
            .existsOnce()
            .hasWidgetProp(
              prop: widgetProp('decoration', (widget) => widget.decoration),
              match: (value) => value.equals(menuItemDecoration),
            );
      });
    });
  });

  group('DropdownDefaults extension', () {
    group('showUnderlineOrDefault', () {
      test('returns defaultShowUnderline when showUnderline is null', () {
        const theme = RRulePickerDropdownThemeData();
        expect(
          theme.showUnderlineOrDefault,
          RRulePickerDropdownThemeData.defaultShowUnderline,
        );
      });

      test('returns showUnderline value when true', () {
        const theme = RRulePickerDropdownThemeData(showUnderline: true);
        expect(theme.showUnderlineOrDefault, true);
      });

      test('returns showUnderline value when false', () {
        const theme = RRulePickerDropdownThemeData(showUnderline: false);
        expect(theme.showUnderlineOrDefault, false);
      });
    });
  });

  group('HeaderDefaults extension', () {
    group('showHeaderOrDefault', () {
      test('returns defaultShowHeader when showHeader is null', () {
        const theme = RRulePickerHeaderThemeData();
        expect(
          theme.showHeaderOrDefault,
          RRulePickerHeaderThemeData.defaultShowHeader,
        );
      });

      test('returns showHeader value when true', () {
        const theme = RRulePickerHeaderThemeData(showHeader: true);
        expect(theme.showHeaderOrDefault, true);
      });

      test('returns showHeader value when false', () {
        const theme = RRulePickerHeaderThemeData(showHeader: false);
        expect(theme.showHeaderOrDefault, false);
      });
    });
  });
}

extension on WidgetTester {
  Future<void> pumpWrapped(Widget widget) => pumpWidget(
    MaterialApp(
      home: Scaffold(body: Center(child: widget)),
    ),
  );
}
