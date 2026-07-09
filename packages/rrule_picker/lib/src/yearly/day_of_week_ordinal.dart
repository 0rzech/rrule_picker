// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

part of '../yearly.dart';

class _DayOfWeekOrdinalDropdown extends StatelessWidget {
  final ValueListenable<List<(DayOfWeek, String)>> daysOfWeek;
  final ValueListenable<DayOfWeek> dayOfWeek;
  final ValueListenable<DayOfWeekOrdinal> dayOfWeekOrdinal;
  final ValueChanged<DayOfWeekOrdinal?> onChanged;

  const _DayOfWeekOrdinalDropdown({
    required this.daysOfWeek,
    required this.dayOfWeekOrdinal,
    required this.dayOfWeek,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l = RRulePickerLocalizations.of(context);
    final theme = ResolvedTheme.of(context).dropdownTheme;
    final decorate = dropdownDecorators(theme);

    return ListenableBuilder(
      listenable: .merge([daysOfWeek, dayOfWeekOrdinal, dayOfWeek]),
      builder: (_, _) {
        final dropdown = DropdownButton(
          value: dayOfWeekOrdinal.value,
          isExpanded: true,
          style: theme.style,
          items: DayOfWeekOrdinal.values
              .map((ordinal) {
                final text = Text(
                  l.rrulePickerDayOfWeekOrdinal(ordinal, dayOfWeek.value),
                  style: theme.menuItemStyle,
                );

                return DropdownMenuItem(
                  value: ordinal,
                  child: decorate.dropdownMenuItem(text),
                );
              })
              .toList(growable: false),
          onChanged: onChanged,
        );

        return Flexible(child: decorate.dropdown(dropdown));
      },
    );
  }
}
