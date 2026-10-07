import 'package:flutter_test/flutter_test.dart';
import 'package:yahwehs_sword/constants/ui_strings.dart';

void main() {
  test('current settings labels and explanations exist in all locales', () {
    for (final locale in ['en', 'zh-Hans', 'zh-Hant']) {
      for (final key in [
        'settingsSectionAccount',
        'localOnlyDataNotice',
        'resetSettingsConfirm',
        'resetSettingsNote'
      ]) {
        expect(uiStrings[key]?[locale], isNotNull, reason: '$key / $locale');
        expect(uiStrings[key]![locale], isNotEmpty);
      }
    }
  });
  test('Sword describes local profiles and current Workbench settings', () {
    expect(uiStrings['settingsSectionAccount']!['en'], 'Local profiles');
    expect(uiStrings['localOnlyDataNotice']!['en'], contains('device'));
    for (final key in ['resetSettingsConfirm', 'resetSettingsNote']) {
      expect(uiStrings[key]!['en'], contains('projection'));
      expect(uiStrings[key]!['en'], contains('search'));
      expect(uiStrings[key]!['en'], isNot(contains('dashboard')));
    }
  });
}
