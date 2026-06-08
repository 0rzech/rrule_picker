// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';

class RRulePickerThemeData extends ThemeExtension<RRulePickerThemeData> {
  final TextStyle? labelStyle;
  final EdgeInsetsGeometry? padding;

  final bool? showHeader;
  final TextStyle? headerStyle;

  final TextStyle? dropdownLabelStyle;
  final BoxDecoration? dropdownDecoration;
  final TextStyle? dropdownMenuItemStyle;
  final BoxDecoration? dropdownMenuItemDecoration;

  final TextStyle? textFieldStyle;
  final InputDecoration? textFieldDecoration;

  final ButtonStyle? segmentedButtonStyle;

  const RRulePickerThemeData({
    this.labelStyle,
    this.padding,
    this.showHeader,
    this.headerStyle,
    this.dropdownLabelStyle,
    this.dropdownDecoration,
    this.dropdownMenuItemStyle,
    this.dropdownMenuItemDecoration,
    this.textFieldStyle,
    this.textFieldDecoration,
    this.segmentedButtonStyle,
  });

  static const defaultPadding = EdgeInsets.all(0);
  static const defaultShowHeader = true;
  static const defaultHeaderFontSize = 16.0;
  static const defaultHeaderFontWeight = FontWeight.bold;
  static const fallbackHeaderStyle = TextStyle(
    fontSize: defaultHeaderFontSize,
    fontWeight: defaultHeaderFontWeight,
  );
  static const defaultTextFieldDecoration = InputDecoration(isDense: true);
  static const defaultSegmentedButtonStyle = ButtonStyle(
    visualDensity: .standard,
    shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: .zero)),
  );

  @override
  ThemeExtension<RRulePickerThemeData> copyWith({
    TextStyle? labelStyle,
    EdgeInsetsGeometry? padding,
    bool? showHeader,
    TextStyle? headerStyle,
    TextStyle? dropdownLabelStyle,
    BoxDecoration? dropdownDecoration,
    TextStyle? dropdownMenuItemStyle,
    BoxDecoration? dropdownMenuItemDecoration,
    TextStyle? textFieldStyle,
    InputDecoration? textFieldDecoration,
    ButtonStyle? segmentedButtonStyle,
  }) => RRulePickerThemeData(
    labelStyle: labelStyle ?? this.labelStyle,
    padding: padding ?? this.padding,
    showHeader: showHeader ?? this.showHeader,
    headerStyle: headerStyle ?? this.headerStyle,
    dropdownLabelStyle: dropdownLabelStyle ?? this.dropdownLabelStyle,
    dropdownDecoration: dropdownDecoration ?? this.dropdownDecoration,
    dropdownMenuItemStyle: dropdownMenuItemStyle ?? this.dropdownMenuItemStyle,
    dropdownMenuItemDecoration:
        dropdownMenuItemDecoration ?? this.dropdownMenuItemDecoration,
    textFieldStyle: textFieldStyle ?? this.textFieldStyle,
    textFieldDecoration: textFieldDecoration ?? this.textFieldDecoration,
    segmentedButtonStyle: segmentedButtonStyle ?? this.segmentedButtonStyle,
  );

  @override
  ThemeExtension<RRulePickerThemeData> lerp(
    covariant ThemeExtension<RRulePickerThemeData>? other,
    double t,
  ) => other is RRulePickerThemeData
      ? RRulePickerThemeData(
          labelStyle: TextStyle.lerp(labelStyle, other.labelStyle, t),
          padding: EdgeInsetsGeometry.lerp(padding, other.padding, t),
          showHeader: showHeader,
          headerStyle: TextStyle.lerp(headerStyle, other.headerStyle, t),
          dropdownLabelStyle: TextStyle.lerp(
            dropdownLabelStyle,
            other.dropdownLabelStyle,
            t,
          ),
          dropdownDecoration: BoxDecoration.lerp(
            dropdownDecoration,
            other.dropdownDecoration,
            t,
          ),
          dropdownMenuItemStyle: TextStyle.lerp(
            dropdownMenuItemStyle,
            other.dropdownMenuItemStyle,
            t,
          ),
          dropdownMenuItemDecoration: BoxDecoration.lerp(
            dropdownMenuItemDecoration,
            other.dropdownMenuItemDecoration,
            t,
          ),
          textFieldStyle: TextStyle.lerp(
            textFieldStyle,
            other.textFieldStyle,
            t,
          ),
          textFieldDecoration: textFieldDecoration,
          segmentedButtonStyle: ButtonStyle.lerp(
            segmentedButtonStyle,
            other.segmentedButtonStyle,
            t,
          ),
        )
      : this;
}
