// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rrule_picker/src/shared/resolved_theme.dart';

@internal
class LabeledSwitch extends StatelessWidget {
  final bool value;
  final void Function(bool) onChanged;
  final String label;

  const LabeledSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ResolvedTheme.of(context);
    void toggle() => onChanged(!value);
    final onOff = Switch.adaptive(value: value, onChanged: onChanged);

    return MergeSemantics(
      child: Semantics(
        toggled: value,
        onIncrease: value ? null : toggle,
        onDecrease: value ? toggle : null,
        child: TextButton(
          onPressed: toggle,
          style: theme.labeledSwitchTheme?.style,
          child: Row(
            spacing: theme.spacing.row,
            mainAxisAlignment: .spaceBetween,
            children: [
              Flexible(child: Text(label)),
              ExcludeSemantics(
                child: ExcludeFocus(
                  child: switch (theme.labeledSwitchTheme?.switchTheme) {
                    null => onOff,
                    final theme => SwitchTheme(data: theme, child: onOff),
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
