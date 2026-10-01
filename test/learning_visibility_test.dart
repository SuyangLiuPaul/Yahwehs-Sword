import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:yahwehs_sword/constants/learning_visibility.dart';

void main() {
  test('Sword hides new entries and retains its existing history wheel', () {
    expect(kShowNewLearningPages, isFalse);
    final workbench = File('lib/pages/workbench_page.dart').readAsStringSync();
    final start = workbench.indexOf('if (kShowNewLearningPages) ...[');
    final end = workbench.indexOf('\n        ],', start);
    expect(start, greaterThanOrEqualTo(0));
    expect(end, greaterThan(start));
    final gated = workbench.substring(start, end);
    expect(gated, contains('PassionWheelPage'));
    expect(gated, contains('BiblePrinciplesPage'));
    expect(gated, isNot(contains('HelpDestination.wheel')));
    expect(workbench.substring(end), contains('HelpDestination.wheel'));
    expect(workbench.substring(end), contains('HelpDestination.strip'));
  });
}
