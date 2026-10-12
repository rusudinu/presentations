// Lecture 14, UI polish and testing: one screen per topic. The tests are in
// test/lecture14 and integration_test.
// Run: flutter run -t lib/lecture14_polish/main.dart

import 'package:flutter/material.dart';

import 'access/accessibility_page.dart';
import 'forms/sign_in_form_page.dart';
import 'l10n/app_localizations.dart';
import 'l10n/localization_page.dart';
import 'layout/media_query_page.dart';
import 'layout/responsive_page.dart';
import 'motion/hero_page.dart';
import 'motion/implicit_animations_page.dart';
import 'testing/todo_screen.dart';
import 'theming/app_theme.dart';
import 'theming/theming_page.dart';

void main() {
  runApp(const Lecture14App());
}

// (part, title, screen). The order follows the slides.
const _examples = <(String, String, Widget)>[
  ('Part 1 · Theming', 'Theme, color roles and dark mode', ThemingPage()),
  ('Part 1 · Theming', 'MediaQuery', MediaQueryPage()),
  ('Part 1 · Theming', 'LayoutBuilder and breakpoints', ResponsivePage()),
  ('Part 2 · Forms', 'Form, validation and errors', SignInFormPage()),
  ('Part 3 · Motion', 'Implicit animations', ImplicitAnimationsPage()),
  ('Part 3 · Motion', 'Hero transitions', HeroPage()),
  ('Part 4 · Reach', 'Accessibility', AccessibilityPage()),
  ('Part 4 · Reach', 'Localization', LocalizationPage()),
  ('Part 5 · Testing', 'The screen under test', TodoScreen()),
];

class Lecture14App extends StatelessWidget {
  const Lecture14App({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeMode,
      builder: (context, mode, _) => MaterialApp(
        title: 'Lecture 14',
        theme: appTheme(Brightness.light),
        darkTheme: appTheme(Brightness.dark),
        themeMode: mode, // system, or the user's choice
        // Generated from the ARB files: the delegates and the list of languages.
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const ExamplesPage(),
      ),
    );
  }
}

class ExamplesPage extends StatelessWidget {
  const ExamplesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lecture 14: UI polish and testing')),
      body: ListView.builder(
        itemCount: _examples.length,
        itemBuilder: (context, i) {
          final (part, title, screen) = _examples[i];
          final startsPart = i == 0 || _examples[i - 1].$1 != part;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (startsPart)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                  child: Text(
                    part,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ListTile(
                title: Text(title),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(
                  context,
                ).push(MaterialPageRoute<void>(builder: (_) => screen)),
              ),
            ],
          );
        },
      ),
    );
  }
}
