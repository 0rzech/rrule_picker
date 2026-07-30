// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kiri_check/kiri_check.dart';
import 'package:rrule_picker/theme.dart';
import 'package:rrule_picker/widget.dart';

void main() {
  group(RRulePickerThemeData, () {
    group('constructor', () {
      test('default creates instance with all null fields', () {
        const theme = RRulePickerThemeData();

        expect(theme.labelStyle, null);
        expect(theme.padding, null);
        expect(theme.spacing, null);
        expect(theme.headerTheme, null);
        expect(theme.dropdownTheme, null);
        expect(theme.topDropdownTheme, null);
        expect(theme.textFieldTheme, null);
        expect(theme.segmentedButtonStyle, null);
        expect(theme.splitSegmentedButtonStyle, null);
        expect(theme.outlinedContentButtonStyle, null);
      });

      test('constructor accepts and stores all provided parameters', () {
        const padding = EdgeInsets.all(16);
        const spacing = RRulePickerSpacing(row: 5, column: 10);
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
        const splitSegmentedButtonStyle = ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.green),
        );
        const outlinedContentButtonStyle = ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.red),
        );

        const theme = RRulePickerThemeData(
          labelStyle: fontSize16,
          padding: padding,
          spacing: spacing,
          headerTheme: headerTheme,
          dropdownTheme: dropdownTheme,
          topDropdownTheme: topDropdownTheme,
          textFieldTheme: textFieldTheme,
          segmentedButtonStyle: segmentedButtonStyle,
          splitSegmentedButtonStyle: splitSegmentedButtonStyle,
          outlinedContentButtonStyle: outlinedContentButtonStyle,
        );

        expect(theme.labelStyle, fontSize16);
        expect(theme.padding, padding);
        expect(theme.spacing, spacing);
        expect(theme.headerTheme, headerTheme);
        expect(theme.dropdownTheme, dropdownTheme);
        expect(theme.topDropdownTheme, topDropdownTheme);
        expect(theme.textFieldTheme, textFieldTheme);
        expect(theme.segmentedButtonStyle, segmentedButtonStyle);
        expect(theme.splitSegmentedButtonStyle, splitSegmentedButtonStyle);
        expect(theme.outlinedContentButtonStyle, outlinedContentButtonStyle);
      });
    });

    test('static constants have expected values', () {
      expect(RRulePickerThemeData.defaultPadding, EdgeInsets.zero);
      expect(
        RRulePickerThemeData.defaultSpacing,
        const RRulePickerSpacing.defaults(),
      );
      expect(
        RRulePickerThemeData.defaultSegmentedButtonStyle,
        const ButtonStyle(visualDensity: .standard),
      );
      expect(
        RRulePickerThemeData.defaultOutlinedContentButtonStyle,
        const ButtonStyle(visualDensity: .standard),
      );
      expect(
        RRulePickerThemeData.defaultSplitSegmentedButtonSegmentShape,
        const StadiumBorder(),
      );
      expect(
        RRulePickerThemeData.defaultSplitSegmentedButtonSegmentSize,
        const Size(80, 40),
      );
    });

    group('copyWith', () {
      test('with no arguments returns equal instance', () {
        final theme = testTheme();

        final copied = theme.copyWith();

        expect(copied, theme);
      });

      test('updates each field individually when provided', () {
        final original = testTheme(labelStyle: fontSize16);

        final copied = original.copyWith(labelStyle: fontSize20);

        expect(copied.labelStyle, fontSize20);
        expect(copied.padding, original.padding);
      });

      test('retains existing values for unspecified fields', () {
        final original = testTheme(
          labelStyle: fontSize16,
          headerTheme: const .new(showHeader: true),
        );

        final copied = original.copyWith(labelStyle: fontSize20);

        expect(copied.labelStyle, fontSize20);
        expect(copied.padding, original.padding);
        expect(copied.headerTheme, original.headerTheme);
      });

      test('handles null values correctly (retains original)', () {
        final original = testTheme(labelStyle: fontSize16);

        final copied = original.copyWith(labelStyle: null);

        expect(copied.labelStyle, original.labelStyle);
        expect(copied.padding, original.padding);
      });

      test('creates new instance with all new values', () {
        final original = testTheme(labelStyle: fontSize16);

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
        final original = testTheme(labelStyle: fontSize16);

        final copied = original.copyWith();

        expect(copied, original);
        expect(identical(original, copied), false);
      });
    });

    group('lerp', () {
      test('with t=0 returns this (first theme)', () {
        final themeA = testTheme(labelStyle: fontSize16);
        final themeB = testTheme(labelStyle: fontSize20);

        final result = themeA.lerp(themeB, 0);

        expect(result.labelStyle, themeA.labelStyle);
      });

      test('with t=1 returns other (second theme)', () {
        final themeA = testTheme(labelStyle: fontSize16);
        final themeB = testTheme(labelStyle: fontSize20);

        final result = themeA.lerp(themeB, 1);

        expect(result.labelStyle, themeB.labelStyle);
      });

      test('with t=0.5 returns properly interpolated theme', () {
        final themeA = testTheme();
        final themeB = testTheme(padding: const .all(16));

        final result = themeA.lerp(themeB, 0.5);

        expect(result.padding, const EdgeInsets.all(12));
      });

      test('with identical themes returns the same instance', () {
        final theme = testTheme(labelStyle: fontSize16);

        final result = theme.lerp(theme, 0.5);

        expect(result, theme);
      });

      test('with null other returns this', () {
        final theme = testTheme(labelStyle: fontSize16);

        final result = theme.lerp(null, 0.5);

        expect(result, theme);
      });

      test('with null fields in either theme handles nulls correctly', () {
        final themeA = testTheme(labelStyle: fontSize16, padding: null);
        final themeB = testTheme(labelStyle: null, padding: const .all(16));

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

        final themeA = testTheme(headerTheme: headerThemeA);
        final themeB = testTheme(headerTheme: headerThemeB);

        final result = themeA.lerp(themeB, 0.5);

        expect(result.headerTheme?.style?.fontSize, 18);
      });

      test('calls lerp for labelStyle and segmentedButtonStyle', () {
        final themeA = testTheme(
          labelStyle: fontSize16,
          segmentedButtonStyle: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.blue),
          ),
        );
        final themeB = testTheme(
          labelStyle: fontSize20,
          padding: const .all(16),
          segmentedButtonStyle: const ButtonStyle(
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
        final themeA = testTheme(labelStyle: fontSize16);
        final themeB = testTheme(labelStyle: fontSize20);

        final resultBelow = themeA.lerp(themeB, -0.5);
        final resultAbove = themeA.lerp(themeB, 1.5);

        expect(resultBelow, isNotNull);
        expect(resultAbove, isNotNull);
      });

      test('handles t=0.5 and both themes having null for a field', () {
        final themeA = testTheme(labelStyle: null);
        final themeB = testTheme(labelStyle: null);

        final result = themeA.lerp(themeB, 0.5);

        expect(result.labelStyle, null);
      });
    });

    group('equality operator', () {
      test('returns true for identical instances', () {
        final theme = testTheme();

        expect(theme == theme, true);
      });

      test('returns true for equal instances', () {
        final themeA = testTheme(labelStyle: fontSize16);
        final themeB = testTheme(labelStyle: fontSize16);

        expect(themeA == themeB, true);
      });

      test('returns false when labelStyle differs', () {
        final themeA = testTheme(labelStyle: fontSize16);
        final themeB = testTheme(labelStyle: fontSize20);

        expect(themeA == themeB, false);
      });

      test('returns false when padding differs', () {
        final themeA = testTheme();
        final themeB = testTheme(padding: const .all(16));

        expect(themeA == themeB, false);
      });

      test('returns false when spacing differs', () {
        final themeA = testTheme();
        final themeB = testTheme(spacing: const .defaults(row: 10));

        expect(themeA == themeB, false);
      });

      test('returns false when headerTheme differs', () {
        final themeA = testTheme(headerTheme: const .new(showHeader: true));
        final themeB = testTheme(headerTheme: const .new(showHeader: false));

        expect(themeA == themeB, false);
      });

      test('returns false when dropdownTheme differs', () {
        final themeA = testTheme(
          dropdownTheme: const .new(showUnderline: true),
        );
        final themeB = testTheme(
          dropdownTheme: const .new(showUnderline: false),
        );

        expect(themeA == themeB, false);
      });

      test('returns false when topDropdownTheme differs', () {
        final themeA = testTheme(
          topDropdownTheme: const .new(showUnderline: true),
        );
        final themeB = testTheme(
          topDropdownTheme: const .new(showUnderline: false),
        );

        expect(themeA == themeB, false);
      });

      test('returns false when textFieldTheme differs', () {
        final themeA = testTheme(textFieldTheme: const .new(style: fontSize16));
        final themeB = testTheme(textFieldTheme: const .new(style: fontSize20));

        expect(themeA == themeB, false);
      });

      test('returns false when segmentedButtonStyle differs', () {
        final themeA = testTheme(
          segmentedButtonStyle: const .new(
            backgroundColor: WidgetStatePropertyAll(Colors.blue),
          ),
        );
        final themeB = testTheme(
          segmentedButtonStyle: const .new(
            backgroundColor: WidgetStatePropertyAll(Colors.red),
          ),
        );

        expect(themeA == themeB, false);
      });

      test('returns false when splitSegmentedButtonStyle differs', () {
        final themeA = testTheme(
          splitSegmentedButtonStyle: const .new(
            backgroundColor: WidgetStatePropertyAll(Colors.blue),
          ),
        );
        final themeB = testTheme(
          splitSegmentedButtonStyle: const .new(
            backgroundColor: WidgetStatePropertyAll(Colors.red),
          ),
        );

        expect(themeA == themeB, false);
      });

      test('returns false when outlinedContentButtonStyle differs', () {
        final themeA = testTheme(
          outlinedContentButtonStyle: const .new(
            backgroundColor: WidgetStatePropertyAll(Colors.blue),
          ),
        );
        final themeB = testTheme(
          outlinedContentButtonStyle: const .new(
            backgroundColor: WidgetStatePropertyAll(Colors.red),
          ),
        );

        expect(themeA == themeB, false);
      });

      test('handles null comparisons correctly', () {
        final themeA = testTheme(labelStyle: fontSize16);
        const RRulePickerThemeData? themeB = null;

        expect(themeA == themeB, false);
        expect(themeB == themeA, false);
      });
    });

    group('hashCode', () {
      test('returns consistent value for identical instances', () {
        final theme = testTheme(labelStyle: fontSize16);

        expect(theme.hashCode, theme.hashCode);
      });

      test('returns same value for equal instances', () {
        final themeA = testTheme(labelStyle: fontSize16);
        final themeB = testTheme(labelStyle: fontSize16);

        expect(themeA.hashCode, themeB.hashCode);
      });

      test('returns different values when labelStyle differs', () {
        final themeA = testTheme(labelStyle: fontSize16);
        final themeB = testTheme(labelStyle: fontSize20);

        expect(themeA.hashCode, isNot(themeB.hashCode));
      });

      test('returns different values when padding differs', () {
        final themeA = testTheme();
        final themeB = testTheme(padding: const .all(16));

        expect(themeA.hashCode, isNot(themeB.hashCode));
      });

      test('returns different values when spacing differs', () {
        final themeA = testTheme();
        final themeB = testTheme(spacing: const .defaults(row: 10));

        expect(themeA.hashCode, isNot(themeB.hashCode));
      });

      test('returns different values when headerTheme differs', () {
        final themeA = testTheme(headerTheme: const .new(showHeader: true));
        final themeB = testTheme(headerTheme: const .new(showHeader: false));

        expect(themeA.hashCode, isNot(themeB.hashCode));
      });

      test('returns different values when dropdownTheme differs', () {
        final themeA = testTheme(
          dropdownTheme: const .new(showUnderline: true),
        );
        final themeB = testTheme(
          dropdownTheme: const .new(showUnderline: false),
        );

        expect(themeA.hashCode, isNot(themeB.hashCode));
      });

      test('returns different values when topDropdownTheme differs', () {
        final themeA = testTheme(
          topDropdownTheme: const .new(showUnderline: true),
        );
        final themeB = testTheme(
          topDropdownTheme: const .new(showUnderline: false),
        );

        expect(themeA.hashCode, isNot(themeB.hashCode));
      });

      test('returns different values when textFieldTheme differs', () {
        final themeA = testTheme(textFieldTheme: const .new(style: fontSize16));
        final themeB = testTheme(textFieldTheme: const .new(style: fontSize20));

        expect(themeA.hashCode, isNot(themeB.hashCode));
      });

      test('returns different values when segmentedButtonStyle differs', () {
        final themeA = testTheme(
          segmentedButtonStyle: const .new(
            backgroundColor: WidgetStatePropertyAll(Colors.blue),
          ),
        );
        final themeB = testTheme(
          segmentedButtonStyle: const .new(
            backgroundColor: WidgetStatePropertyAll(Colors.red),
          ),
        );

        expect(themeA.hashCode, isNot(themeB.hashCode));
      });

      test('returns different values '
          'when splitSegmentedButtonStyle differs', () {
        final themeA = testTheme(
          splitSegmentedButtonStyle: const .new(
            foregroundColor: WidgetStatePropertyAll(Colors.white),
          ),
        );
        final themeB = testTheme(
          splitSegmentedButtonStyle: const .new(
            foregroundColor: WidgetStatePropertyAll(Colors.red),
          ),
        );

        expect(themeA.hashCode, isNot(themeB.hashCode));
      });

      test('returns different values '
          'when splitSegmentedButtonStyle differs', () {
        final themeA = testTheme(
          splitSegmentedButtonStyle: const .new(
            backgroundColor: WidgetStatePropertyAll(Colors.blue),
          ),
        );
        final themeB = testTheme(
          splitSegmentedButtonStyle: const .new(
            backgroundColor: WidgetStatePropertyAll(Colors.red),
          ),
        );

        expect(themeA.hashCode, isNot(themeB.hashCode));
      });

      test('returns different values '
          'when outlinedContentButtonStyle differs', () {
        final themeA = testTheme(
          outlinedContentButtonStyle: const .new(
            backgroundColor: WidgetStatePropertyAll(Colors.blue),
          ),
        );
        final themeB = testTheme(
          outlinedContentButtonStyle: const .new(
            backgroundColor: WidgetStatePropertyAll(Colors.red),
          ),
        );

        expect(themeA.hashCode, isNot(themeB.hashCode));
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
      test('with t=0 returns first theme', () {
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

      test('with t=1 returns second theme', () {
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

      test('calls lerp for style fields', () {
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

    group('equality operator', () {
      test('returns true for identical instances', () {
        const theme = RRulePickerHeaderThemeData(
          showHeader: true,
          style: fontSize16,
        );

        expect(theme == theme, true);
      });

      test('returns true for equal instances', () {
        const themeA = RRulePickerHeaderThemeData(
          showHeader: true,
          style: fontSize16,
        );
        const themeB = RRulePickerHeaderThemeData(
          showHeader: true,
          style: fontSize16,
        );

        expect(themeA == themeB, true);
      });

      test('returns false when showHeader differs', () {
        const themeA = RRulePickerHeaderThemeData(showHeader: true);
        const themeB = RRulePickerHeaderThemeData(showHeader: false);

        expect(themeA == themeB, false);
      });

      test('returns false when style differs', () {
        const themeA = RRulePickerHeaderThemeData(style: fontSize16);
        const themeB = RRulePickerHeaderThemeData(style: fontSize20);

        expect(themeA == themeB, false);
      });

      test('handles null comparisons correctly', () {
        const themeA = RRulePickerHeaderThemeData(
          showHeader: true,
          style: fontSize16,
        );
        const RRulePickerHeaderThemeData? themeB = null;

        expect(themeA == themeB, false);
        expect(themeB == themeA, false);
      });
    });

    group('hashCode', () {
      test('returns consistent value for same instance', () {
        const theme = RRulePickerHeaderThemeData(
          showHeader: true,
          style: fontSize16,
        );

        expect(theme.hashCode, theme.hashCode);
      });

      test('returns same value for equal instances', () {
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

      test('returns different value when showHeader differs', () {
        const themeA = RRulePickerHeaderThemeData(showHeader: true);
        const themeB = RRulePickerHeaderThemeData(showHeader: false);

        expect(themeA.hashCode, isNot(themeB.hashCode));
      });

      test('returns different value when style differs', () {
        const themeA = RRulePickerHeaderThemeData(style: fontSize16);
        const themeB = RRulePickerHeaderThemeData(style: fontSize20);

        expect(themeA.hashCode, isNot(themeB.hashCode));
      });
    });
  });

  group(RRulePickerDropdownThemeData, () {
    group('constructor', () {
      test('default constructor creates instance with all null fields', () {
        const theme = RRulePickerDropdownThemeData();

        expect(theme.showUnderline, null);
        expect(theme.style, null);
        expect(theme.decoration, null);
        expect(theme.menuItemStyle, null);
        expect(theme.menuItemDecoration, null);
      });

      test('constructor accepts and stores all fields correctly', () {
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

      test('static constants have expected values', () {
        expect(RRulePickerDropdownThemeData.defaultShowUnderline, true);
        expect(RRulePickerDropdownThemeData.defaultTopShowUnderline, false);
      });
    });

    group('copyWith', () {
      test('with no arguments returns equal instances', () {
        const theme = RRulePickerDropdownThemeData(
          showUnderline: true,
          style: fontSize16,
        );

        final copied = theme.copyWith();

        expect(copied, theme);
      });

      test('updates each field individually when provided', () {
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

      test('retains existing values for unspecified fields', () {
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

      test('handles null values correctly', () {
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
      test('with t=0 returns first theme', () {
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

      test('with t=1 returns second theme', () {
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

      test('with t=0.5 uses threshold logic for boolean showUnderline', () {
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
      });

      test('calls lerp for style fields', () {
        const themeA = RRulePickerDropdownThemeData(style: fontSize16);
        const themeB = RRulePickerDropdownThemeData(style: fontSize20);

        final result = RRulePickerDropdownThemeData.lerp(themeA, themeB, 0.5);

        expect(result?.style?.fontSize, 18.0);
      });

      test('calls lerp for decoration fields', () {
        const themeA = RRulePickerDropdownThemeData(
          decoration: .new(color: Colors.blue),
        );
        const themeB = RRulePickerDropdownThemeData(
          decoration: .new(color: Colors.red),
        );

        final result = RRulePickerDropdownThemeData.lerp(themeA, themeB, 0.5);

        expect(result?.decoration, isNotNull);
      });

      test('with identical themes returns the same instance', () {
        const theme = RRulePickerDropdownThemeData(
          showUnderline: true,
          style: fontSize16,
        );

        final result = RRulePickerDropdownThemeData.lerp(theme, theme, 0.5);

        expect(result, theme);
      });

      test('with both null returns null', () {
        final result = RRulePickerDropdownThemeData.lerp(null, null, 0.5);

        expect(result, null);
      });

      test('with one null theme handles correctly', () {
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

    group('equality operator', () {
      test('returns true for identical instances', () {
        const theme = RRulePickerDropdownThemeData(
          showUnderline: true,
          style: fontSize16,
        );

        expect(theme == theme, true);
      });

      test('returns true for equal instances', () {
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

        expect(themeA == themeB, true);
      });

      test('returns false when showUnderline differs', () {
        const themeA = RRulePickerDropdownThemeData(showUnderline: true);
        const themeB = RRulePickerDropdownThemeData(showUnderline: false);

        expect(themeA == themeB, false);
      });

      test('returns false when style differs', () {
        const themeA = RRulePickerDropdownThemeData(style: fontSize16);
        const themeB = RRulePickerDropdownThemeData(style: fontSize20);

        expect(themeA == themeB, false);
      });

      test('returns false when decoration differs', () {
        const themeA = RRulePickerDropdownThemeData(
          decoration: .new(color: Colors.blue),
        );
        const themeB = RRulePickerDropdownThemeData(
          decoration: .new(color: Colors.red),
        );

        expect(themeA == themeB, false);
      });

      test('returns false when menuItemStyle differs', () {
        const themeA = RRulePickerDropdownThemeData(menuItemStyle: fontSize16);
        const themeB = RRulePickerDropdownThemeData(menuItemStyle: fontSize20);

        expect(themeA == themeB, false);
      });

      test('returns false when menuItemDecoration differs', () {
        const themeA = RRulePickerDropdownThemeData(
          menuItemDecoration: .new(color: Colors.blue),
        );
        const themeB = RRulePickerDropdownThemeData(
          menuItemDecoration: .new(color: Colors.red),
        );

        expect(themeA == themeB, false);
      });

      test('handles null comparisons correctly', () {
        const themeA = RRulePickerDropdownThemeData(
          showUnderline: true,
          style: fontSize16,
        );
        const RRulePickerDropdownThemeData? themeB = null;

        expect(themeA == themeB, false);
        expect(themeB == themeA, false);
      });
    });

    group('hashCode', () {
      test('returns consistent value for same instance', () {
        const theme = RRulePickerDropdownThemeData(
          showUnderline: true,
          style: fontSize16,
        );

        expect(theme.hashCode, theme.hashCode);
      });

      test('returns same value for equal instances', () {
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

      test('returns different value when showUnderline differs', () {
        const themeA = RRulePickerDropdownThemeData(showUnderline: true);
        const themeB = RRulePickerDropdownThemeData(showUnderline: false);

        expect(themeA.hashCode, isNot(themeB.hashCode));
      });

      test('returns different value when style differs', () {
        const themeA = RRulePickerDropdownThemeData(style: fontSize16);
        const themeB = RRulePickerDropdownThemeData(style: fontSize20);

        expect(themeA.hashCode, isNot(themeB.hashCode));
      });

      test('returns different value when decoration differs', () {
        const themeA = RRulePickerDropdownThemeData(
          decoration: .new(color: Colors.blue),
        );
        const themeB = RRulePickerDropdownThemeData(
          decoration: .new(color: Colors.red),
        );

        expect(themeA.hashCode, isNot(themeB.hashCode));
      });

      test('returns different value when menuItemStyle differs', () {
        const themeA = RRulePickerDropdownThemeData(menuItemStyle: fontSize16);
        const themeB = RRulePickerDropdownThemeData(menuItemStyle: fontSize20);

        expect(themeA.hashCode, isNot(themeB.hashCode));
      });

      test('returns different value when menuItemDecoration differs', () {
        const themeA = RRulePickerDropdownThemeData(
          menuItemDecoration: .new(color: Colors.blue),
        );
        const themeB = RRulePickerDropdownThemeData(
          menuItemDecoration: .new(color: Colors.red),
        );

        expect(themeA.hashCode, isNot(themeB.hashCode));
      });
    });
  });

  group(RRulePickerTextFieldThemeData, () {
    group('constructor', () {
      test('creates instance with all null fields by default', () {
        const theme = RRulePickerTextFieldThemeData();

        expect(theme.style, null);
        expect(theme.decoration, null);
      });

      test('accepts and stores style and decoration correctly', () {
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

      test('static constant defaultDecoration has expected value', () {
        expect(
          RRulePickerTextFieldThemeData.defaultDecoration,
          const InputDecoration(isDense: true),
        );
      });
    });

    group('copyWith', () {
      test('with no arguments returns equal instance', () {
        const theme = RRulePickerTextFieldThemeData(style: fontSize16);

        final copied = theme.copyWith();

        expect(copied, theme);
      });

      test('updates style when provided', () {
        const original = RRulePickerTextFieldThemeData(
          style: fontSize16,
          decoration: .new(isDense: true),
        );
        final copied = original.copyWith(style: fontSize20);

        expect(copied.style, fontSize20);
        expect(copied.decoration, original.decoration);
      });

      test('updates decoration when provided', () {
        const original = RRulePickerTextFieldThemeData(
          style: fontSize16,
          decoration: .new(isDense: true),
        );
        const newDecoration = InputDecoration(isDense: false);
        final copied = original.copyWith(decoration: newDecoration);

        expect(copied.decoration, newDecoration);
        expect(copied.style, original.style);
      });

      test('retains existing values for unspecified fields', () {
        const original = RRulePickerTextFieldThemeData(
          style: fontSize16,
          decoration: .new(isDense: true),
        );
        final copied = original.copyWith(style: fontSize20);

        expect(copied.style, isNot(original.style));
        expect(copied.decoration, original.decoration);
      });
    });

    group('lerp', () {
      test('with t=0 returns first theme', () {
        const themeA = RRulePickerTextFieldThemeData(style: fontSize16);
        const themeB = RRulePickerTextFieldThemeData(style: fontSize20);

        final result = RRulePickerTextFieldThemeData.lerp(themeA, themeB, 0);

        expect(result?.style?.fontSize, 16.0);
      });

      test('with t=1 returns second theme', () {
        const themeA = RRulePickerTextFieldThemeData(style: fontSize16);
        const themeB = RRulePickerTextFieldThemeData(style: fontSize20);

        final result = RRulePickerTextFieldThemeData.lerp(themeA, themeB, 1);

        expect(result?.style?.fontSize, 20.0);
      });

      test('with t=0.5 uses threshold logic for decoration', () {
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

      test('calls lerp for style fields', () {
        const themeA = RRulePickerTextFieldThemeData(style: fontSize16);
        const themeB = RRulePickerTextFieldThemeData(style: fontSize20);

        final result = RRulePickerTextFieldThemeData.lerp(themeA, themeB, 0.5);

        expect(result?.style?.fontSize, 18.0);
      });

      test('with identical themes returns the same instance', () {
        const theme = RRulePickerTextFieldThemeData(style: fontSize16);

        final result = RRulePickerTextFieldThemeData.lerp(theme, theme, 0.5);

        expect(result, theme);
      });

      test('with both null returns null', () {
        final result = RRulePickerTextFieldThemeData.lerp(null, null, 0.5);

        expect(result, null);
      });

      test('with one null theme handles correctly', () {
        const theme = RRulePickerTextFieldThemeData(style: fontSize16);

        final resultA = RRulePickerTextFieldThemeData.lerp(theme, null, 0.5);
        final resultB = RRulePickerTextFieldThemeData.lerp(null, theme, 0.5);

        expect(resultA, isNotNull);
        expect(resultB, isNotNull);
      });
    });

    group('equality operator', () {
      test('returns true for identical instances', () {
        const theme = RRulePickerTextFieldThemeData(style: fontSize16);

        expect(theme == theme, true);
      });

      test('returns true for equal instances', () {
        const themeA = RRulePickerTextFieldThemeData(style: fontSize16);
        const themeB = RRulePickerTextFieldThemeData(style: fontSize16);

        expect(themeA == themeB, true);
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

        expect(themeA == themeB, false);
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

        expect(themeA == themeB, false);
      });

      test('returns true for equal instances with all fields', () {
        const themeA = RRulePickerTextFieldThemeData(
          style: fontSize16,
          decoration: .new(isDense: true),
        );
        const themeB = RRulePickerTextFieldThemeData(
          style: fontSize16,
          decoration: .new(isDense: true),
        );

        expect(themeA == themeB, true);
      });

      test('handles null comparisons correctly', () {
        const themeA = RRulePickerTextFieldThemeData(
          style: fontSize16,
          decoration: .new(isDense: false),
        );
        const RRulePickerTextFieldThemeData? themeB = null;

        expect(themeA == themeB, false);
        expect(themeB == themeA, false);
      });
    });

    group('hashCode', () {
      test('returns consistent value for the same instance', () {
        const theme = RRulePickerTextFieldThemeData(style: fontSize16);

        expect(theme.hashCode, theme.hashCode);
      });

      test('returns same values for equal instances', () {
        const themeA = RRulePickerTextFieldThemeData(style: fontSize16);
        const themeB = RRulePickerTextFieldThemeData(style: fontSize16);

        expect(themeA.hashCode, themeB.hashCode);
      });

      test('returns different value when style differs', () {
        const themeA = RRulePickerTextFieldThemeData(style: fontSize16);
        const themeB = RRulePickerTextFieldThemeData(style: fontSize20);

        expect(themeA.hashCode, isNot(themeB.hashCode));
      });

      test('returns different value when decoration differs', () {
        const themeA = RRulePickerTextFieldThemeData(
          decoration: .new(isDense: true),
        );
        const themeB = RRulePickerTextFieldThemeData(
          decoration: .new(isDense: false),
        );

        expect(themeA.hashCode, isNot(themeB.hashCode));
      });
    });
  });

  group(RRulePickerSpacing, () {
    group('constructor', () {
      property('creates instance with provided row and column values', () {
        forAll(combine2(float(), float()), (f) {
          final spacing = RRulePickerSpacing(row: f.$1, column: f.$2);

          expect(spacing.row, f.$1);
          expect(spacing.column, f.$2);
        });
      });

      test('accepts zero values', () {
        const spacing = RRulePickerSpacing(row: 0.0, column: 0.0);

        expect(spacing.row, 0.0);
        expect(spacing.column, 0.0);
      });
    });

    test('defaults constructor creates instance with default values', () {
      const spacing = RRulePickerSpacing.defaults();

      expect(spacing.row, 8.0);
      expect(spacing.column, 8.0);
    });

    property('defaults constructor allows overriding values', () {
      forAll(combine2(float(), float()), (f) {
        final spacing = RRulePickerSpacing.defaults(row: f.$1, column: f.$2);

        expect(spacing.row, f.$1);
        expect(spacing.column, f.$2);
      });
    });

    group('copyWith', () {
      property('with no arguments returns equal instance', () {
        forAll(combine2(float(), float()), (f) {
          final spacing = RRulePickerSpacing(row: f.$1, column: f.$2);

          final copied = spacing.copyWith();

          expect(copied, spacing);
        });
      });

      property('updates row when provided', () {
        forAll(combine3(float(), float(), float()), (f) {
          final original = RRulePickerSpacing(row: f.$1, column: f.$2);

          final copied = original.copyWith(row: f.$3);

          expect(copied.row, f.$3);
          expect(copied.column, f.$2);
        });
      });

      property('updates column when provided', () {
        forAll(combine3(float(), float(), float()), (f) {
          final original = RRulePickerSpacing(row: f.$1, column: f.$2);

          final copied = original.copyWith(column: f.$3);

          expect(copied.row, f.$1);
          expect(copied.column, f.$3);
        });
      });

      property('updates both row and column when provided', () {
        forAll(combine4(float(), float(), float(), float()), (f) {
          final original = RRulePickerSpacing(row: f.$1, column: f.$2);

          final copied = original.copyWith(row: f.$3, column: f.$4);

          expect(copied.row, f.$3);
          expect(copied.column, f.$4);
        });
      });

      property('handles null values by retaining originals', () {
        forAll(combine2(float(), float()), (f) {
          final original = RRulePickerSpacing(row: f.$1, column: f.$2);

          final copied = original.copyWith(row: null, column: null);

          expect(copied.row, original.row);
          expect(copied.column, original.column);
        });
      });
    });

    group('lerp', () {
      property('with t=0 returns first spacing', () {
        forAll(combine4(float(), float(), float(), float()), (f) {
          final spacingA = RRulePickerSpacing(row: f.$1, column: f.$2);
          final spacingB = RRulePickerSpacing(row: f.$3, column: f.$4);

          final result = RRulePickerSpacing.lerp(spacingA, spacingB, 0);

          expect(result?.row, spacingA.row);
          expect(result?.column, spacingA.column);
        });
      });

      property('with t=1 returns second spacing', () {
        forAll(combine4(float(), float(), float(), float()), (f) {
          final spacingA = RRulePickerSpacing(row: f.$1, column: f.$2);
          final spacingB = RRulePickerSpacing(row: f.$3, column: f.$4);

          final result = RRulePickerSpacing.lerp(spacingA, spacingB, 1);

          expect(result?.row, spacingB.row);
          expect(result?.column, spacingB.column);
        });
      });

      property('with t=0.5 returns average spacing', () {
        final half = double.maxFinite / 2;

        forAll(
          combine4(
            float(min: -half, max: half),
            float(min: -half, max: half),
            float(min: -half, max: half),
            float(min: -half, max: half),
          ),
          (f) {
            final spacingA = RRulePickerSpacing(row: f.$1, column: f.$2);
            final spacingB = RRulePickerSpacing(row: f.$3, column: f.$4);

            final result = RRulePickerSpacing.lerp(spacingA, spacingB, 0.5);

            expect(result?.row, (spacingA.row + spacingB.row) / 2);
            expect(result?.column, (spacingA.column + spacingB.column) / 2);
          },
        );
      });

      property('with identical spacings returns the same instance', () {
        forAll(combine3(float(), float(), float(min: 0, max: 1)), (f) {
          final spacing = RRulePickerSpacing(row: f.$1, column: f.$2);

          final result = RRulePickerSpacing.lerp(spacing, spacing, f.$3);

          expect(result, spacing);
        });
      });

      property('with both nulls returns null', () {
        forAll(float(min: 0, max: 1), (f) {
          final result = RRulePickerSpacing.lerp(null, null, f);

          expect(result, null);
        });
      });

      property('handles one null spacing correctly', () {
        forAll(combine3(float(), float(), float(min: 0, max: 1)), (f) {
          final spacing = RRulePickerSpacing(row: f.$1, column: f.$2);

          final resultA = RRulePickerSpacing.lerp(spacing, null, f.$3);
          final resultB = RRulePickerSpacing.lerp(null, spacing, f.$3);

          expect(resultA, isNotNull);
          expect(resultB, isNotNull);
        });
      });

      property('handles interpolation between zero and non-zero values', () {
        forAll(combine3(float(), float(), float(min: 0, max: 1)), (f) {
          const spacingA = RRulePickerSpacing(row: 0.0, column: 0.0);
          final spacingB = RRulePickerSpacing(row: f.$1, column: f.$2);

          final result = RRulePickerSpacing.lerp(spacingA, spacingB, f.$3);

          expect(result?.row, f.$1 * f.$3);
          expect(result?.column, f.$2 * f.$3);
        });
      });

      property('handles interpolation with negative values', () {
        forAll(combine2(float(), float()), (f) {
          final spacingA = RRulePickerSpacing(row: -f.$1, column: -f.$2);
          final spacingB = RRulePickerSpacing(row: f.$1, column: f.$2);

          final result = RRulePickerSpacing.lerp(spacingA, spacingB, 0.5);

          expect(result?.row, 0.0);
          expect(result?.column, 0.0);
        });
      });
    });

    group('equality operator', () {
      property('returns true for identical instances', () {
        forAll(combine2(float(), float()), (f) {
          final spacing = RRulePickerSpacing(row: f.$1, column: f.$2);

          expect(spacing == spacing, true);
        });
      });

      property('returns true for equal instances', () {
        forAll(combine2(float(), float()), (f) {
          final spacingA = RRulePickerSpacing(row: f.$1, column: f.$2);
          final spacingB = RRulePickerSpacing(row: f.$1, column: f.$2);

          expect(spacingA == spacingB, true);
        });
      });

      property('returns false when row differs', () {
        forAll(
          combine3(float(), float(), float()).filter((f) => f.$1 != f.$3),
          (f) {
            final spacingA = RRulePickerSpacing(row: f.$1, column: f.$2);
            final spacingB = RRulePickerSpacing(row: f.$3, column: f.$2);

            expect(spacingA == spacingB, false);
          },
        );
      });

      property('returns false when column differs', () {
        forAll(
          combine3(float(), float(), float()).filter((f) => f.$2 != f.$3),
          (f) {
            final spacingA = RRulePickerSpacing(row: f.$1, column: f.$2);
            final spacingB = RRulePickerSpacing(row: f.$1, column: f.$3);

            expect(spacingA == spacingB, false);
          },
        );
      });

      property('returns false when both row and column differ', () {
        forAll(
          combine4(float(), float(), float(), float()).filter((f) {
            return f.$1 != f.$3 && f.$2 != f.$4;
          }),
          (f) {
            final spacingA = RRulePickerSpacing(row: f.$1, column: f.$2);
            final spacingB = RRulePickerSpacing(row: f.$3, column: f.$4);

            expect(spacingA == spacingB, false);
          },
        );
      });

      property('handles null comparisons correctly', () {
        forAll(combine2(float(), float()), (f) {
          final spacingA = RRulePickerSpacing(row: f.$1, column: f.$2);
          const RRulePickerSpacing? spacingB = null;

          expect(spacingA == spacingB, false);
          expect(spacingB == spacingA, false);
        });
      });

      property('returns false for different types', () {
        forAll(combine2(float(), float()), (f) {
          final dynamic spacing = RRulePickerSpacing(row: f.$1, column: f.$2);

          expect(spacing == 'not a spacing', false);
        });
      });
    });

    group('hashCode', () {
      property('returns consistent value for same instance', () {
        forAll(combine2(float(), float()), (f) {
          final spacing = RRulePickerSpacing(row: f.$1, column: f.$2);

          expect(spacing.hashCode, spacing.hashCode);
        });
      });

      property('returns same value for equal instances', () {
        forAll(combine2(float(), float()), (f) {
          final spacingA = RRulePickerSpacing(row: f.$1, column: f.$2);
          final spacingB = RRulePickerSpacing(row: f.$1, column: f.$2);

          expect(spacingA.hashCode, spacingB.hashCode);
        });
      });

      property('returns different value when row differs', () {
        forAll(
          combine3(float(), float(), float()).filter((f) => f.$1 != f.$3),
          (f) {
            final spacingA = RRulePickerSpacing(row: f.$1, column: f.$2);
            final spacingB = RRulePickerSpacing(row: f.$3, column: f.$2);

            expect(spacingA.hashCode, isNot(spacingB.hashCode));
          },
        );
      });

      property('returns different value when column differs', () {
        forAll(
          combine3(float(), float(), float()).filter((f) => f.$2 != f.$3),
          (f) {
            final spacingA = RRulePickerSpacing(row: f.$1, column: f.$2);
            final spacingB = RRulePickerSpacing(row: f.$1, column: f.$3);

            expect(spacingA.hashCode, isNot(spacingB.hashCode));
          },
        );
      });

      property('returns different value when both row and column differ', () {
        forAll(
          combine4(float(), float(), float(), float()).filter((f) {
            return f.$1 != f.$3 && f.$2 != f.$4;
          }),
          (f) {
            final spacingA = RRulePickerSpacing(row: f.$1, column: f.$2);
            final spacingB = RRulePickerSpacing(row: f.$3, column: f.$4);

            expect(spacingA.hashCode, isNot(spacingB.hashCode));
          },
        );
      });
    });
  });
}

const fontSize16 = TextStyle(fontSize: 16);
const fontSize20 = TextStyle(fontSize: 20);

RRulePickerThemeData testTheme({
  TextStyle? labelStyle = const .new(),
  EdgeInsetsGeometry? padding = const .all(8),
  RRulePickerSpacing? spacing = const .defaults(),
  RRulePickerHeaderThemeData? headerTheme = const .new(),
  RRulePickerDropdownThemeData? dropdownTheme = const .new(),
  RRulePickerDropdownThemeData? topDropdownTheme = const .new(),
  RRulePickerTextFieldThemeData? textFieldTheme = const .new(),
  ButtonStyle? segmentedButtonStyle = const .new(),
  ButtonStyle? splitSegmentedButtonStyle = const .new(),
  ButtonStyle? outlinedContentButtonStyle = const .new(),
  int? narrowLayoutBreakpoint = RRulePicker.defaultNarrowLayoutBreakpoint,
}) => RRulePickerThemeData(
  labelStyle: labelStyle,
  padding: padding,
  spacing: spacing,
  headerTheme: headerTheme,
  dropdownTheme: dropdownTheme,
  topDropdownTheme: topDropdownTheme,
  textFieldTheme: textFieldTheme,
  segmentedButtonStyle: segmentedButtonStyle,
  splitSegmentedButtonStyle: splitSegmentedButtonStyle,
  outlinedContentButtonStyle: outlinedContentButtonStyle,
);
