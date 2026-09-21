/// A phone reading the chapter gets the reader's own bars, not five of
/// the workspace's.
///
/// 2026-09-21, 「sword read mode是不是很多界面应该学习words … 在保持
/// sword风格的同时」, with the bottom tabs ruled out: 「那个不用」.
/// Measured at 390 wide on John 3 before the change: menu bar, toolbar,
/// title row, Search/Read/Analysis tabs and a status line around the
/// text, where Words spends a floating top bar and a reading bar. Sword's
/// reader is that same reader with its bars switched off
/// (`hostChrome: true`); on a phone in read mode they are switched back
/// on and the workspace's step aside.
///
/// What this file holds is the other half of that trade — that nothing
/// became unreachable. The workspace's menus are one tap away as a
/// sheet, the side-pane entries in it open their screens on a phone, and
/// those screens bring the workspace back. And none of it touches a
/// wide screen, or a phone in 对照.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:yahwehs_sword/constants/ui_strings.dart';
import 'package:yahwehs_sword/models/app_settings.dart';
import 'package:yahwehs_sword/models/verse.dart';
import 'package:yahwehs_sword/models/wb_centre_mode.dart';
import 'package:yahwehs_sword/pages/workbench_page.dart';
import 'package:yahwehs_sword/providers/main_provider.dart';
import 'package:yahwehs_sword/widgets/workbench_chrome.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pump(WidgetTester tester, Size size, WbCentreMode mode) async {
    addTearDown(tester.view.reset);
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = size;
    SharedPreferences.setMockInitialValues(<String, Object>{
      kWorkbenchCentreModeKey: centreModeToStorage(mode),
    });
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) {
            final mp = MainProvider();
            mp.setVerses(const [
              Verse(book: 'John', chapter: 3, verse: 16, text: 'seed 16'),
              Verse(book: 'John', chapter: 3, verse: 17, text: 'seed 17'),
            ]);
            mp.setCurrentChapter(book: 'John', chapter: 3);
            return mp;
          }),
          ChangeNotifierProvider(create: (_) => AppSettings()),
        ],
        child: const MaterialApp(home: WorkbenchPage()),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 400));
  }

  void expectWorkspaceChrome(bool present) {
    final m = present ? findsOneWidget : findsNothing;
    expect(find.byType(WorkbenchMenuBar), m, reason: 'menu bar');
    expect(find.byType(WorkbenchToolbar), m, reason: 'toolbar');
    expect(find.byType(WorkbenchStatusBar), m, reason: 'status line');
  }

  final phone = const Size(390, 844);

  testWidgets('a phone in read mode draws the reader\'s bars, not the '
      'workspace\'s', (tester) async {
    await pump(tester, phone, WbCentreMode.reader);
    expect(tester.takeException(), isNull);
    expectWorkspaceChrome(false);
    expect(find.byKey(const ValueKey('workbench-phone-tab-read')), findsNothing,
        reason: 'the Search/Read/Analysis tabs are not needed here');
    // The door to everything the menu bar carried.
    expect(find.byKey(const ValueKey('reader-workspace-menu')), findsOneWidget);
    // And no Home: the workspace IS the app, and popping to the first
    // route would land on the splash.
    expect(find.byIcon(Icons.home_rounded), findsNothing);
  });

  testWidgets('the menu button opens the workspace menus, and a side-pane '
      'entry opens its screen with the workspace around it', (tester) async {
    await pump(tester, phone, WbCentreMode.reader);
    await tester.tap(find.byKey(const ValueKey('reader-workspace-menu')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('workbenchMenuSheet')), findsOneWidget);

    final searchWindow = uiStrings['menuSearchWindow']!['zh-Hans']!;
    await tester.tap(find.descendant(
        of: find.byKey(const ValueKey('workbenchMenuSheet')),
        matching: find.text(searchWindow)));
    await tester.pumpAndSettle();

    // The Search screen is a workspace surface, so the workspace — tabs
    // included — is back, and the Read tab is the way to the reader.
    expectWorkspaceChrome(true);
    expect(find.byKey(const ValueKey('workbench-phone-tab-read')),
        findsOneWidget);
  });

  testWidgets('a phone in 对照 keeps the workspace', (tester) async {
    await pump(tester, phone, WbCentreMode.browse);
    expectWorkspaceChrome(true);
    expect(find.byKey(const ValueKey('reader-workspace-menu')), findsNothing);
  });

  testWidgets('a wide screen keeps the workspace in read mode', (tester) async {
    await pump(tester, const Size(1400, 900), WbCentreMode.reader);
    expectWorkspaceChrome(true);
    expect(find.byKey(const ValueKey('reader-workspace-menu')), findsNothing);
  });
}
