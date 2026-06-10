// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rrule_picker/theme.dart';

@internal
class ResolvedTheme extends InheritedWidget {
  final ResolvedThemeData theme;

  const ResolvedTheme({super.key, required this.theme, required super.child});

  static ResolvedThemeData of(BuildContext context) {
    final self = context.dependOnInheritedWidgetOfExactType<ResolvedTheme>();

    if (self == null) {
      throw Exception(
        'RRulePicker child widgets must be wrapped in a RRulePickerTheme',
      );
    }

    return self.theme;
  }

  @override
  bool updateShouldNotify(covariant ResolvedTheme oldWidget) =>
      theme != oldWidget.theme;
}

@internal
class ResolvedThemeData {
  final TextStyle? labelStyle;
  final EdgeInsetsGeometry padding;
  final RRulePickerHeaderThemeData headerTheme;
  final RRulePickerDropdownThemeData dropdownTheme;
  final RRulePickerDropdownThemeData topDropdownTheme;
  final RRulePickerTextFieldThemeData? textFieldTheme;
  final ButtonStyle? segmentedButtonStyle;
  final ButtonStyle? weekdaySelectionButtonStyle;

  const ResolvedThemeData({
    this.labelStyle,
    required this.padding,
    required this.headerTheme,
    required this.dropdownTheme,
    required this.topDropdownTheme,
    this.textFieldTheme,
    this.segmentedButtonStyle,
    this.weekdaySelectionButtonStyle,
  });

  factory ResolvedThemeData.defaults(ThemeData theme) => ResolvedThemeData(
    padding: RRulePickerThemeData.defaultPadding,
    headerTheme: RRulePickerHeaderThemeData(
      showHeader: RRulePickerHeaderThemeData.defaultShowHeader,
      style:
          theme.textTheme.titleSmall?.copyWith(
            fontSize: RRulePickerHeaderThemeData.defaultFontSize,
            fontWeight: RRulePickerHeaderThemeData.defaultFontWeight,
          ) ??
          RRulePickerHeaderThemeData.fallbackStyle,
    ),
    dropdownTheme: const RRulePickerDropdownThemeData(
      showUnderline: RRulePickerDropdownThemeData.defaultShowUnderline,
    ),
    topDropdownTheme: const RRulePickerDropdownThemeData(
      showUnderline: RRulePickerDropdownThemeData.defaultTopShowUnderline,
    ),
    textFieldTheme: const RRulePickerTextFieldThemeData(
      decoration: RRulePickerTextFieldThemeData.defaultDecoration,
    ),
    segmentedButtonStyle: RRulePickerThemeData.defaultSegmentedButtonStyle,
  );

  factory ResolvedThemeData.resolve(
    BuildContext context, [
    RRulePickerThemeData? localTheme,
  ]) {
    final theme = Theme.of(context);
    final globalTheme = theme.extension<RRulePickerThemeData>();
    final defaultTheme = ResolvedThemeData.defaults(theme);

    final dropdownTheme = RRulePickerDropdownThemeData(
      showUnderline:
          localTheme?.dropdownTheme?.showUnderline ??
          globalTheme?.dropdownTheme?.showUnderline ??
          defaultTheme.dropdownTheme.showUnderline,
      style:
          localTheme?.dropdownTheme?.style ??
          globalTheme?.dropdownTheme?.style ??
          defaultTheme.dropdownTheme.style,
      decoration:
          localTheme?.dropdownTheme?.decoration ??
          globalTheme?.dropdownTheme?.decoration ??
          defaultTheme.dropdownTheme.decoration,
      menuItemStyle:
          localTheme?.dropdownTheme?.menuItemStyle ??
          globalTheme?.dropdownTheme?.menuItemStyle ??
          defaultTheme.dropdownTheme.menuItemStyle,
      menuItemDecoration:
          localTheme?.dropdownTheme?.menuItemDecoration ??
          globalTheme?.dropdownTheme?.menuItemDecoration ??
          defaultTheme.dropdownTheme.menuItemDecoration,
    );

    final segmentedButtonStyle =
        localTheme?.segmentedButtonStyle ??
        globalTheme?.segmentedButtonStyle ??
        defaultTheme.segmentedButtonStyle;

    return ResolvedThemeData(
      labelStyle:
          localTheme?.labelStyle ??
          globalTheme?.labelStyle ??
          defaultTheme.labelStyle,
      padding:
          localTheme?.padding ?? globalTheme?.padding ?? defaultTheme.padding,
      headerTheme: RRulePickerHeaderThemeData(
        showHeader:
            localTheme?.headerTheme?.showHeader ??
            globalTheme?.headerTheme?.showHeader ??
            defaultTheme.headerTheme.showHeader,
        style:
            localTheme?.headerTheme?.style ??
            globalTheme?.headerTheme?.style ??
            defaultTheme.headerTheme.style,
      ),
      dropdownTheme: dropdownTheme,
      topDropdownTheme: RRulePickerDropdownThemeData(
        showUnderline:
            localTheme?.topDropdownTheme?.showUnderline ??
            globalTheme?.topDropdownTheme?.showUnderline ??
            defaultTheme.topDropdownTheme.showUnderline,
        style:
            localTheme?.topDropdownTheme?.style ??
            globalTheme?.topDropdownTheme?.style ??
            defaultTheme.topDropdownTheme.style ??
            dropdownTheme.style,
        decoration:
            localTheme?.topDropdownTheme?.decoration ??
            globalTheme?.topDropdownTheme?.decoration ??
            defaultTheme.topDropdownTheme.decoration ??
            dropdownTheme.decoration,
        menuItemStyle:
            localTheme?.topDropdownTheme?.menuItemStyle ??
            globalTheme?.topDropdownTheme?.menuItemStyle ??
            defaultTheme.topDropdownTheme.menuItemStyle ??
            dropdownTheme.menuItemStyle,
        menuItemDecoration:
            localTheme?.topDropdownTheme?.menuItemDecoration ??
            globalTheme?.topDropdownTheme?.menuItemDecoration ??
            defaultTheme.topDropdownTheme.menuItemDecoration ??
            dropdownTheme.menuItemDecoration,
      ),
      textFieldTheme: RRulePickerTextFieldThemeData(
        style:
            localTheme?.textFieldTheme?.style ??
            globalTheme?.textFieldTheme?.style ??
            defaultTheme.textFieldTheme?.style,
        decoration:
            localTheme?.textFieldTheme?.decoration ??
            globalTheme?.textFieldTheme?.decoration ??
            defaultTheme.textFieldTheme?.decoration,
      ),
      segmentedButtonStyle: segmentedButtonStyle,
      weekdaySelectionButtonStyle:
          localTheme?.weekdaySelectionButtonStyle ??
          globalTheme?.weekdaySelectionButtonStyle ??
          defaultTheme.weekdaySelectionButtonStyle ??
          segmentedButtonStyle,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other)
      ? true
      : other is ResolvedThemeData &&
            other.labelStyle == labelStyle &&
            other.padding == padding &&
            other.headerTheme == headerTheme &&
            other.dropdownTheme == dropdownTheme &&
            other.topDropdownTheme == topDropdownTheme &&
            other.textFieldTheme == textFieldTheme &&
            other.segmentedButtonStyle == segmentedButtonStyle &&
            other.weekdaySelectionButtonStyle == weekdaySelectionButtonStyle;

  @override
  int get hashCode => Object.hash(
    labelStyle,
    padding,
    headerTheme,
    dropdownTheme,
    topDropdownTheme,
    textFieldTheme,
    segmentedButtonStyle,
    weekdaySelectionButtonStyle,
  );
}
