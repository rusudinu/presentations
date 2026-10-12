import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import 'app_localizations.dart';

// Localized strings, plurals, dates, and right-to-left layout.
// The strings are in app_en.arb and app_ro.arb. flutter gen-l10n writes AppLocalizations.
class LocalizationPage extends StatefulWidget {
  const LocalizationPage({super.key});

  @override
  State<LocalizationPage> createState() => _LocalizationPageState();
}

class _LocalizationPageState extends State<LocalizationPage> {
  Locale _locale = const Locale('en');
  bool _rtl = false;
  int _count = 1;

  @override
  Widget build(BuildContext context) {
    // An app follows the system language through MaterialApp. This screen overrides
    // the locale for its own subtree, so the language can be switched here.
    return Localizations.override(
      context: context,
      locale: _locale,
      child: Directionality(
        textDirection: _rtl ? TextDirection.rtl : TextDirection.ltr,
        child: Builder(builder: _buildBody),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final due = DateTime(2026, 11, 2);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.localizationTitle)),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Română'),
            value: _locale.languageCode == 'ro',
            onChanged: (ro) =>
                setState(() => _locale = Locale(ro ? 'ro' : 'en')),
          ),
          SwitchListTile(
            title: const Text('Right to left'),
            value: _rtl,
            onChanged: (rtl) => setState(() => _rtl = rtl),
          ),
          const Divider(),
          Padding(
            // start and end, never left and right: this padding flips with the direction.
            padding: const EdgeInsetsDirectional.only(start: 32, end: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // The plural form is chosen by the language rules: Romanian has
                // one form for 2 to 19 and another from 20 on.
                Text(
                  l10n.todoCount(_count),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                // Dates are formatted for the locale, never assembled by hand.
                Text(l10n.dueOn(DateFormat.yMMMd(locale).format(due))),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: [
                    FilledButton(
                      onPressed: () => setState(() => _count++),
                      child: Text(l10n.addTodo),
                    ),
                    OutlinedButton(
                      onPressed: _count == 0
                          ? null
                          : () => setState(() => _count--),
                      child: Text(l10n.removeTodo),
                    ),
                    OutlinedButton(
                      onPressed: () => setState(() => _count = 25),
                      child: const Text('25'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
