// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

part of '../monthly.dart';

class _DayOfWeekDropdown extends StatelessWidget {
  final DayOfWeek dayOfWeek;
  final List<(DayOfWeek, String)> daysOfWeek;
  final ValueChanged<DayOfWeek?> onChanged;

  const _DayOfWeekDropdown({
    required this.dayOfWeek,
    required this.daysOfWeek,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ResolvedTheme.of(context).dropdownTheme;
    final decorate = dropdownDecorators(theme);

    final dropdown = DropdownButton(
      value: dayOfWeek,
      style: theme.style,
      isExpanded: true,
      items: daysOfWeek
          .map((day) {
            final text = Text(day.$2, style: theme.menuItemStyle);

            return DropdownMenuItem(
              value: day.$1,
              child: decorate.dropdownMenuItem(text),
            );
          })
          .toList(growable: false),
      onChanged: onChanged,
    );

    return Flexible(child: decorate.dropdown(dropdown));
  }
}
