// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rrule_picker/src/shared/resolved_theme.dart';

@internal
class SplitSegmentedButton<T, U> extends StatelessWidget {
  final Set<T> selected;
  final ValueChanged<Set<T>> onSelectionChanged;
  final List<U> segmentInput;
  final SplitButtonSegment<T> Function(U value) segmentMapper;

  const SplitSegmentedButton({
    super.key,
    required this.selected,
    required this.onSelectionChanged,
    required this.segmentInput,
    required this.segmentMapper,
  });

  @override
  Widget build(BuildContext context) {
    final style = ResolvedTheme.of(context).splitSegmentedButtonStyle;

    return Wrap(
      alignment: .spaceEvenly,
      spacing: 8,
      runSpacing: 8,
      children: segmentInput
          .map((value) {
            final segment = segmentMapper.call(value);
            final isSelected = selected.contains(segment.value);
            final textStyle = style?.textStyle?.resolve(
              isSelected ? const {.selected} : {.focused},
            );

            return SplitButton(
              isSelected: isSelected,
              value: segment.value,
              onTap: onSegmentTap,
              child: Text(segment.text, style: textStyle),
            );
          })
          .toList(growable: false),
    );
  }

  void onSegmentTap(T value) {
    if (!selected.contains(value)) {
      onSelectionChanged(selected.union({value}));
    } else if (selected.length > 1) {
      onSelectionChanged(selected.difference({value}));
    }
  }
}

@internal
class SplitButtonSegment<T> {
  final T value;
  final String text;

  const SplitButtonSegment({required this.value, required this.text});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SplitButtonSegment<T> &&
          other.runtimeType == runtimeType &&
          other.value == value &&
          other.text == text;

  @override
  int get hashCode => Object.hash(value.hashCode, text.hashCode);
}

@internal
class SplitButton<T> extends StatelessWidget {
  final bool isSelected;
  final T value;
  final void Function(T value) onTap;
  final Widget child;

  const SplitButton({
    super.key,
    required this.isSelected,
    required this.value,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final style = ResolvedTheme.of(context).splitSegmentedButtonStyle;
    final states = isSelected
        ? const {WidgetState.selected}
        : const {WidgetState.focused};
    final size = style?.fixedSize?.resolve(states);
    final shape = style?.shape?.resolve(states) ?? const StadiumBorder();

    return AnimatedContainer(
      width: size?.width,
      height: size?.height,
      duration: style?.animationDuration ?? kThemeAnimationDuration,
      curve: Curves.easeInOut,
      decoration: ShapeDecoration(
        shape: shape,
        color: style?.backgroundColor?.resolve(states),
      ),
      child: InkWell(
        customBorder: shape,
        onTap: () => onTap(value),
        child: FittedBox(fit: .scaleDown, child: child),
      ),
    );
  }
}
