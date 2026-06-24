// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/foundation.dart';

@internal
class SetValueNotifier<T> extends ValueNotifier<Set<T>> {
  SetValueNotifier(super.value);

  @override
  set value(Set<T> newValue) {
    if (identical(value, newValue) ||
        (value.length == newValue.length && value.containsAll(newValue))) {
      return;
    }

    super.value = newValue;
  }
}
