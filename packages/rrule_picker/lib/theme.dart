// Copyright 2026 Piotr Mieczysław Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rrule_picker/src/shared/split_segmented_button.dart';

/// Theme data for customizing the appearance of the RRulePicker widget.
///
/// This class provides various styling options for different parts
/// of the picker, including labels, padding, headers, dropdowns, text fields,
/// and buttons.
class RRulePickerThemeData extends ThemeExtension<RRulePickerThemeData> {
  static const defaultPadding = EdgeInsetsGeometry.zero;
  static const defaultSpacing = RRulePickerSpacing.defaults();
  static const defaultSegmentedButtonStyle = ButtonStyle(
    visualDensity: .standard,
  );
  static const defaultSplitSegmentedButtonSegmentShape = StadiumBorder();
  static const defaultSplitSegmentedButtonSegmentSize = Size(80, 40);
  static const defaultOutlinedContentButtonStyle = ButtonStyle(
    visualDensity: .standard,
  );

  /// The text style for labels in the picker.
  final TextStyle? labelStyle;

  /// The padding around the picker.
  ///
  /// The default is [RRulePickerThemeData.defaultPadding].
  final EdgeInsetsGeometry? padding;

  final RRulePickerSpacing? spacing;

  /// Theme data for the header of the picker.
  final RRulePickerHeaderThemeData? headerTheme;

  /// Theme data for dropdown buttons in the picker.
  final RRulePickerDropdownThemeData? dropdownTheme;

  /// Theme data for dropdown buttons in the top section of the picker.
  final RRulePickerDropdownThemeData? topDropdownTheme;

  /// Theme data for text fields in the picker.
  final RRulePickerTextFieldThemeData? textFieldTheme;

  /// The style for segmented buttons in the picker.
  ///
  /// The default is [RRulePickerThemeData.defaultSegmentedButtonStyle].
  ///
  /// See [SegmentedButton.style].
  final ButtonStyle? segmentedButtonStyle;

  /// The style for [SplitSegmentedButton].
  ///
  /// [SplitSegmentedButton] is an internal Widget that by default approximates
  /// [SegmentedButton.style], but with each segment being a separate
  /// [OutlinedButton].
  ///
  /// The widget is currently used for day of week selection for "weekly"
  /// frequency.
  ///
  /// The style defaults to:
  ///
  /// ```dart
  /// OutlinedButton.styleFrom(
  ///   padding: RRulePickerThemeData.defaultPadding,
  ///   foregroundColor: theme.colorScheme.onSurface,
  ///   shape: RRulePickerThemeData.defaultSplitSegmentedButtonSegmentShape,
  ///   side: .new(color: theme.colorScheme.outline),
  ///   fixedSize: RRulePickerThemeData.defaultSplitSelectionButtonSegmentSize,
  /// ).copyWith(
  ///   foregroundColor: .resolveWith((states) {
  ///     return states.contains(WidgetState.selected)
  ///         ? theme.colorScheme.onSecondaryContainer
  ///         : theme.colorScheme.onSurface;
  ///   }),
  ///   backgroundColor: .resolveWith((states) {
  ///     return states.contains(WidgetState.selected)
  ///         ? theme.colorScheme.secondaryContainer
  ///         : Colors.transparent;
  ///   }),
  ///   animationDuration: kThemeAnimationDuration,
  /// )
  /// ```
  ///
  /// See [OutlinedButton.style] and [OutlinedButton.styleFrom].
  final ButtonStyle? splitSegmentedButtonStyle;

  /// The style for outlined content buttons in the picker.
  /// These buttons keep action results as their labels.
  ///
  /// The default is [RRulePickerThemeData.outlinedContentButtonStyle].
  ///
  /// See [OutlinedButton.style].
  final ButtonStyle? outlinedContentButtonStyle;

  /// Theme data for labeled switch buttons. These widgets approximate the look
  /// and feel of [SwitchListTile], but are actually [TextButton]s having [Row]
  /// with [Text] and [Switch] as its children.
  ///
  /// The default is:
  ///
  /// ```dart
  /// LabeledSwitchThemeData(
  ///   style: TextButton.styleFrom(
  ///     padding: LabeledSwitchThemeData.defaultPadding,
  ///     shape: LabeledSwitchThemeData.defaultShape,
  ///     textStyle: Theme.of(context).textTheme.bodyLarge,
  ///     foregroundColor: Theme.of(context).colorScheme.onSurface,
  ///   ),
  /// )
  /// ```
  final LabeledSwitchThemeData? labeledSwitchTheme;

  /// Creates a new [RRulePickerThemeData] with the provided styling options.
  ///
  /// All parameters are optional and can be null, in which case default values
  /// will be used.
  const RRulePickerThemeData({
    this.labelStyle,
    this.padding,
    this.spacing,
    this.headerTheme,
    this.dropdownTheme,
    this.topDropdownTheme,
    this.textFieldTheme,
    this.segmentedButtonStyle,
    this.splitSegmentedButtonStyle,
    this.outlinedContentButtonStyle,
    this.labeledSwitchTheme,
  });

  /// Creates a copy of this theme with the given fields replaced
  /// by the new values.
  ///
  /// If a field is not provided, the existing value is retained.
  @override
  RRulePickerThemeData copyWith({
    TextStyle? labelStyle,
    EdgeInsetsGeometry? padding,
    RRulePickerSpacing? spacing,
    RRulePickerHeaderThemeData? headerTheme,
    RRulePickerDropdownThemeData? dropdownTheme,
    RRulePickerDropdownThemeData? topDropdownTheme,
    RRulePickerTextFieldThemeData? textFieldTheme,
    ButtonStyle? segmentedButtonStyle,
    ButtonStyle? splitSegmentedButtonStyle,
    ButtonStyle? outlinedContentButtonStyle,
    LabeledSwitchThemeData? labeledSwitchTheme,
    int? narrowLayoutBreakpoint,
  }) => RRulePickerThemeData(
    labelStyle: labelStyle ?? this.labelStyle,
    padding: padding ?? this.padding,
    spacing: spacing ?? this.spacing,
    headerTheme: headerTheme ?? this.headerTheme,
    dropdownTheme: dropdownTheme ?? this.dropdownTheme,
    topDropdownTheme: topDropdownTheme ?? this.topDropdownTheme,
    textFieldTheme: textFieldTheme ?? this.textFieldTheme,
    segmentedButtonStyle: segmentedButtonStyle ?? this.segmentedButtonStyle,
    splitSegmentedButtonStyle:
        splitSegmentedButtonStyle ?? this.splitSegmentedButtonStyle,
    outlinedContentButtonStyle:
        outlinedContentButtonStyle ?? this.outlinedContentButtonStyle,
    labeledSwitchTheme: labeledSwitchTheme ?? this.labeledSwitchTheme,
  );

  /// Linearly interpolates between this theme and another theme.
  ///
  /// The [t] argument is a value between 0 and 1, where 0 returns this theme
  /// and 1 returns the [other] theme.
  @override
  RRulePickerThemeData lerp(covariant RRulePickerThemeData? other, double t) {
    if (other == null || identical(this, other)) {
      return this;
    }

    return RRulePickerThemeData(
      labelStyle: TextStyle.lerp(labelStyle, other.labelStyle, t),
      padding: EdgeInsetsGeometry.lerp(padding, other.padding, t),
      spacing: RRulePickerSpacing.lerp(spacing, other.spacing, t),
      headerTheme: RRulePickerHeaderThemeData.lerp(
        headerTheme,
        other.headerTheme,
        t,
      ),
      dropdownTheme: RRulePickerDropdownThemeData.lerp(
        dropdownTheme,
        other.dropdownTheme,
        t,
      ),
      topDropdownTheme: RRulePickerDropdownThemeData.lerp(
        topDropdownTheme,
        other.topDropdownTheme,
        t,
      ),
      textFieldTheme: RRulePickerTextFieldThemeData.lerp(
        textFieldTheme,
        other.textFieldTheme,
        t,
      ),
      segmentedButtonStyle: ButtonStyle.lerp(
        segmentedButtonStyle,
        other.segmentedButtonStyle,
        t,
      ),
      splitSegmentedButtonStyle: ButtonStyle.lerp(
        splitSegmentedButtonStyle,
        other.splitSegmentedButtonStyle,
        t,
      ),
      outlinedContentButtonStyle: ButtonStyle.lerp(
        outlinedContentButtonStyle,
        other.outlinedContentButtonStyle,
        t,
      ),
      labeledSwitchTheme: LabeledSwitchThemeData.lerp(
        labeledSwitchTheme,
        other.labeledSwitchTheme,
        t,
      ),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RRulePickerThemeData &&
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

/// Theme data for customizing the header of the RRulePicker widget.
class RRulePickerHeaderThemeData {
  static const defaultShowHeader = true;
  static const defaultFontSize = 16.0;
  static const defaultFontWeight = FontWeight.bold;
  static const fallbackStyle = TextStyle(
    fontSize: defaultFontSize,
    fontWeight: defaultFontWeight,
  );

  /// Whether to show the header.
  final bool? showHeader;

  /// The text style for the header.
  final TextStyle? style;

  /// Creates a new [RRulePickerHeaderThemeData] with the provided styling
  /// options.
  ///
  /// All parameters are optional and can be null, in which case default values
  /// will be used.
  const RRulePickerHeaderThemeData({this.showHeader, this.style});

  /// Creates a copy of this theme with the given fields replaced
  /// by the new values.
  ///
  /// If a field is not provided, the existing value is retained.
  RRulePickerHeaderThemeData copyWith({bool? showHeader, TextStyle? style}) =>
      RRulePickerHeaderThemeData(
        showHeader: showHeader ?? this.showHeader,
        style: style ?? this.style,
      );

  /// Linearly interpolates between two header themes.
  ///
  /// The [t] argument is a value between 0 and 1, where 0 returns
  /// the first theme and 1 returns the second theme.
  static RRulePickerHeaderThemeData? lerp(
    RRulePickerHeaderThemeData? a,
    RRulePickerHeaderThemeData? b,
    double t,
  ) {
    if (identical(a, b)) {
      return a;
    }

    if (a == null && b == null) {
      return null;
    }

    return RRulePickerHeaderThemeData(
      showHeader: t < 0.5 ? a?.showHeader : b?.showHeader,
      style: TextStyle.lerp(a?.style, b?.style, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RRulePickerHeaderThemeData &&
          other.runtimeType == runtimeType &&
          other.showHeader == showHeader &&
          other.style == style;

  @override
  int get hashCode => Object.hash(showHeader, style);
}

/// Theme data for customizing dropdown buttons in the RRulePicker widget.
class RRulePickerDropdownThemeData {
  static const bool defaultShowUnderline = true;
  static const bool defaultTopShowUnderline = false;

  /// Whether to show an underline for the dropdown.
  final bool? showUnderline;

  /// The text style for the dropdown button.
  final TextStyle? style;

  /// The decoration for the dropdown button.
  final BoxDecoration? decoration;

  /// The text style for dropdown menu items.
  final TextStyle? menuItemStyle;

  /// The decoration for dropdown menu items.
  final BoxDecoration? menuItemDecoration;

  /// Creates a new [RRulePickerDropdownThemeData] with the provided styling
  /// options.
  ///
  /// All parameters are optional and can be null, in which case default values
  /// will be used.
  const RRulePickerDropdownThemeData({
    this.showUnderline,
    this.style,
    this.decoration,
    this.menuItemStyle,
    this.menuItemDecoration,
  });

  /// Creates a copy of this theme with the given fields replaced
  /// by the new values.
  ///
  /// If a field is not provided, the existing value is retained.
  RRulePickerDropdownThemeData copyWith({
    bool? showUnderline,
    TextStyle? style,
    BoxDecoration? decoration,
    TextStyle? menuItemStyle,
    BoxDecoration? menuItemDecoration,
  }) => RRulePickerDropdownThemeData(
    showUnderline: showUnderline ?? this.showUnderline,
    style: style ?? this.style,
    decoration: decoration ?? this.decoration,
    menuItemStyle: menuItemStyle ?? this.menuItemStyle,
    menuItemDecoration: menuItemDecoration ?? this.menuItemDecoration,
  );

  /// Linearly interpolates between two dropdown themes.
  ///
  /// The [t] argument is a value between 0 and 1, where 0 returns the
  /// first theme and 1 returns the second theme.
  static RRulePickerDropdownThemeData? lerp(
    RRulePickerDropdownThemeData? a,
    RRulePickerDropdownThemeData? b,
    double t,
  ) {
    if (identical(a, b)) {
      return a;
    }

    if (a == null && b == null) {
      return null;
    }

    return RRulePickerDropdownThemeData(
      showUnderline: t < 0.5 ? a?.showUnderline : b?.showUnderline,
      style: TextStyle.lerp(a?.style, b?.style, t),
      decoration: BoxDecoration.lerp(a?.decoration, b?.decoration, t),
      menuItemStyle: TextStyle.lerp(a?.menuItemStyle, b?.menuItemStyle, t),
      menuItemDecoration: BoxDecoration.lerp(
        a?.menuItemDecoration,
        b?.menuItemDecoration,
        t,
      ),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RRulePickerDropdownThemeData &&
          other.runtimeType == runtimeType &&
          other.showUnderline == showUnderline &&
          other.style == style &&
          other.decoration == decoration &&
          other.menuItemStyle == menuItemStyle &&
          other.menuItemDecoration == menuItemDecoration;

  @override
  int get hashCode => Object.hash(
    showUnderline,
    style,
    decoration,
    menuItemStyle,
    menuItemDecoration,
  );
}

/// Theme data for customizing text fields in the RRulePicker widget.
class RRulePickerTextFieldThemeData {
  static const defaultDecoration = InputDecoration(isDense: true);

  /// The text style for the text field.
  final TextStyle? style;

  /// The decoration for the text field.
  final InputDecoration? decoration;

  /// Creates a new [RRulePickerTextFieldThemeData] with the provided styling
  /// options.
  ///
  /// All parameters are optional and can be null, in which case default values
  /// will be used.
  const RRulePickerTextFieldThemeData({this.style, this.decoration});

  /// Creates a copy of this theme with the given fields replaced
  /// by the new values.
  ///
  /// If a field is not provided, the existing value is retained.
  RRulePickerTextFieldThemeData copyWith({
    TextStyle? style,
    InputDecoration? decoration,
  }) => RRulePickerTextFieldThemeData(
    style: style ?? this.style,
    decoration: decoration ?? this.decoration,
  );

  /// Linearly interpolates between two text field themes.
  ///
  /// The [t] argument is a value between 0 and 1, where 0 returns
  /// the first theme and 1 returns the second theme.
  static RRulePickerTextFieldThemeData? lerp(
    RRulePickerTextFieldThemeData? a,
    RRulePickerTextFieldThemeData? b,
    double t,
  ) {
    if (identical(a, b)) {
      return a;
    }

    if (a == null && b == null) {
      return null;
    }

    return RRulePickerTextFieldThemeData(
      style: TextStyle.lerp(a?.style, b?.style, t),
      decoration: t < 0.5 ? a?.decoration : b?.decoration,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RRulePickerTextFieldThemeData &&
          other.runtimeType == runtimeType &&
          other.style == style &&
          other.decoration == decoration;

  @override
  int get hashCode => Object.hash(style, decoration);
}

/// Theme data for customizing labeled switches in the RRulePicker widget.
class LabeledSwitchThemeData {
  /// Default shape used by [style].
  static const defaultShape = StadiumBorder();

  /// Default padding used by [style].
  static const defaultPadding = EdgeInsets.symmetric(horizontal: 16);

  /// The style for the button part of the labeled switch.
  final ButtonStyle? style;

  /// The theme for the switch part of the labeled switch.
  final SwitchThemeData? switchTheme;

  /// Creates a new [LabeledSwitchThemeData] with the provided styling options.
  ///
  /// All parameters are optional and can be null, in which case default values
  /// will be used.
  const LabeledSwitchThemeData({this.style, this.switchTheme});

  /// Creates a copy of this theme with the given fields replaced
  /// by the new values.
  ///
  /// If a field is not provided, the existing value is retained.
  LabeledSwitchThemeData copyWith({
    ButtonStyle? style,
    SwitchThemeData? switchTheme,
  }) => LabeledSwitchThemeData(
    style: style ?? this.style,
    switchTheme: switchTheme ?? this.switchTheme,
  );

  /// Linearly interpolates between two labeled switch themes.
  ///
  /// The [t] argument is a value between 0 and 1, where 0 returns
  /// the first theme and 1 returns the second theme.
  static LabeledSwitchThemeData? lerp(
    LabeledSwitchThemeData? a,
    LabeledSwitchThemeData? b,
    double t,
  ) {
    if (identical(a, b)) {
      return a;
    }

    if (a == null && b == null) {
      return null;
    }

    return LabeledSwitchThemeData(
      style: ButtonStyle.lerp(a?.style, b?.style, t),
      switchTheme: SwitchThemeData.lerp(a?.switchTheme, b?.switchTheme, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LabeledSwitchThemeData &&
          other.runtimeType == runtimeType &&
          other.style == style &&
          other.switchTheme == switchTheme;

  @override
  int get hashCode => Object.hash(style, switchTheme);
}

/// Theme data for customizing spacing in the RRulePicker widget.
class RRulePickerSpacing {
  /// The spacing between items in a row (main axis).
  final double row;

  /// The spacing between items in a column (main axis).
  final double column;

  /// Creates a new [RRulePickerSpacing] with the provided spacing values.
  const RRulePickerSpacing({required this.row, required this.column});

  /// Creates a new [RRulePickerSpacing] with the default spacing values.
  ///
  /// All parameters are optional and can be null, in which case default values
  /// will be used.
  const RRulePickerSpacing.defaults({this.row = 8.0, this.column = 8.0});

  /// Creates a copy of this spacing with the given fields replaced
  /// by the new values.
  ///
  /// If a field is not provided, the existing value is retained.
  RRulePickerSpacing copyWith({double? row, double? column}) =>
      RRulePickerSpacing(row: row ?? this.row, column: column ?? this.column);

  /// Linearly interpolates between two spacing configurations.
  ///
  /// The [t] argument is a value between 0 and 1, where 0 returns
  /// the first spacing and 1 returns the second spacing.
  static RRulePickerSpacing? lerp(
    RRulePickerSpacing? a,
    RRulePickerSpacing? b,
    double t,
  ) {
    if (identical(a, b)) {
      return a;
    }

    if (a == null && b == null) {
      return null;
    }

    return RRulePickerSpacing(
      row: lerpDouble(a?.row, b?.row, t)!,
      column: lerpDouble(a?.column, b?.column, t)!,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RRulePickerSpacing &&
          other.runtimeType == runtimeType &&
          other.row == row &&
          other.column == column;

  @override
  int get hashCode => Object.hash(row, column);
}
