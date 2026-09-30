import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('iOS audio SDK purpose declaration survives store builds', () {
    final plist = File('ios/Runner/Info.plist').readAsStringSync();
    expect(plist, contains('<key>NSMicrophoneUsageDescription</key>'));
    expect(plist, contains('play sermon recordings'));
    expect(plist, contains('does not record from the microphone'));
  });
}
