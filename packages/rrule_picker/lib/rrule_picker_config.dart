// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';

class RRulePickerConfig {
  final EdgeInsetsGeometry padding;
  final RRulePickerHeaderStyle headerStyle;
  final RRulePickerDropdownStyle dropdownStyle;

  const RRulePickerConfig({
    this.padding = const .only(),
    this.headerStyle = const .new(),
    this.dropdownStyle = const .new(),
  });
}

class RRulePickerHeaderStyle {
  final bool enabled;
  final TextStyle textStyle;

  const RRulePickerHeaderStyle({
    this.enabled = true,
    this.textStyle = const .new(fontSize: 18, fontWeight: .bold),
  });
}

class RRulePickerDropdownStyle {
  final TextStyle? textStyle;
  final BoxDecoration? decoration;
  final TextStyle? menuItemTextStyle;
  final BoxDecoration? menuItemDecoration;

  const RRulePickerDropdownStyle({
    this.textStyle,
    this.decoration,
    this.menuItemTextStyle,
    this.menuItemDecoration,
  });
}
