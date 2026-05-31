// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';

abstract class RRuleWidgetController<T extends StatefulWidget> {
  final String initialRRule;
  RRuleBuilder? _rruleBuilder;

  RRuleWidgetController(this.initialRRule);

  @protected
  set rruleBuilder(RRuleBuilder? value) => _rruleBuilder = value;

  void buildRRulePart(StringBuffer sb) =>
      _rruleBuilder == null ? sb.write(initialRRule) : _rruleBuilder!.call(sb);
}

typedef RRuleBuilder = void Function(StringBuffer sb);
