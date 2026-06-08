// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rrule_picker/rrule_picker.dart';
import 'package:rrule_picker/theme.dart';

@internal
class RRulePickerTheme extends InheritedWidget {
  final RRulePickerResolvedThemeData theme;

  const RRulePickerTheme({
    super.key,
    required this.theme,
    required super.child,
  });

  static RRulePickerResolvedThemeData of(BuildContext context) {
    final self = context.dependOnInheritedWidgetOfExactType<RRulePickerTheme>();

    if (self == null) {
      throw Exception(
        'RRulePicker child widgets must be wrapped in a RRulePickerTheme',
      );
    }

    return self.theme;
  }

  @override
  bool updateShouldNotify(covariant RRulePickerTheme oldWidget) =>
      theme != oldWidget.theme;
}

@internal
class RRulePickerResolvedThemeData {
  final TextStyle? labelStyle;
  final EdgeInsetsGeometry padding;

  final bool showHeader;
  final TextStyle? headerStyle;

  final TextStyle? dropdownStyle;
  final BoxDecoration? dropdownDecoration;
  final TextStyle? dropdownMenuItemStyle;
  final BoxDecoration? dropdownMenuItemDecoration;

  final TextStyle? textFieldStyle;
  final InputDecoration? textFieldDecoration;

  final ButtonStyle? segmentedButtonStyle;

  const RRulePickerResolvedThemeData({
    this.labelStyle,
    required this.padding,
    required this.showHeader,
    required this.headerStyle,
    this.dropdownStyle,
    this.dropdownDecoration,
    this.dropdownMenuItemStyle,
    this.dropdownMenuItemDecoration,
    this.textFieldStyle,
    this.textFieldDecoration,
    this.segmentedButtonStyle,
  });

  factory RRulePickerResolvedThemeData.defaults(ThemeData theme) =>
      RRulePickerResolvedThemeData(
        padding: RRulePickerThemeData.defaultPadding,
        showHeader: RRulePickerThemeData.defaultShowHeader,
        headerStyle:
            theme.textTheme.titleSmall?.copyWith(
              fontSize: RRulePickerThemeData.defaultHeaderFontSize,
              fontWeight: RRulePickerThemeData.defaultHeaderFontWeight,
            ) ??
            RRulePickerThemeData.fallbackHeaderStyle,
        textFieldDecoration: RRulePickerThemeData.defaultTextFieldDecoration,
        segmentedButtonStyle: RRulePickerThemeData.defaultSegmentedButtonStyle,
      );

  factory RRulePickerResolvedThemeData.resolve(
    BuildContext context, [
    RRulePickerThemeData? localTheme,
  ]) {
    final theme = Theme.of(context);
    final globalTheme = theme.extension<RRulePickerThemeData>();
    final defaultTheme = RRulePickerResolvedThemeData.defaults(theme);

    return RRulePickerResolvedThemeData(
      labelStyle:
          localTheme?.labelStyle ??
          globalTheme?.labelStyle ??
          defaultTheme.labelStyle,
      padding:
          localTheme?.padding ?? globalTheme?.padding ?? defaultTheme.padding,
      showHeader:
          localTheme?.showHeader ??
          globalTheme?.showHeader ??
          defaultTheme.showHeader,
      headerStyle:
          localTheme?.headerStyle ??
          globalTheme?.headerStyle ??
          defaultTheme.headerStyle,
      dropdownStyle:
          localTheme?.dropdownLabelStyle ??
          globalTheme?.dropdownLabelStyle ??
          defaultTheme.dropdownStyle,
      dropdownDecoration:
          localTheme?.dropdownDecoration ??
          globalTheme?.dropdownDecoration ??
          defaultTheme.dropdownDecoration,
      dropdownMenuItemStyle:
          localTheme?.dropdownMenuItemStyle ??
          globalTheme?.dropdownMenuItemStyle ??
          defaultTheme.dropdownMenuItemStyle,
      dropdownMenuItemDecoration:
          localTheme?.dropdownMenuItemDecoration ??
          globalTheme?.dropdownMenuItemDecoration ??
          defaultTheme.dropdownMenuItemDecoration,
      textFieldStyle:
          localTheme?.textFieldStyle ??
          globalTheme?.textFieldStyle ??
          defaultTheme.textFieldStyle,
      textFieldDecoration:
          localTheme?.textFieldDecoration ??
          globalTheme?.textFieldDecoration ??
          defaultTheme.textFieldDecoration,
      segmentedButtonStyle:
          localTheme?.segmentedButtonStyle ??
          globalTheme?.segmentedButtonStyle ??
          defaultTheme.segmentedButtonStyle,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other)
      ? true
      : other is RRulePickerResolvedThemeData &&
            other.labelStyle == labelStyle &&
            other.padding == padding &&
            other.showHeader == showHeader &&
            other.headerStyle == headerStyle &&
            other.dropdownStyle == dropdownStyle &&
            other.dropdownDecoration == dropdownDecoration &&
            other.dropdownMenuItemStyle == dropdownMenuItemStyle &&
            other.dropdownMenuItemDecoration == dropdownMenuItemDecoration &&
            other.textFieldStyle == textFieldStyle &&
            other.textFieldDecoration == textFieldDecoration &&
            other.segmentedButtonStyle == segmentedButtonStyle;

  @override
  int get hashCode => Object.hash(
    labelStyle,
    padding,
    showHeader,
    headerStyle,
    dropdownStyle,
    dropdownDecoration,
    dropdownMenuItemStyle,
    dropdownMenuItemDecoration,
    textFieldStyle,
    textFieldDecoration,
    segmentedButtonStyle,
  );
}
