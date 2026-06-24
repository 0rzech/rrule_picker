// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter_test/flutter_test.dart';
import 'package:kiri_check/kiri_check.dart';
import 'package:rrule_picker/src/shared/set_value_notifier.dart';

void main() {
  group(SetValueNotifier, () {
    group('value setter', () {
      late SetValueNotifier<String> notifier;
      late int listenerCallCount;

      property('does not notify when setting identical set', () {
        forAll(
          string(minLength: 1, maxLength: 5).map((s) => s.split('').toSet()),
          (set) {
            notifier = SetValueNotifier(set)
              ..addListener((() => ++listenerCallCount));

            notifier.value = set;

            expect(listenerCallCount, 0);
            expect(notifier.value, set);
          },
          setUp: () => listenerCallCount = 0,
          tearDown: () => notifier.dispose(),
        );
      });

      property('does not notify '
          'when setting set with same elements but different identity', () {
        forAll(
          string(minLength: 1, maxLength: 5)
              .map((s) => s.split('').toSet())
              .map((s) => (s, Set<String>.from(s))),
          (sets) {
            notifier = SetValueNotifier(sets.$1)
              ..addListener((() => ++listenerCallCount));

            notifier.value = sets.$2;

            expect(listenerCallCount, 0);
            expect(notifier.value, sets.$1);
          },
          setUp: () => listenerCallCount = 0,
          tearDown: () => notifier.dispose(),
        );
      });

      property('notifies '
          'when setting set with same length and different elements', () {
        forAll(
          string(minLength: 1, maxLength: 5, characterSet: .letter(.ascii)).map(
            (s) => (
              s.toLowerCase().split('').toSet(),
              s.toUpperCase().split('').toSet(),
            ),
          ),
          (sets) {
            notifier = SetValueNotifier(sets.$1)
              ..addListener((() => ++listenerCallCount));

            notifier.value = sets.$2;

            expect(listenerCallCount, 1);
            expect(notifier.value, sets.$2);
          },
          setUp: () => listenerCallCount = 0,
          tearDown: () => notifier.dispose(),
        );
      });

      property('notifies '
          'when setting set with different length and different elements', () {
        forAll(
          combine2(
                string(
                  minLength: 1,
                  maxLength: 5,
                  characterSet: .letter(.ascii),
                ),
                string(
                  minLength: 1,
                  maxLength: 5,
                  characterSet: .letter(.ascii),
                ),
              )
              .filter((sets) {
                return !(sets.$1.length == sets.$2.length ||
                    sets.$1 == sets.$2);
              })
              .map(
                (sets) => (
                  sets.$1.toLowerCase().split('').toSet(),
                  sets.$2.toLowerCase().split('').toSet(),
                ),
              ),
          (sets) {
            notifier = SetValueNotifier(sets.$1)
              ..addListener((() => ++listenerCallCount));

            notifier.value = sets.$2;

            expect(listenerCallCount, 1);
          },
          setUp: () => listenerCallCount = 0,
          tearDown: () => notifier.dispose(),
        );
      });

      property('notifies when setting empty set on non-empty', () {
        forAll(
          string(minLength: 1, maxLength: 5).map((s) => s.split('').toSet()),
          (set) {
            notifier = SetValueNotifier(set)
              ..addListener((() => ++listenerCallCount));

            notifier.value = const <String>{};

            expect(listenerCallCount, 1);
            expect(notifier.value, const <String>{});
          },
          setUp: () => listenerCallCount = 0,
          tearDown: () => notifier.dispose(),
        );
      });

      property('notifies when setting non-empty set on empty', () {
        forAll(
          string(minLength: 1, maxLength: 5).map((s) => s.split('').toSet()),
          (set) {
            notifier = SetValueNotifier(const <String>{})
              ..addListener((() => ++listenerCallCount));

            notifier.value = set;

            expect(listenerCallCount, 1);
            expect(notifier.value, set);
          },
          setUp: () => listenerCallCount = 0,
          tearDown: () => notifier.dispose(),
        );
      });

      test('does not notify when setting empty set on empty set', () {
        listenerCallCount = 0;
        notifier = SetValueNotifier(const <String>{})
          ..addListener((() => ++listenerCallCount));

        notifier.value = <String>{};

        expect(listenerCallCount, 0);
        expect(notifier.value, const <String>{});

        addTearDown(() => notifier.dispose());
      });
    });
  });
}
