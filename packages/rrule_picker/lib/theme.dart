// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';

class RRulePickerThemeData extends ThemeExtension<RRulePickerThemeData> {
  static const defaultPadding = EdgeInsets.all(0);
  static const defaultSegmentedButtonStyle = ButtonStyle(
    visualDensity: .standard,
    shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: .zero)),
  );

  final TextStyle? labelStyle;
  final EdgeInsetsGeometry? padding;
  final RRulePickerHeaderThemeData? headerTheme;
  final RRulePickerDropdownThemeData? dropdownTheme;
  final RRulePickerDropdownThemeData? topDropdownTheme;
  final RRulePickerTextFieldThemeData? textFieldTheme;
  final ButtonStyle? segmentedButtonStyle;
  final ButtonStyle? weekdaySelectionButtonStyle;

  const RRulePickerThemeData({
    this.labelStyle,
    this.padding,
    this.headerTheme,
    this.dropdownTheme,
    this.topDropdownTheme,
    this.textFieldTheme,
    this.segmentedButtonStyle,
    this.weekdaySelectionButtonStyle,
  });

  @override
  ThemeExtension<RRulePickerThemeData> copyWith({
    TextStyle? labelStyle,
    EdgeInsetsGeometry? padding,
    RRulePickerHeaderThemeData? headerTheme,
    RRulePickerDropdownThemeData? dropdownTheme,
    RRulePickerDropdownThemeData? topDropdownTheme,
    RRulePickerTextFieldThemeData? textFieldTheme,
    ButtonStyle? segmentedButtonStyle,
    ButtonStyle? weekdaySelectionButtonStyle,
  }) => RRulePickerThemeData(
    labelStyle: labelStyle ?? this.labelStyle,
    padding: padding ?? this.padding,
    headerTheme: headerTheme ?? this.headerTheme,
    dropdownTheme: dropdownTheme ?? this.dropdownTheme,
    topDropdownTheme: topDropdownTheme ?? this.topDropdownTheme,
    textFieldTheme: textFieldTheme ?? this.textFieldTheme,
    segmentedButtonStyle: segmentedButtonStyle ?? this.segmentedButtonStyle,
    weekdaySelectionButtonStyle:
        weekdaySelectionButtonStyle ?? this.weekdaySelectionButtonStyle,
  );

  @override
  ThemeExtension<RRulePickerThemeData> lerp(
    covariant ThemeExtension<RRulePickerThemeData>? other,
    double t,
  ) {
    if (identical(this, other) || other is! RRulePickerThemeData) {
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
      weekdaySelectionButtonStyle: ButtonStyle.lerp(
        weekdaySelectionButtonStyle,
        other.weekdaySelectionButtonStyle,
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

class RRulePickerHeaderThemeData {
  static const defaultShowHeader = true;
  static const defaultFontSize = 16.0;
  static const defaultFontWeight = FontWeight.bold;
  static const fallbackStyle = TextStyle(
    fontSize: defaultFontSize,
    fontWeight: defaultFontWeight,
  );

  final bool? showHeader;
  final TextStyle? style;

  const RRulePickerHeaderThemeData({this.showHeader, this.style});

  RRulePickerHeaderThemeData copyWith({bool? showHeader, TextStyle? style}) =>
      RRulePickerHeaderThemeData(
        showHeader: showHeader ?? this.showHeader,
        style: style ?? this.style,
      );

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

class RRulePickerDropdownThemeData {
  static const bool defaultShowUnderline = true;
  static const bool defaultTopShowUnderline = false;

  final bool? showUnderline;
  final TextStyle? style;
  final BoxDecoration? decoration;
  final TextStyle? menuItemStyle;
  final BoxDecoration? menuItemDecoration;

  const RRulePickerDropdownThemeData({
    this.showUnderline,
    this.style,
    this.decoration,
    this.menuItemStyle,
    this.menuItemDecoration,
  });

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

class RRulePickerTextFieldThemeData {
  static const defaultDecoration = InputDecoration(isDense: true);

  final TextStyle? style;
  final InputDecoration? decoration;

  const RRulePickerTextFieldThemeData({this.style, this.decoration});

  RRulePickerTextFieldThemeData copyWith({
    TextStyle? style,
    InputDecoration? decoration,
  }) => RRulePickerTextFieldThemeData(
    style: style ?? this.style,
    decoration: decoration ?? this.decoration,
  );

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
