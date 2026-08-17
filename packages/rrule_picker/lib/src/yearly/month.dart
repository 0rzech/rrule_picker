// Copyright 2026 Piotr Mieczysław Orzechowski
// SPDX-License-Identifier: Apache-2.0

part of '../yearly.dart';

class _MonthDropdown extends StatelessWidget {
  final ValueListenable<Month> month;
  final DateFormat monthFormatter;
  final ValueChanged<Month?> onChanged;

  const _MonthDropdown({
    required this.month,
    required this.monthFormatter,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ResolvedTheme.of(context).dropdownTheme;
    final decorate = dropdownDecorators(theme);

    return ValueListenableBuilder(
      valueListenable: month,
      builder: (context, day, _) {
        final dropdown = DropdownButton(
          value: day,
          style: theme.style,
          isExpanded: true,
          items: Month.values
              .map((month) {
                final date = DateTime(2026, 01 + month.index, 01);
                final text = Text(
                  monthFormatter.format(date),
                  style: theme.menuItemStyle,
                );

                return DropdownMenuItem(
                  value: month,
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
