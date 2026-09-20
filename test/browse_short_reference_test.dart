// What the Browse gutter prints, and whether the originals appear —
// 2026-09-20.
//
// Two reports from a phone:
//
//   「sword是不是全部写出来使徒行转就太长了 user肯定知道的类似于使就可以
//    了空出多些位置」 — every row repeated 使徒行传 24:7 in full.
//   「要有可以default tick off on 原文吗因为你看希腊希伯来文总是出现」 —
//    the Greek/Hebrew line was appended to every verse unconditionally.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yahwehs_sword/models/app_settings.dart';
import 'package:yahwehs_sword/utils/short_book_name.dart';
import 'package:yahwehs_sword/utils/version_gutter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('the gutter label is the short book name', () {
    // What the row now builds, for the verse in the report.
    final short = '${shortBookName('Acts', 'zh-Hans', 'cuvs-yhwh')} 24:7';
    expect(short, '徒 24:7');
  });

  test('and that is most of the gutter width back', () {
    const size = 16.0;
    final wide = referenceGutterWidth({'使徒行传 24:7'}, size);
    final narrow = referenceGutterWidth({'徒 24:7'}, size);
    expect(narrow, lessThan(wide));
    // The report was about the space it costs; measure it rather than
    // asserting a feeling. Four full-width glyphs at 16 px is ~64 px.
    expect(wide - narrow, greaterThan(40),
        reason: 'recovered ${wide - narrow} px per row');
  });

  test('the originals are off until the reader asks', () async {
    SharedPreferences.setMockInitialValues({});
    final s = AppSettings();
    await s.loadSettings();
    expect(s.showOriginalRows, isFalse);

    await s.setShowOriginalRows(true);
    final after = AppSettings();
    await after.loadSettings();
    expect(after.showOriginalRows, isTrue, reason: 'and it is remembered');

    await after.resetAllSettings();
    expect(after.showOriginalRows, isFalse);
    final fresh = AppSettings();
    await fresh.loadSettings();
    expect(fresh.showOriginalRows, isFalse,
        reason: 'reset must purge the key, not only the field');
  });
}
