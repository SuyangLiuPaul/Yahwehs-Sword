import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:yahwehs_sword/constants/learning_visibility.dart';

void main() {
  test('Sword shows Passion and retains history while principles stay hidden',
      () {
    expect(kShowNewLearningPages, isFalse);
    expect(kShowPassionTimeline, isTrue);
    final workbench = File('lib/pages/workbench_page.dart').readAsStringSync();
    final start = workbench.indexOf('if (kShowNewLearningPages) ...[');
    final end = workbench.indexOf('\n        ],', start);
    expect(start, greaterThanOrEqualTo(0));
    expect(end, greaterThan(start));
    final gated = workbench.substring(start, end);
    expect(gated, isNot(contains('PassionWheelPage')));
    expect(
        workbench.substring(0, start), contains('if (kShowPassionTimeline)'));
    expect(workbench.substring(0, start), contains('PassionWheelPage'));
    expect(gated, contains('BiblePrinciplesPage'));
    expect(gated, isNot(contains('HelpDestination.wheel')));
    expect(workbench.substring(end), contains('HelpDestination.wheel'));
    expect(workbench.substring(end), contains('HelpDestination.strip'));
  });
}
