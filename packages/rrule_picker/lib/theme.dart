// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:rrule_picker/src/shared/split_segmented_button.dart';

/// Theme data for customizing the appearance of the RRulePicker widget.
///
/// This class provides various styling options for different parts
/// of the picker, including labels, padding, headers, dropdowns, text fields,
/// and buttons.
class RRulePickerThemeData extends ThemeExtension<RRulePickerThemeData> {
  static const defaultPadding = EdgeInsets.all(0);
  static const defaultSegmentedButtonStyle = ButtonStyle(
    visualDensity: .standard,
  );

  /// The text style for labels in the picker.
  final TextStyle? labelStyle;

  /// The padding around the picker.
  ///
  /// The default is [RRulePickerThemeData.defaultPadding].
  final EdgeInsetsGeometry? padding;

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
  /// This is an internal Widget that by default approximates
  /// [SegmentedButton.style], but with each segment being a separate [InkWell]
  /// with its own [StadiumBorder].
  ///
  /// The properties used by the widget buttons are:
  ///
  /// * [ButtonStyle.textStyle].
  /// * [ButtonStyle.foregroundColor] - used with default text style only.
  /// * [ButtonStyle.backgroundColor].
  /// * [ButtonStyle.shape].
  /// * [ButtonStyle.side] - used with default shape only.
  /// * [ButtonStyle.fixedSize].
  /// * [ButtonStyle.animationDuration] - used for button tap animation.
  final ButtonStyle? splitSegmentedButtonStyle;

  /// Creates a new [RRulePickerThemeData] with the provided styling options.
  ///
  /// All parameters are optional and can be null, in which case default values
  /// will be used.
  const RRulePickerThemeData({
    this.labelStyle,
    this.padding,
    this.headerTheme,
    this.dropdownTheme,
    this.topDropdownTheme,
    this.textFieldTheme,
    this.segmentedButtonStyle,
    this.splitSegmentedButtonStyle,
  });

  /// Creates a copy of this theme with the given fields replaced
  /// by the new values.
  ///
  /// If a field is not provided, the existing value is retained.
  @override
  RRulePickerThemeData copyWith({
    TextStyle? labelStyle,
    EdgeInsetsGeometry? padding,
    RRulePickerHeaderThemeData? headerTheme,
    RRulePickerDropdownThemeData? dropdownTheme,
    RRulePickerDropdownThemeData? topDropdownTheme,
    RRulePickerTextFieldThemeData? textFieldTheme,
    ButtonStyle? segmentedButtonStyle,
    ButtonStyle? splitSegmentedButtonStyle,
    int? narrowLayoutBreakpoint,
  }) => RRulePickerThemeData(
    labelStyle: labelStyle ?? this.labelStyle,
    padding: padding ?? this.padding,
    headerTheme: headerTheme ?? this.headerTheme,
    dropdownTheme: dropdownTheme ?? this.dropdownTheme,
    topDropdownTheme: topDropdownTheme ?? this.topDropdownTheme,
    textFieldTheme: textFieldTheme ?? this.textFieldTheme,
    segmentedButtonStyle: segmentedButtonStyle ?? this.segmentedButtonStyle,
    splitSegmentedButtonStyle:
        splitSegmentedButtonStyle ?? this.splitSegmentedButtonStyle,
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
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other)
      ? true
      : other is RRulePickerThemeData &&
            other.labelStyle == labelStyle &&
            other.padding == padding &&
            other.headerTheme == headerTheme &&
            other.dropdownTheme == dropdownTheme &&
            other.topDropdownTheme == topDropdownTheme &&
            other.textFieldTheme == textFieldTheme &&
            other.segmentedButtonStyle == segmentedButtonStyle &&
            other.splitSegmentedButtonStyle == splitSegmentedButtonStyle;

  @override
  int get hashCode => Object.hash(
    labelStyle,
    padding,
    headerTheme,
    dropdownTheme,
    topDropdownTheme,
    textFieldTheme,
    segmentedButtonStyle,
    splitSegmentedButtonStyle,
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
  bool operator ==(Object other) => identical(this, other)
      ? true
      : other is RRulePickerHeaderThemeData &&
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
  bool operator ==(Object other) => identical(this, other)
      ? true
      : other is RRulePickerDropdownThemeData &&
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
  bool operator ==(Object other) => identical(this, other)
      ? true
      : other is RRulePickerTextFieldThemeData &&
            other.style == style &&
            other.decoration == decoration;

  @override
  int get hashCode => Object.hash(style, decoration);
}
