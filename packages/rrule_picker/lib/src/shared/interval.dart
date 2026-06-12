// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rrule_picker/src/shared/parsing.dart';
import 'package:rrule_picker/src/shared/resolved_theme.dart';

@internal
class IntervalPicker extends StatelessWidget {
  final String Function(int interval) everyUnitText;
  final String Function(int interval) intervalUnitText;
  final TextEditingController intervalController;
  final ValueNotifier<int> intervalNotifier;

  const IntervalPicker({
    super.key,
    required this.everyUnitText,
    required this.intervalUnitText,
    required this.intervalController,
    required this.intervalNotifier,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ResolvedTheme.of(context);

    final everyLabel = ValueListenableBuilder(
      valueListenable: intervalNotifier,
      builder: (context, count, _) =>
          Text(everyUnitText(count), style: theme.labelStyle),
    );

    final countField = Expanded(
      child: TextField(
        controller: intervalController,
        keyboardType: .number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          const IntervalPickerValueInputFormatter(),
        ],
        style: theme.textFieldTheme?.style,
        decoration: theme.textFieldTheme?.decoration,
        onChanged: (value) {
          if (int.tryParse(value) case final count?) {
            intervalNotifier.value = count;
          }
        },
      ),
    );

    final daysLabel = ValueListenableBuilder(
      valueListenable: intervalNotifier,
      builder: (context, count, _) =>
          Text(intervalUnitText(count), style: theme.labelStyle),
    );

    return Row(
      children: [
        everyLabel,
        const SizedBox(width: 8),
        countField,
        const SizedBox(width: 8),
        daysLabel,
      ],
    );
  }
}

@internal
class IntervalPickerValueInputFormatter extends TextInputFormatter {
  const IntervalPickerValueInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) => switch (int.tryParse(newValue.text)) {
    final value? when value < intervalMin => oldValue,
    _ => newValue,
  };
}

@internal
mixin IntervalPickerState {
  late final int initialIntervalValue;
  late final ValueNotifier<int> intervalNotifier;
  late final TextEditingController intervalController;

  @protected
  @mustCallSuper
  void initIntervalState({
    int initialValue = defaultInterval,
    required VoidCallback listener,
  }) {
    initialIntervalValue = initialValue;
    intervalNotifier = .new(initialIntervalValue)..addListener(listener);
    intervalController = .new(text: intervalNotifier.value.toString());
  }

  @protected
  @mustCallSuper
  void disposeIntervalState() {
    intervalController.dispose();
    intervalNotifier.dispose();
  }

  @protected
  void setIntervalValue(int value) {
    intervalNotifier.value = value;
    intervalController.text = value.toString();
  }

  int getIntervalValue({int minValue = intervalMin, int? defaultValue}) =>
      intervalNotifier.value < minValue
      ? (defaultValue ?? initialIntervalValue)
      : intervalNotifier.value;
}

@internal
mixin IntervalPickerSegmentTypeState {
  late final ValueNotifier<Set<IntervalPickerSegmentType>> intervalSegmentType;

  @protected
  @mustCallSuper
  void initIntervalSegmentTypeState({
    Set<IntervalPickerSegmentType> initialSegmentType = const {.precise},
    required VoidCallback listener,
  }) =>
      intervalSegmentType = ValueNotifier(initialSegmentType)
        ..addListener(listener);

  @protected
  @mustCallSuper
  void disposeIntervalSegmentTypeState() => intervalSegmentType.dispose();

  @protected
  void setIntervalSegmentTypeValue(
    Set<IntervalPickerSegmentType> segmentType,
  ) => intervalSegmentType.value = segmentType;
}

@internal
enum IntervalPickerSegmentType { precise, relative }
