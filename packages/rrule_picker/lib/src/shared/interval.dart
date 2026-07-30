// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:rrule_picker/l10n/l10n.dart';
import 'package:rrule_picker/src/shared/parsing.dart';
import 'package:rrule_picker/src/shared/picker.dart';
import 'package:rrule_picker/src/shared/resolved_theme.dart';

@internal
class IntervalPicker extends StatelessWidget {
  final String Function(int interval) everyUnitText;
  final String Function(int interval) intervalUnitText;
  final IntervalPickerController controller;

  const IntervalPicker({
    super.key,
    required this.everyUnitText,
    required this.intervalUnitText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ResolvedTheme.of(context);

    final everyLabel = ValueListenableBuilder(
      valueListenable: controller.intervalNotifier,
      builder: (context, count, _) =>
          Text(everyUnitText(count), style: theme.labelStyle),
    );

    final countField = Expanded(
      child: TextField(
        controller: controller.intervalController,
        keyboardType: .number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          const IntervalPickerValueInputFormatter(),
        ],
        style: theme.textFieldTheme?.style,
        decoration: theme.textFieldTheme?.decoration,
        onChanged: (value) {
          if (int.tryParse(value) case final count?) {
            controller.intervalNotifier.value = count;
          }
        },
      ),
    );

    final daysLabel = ValueListenableBuilder(
      valueListenable: controller.intervalNotifier,
      builder: (context, count, _) =>
          Text(intervalUnitText(count), style: theme.labelStyle),
    );

    return Row(
      spacing: theme.spacing.row,
      children: [everyLabel, countField, daysLabel],
    );
  }
}

@visibleForTesting
@internal
class IntervalPickerValueInputFormatter extends TextInputFormatter {
  const IntervalPickerValueInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) => newValue.text.isEmpty
      ? newValue
      : switch (int.tryParse(newValue.text)) {
          null || < intervalMin => oldValue,
          _ => newValue,
        };
}

@internal
abstract class IntervalPickerController extends PickerController {
  final int initialInterval;
  late final ValueNotifier<int> intervalNotifier;
  late final TextEditingController intervalController;

  IntervalPickerController({
    required VoidCallback listener,
    int initialInterval = defaultInterval,
  }) : initialInterval = initialInterval {
    intervalNotifier = .new(initialInterval)..addListener(listener);
    intervalController = .new(text: intervalNotifier.value.toString());
  }

  @override
  void dispose() {
    intervalController.dispose();
    intervalNotifier.dispose();
  }

  @visibleForTesting
  @protected
  void setIntervalValue(int value) {
    intervalNotifier.value = value;
    intervalController.value = TextEditingValue(text: value.toString());
  }

  @visibleForTesting
  @protected
  int getIntervalValue({int minValue = intervalMin, int? defaultValue}) =>
      intervalNotifier.value < minValue
      ? (defaultValue ?? initialInterval)
      : intervalNotifier.value;
}

@internal
abstract class IntervalPickerSegmentController
    extends IntervalPickerController {
  final ValueNotifier<Set<IntervalSegmentType>> intervalSegmentType;

  late final ValueNotifier<int> dayOfMonth;
  late final NumberFormat dayOfMonthFormatter;
  late final ValueNotifier<DayOfWeekOrdinal> dayOfWeekOrdinal;

  late final ValueNotifier<DayOfWeek> dayOfWeek;
  late DateFormat dayOfWeekFormatter;
  late final ValueNotifier<List<(DayOfWeek, String)>> daysOfWeek;

  IntervalPickerSegmentController({
    super.initialInterval,
    Set<IntervalSegmentType> initialSegmentType = const {.precise},
    int initialDayOfMonth = defaultByMonthDay,
    String dayOfMonthFormat = '00',
    DayOfWeekOrdinal initialDayOfWeekOrdinal = .first,
    DayOfWeek initialDayOfWeek = .monday,
    required VoidCallback listener,
  }) : intervalSegmentType = ValueNotifier(initialSegmentType)
         ..addListener(listener),

       dayOfMonth = ValueNotifier(initialDayOfMonth)..addListener(listener),
       dayOfMonthFormatter = NumberFormat(dayOfMonthFormat),
       dayOfWeekOrdinal = ValueNotifier(initialDayOfWeekOrdinal)
         ..addListener(listener),

       dayOfWeek = ValueNotifier(initialDayOfWeek)..addListener(listener),
       dayOfWeekFormatter = DateFormat.EEEE(),

       super(listener: listener) {
    daysOfWeek = ValueNotifier(
      DayOfWeek.buildWeek(initialDayOfWeek, dayOfWeekFormatter),
    )..addListener(listener);
  }

  @override
  void dispose() {
    daysOfWeek.dispose();
    dayOfWeek.dispose();
    dayOfWeekOrdinal.dispose();
    dayOfMonth.dispose();
    intervalSegmentType.dispose();
    super.dispose();
  }

  @visibleForTesting
  @protected
  void setIntervalSegmentTypeValue(Set<IntervalSegmentType> segmentType) =>
      intervalSegmentType.value = segmentType;

  @visibleForTesting
  @protected
  void setDayOfMonthValue(int value) => dayOfMonth.value = value;

  @visibleForTesting
  @protected
  @mustCallSuper
  void updateDayOfWeekState({
    RRulePickerLocalizations? localizations,
    DayOfWeek? firstDayOfWeek,
  }) {
    if (localizations != null) {
      dayOfWeekFormatter = DateFormat.EEEE(localizations.localeName);
    }

    if (firstDayOfWeek != null) {
      daysOfWeek.value = DayOfWeek.buildWeek(
        firstDayOfWeek,
        dayOfWeekFormatter,
      );
    }
  }

  @visibleForTesting
  @protected
  void setDayOfWeekValue(
    DayOfWeekOrdinal dayOfWeekOrdinal,
    DayOfWeek dayOfWeek, [
    DayOfWeek? firstDayOfWeek,
  ]) {
    this.dayOfWeekOrdinal.value = dayOfWeekOrdinal;
    this.dayOfWeek.value = dayOfWeek;
    if (firstDayOfWeek != null) {
      daysOfWeek.value = DayOfWeek.buildWeek(
        firstDayOfWeek,
        dayOfWeekFormatter,
      );
    }
  }
}

@internal
class IntervalSegmentTypeButton extends StatelessWidget {
  final Set<IntervalSegmentType> segmentType;
  final String preciseText;
  final String relativeText;
  final void Function(Set<IntervalSegmentType> value) onSelectionChanged;

  const IntervalSegmentTypeButton({
    super.key,
    required this.segmentType,
    required this.preciseText,
    required this.relativeText,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<IntervalSegmentType>(
      onSelectionChanged: onSelectionChanged,
      selected: segmentType,
      showSelectedIcon: false,
      style: ResolvedTheme.of(context).segmentedButtonStyle,
      segments: [
        ButtonSegment(value: .precise, label: Text(preciseText)),
        ButtonSegment(value: .relative, label: Text(relativeText)),
      ],
    );
  }
}

@internal
enum IntervalSegmentType { precise, relative }
