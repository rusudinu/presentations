// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class AppLocalizationsRo extends AppLocalizations {
  AppLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String get localizationTitle => 'Texte localizate';

  @override
  String todoCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de sarcini',
      few: '$count sarcini',
      one: 'O sarcină',
      zero: 'Nicio sarcină',
    );
    return '$_temp0';
  }

  @override
  String dueOn(String date) {
    return 'Termen: $date';
  }

  @override
  String get addTodo => 'Adaugă o sarcină';

  @override
  String get removeTodo => 'Șterge o sarcină';
}
