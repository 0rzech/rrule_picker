// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';

abstract class RRuleWidgetController<T extends StatefulWidget> {
  final String initialRRule;
  RRulePartBuilder? _rrulePartBuilder;

  RRuleWidgetController(this.initialRRule);

  @protected
  set rrulePartBuilder(RRulePartBuilder? value) => _rrulePartBuilder = value;

  void buildRRulePart(StringBuffer sb) {
    final buildFn = _rrulePartBuilder;
    return buildFn == null ? sb.write(initialRRule) : buildFn(sb);
  }
}

typedef RRulePartBuilder = void Function(StringBuffer sb);
