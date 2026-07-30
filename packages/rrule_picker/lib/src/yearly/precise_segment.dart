// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

part of '../yearly.dart';

class _PreciseIntervalSegment extends StatelessWidget {
  final IntervalPicker intervalPicker;
  final IntervalSegmentTypeButton segmentTypeButton;
  final _MonthDropdown monthDropdown;
  final Text slash;
  final _DayOfMonthDropdown dayOfMonthDropdown;

  const _PreciseIntervalSegment({
    required this.intervalPicker,
    required this.segmentTypeButton,
    required this.monthDropdown,
    required this.slash,
    required this.dayOfMonthDropdown,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ResolvedTheme.of(context);

    return Column(
      mainAxisSize: .min,
      spacing: theme.spacing.column,
      children: [
        intervalPicker,
        segmentTypeButton,
        Row(
          spacing: theme.spacing.row,
          children: [monthDropdown, slash, dayOfMonthDropdown],
        ),
      ],
    );
  }
}
