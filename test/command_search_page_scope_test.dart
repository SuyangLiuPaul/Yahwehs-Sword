/// 2026-10-15: the full-screen search page lost the search scope.
///
/// A reader on a phone picked "John, 1 John, 2 John, 3 John" on the scope
/// sheet, tapped the magnifier, and landed on a search whose chips said
/// "Entire Bible": `CommandSearchPage` built a fresh `WorkbenchProvider`
/// and the limit lived on the Workbench's. The Workbench now hands its own
/// provider over; these pin that the scope arrives, is still the
/// Workbench's when the page closes, and that a page opened with no
/// Workbench (the standalone reader) still works on its own.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yahwehs_sword/constants/workbench_theme.dart';
import 'package:yahwehs_sword/models/app_settings.dart';
import 'package:yahwehs_sword/models/verse.dart';
import 'package:yahwehs_sword/pages/command_search_page.dart';
import 'package:yahwehs_sword/providers/main_provider.dart';
import 'package:yahwehs_sword/providers/workbench_provider.dart';

const _seed = [
  Verse(book: 'Genesis', chapter: 1, verse: 1, text: 'In the beginning God'),
  Verse(book: 'John', chapter: 3, verse: 16, text: 'should have eternal life'),
  Verse(book: '1 John', chapter: 5, verse: 13, text: 'ye have eternal life'),
  Verse(book: 'Romans', chapter: 6, verse: 23, text: 'is eternal life through'),
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<MainProvider> pumpPage(WidgetTester tester,
      {WorkbenchProvider? Function(MainProvider mp)? workbench}) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.reset);
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final mp = MainProvider()
      ..setVerses(_seed)
      ..currentVersion = 'kjv';
    final settings = AppSettings();
    await settings.setLocale('en');
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: mp),
        ChangeNotifierProvider.value(value: settings),
      ],
      child: Builder(
        builder: (context) => MaterialApp(
          theme: workbenchTheme(Theme.of(context)),
          home: CommandSearchPage(workbench: workbench?.call(mp)),
        ),
      ),
    ));
    await tester.pump(const Duration(seconds: 1));
    return mp;
  }

  testWidgets('the scope picked in the Workbench is the scope searched',
      (tester) async {
    late WorkbenchProvider wb;
    await pumpPage(tester, workbench: (mp) {
      wb = WorkbenchProvider(mainProvider: mp);
      return wb;
    });
    addTearDown(wb.dispose);
    // What the scope sheet does with the ticked books.
    final applied = await tester.runAsync(
        () => wb.setSearchLimitFromBooks({'John', '1 John'}));
    expect(applied, isTrue);
    await tester.pump(const Duration(milliseconds: 100));

    await tester.enterText(find.byType(TextField), 'eternal life');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    for (var i = 0; i < 8; i++) {
      await tester.runAsync(() => Future<void>.delayed(
          const Duration(milliseconds: 20)));
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(wb.hasSearchLimit, isTrue);
    final books = wb.textResults.map((v) => v.book).toSet();
    expect(books, isNotEmpty);
    expect(books.difference({'John', '1 John'}), isEmpty,
        reason: 'a hit outside the chosen books means the page searched the '
            'whole Bible instead of the scope');
    // The banner says so, so the limit is never silent.
    expect(find.textContaining('Limited to'), findsOneWidget);
  });

  testWidgets('closing the page leaves the Workbench provider usable',
      (tester) async {
    late WorkbenchProvider wb;
    await pumpPage(tester, workbench: (mp) {
      wb = WorkbenchProvider(mainProvider: mp);
      return wb;
    });
    addTearDown(wb.dispose);
    await tester.runAsync(() => wb.setSearchLimitFromBooks({'John'}));

    await tester.pumpWidget(const SizedBox());
    // Borrowed, so the page must not have disposed it: touching a
    // disposed ChangeNotifier asserts.
    expect(() => wb.addListener(() {}), returnsNormally);
    expect(wb.hasSearchLimit, isTrue);
  });

  testWidgets('with no Workbench the page searches the whole Bible',
      (tester) async {
    await pumpPage(tester);
    expect(find.textContaining('Limited to'), findsNothing);
  });
}
