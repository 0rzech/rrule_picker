// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

part of '../yearly.dart';

class _DayOfWeekDropdown extends StatelessWidget {
  final ValueListenable<List<(DayOfWeek, String)>> daysOfWeek;
  final ValueListenable<DayOfWeek> dayOfWeek;
  final ValueChanged<DayOfWeek?> onChanged;

  const _DayOfWeekDropdown({
    required this.daysOfWeek,
    required this.dayOfWeek,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ResolvedTheme.of(context).dropdownTheme;
    final decorate = dropdownDecorators(theme);

    return ListenableBuilder(
      listenable: .merge([daysOfWeek, dayOfWeek]),
      builder: (_, _) {
        final dropdown = DropdownButton(
          value: dayOfWeek.value,
          isExpanded: true,
          style: theme.style,
          items: daysOfWeek.value
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
      },
    );
  }
}
