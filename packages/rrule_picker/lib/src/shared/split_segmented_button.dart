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
  Widget build(BuildContext context) => Semantics(
    container: true,
    child: Wrap(
      alignment: .spaceEvenly,
      spacing: 8,
      runSpacing: 8,
      children: segmentInput
          .map((value) {
            final segment = segmentMapper.call(value);

            return SplitButton(
              key: ValueKey(segment.value),
              isSelected: selected.contains(segment.value),
              value: segment.value,
              onSelected: onSegmentTap,
              child: Text(segment.text),
            );
          })
          .toList(growable: false),
    ),
  );

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
class SplitButton<T> extends StatefulWidget {
  final bool isSelected;
  final T value;
  final void Function(T value) onSelected;
  final Widget child;

  const SplitButton({
    super.key,
    required this.isSelected,
    required this.value,
    required this.onSelected,
    required this.child,
  });

  @override
  State<SplitButton<T>> createState() => _SplitButtonState<T>();
}

class _SplitButtonState<T> extends State<SplitButton<T>> {
  late final WidgetStatesController controller;

  @override
  void initState() {
    super.initState();
    controller = WidgetStatesController(
      widget.isSelected ? const {.selected} : const {},
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SplitButton<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isSelected != widget.isSelected) {
      // sneaking .selected into states without notifying listeners,
      // because the parent has just triggered rebuild anyway
      widget.isSelected
          ? controller.value.add(.selected)
          : controller.value.remove(WidgetState.selected);
    }
  }

  @override
  Widget build(BuildContext context) => MergeSemantics(
    child: Semantics(
      selected: widget.isSelected,
      child: OutlinedButton(
        style: ResolvedTheme.of(context).splitSegmentedButtonStyle,
        statesController: controller,
        onPressed: () => widget.onSelected(widget.value),
        child: FittedBox(fit: .scaleDown, child: widget.child),
      ),
    ),
  );
}
