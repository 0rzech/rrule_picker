// Copyright 2026 Piotr Mieczysław Orzechowski
// SPDX-License-Identifier: Apache-2.0

part of '../yearly.dart';

class _RelativeIntervalSegment extends StatelessWidget {
  final IntervalPicker intervalPicker;
  final IntervalSegmentTypeButton segmentTypeButton;
  final _MonthDropdown monthDropdown;
  final Text slash;
  final _DayOfWeekOrdinalDropdown dayOfWeekOrdinalDropdown;
  final _DayOfWeekDropdown dayOfWeekDropdown;

  const _RelativeIntervalSegment({
    required this.intervalPicker,
    required this.segmentTypeButton,
    required this.monthDropdown,
    required this.slash,
    required this.dayOfWeekOrdinalDropdown,
    required this.dayOfWeekDropdown,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ResolvedTheme.of(context);

    return LayoutBuilder(
      builder: (_, constraints) {
        final width = constraints.maxWidth - theme.padding.vertical;

        return width < global.narrowLayoutBreakpoint
            ? Column(
                mainAxisSize: .min,
                spacing: theme.spacing.column,
                children: [
                  intervalPicker,
                  segmentTypeButton,
                  Row(
                    spacing: theme.spacing.row,
                    children: [monthDropdown, slash],
                  ),
                  Row(
                    spacing: theme.spacing.row,
                    children: [dayOfWeekOrdinalDropdown, dayOfWeekDropdown],
                  ),
                ],
              )
            : Column(
                mainAxisSize: .min,
                spacing: theme.spacing.column,
                children: [
                  intervalPicker,
                  segmentTypeButton,
                  Row(
                    spacing: theme.spacing.row,
                    children: [
                      monthDropdown,
                      slash,
                      dayOfWeekOrdinalDropdown,
                      dayOfWeekDropdown,
                    ],
                  ),
                ],
              );
      },
    );
  }
}
