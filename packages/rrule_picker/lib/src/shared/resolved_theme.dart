// Copyright 2026 Piotr Mieczysław Orzechowski
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
  final RRulePickerSpacing spacing;
  final RRulePickerHeaderThemeData headerTheme;
  final RRulePickerDropdownThemeData dropdownTheme;
  final RRulePickerDropdownThemeData topDropdownTheme;
  final RRulePickerTextFieldThemeData? textFieldTheme;
  final ButtonStyle? segmentedButtonStyle;
  final ButtonStyle? splitSegmentedButtonStyle;
  final ButtonStyle? outlinedContentButtonStyle;
  final LabeledSwitchThemeData? labeledSwitchTheme;

  @visibleForTesting
  const ResolvedThemeData({
    this.labelStyle,
    required this.padding,
    required this.spacing,
    required this.headerTheme,
    required this.dropdownTheme,
    required this.topDropdownTheme,
    this.textFieldTheme,
    this.segmentedButtonStyle,
    this.splitSegmentedButtonStyle,
    this.outlinedContentButtonStyle,
    this.labeledSwitchTheme,
  });

  @visibleForTesting
  factory ResolvedThemeData.defaults(ThemeData theme) => .new(
    padding: RRulePickerThemeData.defaultPadding,
    spacing: RRulePickerThemeData.defaultSpacing,
    headerTheme: .new(
      showHeader: RRulePickerHeaderThemeData.defaultShowHeader,
      style:
          theme.textTheme.titleSmall?.copyWith(
            fontSize: RRulePickerHeaderThemeData.defaultFontSize,
            fontWeight: RRulePickerHeaderThemeData.defaultFontWeight,
          ) ??
          RRulePickerHeaderThemeData.fallbackStyle,
    ),
    dropdownTheme: const .new(
      showUnderline: RRulePickerDropdownThemeData.defaultShowUnderline,
    ),
    topDropdownTheme: const .new(
      showUnderline: RRulePickerDropdownThemeData.defaultTopShowUnderline,
    ),
    textFieldTheme: const .new(
      decoration: RRulePickerTextFieldThemeData.defaultDecoration,
    ),
    segmentedButtonStyle: RRulePickerThemeData.defaultSegmentedButtonStyle,
    splitSegmentedButtonStyle: defaultSplitSegmentedButtonStyle(theme),
    outlinedContentButtonStyle:
        RRulePickerThemeData.defaultOutlinedContentButtonStyle,
    labeledSwitchTheme: LabeledSwitchThemeData(
      style: TextButton.styleFrom(
        padding: LabeledSwitchThemeData.defaultPadding,
        shape: LabeledSwitchThemeData.defaultShape,
        textStyle: theme.textTheme.bodyLarge,
        foregroundColor: theme.colorScheme.onSurface,
      ),
    ),
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

    return .new(
      labelStyle:
          localTheme?.labelStyle ??
          globalTheme?.labelStyle ??
          defaultTheme.labelStyle,
      padding:
          localTheme?.padding ?? globalTheme?.padding ?? defaultTheme.padding,
      spacing:
          localTheme?.spacing ?? globalTheme?.spacing ?? defaultTheme.spacing,
      headerTheme: .new(
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
      topDropdownTheme: .new(
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
      textFieldTheme: .new(
        style:
            localTheme?.textFieldTheme?.style ??
            globalTheme?.textFieldTheme?.style ??
            defaultTheme.textFieldTheme?.style,
        decoration:
            localTheme?.textFieldTheme?.decoration ??
            globalTheme?.textFieldTheme?.decoration ??
            defaultTheme.textFieldTheme?.decoration,
      ),
      segmentedButtonStyle:
          localTheme?.segmentedButtonStyle ??
          globalTheme?.segmentedButtonStyle ??
          defaultTheme.segmentedButtonStyle,
      splitSegmentedButtonStyle:
          localTheme?.splitSegmentedButtonStyle ??
          globalTheme?.splitSegmentedButtonStyle ??
          defaultTheme.splitSegmentedButtonStyle,
      outlinedContentButtonStyle:
          localTheme?.outlinedContentButtonStyle ??
          globalTheme?.outlinedContentButtonStyle ??
          defaultTheme.outlinedContentButtonStyle,
      labeledSwitchTheme:
          localTheme?.labeledSwitchTheme ??
          globalTheme?.labeledSwitchTheme ??
          defaultTheme.labeledSwitchTheme,
    );
  }

  @visibleForTesting
  static ButtonStyle? defaultSplitSegmentedButtonStyle(ThemeData theme) =>
      OutlinedButton.styleFrom(
        padding: RRulePickerThemeData.defaultPadding,
        foregroundColor: theme.colorScheme.onSurface,
        shape: RRulePickerThemeData.defaultSplitSegmentedButtonSegmentShape,
        side: .new(color: theme.colorScheme.outline),
        fixedSize: RRulePickerThemeData.defaultSplitSegmentedButtonSegmentSize,
      ).copyWith(
        foregroundColor: .resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? theme.colorScheme.onSecondaryContainer
              : theme.colorScheme.onSurface;
        }),
        backgroundColor: .resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? theme.colorScheme.secondaryContainer
              : Colors.transparent;
        }),
        animationDuration: kThemeAnimationDuration,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResolvedThemeData &&
          other.runtimeType == runtimeType &&
          other.labelStyle == labelStyle &&
          other.padding == padding &&
          other.spacing == spacing &&
          other.headerTheme == headerTheme &&
          other.dropdownTheme == dropdownTheme &&
          other.topDropdownTheme == topDropdownTheme &&
          other.textFieldTheme == textFieldTheme &&
          other.segmentedButtonStyle == segmentedButtonStyle &&
          other.splitSegmentedButtonStyle == splitSegmentedButtonStyle &&
          other.outlinedContentButtonStyle == outlinedContentButtonStyle &&
          other.labeledSwitchTheme == labeledSwitchTheme;

  @override
  int get hashCode => Object.hash(
    labelStyle,
    padding,
    spacing,
    headerTheme,
    dropdownTheme,
    topDropdownTheme,
    textFieldTheme,
    segmentedButtonStyle,
    splitSegmentedButtonStyle,
    outlinedContentButtonStyle,
    labeledSwitchTheme,
  );
}
