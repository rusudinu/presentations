// The generated AppLocalizations: plural forms are chosen by each language's rules.
import 'package:flutter_examples/lecture14_polish/l10n/app_localizations_en.dart';
import 'package:flutter_examples/lecture14_polish/l10n/app_localizations_ro.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('English has two plural forms and a zero case', () {
    final en = AppLocalizationsEn();

    expect(en.todoCount(0), 'No todos');
    expect(en.todoCount(1), '1 todo');
    expect(en.todoCount(5), '5 todos');
  });

  test('Romanian has a separate form from 20 on', () {
    final ro = AppLocalizationsRo();

    expect(ro.todoCount(0), 'Nicio sarcină');
    expect(ro.todoCount(1), 'O sarcină');
    expect(ro.todoCount(5), '5 sarcini');
    expect(ro.todoCount(25), '25 de sarcini');
  });
}
