// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get localizationTitle => 'Localized strings';

  @override
  String todoCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count todos',
      one: '1 todo',
      zero: 'No todos',
    );
    return '$_temp0';
  }

  @override
  String dueOn(String date) {
    return 'Due on $date';
  }

  @override
  String get addTodo => 'Add a todo';

  @override
  String get removeTodo => 'Remove a todo';
}
