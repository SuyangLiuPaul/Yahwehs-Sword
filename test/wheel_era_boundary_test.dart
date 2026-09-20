/// The BC|AD boundary — where it sits, and that it is visible.
///
/// 2026-09-21, 「sword wheel 真好6个字 一半的位置应该是0年 现在好像在
/// 7-8个字位置，并且要highlight出来」. Two claims, and this file holds
/// both of them, because they fail independently: the year can be at
/// the right bearing and still print nothing, which is exactly the
/// state the owner was looking at.
///
/// The clock arithmetic is in `radial_chronology_layout_test`. What is
/// here is the SECOND half — that the boundary has a mark of its own,
/// drawn outside the label budget that used to throw its word away.
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:yahwehs_sword/pages/radial_chronology_page.dart'
    show centuryTickLabel, kMaxYear, kMinYear;
import 'package:yahwehs_sword/utils/radial_chronology_layout.dart';

void main() {
  test('the boundary keeps its tick line and loses only its ring copy', () {
    final planned = planAxisLabels(
      minYear: kMinYear,
      maxYear: kMaxYear,
      tickLabel: (y) => centuryTickLabel(y, 'zh-Hans'),
      endLabel: (y) => '$y',
      endSwing: 0.1,
    );
    // The plan still offers it — this function is shared with the strip,
    // which has no separate boundary mark and needs the word here.
    expect(planned.where((l) => l.onRing && l.year == 0), hasLength(1));

    final kept = withoutEraBoundaryRingLabel(planned);
    expect(kept.where((l) => l.year == 0), isEmpty);
    // Nothing else was taken: both range ends and every other century.
    expect(kept.length, planned.length - 1);
    expect(kept.where((l) => !l.onRing), hasLength(2));
  });

  /// A SOURCE-LEVEL GUARD, and it is the honest kind for this one.
  ///
  /// The boundary is strokes and a plate on the wheel's own canvas.
  /// Canvas ink leaves no widget, no semantics node and nothing a
  /// `find.text` can reach, and this file is not the place to stand up
  /// a recording canvas for two `drawLine` calls. What can go wrong
  /// silently is the WIRING — a painter method that nothing calls
  /// compiles, analyzes and ships as a blank axis — so that is what is
  /// pinned. The geometry it draws at is covered by the layout test.
  test('the wheel painter actually calls the boundary', () {
    final src = File('lib/pages/radial_chronology_page.dart').readAsStringSync();
    expect(src, contains('void _paintEraBoundary('),
        reason: 'the boundary painter is gone');
    expect(src, contains('_paintEraBoundary(canvas, c, rHub, rRim);'),
        reason: 'the boundary painter is defined but never called — the '
            'axis would ship without its one named tick');
    // Drawn after the rim and the axis ends, or the bands print over it.
    expect(
        src.indexOf('_paintEraBoundary(canvas, c, rHub, rRim);'),
        greaterThan(src.indexOf('_paintRim(canvas, c, rBands, rRim);')),
        reason: 'the boundary must be drawn on top of the rings');
  });

  test('the word it prints names the boundary in the reader\'s language', () {
    expect(centuryTickLabel(0, 'en'), 'BC | AD');
    expect(centuryTickLabel(0, 'zh-Hans'), '主前｜主后');
    expect(centuryTickLabel(0, 'zh-Hant'), '主前｜主後');
  });
}
