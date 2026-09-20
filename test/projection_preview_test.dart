// The projector preview is the wall, smaller — 2026-09-20.
//
// Reported from a phone with a photo: the Settings preview showed the
// verse as a column about five characters wide running down the middle
// of the card, with the reference printed across it.
//
// The cause was handing `ProjectionStage` the preview's own box. The
// stage pins its text to the width it is given and only then lets
// `BoxFit.scaleDown` act (its own "THE CHOSEN SIZE IS A CEILING" doc),
// so wall type — 64 px at the default step — wrapped every few glyphs
// in a ~320 px card and then shrank as an already-wrapped block. The
// preview now lays the stage out at `kProjectionPreviewWallWidth` and
// scales the finished picture down.
//
// What this pins is the line breaking, because that is what went wrong:
// at wall size the verse takes a handful of long lines; in a phone-sized
// box it took dozens of tiny ones.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yahwehs_sword/constants/projection_setup.dart';
import 'package:yahwehs_sword/models/verse.dart';
import 'package:yahwehs_sword/widgets/projection_stage.dart';

const _verse = Verse(
  book: 'Acts',
  chapter: 24,
  verse: 1,
  text: '过了五天，大祭司亚拿尼亚同几个长老，和一个辩士帖士罗下来，'
      '向巡抚控告保罗。',
);

/// Roughly how many CJK glyphs fit on a line of the passage, as laid
/// out: the widest text block's measure divided by the type size. One
/// full-width glyph is one em, so this is the line length the room
/// would read — about 4 in the broken preview, about 17 on a wall.
double _glyphsPerLine(WidgetTester tester) {
  var widest = 0.0;
  for (final p in tester.widgetList<RichText>(find.byType(RichText))) {
    final size = tester.getSize(find.byWidget(p));
    if (size.width > widest) widest = size.width;
  }
  return widest / kProjectionTypeSteps[kProjectionTypeDefaultStep];
}

Future<void> pumpStage(WidgetTester tester, {required Widget box}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(MaterialApp(home: Scaffold(body: box)));
  await tester.pump();
}

Widget _stage() => ProjectionStage(
      verses: const [_verse],
      reference: 'Acts 24:1',
      versionCode: 'cuvs-yhwh',
      typeSize: kProjectionTypeSteps[kProjectionTypeDefaultStep],
      blank: false,
      locale: 'zh-Hans',
      ground: kProjectionGroundDefault,
      secondOn: false,
      secondTexts: null,
      secondCode: null,
      secondLoading: false,
      layout: ProjectionLayout.standard,
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('a phone-sized box alone breaks the verse into a column',
      (tester) async {
    // The old preview, kept as the measurement that justifies the fix.
    await pumpStage(tester,
        box: SizedBox(
            width: 318, child: AspectRatio(aspectRatio: 16 / 9, child: _stage())));
    expect(_glyphsPerLine(tester), lessThan(8),
        reason: 'this is the symptom: about four glyphs to a line');
  });

  testWidgets('laid out at wall size it reads in a few long lines',
      (tester) async {
    await pumpStage(
      tester,
      box: SizedBox(
        width: 318,
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: FittedBox(
            fit: BoxFit.contain,
            child: SizedBox(
              width: kProjectionPreviewWallWidth,
              height: kProjectionPreviewWallWidth * 9 / 16,
              child: _stage(),
            ),
          ),
        ),
      ),
    );
    final perLine = _glyphsPerLine(tester);
    expect(perLine, greaterThan(12),
        reason: 'the wall reads in long lines; this measured $perLine');
    expect(tester.takeException(), isNull);
  });

  testWidgets('the wall itself is untouched', (tester) async {
    // The stage on a real 1280x720 surface must be exactly what it was.
    tester.view.physicalSize = const Size(1280, 720);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: _stage())));
    await tester.pump();
    expect(_glyphsPerLine(tester), greaterThan(12));
  });
}
