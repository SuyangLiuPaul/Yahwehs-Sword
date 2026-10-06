import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:yahwehs_sword/constants/learning_visibility.dart';

void main() {
  test('Sword shows Passion and retains history while principles stay hidden',
      () {
    expect(kShowNewLearningPages, isFalse);
    expect(kShowPassionTimeline, isTrue);
    final workbench = File('lib/pages/workbench_page.dart').readAsStringSync();
    // 2026-10-06: the Resources menu was regrouped with separators, so the
    // gated entry is a single item up to the next separator rather than a
    // spread block. The three study pages sit just above it, un-gated on
    // purpose (owner: 「hiden page 两个app都上不用hidden了」).
    final start = workbench.indexOf('if (kShowNewLearningPages)');
    final end = workbench.indexOf('const WbMenuItem.separator()', start);
    expect(start, greaterThanOrEqualTo(0));
    expect(end, greaterThan(start));
    final gated = workbench.substring(start, end);
    expect(gated, isNot(contains('PassionWheelPage')));
    // Passion moved to the "time" group, below the gated entry.
    expect(workbench, contains('if (kShowPassionTimeline)'));
    expect(workbench, contains('PassionWheelPage()'));
    expect(gated, contains('BiblePrinciplesPage'));
    for (final p in ['StudyPrinciplesPage', 'StudyPromisesPage', 'StudyTestamentsPage']) {
      expect(workbench.substring(0, start), contains('$p()'), reason: p);
    }
    expect(gated, isNot(contains('HelpDestination.wheel')));
    expect(workbench, contains('HelpDestination.wheel'));
    expect(workbench, contains('HelpDestination.strip'));
  });
}
