/// The WLC row's Strong's numbers — 2026-09-21, 「why希伯来文没有编号的」.
///
/// Run over the WHOLE Old Testament from the shipped assets, because the
/// two things that can go wrong are both rare and silent: a word of the
/// edition quietly dropped or altered, and the numbers sliding one word
/// out of step. A spot check of Genesis 1 would pass either.
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:yahwehs_sword/models/original_word.dart';
import 'package:yahwehs_sword/utils/wlc_alignment.dart';

void main() {
  late List<Map<String, dynamic>> wlc;
  final originals = <String, Map<String, dynamic>>{};

  setUpAll(() {
    wlc = (json.decode(File('assets/wlc.json').readAsStringSync()) as List)
        .cast<Map<String, dynamic>>();
  });

  List<OriginalWord> taggedFor(String book, String chapter, String verse) {
    final file = 'assets/originals/${book.toLowerCase().replaceAll(' ', '_')}.json';
    final data = originals.putIfAbsent(
        file,
        () => json.decode(File(file).readAsStringSync())
            as Map<String, dynamic>);
    return [
      for (final w in (data['$chapter:$verse'] as List? ?? const []))
        OriginalWord.fromJson(w as Map<String, dynamic>)
    ];
  }

  test('every verse keeps every word, and 98% of them carry a number', () {
    var words = 0, numbered = 0;
    final damaged = <String>[];
    for (final v in wlc) {
      final text = v['text'] as String;
      final aligned = alignWlcWords(
          text, taggedFor(v['book'] as String, '${v['chapter']}', '${v['verse']}'));
      // Not one word added, dropped or changed.
      if (aligned.map((w) => w.text).join() != text.replaceAll(RegExp(r'\s+'), '')) {
        damaged.add('${v['book']} ${v['chapter']}:${v['verse']}');
      }
      for (final w in aligned) {
        if (!RegExp('[א-ת]').hasMatch(w.text)) continue;
        words++;
        if (w.strongs.isNotEmpty) numbered++;
      }
    }
    expect(damaged, isEmpty,
        reason: 'the WLC row must print the edition exactly: $damaged');
    // 299,553 of 305,507 (98.05%) on 2026-09-21. The rest are the
    // preposition-with-suffix forms Strong's gives no number of its own.
    expect(numbered / words, greaterThan(0.98),
        reason: 'only $numbered of $words WLC words got a number');
  });

  test('the numbers land on the right words', () {
    // Genesis 1:1 word for word — the one verse every reader checks.
    final gen11 = wlc.firstWhere((v) =>
        v['book'] == 'Genesis' && '${v['chapter']}' == '1' && '${v['verse']}' == '1');
    final aligned = alignWlcWords(
        gen11['text'] as String, taggedFor('Genesis', '1', '1'));
    expect([for (final w in aligned) w.strongs],
        ['H7225', 'H1254', 'H430', 'H853', 'H8064', 'H853', 'H776']);

    // And a word the tagged list lacks is SHOWN, just unnumbered, with
    // the words either side of it still correctly numbered.
    final gen111 = wlc.firstWhere((v) =>
        v['book'] == 'Genesis' && '${v['chapter']}' == '1' && '${v['verse']}' == '11');
    final a = alignWlcWords(
        gen111['text'] as String, taggedFor('Genesis', '1', '11'));
    final bo = a.indexWhere((w) => w.text.contains('ב֖וֹ'));
    expect(bo, greaterThan(0), reason: 'בּוֹ must still be printed');
    expect(a[bo].strongs, isEmpty);
    expect(a[bo - 1].strongs, isNotEmpty,
        reason: 'the word before בּוֹ lost its number');
  });

  test('a maqaf stays with the word before it', () {
    expect(wlcTokens('עַל־פְּנֵ֣י תְה֑וֹם'), ['עַל־', 'פְּנֵ֣י', 'תְה֑וֹם']);
  });
}
