// Copyright 2026 Piotr Mieczysław Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/foundation.dart';

@internal
abstract class PickerController {
  const PickerController();

  @mustCallSuper
  void dispose();
  void setRRule(String rrule);
  void buildRRulePart(StringBuffer sb);
}
