// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

extension PumpWrapped on WidgetTester {
  Future<void> pumpWrapped(Widget widget) => pumpWidget(
    MaterialApp(
      home: Scaffold(body: Center(child: widget)),
    ),
  );
}
