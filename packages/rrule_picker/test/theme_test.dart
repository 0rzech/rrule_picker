// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rrule_picker/theme.dart';

void main() {
  group(RRulePickerThemeData, () {
    group('constructor', () {
      test('default creates instance with all null fields', () {
        const theme = RRulePickerThemeData();

        expect(theme.labelStyle, null);
        expect(theme.padding, null);
        expect(theme.headerTheme, null);
        expect(theme.dropdownTheme, null);
        expect(theme.topDropdownTheme, null);
        expect(theme.textFieldTheme, null);
        expect(theme.segmentedButtonStyle, null);
        expect(theme.weekdaySelectionButtonStyle, null);
      });

      test('constructor accepts and stores all provided parameters', () {
        const padding = EdgeInsets.all(8);
        const headerTheme = RRulePickerHeaderThemeData(
          showHeader: true,
          style: .new(fontWeight: .bold),
        );
        const dropdownTheme = RRulePickerDropdownThemeData(showUnderline: true);
        const topDropdownTheme = RRulePickerDropdownThemeData(
          showUnderline: false,
        );
        const textFieldTheme = RRulePickerTextFieldThemeData(
          style: .new(color: Colors.black),
        );
        const segmentedButtonStyle = ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.blue),
        );
        const weekdaySelectionButtonStyle = ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.green),
        );

        const theme = RRulePickerThemeData(
          labelStyle: fontSize16,
          padding: padding,
          headerTheme: headerTheme,
          dropdownTheme: dropdownTheme,
          topDropdownTheme: topDropdownTheme,
          textFieldTheme: textFieldTheme,
          segmentedButtonStyle: segmentedButtonStyle,
          weekdaySelectionButtonStyle: weekdaySelectionButtonStyle,
        );

        expect(theme.labelStyle, fontSize16);
        expect(theme.padding, padding);
        expect(theme.headerTheme, headerTheme);
        expect(theme.dropdownTheme, dropdownTheme);
        expect(theme.topDropdownTheme, topDropdownTheme);
        expect(theme.textFieldTheme, textFieldTheme);
        expect(theme.segmentedButtonStyle, segmentedButtonStyle);
        expect(theme.weekdaySelectionButtonStyle, weekdaySelectionButtonStyle);
      });

      test('handles nested null values', () {
        const themeA = RRulePickerThemeData(
          labelStyle: fontSize16,
          headerTheme: null,
          dropdownTheme: null,
        );
        const themeB = RRulePickerThemeData(
          labelStyle: fontSize16,
          headerTheme: null,
          dropdownTheme: null,
        );

        expect(themeA, themeB);
      });
    });

    test('static constants have expected values', () {
      expect(RRulePickerThemeData.defaultPadding, const EdgeInsets.all(0));
      expect(
        RRulePickerThemeData.defaultSegmentedButtonStyle,
        const ButtonStyle(
          visualDensity: .standard,
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: .zero),
          ),
        ),
      );
    });

    group('copyWith', () {
      test('with no arguments returns equal instance', () {
        const theme = RRulePickerThemeData();

        final copied = theme.copyWith();

        expect(copied, theme);
      });

      test('updates each field individually when provided', () {
        const original = RRulePickerThemeData(
          labelStyle: fontSize16,
          padding: .all(8),
        );

        final copied = original.copyWith(labelStyle: fontSize20);

        expect(copied.labelStyle, fontSize20);
        expect(copied.padding, original.padding);
      });

      test('retains existing values for unspecified fields', () {
        const original = RRulePickerThemeData(
          labelStyle: fontSize16,
          padding: .all(8),
          headerTheme: .new(showHeader: true),
        );

        final copied = original.copyWith(labelStyle: fontSize20);

        expect(copied.labelStyle, fontSize20);
        expect(copied.padding, original.padding);
        expect(copied.headerTheme, original.headerTheme);
      });

      test('handles null values correctly (retains original)', () {
        const original = RRulePickerThemeData(
          labelStyle: fontSize16,
          padding: .all(8),
        );

        final copied = original.copyWith(labelStyle: null);

        expect(copied.labelStyle, original.labelStyle);
        expect(copied.padding, original.padding);
      });

      test('creates new instance with all new values', () {
        const original = RRulePickerThemeData(
          labelStyle: fontSize16,
          padding: .all(8),
        );

        const newTheme = RRulePickerThemeData(
          labelStyle: fontSize20,
          padding: .all(16),
        );

        final copied = original.copyWith(
          labelStyle: newTheme.labelStyle,
          padding: newTheme.padding,
        );

        expect(copied.labelStyle, newTheme.labelStyle);
        expect(copied.padding, newTheme.padding);
        expect(copied, isNot(original));
      });

      test('handles all null values', () {
        const original = RRulePickerThemeData(labelStyle: fontSize16);

        final copied = original.copyWith(
          labelStyle: null,
          padding: null,
          headerTheme: null,
          dropdownTheme: null,
          topDropdownTheme: null,
          textFieldTheme: null,
          segmentedButtonStyle: null,
          weekdaySelectionButtonStyle: null,
        );

        expect(copied, original);
      });
    });

    group('lerp', () {
      test('with t=0 returns this (first theme)', () {
        const themeA = RRulePickerThemeData(labelStyle: fontSize16);
        const themeB = RRulePickerThemeData(labelStyle: fontSize20);

        final result = themeA.lerp(themeB, 0);

        expect(result.labelStyle, themeA.labelStyle);
      });

      test('with t=1 returns other (second theme)', () {
        const themeA = RRulePickerThemeData(labelStyle: fontSize16);
        const themeB = RRulePickerThemeData(labelStyle: fontSize20);

        final result = themeA.lerp(themeB, 1);

        expect(result.labelStyle, themeB.labelStyle);
      });

      test('with t=0.5 returns properly interpolated theme', () {
        const themeA = RRulePickerThemeData(padding: .all(8));
        const themeB = RRulePickerThemeData(padding: .all(16));

        final result = themeA.lerp(themeB, 0.5);

        expect(result.padding, const EdgeInsets.all(12));
      });

      test('with identical themes returns the same instance', () {
        const theme = RRulePickerThemeData(labelStyle: fontSize16);

        final result = theme.lerp(theme, 0.5);

        expect(result, theme);
      });

      test('with null other returns this', () {
        const theme = RRulePickerThemeData(labelStyle: fontSize16);

        final result = theme.lerp(null, 0.5);

        expect(result, theme);
      });

      test('with null fields in either theme handles nulls correctly', () {
        const themeA = RRulePickerThemeData(
          labelStyle: fontSize16,
          padding: null,
        );
        const themeB = RRulePickerThemeData(
          labelStyle: null,
          padding: .all(16),
        );

        final result = themeA.lerp(themeB, 0.5);

        expect(result.labelStyle, isNotNull);
        expect(result.padding, isNotNull);
      });

      test('calls appropriate lerp methods on nested theme objects', () {
        const headerThemeA = RRulePickerHeaderThemeData(
          showHeader: true,
          style: fontSize16,
        );
        const headerThemeB = RRulePickerHeaderThemeData(
          showHeader: false,
          style: fontSize20,
        );

        const themeA = RRulePickerThemeData(headerTheme: headerThemeA);
        const themeB = RRulePickerThemeData(headerTheme: headerThemeB);

        final result = themeA.lerp(themeB, 0.5);

        expect(result.headerTheme?.style?.fontSize, 18);
      });

      test('calls Flutter built-in lerp '
          'for TextStyle, EdgeInsetsGeometry, ButtonStyle', () {
        const themeA = RRulePickerThemeData(
          labelStyle: fontSize16,
          padding: .all(8),
          segmentedButtonStyle: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.blue),
          ),
        );
        const themeB = RRulePickerThemeData(
          labelStyle: fontSize20,
          padding: .all(16),
          segmentedButtonStyle: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.red),
          ),
        );

        final result = themeA.lerp(themeB, 0.5);

        expect(result.labelStyle?.fontSize, 18);
        expect(result.padding, const EdgeInsets.all(12));
        expect(
          result.segmentedButtonStyle?.backgroundColor?.resolve({}),
          WidgetStateProperty.lerp<Color?>(
            const WidgetStatePropertyAll(Colors.blue),
            const WidgetStatePropertyAll(Colors.red),
            0.5,
            Color.lerp,
          )?.resolve({}),
        );
      });

      test('handles t values outside [0, 1] range', () {
        const themeA = RRulePickerThemeData(labelStyle: fontSize16);
        const themeB = RRulePickerThemeData(labelStyle: fontSize20);

        final resultBelow = themeA.lerp(themeB, -0.5);
        final resultAbove = themeA.lerp(themeB, 1.5);

        expect(resultBelow, isNotNull);
        expect(resultAbove, isNotNull);
      });

      test('handles t=0.5 and both themes having null for a field', () {
        const themeA = RRulePickerThemeData(labelStyle: null);
        const themeB = RRulePickerThemeData(labelStyle: null);

        final result = themeA.lerp(themeB, 0.5);

        expect(result.labelStyle, null);
      });
    });

    group('equality', () {
      test('returns true for identical instances', () {
        const themeA = RRulePickerThemeData(labelStyle: fontSize16);
        const themeB = RRulePickerThemeData(labelStyle: fontSize16);

        expect(themeA, themeB);
      });

      test('returns false for different instances', () {
        const themeA = RRulePickerThemeData(labelStyle: fontSize16);
        const themeB = RRulePickerThemeData(labelStyle: fontSize20);

        expect(themeA, isNot(themeB));
      });

      test('returns true when all fields are equal', () {
        const themeA = RRulePickerThemeData(
          labelStyle: fontSize16,
          padding: .all(8),
        );
        const themeB = RRulePickerThemeData(
          labelStyle: fontSize16,
          padding: .all(8),
        );

        expect(themeA, themeB);
      });

      test('returns false when any field differs', () {
        const themeA = RRulePickerThemeData(
          labelStyle: fontSize16,
          padding: .all(8),
        );
        const themeB = RRulePickerThemeData(
          labelStyle: fontSize16,
          padding: .all(16),
        );

        expect(themeA, isNot(themeB));
      });

      test('handles null comparisons correctly', () {
        const themeA = RRulePickerThemeData(labelStyle: fontSize16);
        const RRulePickerThemeData? themeB = null;

        expect(themeA == themeB, false);
        expect(themeB == themeA, false);
      });
    });

    group('hashCode', () {
      test('returns consistent value for same instance', () {
        const theme = RRulePickerThemeData(labelStyle: fontSize16);

        final hashA = theme.hashCode;
        final hashB = theme.hashCode;

        expect(hashA, hashB);
      });

      test('returns same value for equal instances', () {
        const themeA = RRulePickerThemeData(
          labelStyle: fontSize16,
          padding: .all(8),
        );
        const themeB = RRulePickerThemeData(
          labelStyle: fontSize16,
          padding: .all(8),
        );

        expect(themeA.hashCode, themeB.hashCode);
      });

      test('returns different value for different instances', () {
        const themeA = RRulePickerThemeData(labelStyle: fontSize16);
        const themeB = RRulePickerThemeData(labelStyle: fontSize20);

        expect(themeA.hashCode, isNot(themeB.hashCode));
      });

      test('returns same values for themes containing all null values', () {
        const themeA = RRulePickerThemeData();
        const themeB = RRulePickerThemeData();

        expect(themeA.hashCode, themeB.hashCode);
      });
    });
  });

  group(RRulePickerHeaderThemeData, () {
    group('constructor', () {
      test('default creates instance with all null fields', () {
        const theme = RRulePickerHeaderThemeData();

        expect(theme.showHeader, null);
        expect(theme.style, null);
      });

      test('accepts and stores showHeader and style correctly', () {
        const theme = RRulePickerHeaderThemeData(
          showHeader: true,
          style: .new(fontSize: 16, fontWeight: .bold),
        );

        expect(theme.showHeader, true);
        expect(theme.style, const TextStyle(fontSize: 16, fontWeight: .bold));
      });
    });

    test('static constants have expected values', () {
      expect(RRulePickerHeaderThemeData.defaultShowHeader, true);
      expect(RRulePickerHeaderThemeData.defaultFontSize, 16.0);
      expect(RRulePickerHeaderThemeData.defaultFontWeight, FontWeight.bold);
      expect(
        RRulePickerHeaderThemeData.fallbackStyle,
        const TextStyle(fontSize: 16.0, fontWeight: .bold),
      );
    });

    group('copyWith', () {
      test('with no arguments returns equal instance', () {
        const theme = RRulePickerHeaderThemeData();

        final copied = theme.copyWith();

        expect(copied, theme);
      });

      test('updates showHeader when provided', () {
        const original = RRulePickerHeaderThemeData(
          showHeader: true,
          style: fontSize16,
        );

        final copied = original.copyWith(showHeader: false);

        expect(copied.showHeader, false);
        expect(copied.style, original.style);
      });

      test('updates style when provided', () {
        const original = RRulePickerHeaderThemeData(
          showHeader: true,
          style: fontSize16,
        );

        final copied = original.copyWith(style: fontSize20);

        expect(copied.style, fontSize20);
        expect(copied.showHeader, original.showHeader);
      });

      test('retains existing values for unspecified fields', () {
        const original = RRulePickerHeaderThemeData(
          showHeader: true,
          style: fontSize16,
        );

        final copied = original.copyWith(style: fontSize20);

        expect(copied.showHeader, original.showHeader);
        expect(copied.style, isNot(original.style));
      });

      test('handles null values correctly', () {
        const original = RRulePickerHeaderThemeData(
          showHeader: true,
          style: fontSize16,
        );

        final copied = original.copyWith(showHeader: null, style: null);

        expect(copied.showHeader, original.showHeader);
        expect(copied.style, original.style);
      });
    });

    group('lerp', () {
      test('with t=0 returns first theme (a)', () {
        const themeA = RRulePickerHeaderThemeData(
          showHeader: true,
          style: fontSize16,
        );
        const themeB = RRulePickerHeaderThemeData(
          showHeader: false,
          style: fontSize20,
        );

        final result = RRulePickerHeaderThemeData.lerp(themeA, themeB, 0);

        expect(result?.showHeader, themeA.showHeader);
      });

      test('with t=1 returns second theme (b)', () {
        const themeA = RRulePickerHeaderThemeData(
          showHeader: true,
          style: fontSize16,
        );
        const themeB = RRulePickerHeaderThemeData(
          showHeader: false,
          style: fontSize20,
        );

        final result = RRulePickerHeaderThemeData.lerp(themeA, themeB, 1);

        expect(result?.showHeader, themeB.showHeader);
      });

      test('with t=0.5 uses threshold logic for boolean showHeader', () {
        const themeA = RRulePickerHeaderThemeData(showHeader: true);
        const themeB = RRulePickerHeaderThemeData(showHeader: false);

        final resultBelow = RRulePickerHeaderThemeData.lerp(
          themeA,
          themeB,
          0.4,
        );
        final resultAbove = RRulePickerHeaderThemeData.lerp(
          themeA,
          themeB,
          0.6,
        );

        expect(resultBelow?.showHeader, themeA.showHeader);
        expect(resultAbove?.showHeader, themeB.showHeader);
      });

      test('calls TextStyle.lerp for style fields', () {
        const themeA = RRulePickerHeaderThemeData(style: fontSize16);
        const themeB = RRulePickerHeaderThemeData(style: fontSize20);

        final result = RRulePickerHeaderThemeData.lerp(themeA, themeB, 0.5);

        expect(result?.style?.fontSize, 18.0);
      });

      test('with identical themes returns the same instance', () {
        const theme = RRulePickerHeaderThemeData(
          showHeader: true,
          style: fontSize16,
        );

        final result = RRulePickerHeaderThemeData.lerp(theme, theme, 0.5);

        expect(identical(result, theme), true);
      });

      test('with both nulls returns null', () {
        final result = RRulePickerHeaderThemeData.lerp(null, null, 0.5);

        expect(result, null);
      });

      test('lerp with one null theme handles correctly', () {
        const theme = RRulePickerHeaderThemeData(
          showHeader: true,
          style: fontSize16,
        );

        final resultA = RRulePickerHeaderThemeData.lerp(theme, null, 0.5);
        final resultB = RRulePickerHeaderThemeData.lerp(null, theme, 0.5);

        expect(resultA, isNotNull);
        expect(resultB, isNotNull);
      });
    });

    group('equality', () {
      test('Equals operator returns true for identical instances', () {
        const themeA = RRulePickerHeaderThemeData(
          showHeader: false,
          style: fontSize16,
        );
        const themeB = RRulePickerHeaderThemeData(
          showHeader: false,
          style: fontSize16,
        );

        expect(themeA, themeB);
      });

      test('Equals operator returns false for different instances', () {
        const themeA = RRulePickerHeaderThemeData(
          showHeader: true,
          style: fontSize16,
        );
        const themeB = RRulePickerHeaderThemeData(
          showHeader: false,
          style: fontSize20,
        );

        expect(themeA, isNot(themeB));
      });

      test('Equals operator returns true '
          'when showHeader and style are equal', () {
        const themeA = RRulePickerHeaderThemeData(
          showHeader: true,
          style: fontSize16,
        );
        const themeB = RRulePickerHeaderThemeData(
          showHeader: true,
          style: fontSize16,
        );

        expect(themeA, themeB);
      });

      test('Equals operator returns false when showHeader differs', () {
        const themeA = RRulePickerHeaderThemeData(
          showHeader: true,
          style: fontSize16,
        );
        const themeB = RRulePickerHeaderThemeData(
          showHeader: false,
          style: fontSize16,
        );

        expect(themeA, isNot(themeB));
      });

      test('Equals operator returns false when style differs', () {
        const themeA = RRulePickerHeaderThemeData(
          showHeader: true,
          style: fontSize16,
        );
        const themeB = RRulePickerHeaderThemeData(
          showHeader: true,
          style: fontSize20,
        );

        expect(themeA, isNot(themeB));
      });
    });

    group('hashCode', () {
      test('hashCode returns consistent value for same instance', () {
        const theme = RRulePickerHeaderThemeData(
          showHeader: true,
          style: fontSize16,
        );

        final hashA = theme.hashCode;
        final hashB = theme.hashCode;

        expect(hashA, hashB);
      });

      test('hashCode returns same value for equal instances', () {
        const themeA = RRulePickerHeaderThemeData(
          showHeader: true,
          style: fontSize16,
        );
        const themeB = RRulePickerHeaderThemeData(
          showHeader: true,
          style: fontSize16,
        );

        expect(themeA.hashCode, themeB.hashCode);
      });

      test('hashCode returns different value for different instances', () {
        const themeA = RRulePickerHeaderThemeData(
          showHeader: true,
          style: fontSize16,
        );
        const themeB = RRulePickerHeaderThemeData(
          showHeader: false,
          style: fontSize20,
        );

        expect(themeA.hashCode, isNot(themeB.hashCode));
      });
    });
  });

  group(RRulePickerDropdownThemeData, () {
    group('constructor', () {
      test('Default constructor creates instance with all null fields', () {
        const theme = RRulePickerDropdownThemeData();

        expect(theme.showUnderline, null);
        expect(theme.style, null);
        expect(theme.decoration, null);
        expect(theme.menuItemStyle, null);
        expect(theme.menuItemDecoration, null);
      });

      test('Constructor accepts and stores all fields correctly', () {
        const theme = RRulePickerDropdownThemeData(
          showUnderline: true,
          style: fontSize16,
          decoration: .new(color: Colors.blue),
          menuItemStyle: .new(fontSize: 14),
          menuItemDecoration: .new(color: Colors.green),
        );

        expect(theme.showUnderline, true);
        expect(theme.style, fontSize16);
        expect(theme.decoration, const BoxDecoration(color: Colors.blue));
        expect(theme.menuItemStyle, const TextStyle(fontSize: 14));
        expect(
          theme.menuItemDecoration,
          const BoxDecoration(color: Colors.green),
        );
      });

      test('Static constants have expected values', () {
        expect(RRulePickerDropdownThemeData.defaultShowUnderline, true);
        expect(RRulePickerDropdownThemeData.defaultTopShowUnderline, false);
      });
    });

    group('copyWith', () {
      test('copyWith with no arguments returns identical instance', () {
        const theme = RRulePickerDropdownThemeData(
          showUnderline: true,
          style: fontSize16,
        );
        final copied = theme.copyWith();
        expect(copied, theme);
      });

      test('copyWith updates each field individually when provided', () {
        const original = RRulePickerDropdownThemeData(
          showUnderline: true,
          style: fontSize16,
          decoration: .new(color: Colors.blue),
        );
        final copied = original.copyWith(showUnderline: false);

        expect(copied.showUnderline, false);
        expect(copied.style, original.style);
        expect(copied.decoration, original.decoration);
      });

      test('copyWith retains existing values for unspecified fields', () {
        const original = RRulePickerDropdownThemeData(
          showUnderline: true,
          style: fontSize16,
          decoration: .new(color: Colors.blue),
        );
        final copied = original.copyWith(style: fontSize20);

        expect(copied.showUnderline, original.showUnderline);
        expect(copied.style, isNot(original.style));
        expect(copied.decoration, original.decoration);
      });

      test('copyWith handles null values correctly', () {
        const original = RRulePickerDropdownThemeData(
          showUnderline: true,
          style: fontSize16,
        );
        final copied = original.copyWith(showUnderline: null, style: null);

        expect(copied.showUnderline, original.showUnderline);
        expect(copied.style, original.style);
      });
    });

    group('lerp', () {
      test('lerp with t=0 returns first theme (a)', () {
        const themeA = RRulePickerDropdownThemeData(
          showUnderline: true,
          style: fontSize16,
        );
        const themeB = RRulePickerDropdownThemeData(
          showUnderline: false,
          style: fontSize20,
        );

        final result = RRulePickerDropdownThemeData.lerp(themeA, themeB, 0);

        expect(result?.showUnderline, themeA.showUnderline);
      });

      test('lerp with t=1 returns second theme (b)', () {
        const themeA = RRulePickerDropdownThemeData(
          showUnderline: true,
          style: fontSize16,
        );
        const themeB = RRulePickerDropdownThemeData(
          showUnderline: false,
          style: fontSize20,
        );

        final result = RRulePickerDropdownThemeData.lerp(themeA, themeB, 1);

        expect(result?.showUnderline, themeB.showUnderline);
      });

      test(
        'lerp with t=0.5 uses threshold logic for boolean showUnderline',
        () {
          const themeA = RRulePickerDropdownThemeData(showUnderline: true);
          const themeB = RRulePickerDropdownThemeData(showUnderline: false);

          final resultBelow = RRulePickerDropdownThemeData.lerp(
            themeA,
            themeB,
            0.4,
          );
          final resultAbove = RRulePickerDropdownThemeData.lerp(
            themeA,
            themeB,
            0.6,
          );

          expect(resultBelow?.showUnderline, themeA.showUnderline);
          expect(resultAbove?.showUnderline, themeB.showUnderline);
        },
      );

      test('lerp calls .new.lerp for style fields', () {
        const themeA = RRulePickerDropdownThemeData(style: fontSize16);
        const themeB = RRulePickerDropdownThemeData(style: fontSize20);

        final result = RRulePickerDropdownThemeData.lerp(themeA, themeB, 0.5);

        expect(result?.style?.fontSize, 18.0);
      });

      test('lerp calls BoxDecoration.lerp for decoration fields', () {
        const themeA = RRulePickerDropdownThemeData(
          decoration: .new(color: Colors.blue),
        );
        const themeB = RRulePickerDropdownThemeData(
          decoration: .new(color: Colors.red),
        );

        final result = RRulePickerDropdownThemeData.lerp(themeA, themeB, 0.5);

        expect(result?.decoration, isNotNull);
      });

      test('lerp with identical themes returns the same instance', () {
        const theme = RRulePickerDropdownThemeData(
          showUnderline: true,
          style: fontSize16,
        );

        final result = RRulePickerDropdownThemeData.lerp(theme, theme, 0.5);

        expect(result, theme);
      });

      test('lerp with both null returns null', () {
        final result = RRulePickerDropdownThemeData.lerp(null, null, 0.5);

        expect(result, null);
      });

      test('lerp with one null theme handles correctly', () {
        const theme = RRulePickerDropdownThemeData(
          showUnderline: true,
          style: fontSize16,
        );

        final resultA = RRulePickerDropdownThemeData.lerp(theme, null, 0.5);
        final resultB = RRulePickerDropdownThemeData.lerp(null, theme, 0.5);

        expect(resultA, isNotNull);
        expect(resultB, isNotNull);
      });
    });

    group('equality', () {
      test('Equals operator returns true for identical instances', () {
        const themeA = RRulePickerDropdownThemeData(
          showUnderline: true,
          style: fontSize16,
        );
        const themeB = RRulePickerDropdownThemeData(
          showUnderline: true,
          style: fontSize16,
        );

        expect(themeA, themeB);
      });

      test('Equals operator returns false for different instances', () {
        const themeA = RRulePickerDropdownThemeData(
          showUnderline: true,
          style: fontSize16,
        );
        const themeB = RRulePickerDropdownThemeData(
          showUnderline: false,
          style: fontSize20,
        );

        expect(themeA, isNot(themeB));
      });

      test('Equals operator returns true when all fields are equal', () {
        const themeA = RRulePickerDropdownThemeData(
          showUnderline: true,
          style: fontSize16,
          decoration: .new(color: Colors.blue),
        );
        const themeB = RRulePickerDropdownThemeData(
          showUnderline: true,
          style: fontSize16,
          decoration: .new(color: Colors.blue),
        );

        expect(themeA, themeB);
      });

      test('Equals operator returns false when any field differs', () {
        const themeA = RRulePickerDropdownThemeData(
          showUnderline: true,
          style: fontSize16,
        );
        const themeB = RRulePickerDropdownThemeData(
          showUnderline: false,
          style: fontSize16,
        );

        expect(themeA, isNot(themeB));
      });
    });

    group('hashCode', () {
      test('hashCode returns consistent value for same instance', () {
        const theme = RRulePickerDropdownThemeData(
          showUnderline: true,
          style: fontSize16,
        );

        final hashA = theme.hashCode;
        final hashB = theme.hashCode;

        expect(hashA, hashB);
      });

      test('hashCode returns same value for equal instances', () {
        const themeA = RRulePickerDropdownThemeData(
          showUnderline: true,
          style: fontSize16,
        );
        const themeB = RRulePickerDropdownThemeData(
          showUnderline: true,
          style: fontSize16,
        );

        expect(themeA.hashCode, themeB.hashCode);
      });

      test('hashCode returns different value for different instances', () {
        const themeA = RRulePickerDropdownThemeData(
          showUnderline: true,
          style: fontSize16,
        );
        const themeB = RRulePickerDropdownThemeData(
          showUnderline: false,
          style: fontSize20,
        );

        expect(themeA.hashCode, isNot(themeB.hashCode));
      });
    });
  });

  group(RRulePickerTextFieldThemeData, () {
    group('constructor', () {
      test('Default constructor creates instance with all null fields', () {
        const theme = RRulePickerTextFieldThemeData();

        expect(theme.style, null);
        expect(theme.decoration, null);
      });

      test('Constructor accepts and stores style and decoration correctly', () {
        const decoration = InputDecoration(
          isDense: true,
          hintText: 'Enter text',
        );
        const theme = RRulePickerTextFieldThemeData(
          style: fontSize16,
          decoration: decoration,
        );

        expect(theme.style, fontSize16);
        expect(theme.decoration, decoration);
      });

      test('Static constant defaultDecoration has expected value', () {
        expect(
          RRulePickerTextFieldThemeData.defaultDecoration,
          const InputDecoration(isDense: true),
        );
      });
    });

    group('copyWith', () {
      test('copyWith with no arguments returns identical instance', () {
        const theme = RRulePickerTextFieldThemeData(style: fontSize16);
        final copied = theme.copyWith();
        expect(copied, theme);
      });

      test('copyWith updates style when provided', () {
        const original = RRulePickerTextFieldThemeData(
          style: fontSize16,
          decoration: .new(isDense: true),
        );
        final copied = original.copyWith(style: fontSize20);

        expect(copied.style, fontSize20);
        expect(copied.decoration, original.decoration);
      });

      test('copyWith updates decoration when provided', () {
        const original = RRulePickerTextFieldThemeData(
          style: fontSize16,
          decoration: .new(isDense: true),
        );
        const newDecoration = InputDecoration(isDense: false);
        final copied = original.copyWith(decoration: newDecoration);

        expect(copied.decoration, newDecoration);
        expect(copied.style, original.style);
      });

      test('copyWith retains existing values for unspecified fields', () {
        const original = RRulePickerTextFieldThemeData(
          style: fontSize16,
          decoration: .new(isDense: true),
        );
        final copied = original.copyWith(style: fontSize20);

        expect(copied.style, isNot(original.style));
        expect(copied.decoration, original.decoration);
      });

      test('copyWith handles null values correctly', () {
        const original = RRulePickerTextFieldThemeData(
          style: fontSize16,
          decoration: .new(isDense: true),
        );
        final copied = original.copyWith(style: null, decoration: null);

        expect(copied.style, original.style);
        expect(copied.decoration, original.decoration);
      });
    });

    group('lerp', () {
      test('lerp with t=0 returns first theme (a)', () {
        const themeA = RRulePickerTextFieldThemeData(style: fontSize16);
        const themeB = RRulePickerTextFieldThemeData(style: fontSize20);

        final result = RRulePickerTextFieldThemeData.lerp(themeA, themeB, 0);

        expect(result?.style?.fontSize, 16.0);
      });

      test('lerp with t=1 returns second theme (b)', () {
        const themeA = RRulePickerTextFieldThemeData(style: fontSize16);
        const themeB = RRulePickerTextFieldThemeData(style: fontSize20);

        final result = RRulePickerTextFieldThemeData.lerp(themeA, themeB, 1);

        expect(result?.style?.fontSize, 20.0);
      });

      test('lerp with t=0.5 uses threshold logic for InputDecoration', () {
        const themeA = RRulePickerTextFieldThemeData(
          decoration: .new(isDense: true),
        );
        const themeB = RRulePickerTextFieldThemeData(
          decoration: .new(isDense: false),
        );

        final resultBelow = RRulePickerTextFieldThemeData.lerp(
          themeA,
          themeB,
          0.4,
        );
        final resultAbove = RRulePickerTextFieldThemeData.lerp(
          themeA,
          themeB,
          0.6,
        );

        expect(resultBelow?.decoration, themeA.decoration);
        expect(resultAbove?.decoration, themeB.decoration);
      });

      test('lerp calls .new.lerp for style fields', () {
        const themeA = RRulePickerTextFieldThemeData(style: fontSize16);
        const themeB = RRulePickerTextFieldThemeData(style: fontSize20);

        final result = RRulePickerTextFieldThemeData.lerp(themeA, themeB, 0.5);

        expect(result?.style?.fontSize, 18.0);
      });

      test('lerp with identical themes returns the same instance', () {
        const theme = RRulePickerTextFieldThemeData(style: fontSize16);

        final result = RRulePickerTextFieldThemeData.lerp(theme, theme, 0.5);

        expect(result, theme);
      });

      test('lerp with both null returns null', () {
        final result = RRulePickerTextFieldThemeData.lerp(null, null, 0.5);

        expect(result, null);
      });

      test('lerp with one null theme handles correctly', () {
        const theme = RRulePickerTextFieldThemeData(style: fontSize16);

        final resultA = RRulePickerTextFieldThemeData.lerp(theme, null, 0.5);
        final resultB = RRulePickerTextFieldThemeData.lerp(null, theme, 0.5);

        expect(resultA, isNotNull);
        expect(resultB, isNotNull);
      });
    });

    group('equality', () {
      test('returns true for identical instances', () {
        const themeA = RRulePickerTextFieldThemeData(style: fontSize16);
        const themeB = RRulePickerTextFieldThemeData(style: fontSize16);

        expect(themeA, themeB);
      });

      test('returns false for different instances', () {
        const themeA = RRulePickerTextFieldThemeData(style: fontSize16);
        const themeB = RRulePickerTextFieldThemeData(style: fontSize20);

        expect(themeA, isNot(themeB));
      });

      test('returns true when style and decoration are equal', () {
        const decoration = InputDecoration(isDense: true);
        const themeA = RRulePickerTextFieldThemeData(
          style: fontSize16,
          decoration: decoration,
        );
        const themeB = RRulePickerTextFieldThemeData(
          style: fontSize16,
          decoration: decoration,
        );

        expect(themeA, themeB);
      });

      test('returns false when style differs', () {
        const themeA = RRulePickerTextFieldThemeData(
          style: fontSize16,
          decoration: .new(isDense: true),
        );
        const themeB = RRulePickerTextFieldThemeData(
          style: fontSize20,
          decoration: .new(isDense: true),
        );

        expect(themeA, isNot(themeB));
      });

      test('returns false when decoration differs', () {
        const themeA = RRulePickerTextFieldThemeData(
          style: fontSize16,
          decoration: .new(isDense: true),
        );
        const themeB = RRulePickerTextFieldThemeData(
          style: fontSize16,
          decoration: .new(isDense: false),
        );

        expect(themeA, isNot(themeB));
      });
    });

    group('hashCode', () {
      test('returns consistent value for same instance', () {
        const theme = RRulePickerTextFieldThemeData(style: fontSize16);

        final hashA = theme.hashCode;
        final hashB = theme.hashCode;

        expect(hashA, hashB);
      });

      test('returns same value for equal instances', () {
        const themeA = RRulePickerTextFieldThemeData(style: fontSize16);
        const themeB = RRulePickerTextFieldThemeData(style: fontSize16);

        expect(themeA.hashCode, themeB.hashCode);
      });

      test('returns different value for different instances', () {
        const themeA = RRulePickerTextFieldThemeData(style: fontSize16);
        const themeB = RRulePickerTextFieldThemeData(style: fontSize20);

        expect(themeA.hashCode, isNot(themeB.hashCode));
      });
    });
  });
}

const fontSize16 = TextStyle(fontSize: 16);
const fontSize20 = TextStyle(fontSize: 20);
