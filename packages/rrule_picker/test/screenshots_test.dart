// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

@Tags(['screenshots'])
library;

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rrule_picker/l10n/l10n.dart';
import 'package:rrule_picker/widget.dart';
import 'package:spot/spot.dart';

void main() {
  setUpAll(() async {
    if (!kIsWeb) {
      await loadAppFonts();
    }
  });

  group('take screenshot', () {
    for (final testCase in testCases) {
      testWidgets('of ${testCase.name} on ${testCase.device.name}', (tester) {
        return tester.takeScreenshot(
          rrule: testCase.rrule,
          device: testCase.device,
          baseName: testCase.fileName,
        );
      });
    }
  });
}

const testCases = [
  (
    name: 'yearly relative day recurrence',
    rrule:
        'RRULE:FREQ=YEARLY;INTERVAL=10;BYMONTH=3;BYDAY=FR;BYSETPOS=-1;'
        'UNTIL=20991231;EXDATE;VALUE=DATE:20561112,20591101',
    device: ScreenshotDevice.linux,
    fileName: 'yearly_relative',
  ),
  (
    name: 'yearly exact day recurrence',
    rrule:
        'RRULE:FREQ=YEARLY;INTERVAL=10;BYMONTH=3;BYMONTHDAY=1;'
        'UNTIL=20991231;EXDATE;VALUE=DATE:20561112,20591101',
    device: ScreenshotDevice.android,
    fileName: 'yearly_exact',
  ),
  (
    name: 'monthly relative day recurrence',
    rrule:
        'RRULE:FREQ=MONTHLY;INTERVAL=10;BYDAY=FR;BYSETPOS=-1;'
        'UNTIL=20991231;EXDATE;VALUE=DATE:20561112,20591101',

    device: ScreenshotDevice.ios,
    fileName: 'monthly_relative',
  ),
  (
    name: 'monthly exact day recurrence',
    rrule:
        'RRULE:FREQ=MONTHLY;INTERVAL=10;BYMONTHDAY=1;UNTIL=20991231;'
        'EXDATE;VALUE=DATE:20561112,20591101',

    device: ScreenshotDevice.linux,
    fileName: 'monthly_exact',
  ),
  (
    name: 'weekly recurrence',
    rrule:
        'RRULE:FREQ=WEEKLY;INTERVAL=10;BYDAY=FR;UNTIL=20991231;'
        'EXDATE;VALUE=DATE:20561112,20591101',

    device: ScreenshotDevice.android,
    fileName: 'weekly',
  ),
  (
    name: 'weekly recurrence',
    rrule:
        'RRULE:FREQ=WEEKLY;INTERVAL=10;BYDAY=FR;UNTIL=20991231;'
        'EXDATE;VALUE=DATE:20561112,20591101',

    device: ScreenshotDevice.ios,
    fileName: 'weekly',
  ),
  (
    name: 'weekly recurrence',
    rrule:
        'RRULE:FREQ=WEEKLY;INTERVAL=10;BYDAY=FR;UNTIL=20991231;'
        'EXDATE;VALUE=DATE:20561112,20591101',

    device: ScreenshotDevice.linux,
    fileName: 'weekly',
  ),
  (
    name: 'daily recurrence',
    rrule:
        'RRULE:FREQ=DAILY;INTERVAL=10;UNTIL=20991231;'
        'EXDATE;VALUE=DATE:20561112,20591101',

    device: ScreenshotDevice.android,
    fileName: 'daily',
  ),
  (
    name: 'no recurrence',
    rrule: '',
    device: ScreenshotDevice.ios,
    fileName: 'never',
  ),
];

extension on WidgetTester {
  Future<void> takeScreenshot({
    String rrule = '',
    required ScreenshotDevice device,
    required String baseName,
  }) async {
    view.physicalSize = device.physicalSize;
    view.devicePixelRatio = device.pixelRatio;

    await pumpWidget(
      MaterialApp(
        theme: ThemeData(
          platform: device.platform,
          colorScheme: .fromSeed(seedColor: Colors.cyan),
          fontFamily: device == .ios ? 'Roboto' : null,
        ),
        localizationsDelegates: RRulePickerLocalizations.localizationsDelegates,
        supportedLocales: RRulePickerLocalizations.supportedLocales,
        home: LayoutBuilder(
          builder: (_, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: .new(
                minWidth: constraints.maxWidth,
                minHeight: constraints.maxHeight,
              ),
              child: Center(
                child: RepaintBoundary(
                  child: Material(
                    child: RRulePicker(
                      initialRRule: rrule,
                      theme: const .new(padding: .all(16)),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await expectLater(
      find.byType(RRulePicker),
      matchesGoldenFile(
        '..${Platform.pathSeparator}screenshots${Platform.pathSeparator}'
        '${device.outputFolder}_$baseName.png',
      ),
    );
  }
}

enum ScreenshotDevice {
  android(
    platform: TargetPlatform.android,
    physicalSize: Size(427, 714),
    pixelRatio: 1,
    outputFolder: 'android',
  ),

  ios(
    platform: TargetPlatform.iOS,
    physicalSize: Size(440, 717),
    pixelRatio: 1,
    outputFolder: 'ios',
  ),

  linux(
    platform: TargetPlatform.linux,
    physicalSize: Size(640, 640),
    pixelRatio: 1,
    outputFolder: 'linux',
  );

  final TargetPlatform platform;
  final Size physicalSize;
  final double pixelRatio;
  final String outputFolder;

  const ScreenshotDevice({
    required this.platform,
    required this.physicalSize,
    required this.pixelRatio,
    required this.outputFolder,
  });
}
