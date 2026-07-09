// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

part of '../monthly.dart';

class _DayOfWeekOrdinalDropdown extends StatelessWidget {
  final DayOfWeekOrdinal dayOfWeekOrdinal;
  final DayOfWeek dayOfWeek;
  final ValueChanged<DayOfWeekOrdinal?> onChanged;

  const _DayOfWeekOrdinalDropdown({
    required this.dayOfWeekOrdinal,
    required this.dayOfWeek,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l = RRulePickerLocalizations.of(context);
    final theme = ResolvedTheme.of(context).dropdownTheme;
    final decorate = dropdownDecorators(theme);

    final dropdown = DropdownButton(
      isExpanded: true,
      value: dayOfWeekOrdinal,
      style: theme.style,
      items: DayOfWeekOrdinal.values
          .map((ordinal) {
            final text = Text(
              l.rrulePickerDayOfWeekOrdinal(ordinal, dayOfWeek),
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
  }
}
