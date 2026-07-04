// Copyright 2026 Piotr Orzechowski
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rrule_picker/rrule_picker.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const RRuleExampleApp());

class RRuleExampleApp extends StatelessWidget {
  const RRuleExampleApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'rrule_picker Example',
    theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.cyan)),
    localizationsDelegates: [
      RRulePickerLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: RRulePickerLocalizations.supportedLocales,
    home: const RRuleExample(title: 'rrule_picker Example'),
  );
}

class RRuleExample extends StatefulWidget {
  final String title;

  const RRuleExample({super.key, required this.title});

  @override
  State<RRuleExample> createState() => _RRuleExampleState();
}

class _RRuleExampleState extends State<RRuleExample> {
  static const codebergBadge = 'assets/images/codeberg-badge.svg';
  final codebergUrl = Uri.parse('https://codeberg.org/0rzech/rrule_picker');
  late final RRulePickerController rrulePickerController;

  @override
  void initState() {
    super.initState();
    rrulePickerController = .new(
      initialRRule:
          'RRULE:FREQ=YEARLY;INTERVAL=10;BYMONTH=3;BYDAY=FR;BYSETPOS=-1;'
          'EXDATE;VALUE=DATE:20561112,20591101',
    );
  }

  @override
  Widget build(BuildContext context) {
    final rrulePicker = RRulePicker(
      // this `initialRRule` value will not be used, because
      // `rrulePickerController` was initialized with its own non-empty
      // `initialRRule` value
      initialRRule:
          'RRULE:FREQ=WEEKLY;INTERVAL=30;BYDAY=MO,TH,SU;'
          'EXDATE;TZID=Etc/UTC;VALUE=DATE:20840330,20870510',
      controller: rrulePickerController,
      theme: const .new(padding: .all(8)),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: kIsWeb,
        actions: [
          Padding(
            padding: const .directional(end: NavigationToolbar.kMiddleSpacing),
            child: Stack(
              children: [
                SvgPicture.asset(
                  codebergBadge,
                  height: kToolbarHeight - kToolbarHeight / 5,
                  semanticsLabel: 'Fork me on Codeberg badge',
                ),
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(onTap: () => launchUrl(codebergUrl)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: .new(
              minWidth: constraints.maxWidth,
              minHeight: constraints.maxHeight,
            ),
            child: Center(
              child: Card(
                child: ConstrainedBox(
                  constraints: const .new(maxWidth: 640),
                  child: Padding(
                    padding: const .only(bottom: 8),
                    child: Column(
                      children: [
                        rrulePicker,
                        ElevatedButton(
                          onPressed: buttonPressed,
                          child: const Icon(
                            Icons.play_arrow,
                            color: Colors.green,
                            semanticLabel: 'Generate RRULE button',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void buttonPressed() {
    if (context.mounted) {
      var rrule = rrulePickerController.value;
      rrule = rrule.isEmpty ? '❌' : rrule;
      final snackBar = SnackBar(content: Text(rrule, textAlign: .center));

      // ignore: avoid_print
      print(rrule);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
