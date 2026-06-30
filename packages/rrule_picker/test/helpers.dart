// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rrule_picker/localizations/localizations.dart';
import 'package:spot/spot.dart';

extension PumpWrapped on WidgetTester {
  Future<void> pumpWrapped(
    Widget widget, {
    Locale locale = const Locale('en'),
  }) => pumpWidget(
    MaterialApp(
      locale: locale,
      supportedLocales: RRulePickerLocalizations.supportedLocales,
      localizationsDelegates: RRulePickerLocalizations.localizationsDelegates,
      home: Scaffold(body: Center(child: widget)),
    ),
  );
}

extension Localizations on WidgetTester {
  RRulePickerLocalizations localizations<T extends Widget>() {
    final widget = spot<T>().existsOnce().element;
    return RRulePickerLocalizations.of(widget);
  }
}

extension IgnoreErrors on void Function() {
  /// Catches and ignores [Error]s. Useful, for example, when calling
  /// `dispose()` on a `late` instance, that hasn't been initialized.
  void callIgnoringErrors() {
    try {
      call();
    } on Error {
      // noop
    }
  }
}
