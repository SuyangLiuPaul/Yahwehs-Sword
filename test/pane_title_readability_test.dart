import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yahwehs_sword/models/app_settings.dart';
import 'package:yahwehs_sword/widgets/workbench_chrome.dart';

void main() {
  for (final title in [
    'Parallel Bible: King James Version and New Testament Greek',
    '圣经对照：和合本雅伟版与新约希腊文',
    '聖經對照：和合本雅偉版與新約希臘文',
  ]) {
    testWidgets('pane title wraps without shrinking: $title', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final settings = AppSettings();
      var taps = 0;
      for (final scale in [1.0, 1.8]) {
        await tester.pumpWidget(ChangeNotifierProvider.value(
          value: settings,
          child: MaterialApp(
            home: MediaQuery(
              data: MediaQueryData(textScaler: TextScaler.linear(scale)),
              child: Scaffold(
                body: Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    width: 180,
                    child: WbPaneTitle(title: title, onTitleTap: () => taps++),
                  ),
                ),
              ),
            ),
          ),
        ));
        await tester.pump(const Duration(milliseconds: 700));
        expect(tester.takeException(), isNull);
        expect(
          find.descendant(
              of: find.byType(WbPaneTitle), matching: find.byType(FittedBox)),
          findsNothing,
        );
        final text = tester.widget<Text>(find.text(title));
        expect(text.softWrap, isTrue);
        expect(text.maxLines, isNull);
        await tester.tap(find.text(title));
      }
      expect(taps, 2);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 700));
      settings.dispose();
    });
  }
}
