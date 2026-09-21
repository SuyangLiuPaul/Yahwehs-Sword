/// The wheel's geometry, which is the part worth testing.
///
/// FOUR GROUPS LEFT THIS FILE when the Anno Mundi half of
/// `radial_chronology_layout.dart` was deleted: `angleForYear`,
/// `buildWheelArcs`, `hitTest` and `wheelTicks`, plus the `Patriarch`
/// fixture they shared. They tested the wheel's first life, when it
/// drew the Genesis lifespans on an axis counted from the creation.
/// The wheel became world history in `b75ffc6` and the patriarchs kept
/// their own AM page; the code stayed behind, passing, for long enough
/// to read as an unfinished feature. `3b44f2e` holds all of it, tests
/// included, if it is ever wanted back.
library;

import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';

import 'package:yahwehs_sword/utils/radial_chronology_layout.dart';

/// A canvas angle as a clock position: canvas 0 rad points at three
/// o'clock, and a clockwise quarter turn is three hours. 12 rather than
/// 0 at the top, because that is how the owner reads the wheel.
double _clock(double a) {
  final h = (3 + a / (2 * math.pi) * 12) % 12;
  return h < 1e-9 ? 12 : h;
}

void main() {
  group('ringRadii', () {
    test('ring 0 touches the rim and rings step inward without meeting '
        'the hub', () {
      final r0 = ringRadii(0, 26, 100, 400);
      final r25 = ringRadii(25, 26, 100, 400);
      expect(r0.outer, 400);
      expect(r25.inner, greaterThanOrEqualTo(100));
      expect(r0.inner, greaterThan(r25.outer));
    });

    test('leaves a gap between neighbouring rings', () {
      final r0 = ringRadii(0, 26, 100, 400);
      final r1 = ringRadii(1, 26, 100, 400);
      expect(r1.outer, lessThan(r0.inner));
    });
  });

  group('angleForSpan', () {
    test('min and max map to the axis ends, BC years included', () {
      expect(angleForSpan(-4000, -4000, 2026), startRad);
      expect(angleForSpan(2026, -4000, 2026),
          closeTo(startRad + sweepRad, 1e-9));
    });

    test('AD 1 lands past the halfway point of a -4000..2026 axis', () {
      final a = angleForSpan(1, -4000, 2026);
      expect(a, greaterThan(startRad + sweepRad / 2));
    });

    // 2026-09-21, in two asks. 「sword wheel 真好6个字 一半的位置应该是
    // 0年 现在好像在7-8个字位置」 — the reading was exact; a single-rate
    // -4200..2026 axis put year 0 at 4200/6226 of a 320° sweep, 215.9°,
    // 7.2 o'clock. Then 「创世是12点钟方向 这样时钟可能要密度再整理一下」.
    //
    // THE LOAD-BEARING PAIR. Together they fix the whole axis, and
    // either one failing alone says which half broke.
    test('the chart begins at twelve o\'clock', () {
      final a = angleForSpan(kAxisMinYear, kAxisMinYear, kAxisMaxYear);
      expect(_clock(a), closeTo(12, 1e-9));
    });

    test('year 0 sits at six o\'clock', () {
      final a = angleForSpan(0, kAxisMinYear, kAxisMaxYear);
      expect(_clock(a), closeTo(6, 1e-9));
    });

    // The creation itself is 86 years after the axis start — the
    // headroom `kMinYear` exists to leave — so it sits just past the
    // top rather than exactly on it. 86 of 4200 BC years across 180°.
    test('the creation sits just past twelve, by its own headroom', () {
      // In hours past the top rather than as a clock reading, which
      // wraps to 0 the moment it passes twelve.
      final past =
          (angleForSpan(-4114, kAxisMinYear, kAxisMaxYear) - startRad) /
              (2 * math.pi) *
              12;
      expect(past, greaterThan(0));
      expect(past, lessThan(0.2),
          reason: 'the creation must read as the top of the clock — it is '
              'seven minutes past it, which is the 86 years of headroom '
              '`kMinYear` leaves before Adam');
    });

    test('the ends are still the ends and the years still run forwards', () {
      expect(angleForSpan(kAxisMinYear, kAxisMinYear, kAxisMaxYear),
          closeTo(startRad, 1e-9));
      expect(angleForSpan(kAxisMaxYear, kAxisMinYear, kAxisMaxYear),
          closeTo(startRad + sweepRad, 1e-9));
      final years = [-4200, -3000, -1000, -1, 0, 1, 500, 1500, 2026];
      for (var i = 1; i < years.length; i++) {
        expect(angleForSpan(years[i], kAxisMinYear, kAxisMaxYear),
            greaterThan(angleForSpan(years[i - 1], kAxisMinYear, kAxisMaxYear)),
            reason: '${years[i]} must fall after ${years[i - 1]}');
      }
    });

    // A degree is no longer the same number of years on both sides, and
    // that is the density change the second ask named. Pinned so the
    // two rates cannot drift into one another by accident.
    test('each era runs at its own even rate', () {
      double rate(int from, int to) =>
          (angleForSpan(to, kAxisMinYear, kAxisMaxYear) -
                  angleForSpan(from, kAxisMinYear, kAxisMaxYear)) /
              (to - from);
      final bc = rate(-4200, -4199);
      final ad = rate(1, 2);
      for (final pair in [(-4200, -3000), (-587, -586), (-1, 0)]) {
        expect(rate(pair.$1, pair.$2), closeTo(bc, 1e-12),
            reason: 'a BC year is a BC year at ${pair.$1} too');
      }
      for (final pair in [(0, 1), (1516, 1517), (1000, 2026)]) {
        expect(rate(pair.$1, pair.$2), closeTo(ad, 1e-12),
            reason: 'an AD year is an AD year at ${pair.$1} too');
      }
      // BC is the slower of the two: 4200 years into 180°, against
      // 2026 into the remaining 140°.
      expect(ad, greaterThan(bc));
      expect(1 / (bc * 180 / math.pi), closeTo(23.3, 0.1),
          reason: 'BC years per degree');
      expect(1 / (ad * 180 / math.pi), closeTo(14.5, 0.1),
          reason: 'AD years per degree');
    });

    test('the hit test inverts the mapping on both sides of year 0', () {
      for (final y in [-4200, -4114, -2000, -586, 0, 1, 70, 1517, 2026]) {
        final t = fractionForSpan(y, kAxisMinYear, kAxisMaxYear);
        expect(yearForFraction(t, kAxisMinYear, kAxisMaxYear), y,
            reason: 'year $y did not survive the round trip');
      }
    });

    // The depth view rebuilds its axis from the reader's period filter,
    // and most of those ranges are no place for the pin.
    test('an axis with no real second era runs at one rate', () {
      expect(axisPinsEraBoundary(0, 1000), isFalse);
      expect(fractionForSpan(500, 0, 1000), closeTo(0.5, 1e-9));
      expect(fractionForSpan(-500, -1000, 0), closeTo(0.5, 1e-9));
      expect(yearForFraction(0.5, 1000, 2000), 1500);

      // Straddling is not enough: 100 BC years do not earn half a dial.
      expect(axisPinsEraBoundary(-100, 1500), isFalse);
      expect(fractionForSpan(700, -100, 1500), closeTo(0.5, 1e-9));
      expect(yearForFraction(0.5, -100, 1500), 700);

      expect(axisPinsEraBoundary(kAxisMinYear, kAxisMaxYear), isTrue,
          reason: 'the wheel\'s own axis is what the pin is for');
      expect(axisPinsEraBoundary(-500, 1000), isTrue);
      expect(fractionForSpan(0, -500, 1000), closeTo(eraFraction, 1e-9));
    });
  });

  group('stackRadialLabels', () {
    test('labels on distinct spokes each start at the base radius', () {
      final out = stackRadialLabels([0.0, 0.5, 1.0], [20, 20, 20], 100);
      expect(out.map((l) => l.rStart), [100, 100, 100]);
    });

    test('labels sharing a spoke step outward instead of overprinting', () {
      final out = stackRadialLabels([0.0, 0.0, 0.0], [20, 30, 10], 100);
      expect(out[0].rStart, 100);
      expect(out[1].rStart, greaterThanOrEqualTo(out[0].rEnd));
      expect(out[2].rStart, greaterThanOrEqualTo(out[1].rEnd));
    });

    test('a near-identical angle counts as the same spoke', () {
      // Two events four days apart on a 6000-year axis.
      final out = stackRadialLabels([0.0, 0.001], [20, 20], 100);
      expect(out[1].rStart, greaterThan(out[0].rStart));
    });

    test('the left half of the wheel is flagged for flipping', () {
      // 0 rad points right, pi points left.
      final out = stackRadialLabels([0.0, math.pi], [10, 10], 100);
      expect(out[0].flipped, isFalse);
      expect(out[1].flipped, isTrue);
    });
  });

  group('packIntoRings', () {
    test('non-overlapping items all stay on ring 0', () {
      expect(
          packIntoRings([0.0, 0.5, 1.0], [0.1, 0.6, 1.1], 3), [0, 0, 0]);
    });

    test('items closer than the gap spread across rings', () {
      final rings =
          packIntoRings([0.0, 0.005, 0.01], [0.0, 0.005, 0.01], 3);
      expect(rings.toSet().length, 3);
    });

    test('overflow falls back to a ring instead of crashing', () {
      final rings = packIntoRings(
          [0.0, 0.001, 0.002, 0.003], [0.0, 0.001, 0.002, 0.003], 2);
      expect(rings.length, 4);
      expect(rings.every((r) => r >= 0 && r < 2), isTrue);
    });

    test('a long band holds its ring for its whole length', () {
      // The band spans 0.0..1.0 on ring 0, so the dot at 0.5 must be
      // pushed to ring 1.
      expect(packIntoRings([0.0, 0.5], [1.0, 0.5], 2), [0, 1]);
    });
  });

  /// Panning a found record into view — the radial answer to what
  /// BibleWorks' timeline does when you type a date at it.
  group('focusTranslation', () {
    test('a point in the middle of the scene needs no pan', () {
      // At 4× the middle of the scene sits at 4 × 500 = 2000, and the
      // middle of the viewport is 500, so the scene moves back by 1500.
      final t = focusTranslation(
          px: 500, py: 400, scale: 4, viewW: 1000, viewH: 800);
      expect(t.dx, closeTo(-1500, 0.001));
      expect(t.dy, closeTo(-1200, 0.001));
    });

    /// The controller can be set to anything, so an unclamped jump
    /// leaves the canvas hanging half out of the frame until the
    /// reader's next gesture snaps it back. These are the bounds
    /// `InteractiveViewer` enforces for itself on a drag.
    test('a point near an edge is clamped to keep the canvas covering', () {
      final topLeft =
          focusTranslation(px: 0, py: 0, scale: 4, viewW: 1000, viewH: 800);
      expect(topLeft.dx, 0.0);
      expect(topLeft.dy, 0.0);

      final bottomRight = focusTranslation(
          px: 1000, py: 800, scale: 4, viewW: 1000, viewH: 800);
      expect(bottomRight.dx, closeTo(-3000, 0.001));
      expect(bottomRight.dy, closeTo(-2400, 0.001));
    });

    test('the clamp never lets the canvas leave the frame, anywhere', () {
      const w = 1000.0, h = 800.0;
      for (final scale in [1.5, 2.0, 7.0, 14.0]) {
        for (var i = 0; i <= 20; i++) {
          final t = focusTranslation(
              px: w * i / 20, py: h * i / 20, scale: scale, viewW: w, viewH: h);
          expect(t.dx, lessThanOrEqualTo(0.0001));
          expect(t.dy, lessThanOrEqualTo(0.0001));
          expect(t.dx, greaterThanOrEqualTo(w * (1 - scale) - 0.0001));
          expect(t.dy, greaterThanOrEqualTo(h * (1 - scale) - 0.0001));
        }
      }
    });

    /// At rest the whole wheel is on screen, so "centre this" has no
    /// work to do — and moving anyway would be motion for its own sake.
    test('nothing moves at a scale of 1 or less', () {
      for (final scale in [0.8, 1.0]) {
        final t = focusTranslation(
            px: 100, py: 700, scale: scale, viewW: 1000, viewH: 800);
        expect(t.dx, 0.0);
        expect(t.dy, 0.0);
      }
    });
  });
}
