import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:yahwehs_sword/models/app_settings.dart';
import 'package:yahwehs_sword/models/bible_evidence.dart';
import 'package:yahwehs_sword/models/verse.dart';
import 'package:yahwehs_sword/pages/evidence_detail_page.dart';
import 'package:yahwehs_sword/providers/main_provider.dart';
import 'package:yahwehs_sword/utils/reference_parser.dart';

/// A citation the app cannot open must not be dressed as a link.
///
/// Two of the 225 evidence entries cite something outside every version
/// we ship — `cairo_genizah` cites `Ecclesiasticus (Sirach) 39:1`, which
/// is deuterocanonical, and `strabo_geography` cites the prose
/// `Various NT references`. Both went down the single-reference path,
/// which wired `onTap` unconditionally, so the card and the detail page
/// each offered a 「→ 阅读经文」 that could only answer "Couldn't parse
/// reference".
///
/// Nothing is wrong with the data: those are honest citations of things
/// that are not in the app. It was the affordance that lied, and an
/// affordance that always fails teaches a reader that the app's
/// cross-links to scripture do not work — which then discourages them
/// from following the 223 that do.
BibleEvidence _evidence(String reference) => BibleEvidence(
      id: 'test-unresolvable',
      category: 'Manuscripts',
      bibleBooks: const [],
      timeline: '1st century',
      discoveryDate: '1896',
      location: 'Cairo',
      scriptureReference: reference,
      images: const [],
      academicSources: const [],
      confidenceLevel: 'high',
      icon: 'scroll',
      title: const {'en': 'Unresolvable citation'},
      summary: const {'en': 'Summary.'},
      description: const {'en': 'Description.'},
      scripturalCorrelation: const {'en': 'Correlation.'},
    );

class _Settings extends AppSettings {
  @override
  String get locale => 'en';
}

Future<void> _pump(WidgetTester tester, String reference) async {
  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = const Size(402, 874);
  final mp = MainProvider();
  mp.setVersion('kjv');
  mp.setVerses([
    for (var v = 1; v <= 31; v++)
      Verse(book: 'Genesis', chapter: 1, verse: v, text: 'v$v'),
  ]);
  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: mp),
        ChangeNotifierProvider<AppSettings>(create: (_) => _Settings()),
      ],
      child: MaterialApp(
        home: EvidenceDetailPage(evidence: _evidence(reference)),
      ),
    ),
  );
  await tester.pump(const Duration(milliseconds: 100));
  await tester.pump(const Duration(milliseconds: 400));
}

/// The chip's tap target: the only `InkWell` on the page whose corner
/// radius is the chip's 8.
Finder _chipTapTargets() => find.byWidgetPredicate((w) =>
    w is InkWell &&
    w.onTap != null &&
    w.borderRadius == BorderRadius.circular(8));

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    Get.testMode = true;
  });

  test('all evidence citation parts retain distinct navigation targets', () {
    final entries =
        (jsonDecode(File('assets/bible_evidence.json').readAsStringSync())
            as Map)['evidences'] as List;
    expect(entries.length, 225);
    final missing = <String>[];
    for (final entry in entries) {
      for (final part in splitCitation(entry['scriptureReference'] as String)) {
        if (part.target == null) missing.add(part.text);
      }
    }
    expect(missing, ['Ecclesiasticus (Sirach) 39:1', 'Various NT references']);
    final verses = splitCitation('John 18:31-33, 37-38');
    expect(verses.last.target!.chapter, 18);
    expect(verses.last.target!.verseStart, 37);
    final chapters = splitCitation('Daniel 2, 7, 8, 11');
    expect(chapters.map((part) => part.target!.chapter), [2, 7, 8, 11]);
    expect(splitCitation('Exodus 14:21-22; Sirach 44:1; 45:1').last.target,
        isNull);
  });

  testWidgets('an unresolvable citation is plain text, not a link',
      (tester) async {
    addTearDown(tester.view.reset);
    await _pump(tester, 'Ecclesiasticus (Sirach) 39:1');

    // The citation is still printed — the entry cites it and the card
    // goes on saying so.
    expect(
      find.byWidgetPredicate((w) =>
          w is RichText &&
          w.text.toPlainText().contains('Ecclesiasticus (Sirach) 39:1')),
      findsWidgets,
    );
    // Pre-fix this found one, and tapping it produced only a snackbar.
    expect(_chipTapTargets(), findsNothing);
    expect(find.byIcon(Icons.arrow_forward), findsNothing,
        reason: 'the arrow promises a destination there is none of');
  });

  testWidgets('an external citation explains why it cannot open in the reader',
      (tester) async {
    addTearDown(tester.view.reset);
    await _pump(tester, 'Ecclesiasticus (Sirach) 39:1');
    await tester.ensureVisible(find.text('About this citation'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('About this citation'));
    await tester.pumpAndSettle();
    expect(find.text('Reference outside the reader'), findsOneWidget);
    expect(find.textContaining('installed Bible editions'), findsOneWidget);
    expect(_chipTapTargets(), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('prose in the reference field is plain text too', (tester) async {
    addTearDown(tester.view.reset);
    await _pump(tester, 'Various NT references');

    expect(_chipTapTargets(), findsNothing);
    expect(find.byIcon(Icons.arrow_forward), findsNothing);
  });

  testWidgets('a resolvable single citation keeps its chip and its jump',
      (tester) async {
    addTearDown(tester.view.reset);
    await _pump(tester, 'Genesis 1:1');

    expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
    expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
  });
}
