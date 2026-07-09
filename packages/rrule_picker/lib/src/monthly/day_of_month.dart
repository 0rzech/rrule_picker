// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

part of '../monthly.dart';

class _DayOfMonthDropdown extends StatelessWidget {
  final ValueListenable<int> dayOfMonth;
  final NumberFormat formatter;
  final ValueChanged<int?> onChanged;

  const _DayOfMonthDropdown({
    required this.dayOfMonth,
    required this.formatter,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l = RRulePickerLocalizations.of(context);
    final theme = ResolvedTheme.of(context).dropdownTheme;
    final decorate = dropdownDecorators(theme);

    return ValueListenableBuilder(
      valueListenable: dayOfMonth,
      builder: (context, day, _) {
        final dropdown = DropdownButton(
          value: day,
          isExpanded: true,
          style: theme.style,
          items: .generate(byMonthDayMax, (i) {
            final day = i + 1;
            final text = switch (day) {
              byMonthDayMax => Text(
                l.rrulePickerLastDay,
                style: theme.menuItemStyle,
              ),
              _ => Text(formatter.format(day), style: theme.menuItemStyle),
            };

            return DropdownMenuItem(
              value: day,
              child: decorate.dropdownMenuItem(text),
            );
          }),
          onChanged: onChanged,
        );

        return decorate.dropdown(dropdown);
      },
    );
  }
}
