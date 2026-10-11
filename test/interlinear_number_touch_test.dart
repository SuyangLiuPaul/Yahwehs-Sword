import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yahwehs_sword/constants/word_study_style.dart';
import 'package:yahwehs_sword/constants/workbench_theme.dart';
import 'package:yahwehs_sword/models/app_settings.dart';
import 'package:yahwehs_sword/services/tagged_text_service.dart';
import 'package:yahwehs_sword/widgets/interlinear_verse_text.dart';

void main() {
  testWidgets(
      'touch coordinates route each source number after wrapping and rebuild',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final settings = AppSettings();
    final taps = <(TaggedRun, String)>[];
    final run = TaggedRun.fromJson({
      'w': '每日，',
      's': 'G2596',
      'i': ['G2250'],
      's2': ['G3588'],
      'g': ['G5723']
    });
    for (final scale in [1.0, 1.6]) {
      await tester.pumpWidget(ChangeNotifierProvider.value(
          value: settings,
          child: MaterialApp(
              home: Builder(
                  builder: (context) => Scaffold(
                      body: MediaQuery(
                          data: MediaQueryData(
                              textScaler: TextScaler.linear(scale)),
                          child: Center(
                              child: SizedBox(
                                  width: 260,
                                  child: InterlinearVerseText(
                                    runs: [run],
                                    showNumbers: true,
                                    style: WordStudyStyle.resolve(
                                        embedded: false,
                                        scheme: Theme.of(context).colorScheme,
                                        wb: WbColors.of(context),
                                        type: WbType.of(context)),
                                    onTapRun: (r) => taps.add((r, r.strongs)),
                                    onTapNumber: (r, n) => taps.add((r, n)),
                                  )))))))));
      await tester.pumpAndSettle();
      final finder = find
          .descendant(
              of: find.byType(InterlinearVerseText),
              matching: find.byType(RichText))
          .first;
      final paragraph = tester.renderObject<RenderParagraph>(finder);
      final text = paragraph.text.toPlainText();
      for (final number in ['G2250', 'G2596', 'G3588']) {
        final start = text.indexOf(number);
        final boxes = paragraph.getBoxesForSelection(TextSelection(
            baseOffset: start, extentOffset: start + number.length));
        expect(boxes, isNotEmpty);
        await tester
            .tapAt(paragraph.localToGlobal(boxes.first.toRect().center));
        await tester.pump();
        expect(taps.last, (run, number));
      }
      expect(tester.takeException(), isNull);
    }
    await tester.pumpWidget(const SizedBox());
    settings.dispose();
  });
  for (final version in TaggedTextService.taggedVersions) {
    testWidgets('$version actual Hebrews word routes its lexical numbers',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      final settings = AppSettings();
      final runs = await tester.runAsync(() => TaggedTextService.forVerse(
          version: version, englishBook: 'Hebrews', chapter: 7, verse: 27));
      expect(runs, isNotEmpty);
      final run = runs!.firstWhere((r) => r.lexicalNumbers.contains('G2250'));
      final taps = <(TaggedRun, String)>[];
      for (final scale in [1.0, 1.6]) {
        await tester.pumpWidget(ChangeNotifierProvider.value(
            value: settings,
            child: MaterialApp(
                home: Builder(
                    builder: (context) => Scaffold(
                        body: MediaQuery(
                            data: MediaQueryData(
                                textScaler: TextScaler.linear(scale)),
                            child: Center(
                                child: SizedBox(
                                    width: 280,
                                    child: InterlinearVerseText(
                                        runs: [run],
                                        showNumbers: true,
                                        style: WordStudyStyle.resolve(
                                            embedded: false,
                                            scheme:
                                                Theme.of(context).colorScheme,
                                            wb: WbColors.of(context),
                                            type: WbType.of(context)),
                                        onTapNumber: (r, n) =>
                                            taps.add((r, n)))))))))));
        await tester.pumpAndSettle();
        final finder = find
            .descendant(
                of: find.byType(InterlinearVerseText),
                matching: find.byType(RichText))
            .first;
        final paragraph = tester.renderObject<RenderParagraph>(finder);
        final text = paragraph.text.toPlainText();
        for (final number in run.lexicalNumbers) {
          final start = text.indexOf(number);
          expect(start, isNonNegative);
          final boxes = paragraph.getBoxesForSelection(TextSelection(
              baseOffset: start, extentOffset: start + number.length));
          expect(boxes, isNotEmpty);
          await tester
              .tapAt(paragraph.localToGlobal(boxes.first.toRect().center));
          await tester.pump();
          expect(taps.last, (run, number));
        }
        expect(tester.takeException(), isNull);
      }
      await tester.pumpWidget(const SizedBox());
      settings.dispose();
    });
  }
}
