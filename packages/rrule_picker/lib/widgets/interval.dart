// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rrule_picker/parsing.dart';
import 'package:rrule_picker/rrule_picker.dart';

class RRulePickerInterval extends StatelessWidget {
  final String Function(int interval) everyUnitText;
  final String Function(int interval) intervalUnitText;
  final TextEditingController intervalController;
  final ValueNotifier<int> intervalNotifier;
  final RRulePickerConfig config;

  const RRulePickerInterval({
    super.key,
    required this.everyUnitText,
    required this.intervalUnitText,
    required this.intervalController,
    required this.intervalNotifier,
    this.config = const RRulePickerConfig(),
  });

  @override
  Widget build(BuildContext context) {
    final everyLabel = ValueListenableBuilder(
      valueListenable: intervalNotifier,
      builder: (context, count, _) =>
          Text(everyUnitText(count), style: config.labelStyle),
    );

    final countField = Expanded(
      child: TextField(
        controller: intervalController,
        keyboardType: .number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          const _RRulePickerIntervalValueInputFormatter(),
        ],
        style: config.textFieldStyle.textStyle,
        decoration: config.textFieldStyle.decoration,
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
          Text(intervalUnitText(count), style: config.labelStyle),
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

class _RRulePickerIntervalValueInputFormatter extends TextInputFormatter {
  const _RRulePickerIntervalValueInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) => switch (int.tryParse(newValue.text)) {
    final value? when value < intervalMin => oldValue,
    _ => newValue,
  };
}

mixin RRulePickerIntervalState {
  late final int initialIntervalValue;
  late final ValueNotifier<int> intervalNotifier;
  late final TextEditingController intervalController;

  @protected
  @mustCallSuper
  void initIntervalState([int initialValue = defaultInterval]) {
    initialIntervalValue = initialValue;
    intervalNotifier = .new(initialIntervalValue);
    intervalController = .new(text: intervalNotifier.value.toString());
  }

  @protected
  @mustCallSuper
  void disposeIntervalState() {
    intervalController.dispose();
    intervalNotifier.dispose();
  }

  int getIntervalValue({int minValue = intervalMin, int? defaultValue}) =>
      intervalNotifier.value < minValue
      ? (defaultValue ?? initialIntervalValue)
      : intervalNotifier.value;
}

mixin RRulePickerIntervalSegmentTypeState {
  late final ValueNotifier<Set<RRulePickerIntervalSegmentType>>
  intervalSegmentType;

  @protected
  @mustCallSuper
  void initIntervalSegmentTypeState([
    Set<RRulePickerIntervalSegmentType> segmentType = const {.precise},
  ]) => intervalSegmentType = ValueNotifier(segmentType);

  @protected
  @mustCallSuper
  void disposeIntervalSegmentTypeState() => intervalSegmentType.dispose();
}

enum RRulePickerIntervalSegmentType { precise, relative }
