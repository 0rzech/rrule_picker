// Copyright 2026 Piotr Mieczysław Orzechowski
// SPDX-License-Identifier: Apache-2.0

part of '../yearly.dart';

class _DayOfMonthDropdown extends StatelessWidget {
  final ValueListenable<Month> month;
  final ValueListenable<int> dayOfMonth;
  final NumberFormat dayOfMonthFormatter;
  final ValueChanged<int?> onChanged;

  const _DayOfMonthDropdown({
    required this.month,
    required this.dayOfMonthFormatter,
    required this.dayOfMonth,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ResolvedTheme.of(context).dropdownTheme;
    final decorate = dropdownDecorators(theme);

    return ListenableBuilder(
      listenable: .merge([month, dayOfMonth]),
      builder: (_, _) {
        final dropdown = DropdownButton(
          value: dayOfMonth.value,
          style: theme.style,
          isExpanded: true,
          items: .generate(month.value.maxDay, (i) {
            final day = i + 1;
            final text = Text(
              dayOfMonthFormatter.format(day),
              style: theme.menuItemStyle,
            );

            return DropdownMenuItem(
              value: day,
              child: decorate.dropdownMenuItem(text),
            );
          }, growable: false),
          onChanged: onChanged,
        );

        return Flexible(child: decorate.dropdown(dropdown));
      },
    );
  }
}
