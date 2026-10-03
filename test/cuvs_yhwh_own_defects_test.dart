// 2026-10-03: six verses where THIS app was wrong and the publisher was right.
//
// Each was checked against the official database (bible.db v38) and the
// printed 和合本: our copy had lost a word, mangled a footnote's quotation
// marks, or kept a stray symbol while the text was converted. None is a
// reading. The fixes live in tools/repair_by_official_cuv.py; this test
// keeps them from coming back.

import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';

Future<Map<String, String>> _load(String asset) async {
  final rows = jsonDecode(await rootBundle.loadString(asset)) as List;
  return {for (final r in rows) (r as Map)['id'] as String: r['text'] as String};
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  for (final asset in ['assets/cuvs-yhwh.json', 'assets/cuvs-yhwh-tr.json']) {
    group(asset, () {
      late Map<String, String> v;
      setUpAll(() async => v = await _load(asset));

      test('耶利米书 49:36 keeps the word 方 before its footnote', () {
        expect(v['024049036'], contains('分散四方<note:'));
      });
      test('以西结书 26:6 keeps the word 居民 before its footnote', () {
        expect(v['026026006'], contains('城邑的居民<note:'));
      });
      test('启示录 12:5 footnote is closed properly', () {
        final t = v['066012005']!;
        expect(t, contains('<note: "'));
        expect(t, contains('原文是"牧">'));
        expect(t, isNot(contains('"<note:')));
      });
      test('以赛亚书 41:16 reads 以以色列的圣者', () {
        expect(v['023041016'], contains('以以色列'));
      });
      test('马可福音 15:13 has no stray bracket', () {
        expect(v['041015013']!.trimLeft(), isNot(startsWith(')')));
      });
      test('路加福音 18:37 has no doubled colon', () {
        expect(v['042018037'], isNot(contains(':：')));
      });
    });
  }
}
