/// Sword's text on a phone is Yahweh's Words' size — 2026-09-21,
/// 「跟words一样大」, after a glyph-for-glyph comparison of both apps at 390
/// wide.
///
/// Two mechanisms, both phone-only, and both pinned here from the side
/// that can silently regress: the theme's text roles
/// (`withPhoneTextRoles`), which is where every theme-driven list title
/// and search hint gets its size, and the page boost
/// (`kPhonePageBoost`), for the pages Sword wrote at the workbench's
/// density. A wide screen gets neither.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:yahwehs_sword/constants/workbench_theme.dart';
import 'package:yahwehs_sword/models/app_settings.dart';
import 'package:yahwehs_sword/pages/atlas_page.dart';
import 'package:yahwehs_sword/pages/hebrew_kings_page.dart';
import 'package:yahwehs_sword/pages/illustrations_page.dart';
import 'package:yahwehs_sword/pages/lexicon_page.dart';
import 'package:yahwehs_sword/pages/modern_concordance_page.dart';
import 'package:yahwehs_sword/pages/naves_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  /// Resolves [probe] under the app's real theme, at [width].
  Future<T> under<T>(WidgetTester tester, double width,
      T Function(BuildContext) probe, {bool boosted = false}) async {
    addTearDown(tester.view.reset);
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = Size(width, 800);
    SharedPreferences.setMockInitialValues(<String, Object>{});
    late T out;
    Widget leaf = Builder(builder: (context) {
      out = probe(context);
      return const SizedBox();
    });
    if (boosted) leaf = WbPhoneBoost(child: leaf);
    await tester.pumpWidget(ChangeNotifierProvider(
      create: (_) => AppSettings(),
      child: MaterialApp(
        home: Builder(
          builder: (context) => Theme(
            data: withPhoneTextRolesOn(
                context, workbenchTheme(Theme.of(context)),
                fontSize: kFontSizeDefault),
            child: leaf,
          ),
        ),
      ),
    ));
    return out;
  }

  testWidgets('on a phone the theme\'s roles are Words\' sizes',
      (tester) async {
    final t = await under(tester, 390, (c) => Theme.of(c));
    // Words' own theme: fontSize, fontSize - 2, fontSize + 4.
    expect(t.textTheme.bodyLarge!.fontSize, 20);
    expect(t.textTheme.bodyMedium!.fontSize, 18);
    expect(t.textTheme.titleLarge!.fontSize, 24);
    // And Material's for the three this theme had pinned at 11 px.
    expect(t.textTheme.bodySmall!.fontSize, 12);
    expect(t.textTheme.labelSmall!.fontSize, 11);
    expect(t.textTheme.titleSmall!.fontSize, 14);
    // A search field's hint, which is where the sermon page's 10.5 px
    // hint came from.
    expect(t.inputDecorationTheme.hintStyle!.fontSize, 20);
  });

  testWidgets('a wide screen keeps the workbench\'s density', (tester) async {
    final t = await under(tester, 1280, (c) => Theme.of(c));
    expect(t.textTheme.bodyLarge!.fontSize, WbMetrics.text);
    expect(t.inputDecorationTheme.hintStyle!.fontSize, WbMetrics.text);
  });

  testWidgets('a boosted page scales by kPhonePageBoost on a phone, and '
      'only there', (tester) async {
    expect(
        await under(tester, 390, (c) => WbType.of(c).textScale, boosted: true),
        closeTo(kPhonePageBoost, 1e-9));
    expect(
        await under(tester, 1280, (c) => WbType.of(c).textScale,
            boosted: true),
        closeTo(1.0, 1e-9));
    // And an ordinary page on a phone is not boosted at all — the
    // ported pages already name Words' sizes and would overshoot.
    expect(await under(tester, 390, (c) => WbType.of(c).textScale),
        closeTo(1.0, 1e-9));
  });

  test('the dense pages carry the boost, and the kings chart does not', () {
    for (final page in <Widget>[
      const NavesPage(),
      const LexiconPage(),
      const IllustrationsPage(),
      const AtlasPage(),
      const ModernConcordancePage(),
    ]) {
      expect(page, isA<PhoneBoostedPage>(), reason: '${page.runtimeType}');
    }
    // A chart lays its labels out for the dense sizes; boosting it was
    // tried and clipped 「大卫 公元前1010–」 at 390 wide.
    expect(const HebrewKingsPage(), isNot(isA<PhoneBoostedPage>()));
  });
}
