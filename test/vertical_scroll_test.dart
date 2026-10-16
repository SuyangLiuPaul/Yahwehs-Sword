// 2026-10-16: continuous vertical scrolling — chapters flow into each
// other in one list, the current chapter follows the scroll, and the
// reader's own navigation still lands on the right chapter. Off by
// default.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:yahwehs_sword/models/app_settings.dart';
import 'package:yahwehs_sword/models/book.dart';
import 'package:yahwehs_sword/models/chapter.dart';
import 'package:yahwehs_sword/models/verse.dart';
import 'package:yahwehs_sword/providers/main_provider.dart';
import 'package:yahwehs_sword/widgets/bible_reading_pane.dart';

List<Verse> _chapter(String book, int c, {int verses = 12}) => [
      for (var v = 1; v <= verses; v++)
        Verse(
            book: book,
            chapter: c,
            verse: v,
            text: '$book $c:$v ${'and God spoke these words for a while ' * 4}'),
    ];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<(MainProvider, AppSettings)> pumpReader(WidgetTester tester,
      {required bool vertical, int startChapter = 1}) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.reset);
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final verses = [
      for (var c = 1; c <= 8; c++) ..._chapter('Genesis', c),
    ];
    final settings = AppSettings();
    await settings.setVerticalScroll(vertical);
    late MainProvider mp;
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) {
          mp = MainProvider()
            ..currentBook = 'Genesis'
            ..currentChapter = startChapter
            ..setBooks([
              Book(title: 'Genesis', chapters: [
                for (var c = 1; c <= 8; c++)
                  Chapter(title: c, verses: _chapter('Genesis', c)),
              ]),
            ])
            ..setVerses(verses);
          return mp;
        }),
        ChangeNotifierProvider<AppSettings>.value(value: settings),
      ],
      child: const MaterialApp(home: Scaffold(body: BibleReadingPane())),
    ));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 700));
    return (mp, settings);
  }

  testWidgets('off by default: the reader pages, no chapter headings between',
      (tester) async {
    final (mp, settings) = await pumpReader(tester, vertical: false);
    expect(settings.verticalScroll, isFalse);
    expect(find.byKey(const ValueKey('flow.heading.Genesis 2')), findsNothing);
    expect(mp.currentChapter, 1);
  });

  testWidgets('on: the next chapter is in the same list, below the first',
      (tester) async {
    final (mp, _) = await pumpReader(tester, vertical: true);
    expect(mp.currentChapter, 1);
    expect(find.byKey(const ValueKey('flow.heading.Genesis 1')), findsOneWidget);
    for (var i = 0; i < 40; i++) {
      if (find
          .byKey(const ValueKey('flow.heading.Genesis 2'))
          .evaluate()
          .isNotEmpty) {
        break;
      }
      await tester.drag(find.byType(BibleReadingPane), const Offset(0, -300));
      await tester.pump(const Duration(milliseconds: 400));
    }
    expect(find.byKey(const ValueKey('flow.heading.Genesis 2')), findsOneWidget);
  });

  testWidgets('scrolling into chapter 3 makes it current, and back up to 2',
      (tester) async {
    final (mp, _) = await pumpReader(tester, vertical: true);
    for (var i = 0; i < 80 && mp.currentChapter != 3; i++) {
      await tester.drag(find.byType(BibleReadingPane), const Offset(0, -400));
      await tester.pump(const Duration(milliseconds: 300));
    }
    expect(mp.currentChapter, 3);
    for (var i = 0; i < 80 && mp.currentChapter != 2; i++) {
      await tester.drag(find.byType(BibleReadingPane), const Offset(0, 400));
      await tester.pump(const Duration(milliseconds: 300));
    }
    expect(mp.currentChapter, 2);
  });

  testWidgets('the bottom bar steps to the next chapter heading',
      (tester) async {
    final (mp, _) = await pumpReader(tester, vertical: true);
    await tester.tap(find.byIcon(Icons.chevron_right_rounded));
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump(const Duration(milliseconds: 600));
    expect(mp.currentChapter, 2);
    final y = tester
        .getTopLeft(find.byKey(const ValueKey('flow.heading.Genesis 2')))
        .dy;
    expect(y, lessThan(200), reason: 'chapter 2 starts near the top');
  });

  testWidgets('opening on chapter 5: earlier chapters are above, not missing',
      (tester) async {
    final (mp, _) = await pumpReader(tester, vertical: true, startChapter: 5);
    expect(mp.currentChapter, 5);
    expect(find.byKey(const ValueKey('flow.heading.Genesis 5')), findsOneWidget);
    for (var i = 0; i < 80 && mp.currentChapter != 4; i++) {
      await tester.drag(find.byType(BibleReadingPane), const Offset(0, 400));
      await tester.pump(const Duration(milliseconds: 300));
    }
    expect(mp.currentChapter, 4);
  });
}
