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
  Widget build(BuildContext context) => Column(
    spacing: 8,
    children: [
      intervalPicker,
      segmentTypeButton,
      Row(spacing: 8, children: [monthDropdown, slash, dayOfMonthDropdown]),
    ],
  );
}
