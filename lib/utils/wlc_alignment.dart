/// Strong's numbers for the WLC edition's own words.
///
/// 2026-09-21, from a phone screenshot of Daniel 1 in 对照: 「why希伯来文
/// 没有编号的」. The 雅简+ and LXX+WH rows carried numbers and the WLC
/// row did not, because WLC was never in `TaggedTextService`'s list — it
/// has no tagged asset of its own. The app DOES carry the same text
/// tagged word by word, as `assets/originals` (openscriptures/morphhb,
/// behind the 原文 sheet), so the numbers were already on the device.
///
/// WHY THIS ALIGNS INSTEAD OF SWAPPING. Drawing the WLC row straight
/// from `assets/originals` was measured first and would have DELETED
/// Hebrew: 5,644 of the 23,213 verses are missing at least one word
/// there — בּוֹ, לָהֶם, לָכֶם, a preposition carrying a suffix, which
/// the source tags as a bare prefix and the import dropped. So the row
/// keeps the edition's text exactly as printed, and each of its words
/// takes a number by walking the tagged list alongside it. A word the
/// tagged list does not have is shown with no number, which is the
/// truth: Strong's gives those prepositions no number of their own.
///
/// Measured over the whole Old Testament on 2026-09-21: 299,553 of the
/// edition's 305,507 words numbered (98.05%), 300,698 of the 300,808
/// tagged words placed, and every verse's text reproduced exactly.
///
/// Matched on CONSONANTS (א–ת) only. The two sources order their points
/// and accents differently — byte-comparing identical-looking words
/// failed on 23,034 verses before any normalisation — and Dart has no
/// Unicode normaliser to hand. The consonants are what makes a word
/// that word, and the walk is sequential, so a skeleton shared by two
/// different words cannot pair them out of order.
library;

import 'package:yahwehs_sword/models/original_word.dart';

const int _alef = 0x05D0;
const int _tav = 0x05EA;
const int _maqaf = 0x05BE;

String _consonants(String s) => String.fromCharCodes(
    s.runes.where((c) => c >= _alef && c <= _tav));

/// The edition's words, as printed: split at spaces and after a maqaf,
/// the maqaf staying with the word before it. Punctuation (sof pasuq,
/// paseq) stays attached to the word it follows.
List<String> wlcTokens(String text) {
  final out = <String>[];
  for (final part in text.split(RegExp(r'\s+'))) {
    if (part.isEmpty) continue;
    var start = 0;
    final runes = part.runes.toList();
    for (var i = 0; i < runes.length; i++) {
      if (runes[i] == _maqaf) {
        out.add(String.fromCharCodes(runes.sublist(start, i + 1)));
        start = i + 1;
      }
    }
    if (start < runes.length) {
      out.add(String.fromCharCodes(runes.sublist(start)));
    }
  }
  return out;
}

/// [text]'s words, each carrying the Strong's number and parsing of the
/// [tagged] word it lines up with, or none.
///
/// Never adds, drops or alters a word of [text]: joining the result's
/// `text` fields reproduces [text] without its spaces.
List<OriginalWord> alignWlcWords(String text, List<OriginalWord> tagged) {
  final out = <OriginalWord>[];
  final n = tagged.length;
  var j = 0;
  OriginalWord take(String token, OriginalWord src) => OriginalWord(
        text: token,
        strongs: src.strongs,
        translit: src.translit,
        morph: src.morph,
        ketivQere: src.ketivQere,
      );
  for (final token in wlcTokens(text)) {
    final k = _consonants(token);
    if (k.isEmpty) {
      out.add(OriginalWord(text: token, strongs: ''));
      continue;
    }
    // The next tagged word is this one.
    if (j < n && _consonants(tagged[j].text) == k) {
      out.add(take(token, tagged[j++]));
      continue;
    }
    // The tagged list has a word or two the text does not print here —
    // a ketiv beside its qere — so step over them.
    var matched = false;
    for (final skip in const [1, 2]) {
      if (j + skip < n && _consonants(tagged[j + skip].text) == k) {
        j += skip;
        out.add(take(token, tagged[j++]));
        matched = true;
        break;
      }
    }
    if (matched) continue;
    // One printed word the tagged list splits in two.
    if (j + 1 < n &&
        _consonants(tagged[j].text + tagged[j + 1].text) == k) {
      out.add(take(token, tagged[j]));
      j += 2;
      continue;
    }
    // A word the tagged list does not have. Shown, unnumbered.
    out.add(OriginalWord(text: token, strongs: ''));
  }
  return out;
}
