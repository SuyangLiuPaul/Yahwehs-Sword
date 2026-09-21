/// SERMON AUDIO (#293): the app ships PATHS, never the audio.
///
/// The 589 recordings are 4.88 GB and have been public on the church's
/// own site since one upload on 2022-01-09. Mirroring them would be
/// four and a half gigabytes of hosting to serve files that are already
/// served, so `assets/sermons/audio.json` carries 107 KB of paths and
/// the player streams from the source.
///
/// WHAT THIS FILE GUARDS. Two assets have to agree — `index.json` says
/// which sermons exist and how many parts each has, `audio.json` says
/// where those parts are — and nothing in the app compares them. A
/// sermon whose `parts` field says `A/B` and whose audio has one file
/// would give the reader half a sermon with no sign that the other half
/// exists, and neither asset is wrong on its own.
///
/// It also pins the two facts the whole arrangement rests on, so that
/// if either stops being true someone finds out here rather than from a
/// reader:
///
///   * the host is a DART-DEFINE, so moving to a mirror is a rebuild
///     and not an edit to 589 rows;
///   * paths are stored WITHOUT the host, which is the only reason the
///     first fact works.
///
/// It does NOT reach the network. The URLs were verified live on
/// 2026-09-02 — 589/589 HTTP 200, `audio/mpeg`, `Accept-Ranges: bytes`,
/// and two real 206s including a mid-file seek — and a test that
/// re-checks that on every run would make the suite depend on someone
/// else's nginx being up.
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:just_audio/just_audio.dart' show ProcessingState;

import 'package:yahwehs_sword/services/sermon_audio_service.dart';
import 'package:yahwehs_sword/widgets/sermon_audio_player.dart'
    show sermonAudioControl;

late final Map<String, dynamic> manifest;
late final Map<String, List<dynamic>> audio;
late final List<Map<String, dynamic>> index;

void main() {
  setUpAll(() {
    manifest = jsonDecode(
            File('assets/sermons/audio.json').readAsStringSync())
        as Map<String, dynamic>;
    audio = (manifest['audio'] as Map<String, dynamic>)
        .map((k, v) => MapEntry(k, v as List<dynamic>));
    index = (jsonDecode(File('assets/sermons/index.json').readAsStringSync())
            as List)
        .cast<Map<String, dynamic>>();
  });

  group('the two assets agree', () {
    // 2026-09-21: no longer a bijection, and deliberately. The 140
    // Chinese-only messages from the 福音电台 merge have transcripts and
    // no recordings — their `parts` is empty — so the index holds 429 and
    // the audio 289. What must still hold is that the two agree about
    // WHICH: every sermon that lists parts has them, and nothing without
    // parts has audio. `sermon_detail_page` shows no player for an empty
    // list, so a sermon with no recording costs no space at all.
    test('every sermon that lists parts has its recording, and no other',
        () {
      expect(index.length, 429);
      expect(audio.length, 289);
      final recorded = {
        for (final s in index)
          if (((s['parts'] as String?) ?? '').trim().isNotEmpty)
            s['id'] as String
      };
      expect(audio.keys.toSet(), recorded,
          reason: 'a sermon has audio the index does not list parts for, '
              'or the other way round');
      final unrecorded = {
        for (final s in index)
          if (!recorded.contains(s['id'])) s['id'] as String
      };
      expect(unrecorded, hasLength(140));
      expect(unrecorded.every((id) => id.startsWith('fy-')), isTrue,
          reason: 'only the 福音电台 messages come without recordings');
    });

    test('the part letters match `index.json` sermon for sermon', () {
      // `parts` reads "A" or "A/B" — the church's own lettering. The
      // audio files carry the same letters, and this is the check that
      // catches half a sermon.
      for (final s in index) {
        final id = s['id'] as String;
        final want = ((s['parts'] as String?) ?? '')
            .split('/')
            .map((p) => p.trim().toLowerCase())
            .where((p) => p.isNotEmpty)
            .toList();
        final got = [
          for (final f in audio[id] ?? const <dynamic>[])
            (f as Map<String, dynamic>)['p'] as String
        ];
        expect(got, want, reason: 'sermon $id: index says ${s['parts']}');
      }
    });

    test('589 files, and the survey total is what the rows add up to', () {
      final files = audio.values.fold<int>(0, (n, v) => n + v.length);
      expect(files, 589);
      expect((manifest['_meta'] as Map<String, dynamic>)['files'], files);
      final bytes = audio.values.fold<int>(
          0,
          (n, v) => n +
              v.fold<int>(
                  0, (m, f) => m + ((f as Map<String, dynamic>)['b'] as int)));
      expect((manifest['_meta'] as Map<String, dynamic>)['bytes'], bytes);
      // 4.88 GB. Stated so that anyone proposing to mirror these files
      // is looking at the number while they propose it.
      expect(bytes / (1000 * 1000 * 1000), closeTo(4.88, 0.01));
    });
  });

  group('the host can move', () {
    test('no row carries a host — only paths', () {
      for (final entry in audio.entries) {
        for (final f in entry.value) {
          final u = (f as Map<String, dynamic>)['u'] as String;
          expect(u.startsWith('/'), isTrue, reason: '${entry.key}: $u');
          expect(u, isNot(contains('://')),
              reason: '${entry.key}: a row hard-codes a host, so the '
                  'dart-define cannot move it');
          expect(u.toLowerCase(), endsWith('.mp3'), reason: entry.key);
        }
      }
    });

    test('the base is a dart-define with the church as its default', () {
      // Read from source: the point is that it is compile-time
      // overridable, and a test that only called `urlFor` would pass
      // just as well with the host pasted into every row.
      final src =
          File('lib/services/sermon_audio_service.dart').readAsStringSync();
      expect(src, contains("String.fromEnvironment("));
      expect(src, contains("'SERMON_AUDIO_BASE'"));
      expect(SermonAudioService.base,
          'https://www.christiandiscipleschurch.org');
    });

    test('urlFor joins exactly once, whatever the base looks like', () {
      const part = SermonAudioPart(part: 'a', path: '/x/y.mp3', bytes: 1);
      final url = SermonAudioService.urlFor(part);
      expect(url, 'https://www.christiandiscipleschurch.org/x/y.mp3');
      expect('://'.allMatches(url).length, 1);
      expect(url, isNot(contains('//x/y')));
    });
  });

  group('the transport control', () {
    // Reported from the screen: "why is there no pause button on the
    // sermon recording". There was one, and buffering was eating it.
    // `waiting` folded in `ProcessingState.buffering`, which is right
    // BEFORE playback starts and wrong after it — a stream re-buffers
    // while it plays, so the first network hiccup swapped the pause
    // button for a disabled spinner and the reader could not stop the
    // sermon. The spinner means "not yet playable" and nothing else.

    test('once it is playing the control is PAUSE, buffering or not', () {
      for (final p in ProcessingState.values) {
        final c = sermonAudioControl(
            playing: true, preparing: false, processing: p);
        expect(c.showPause, isTrue, reason: '$p');
        expect(c.waiting, isFalse,
            reason: '$p disabled the control while the sermon was playing');
      }
    });

    test('before playback, loading and buffering both wait', () {
      for (final p in [
        ProcessingState.loading,
        ProcessingState.buffering,
      ]) {
        final c = sermonAudioControl(
            playing: false, preparing: false, processing: p);
        expect(c.waiting, isTrue, reason: '$p');
        expect(c.showPause, isFalse);
      }
    });

    test('idle and ready offer PLAY, and completed offers it again', () {
      for (final p in [
        ProcessingState.idle,
        ProcessingState.ready,
        ProcessingState.completed,
      ]) {
        final c = sermonAudioControl(
            playing: false, preparing: false, processing: p);
        expect(c.waiting, isFalse, reason: '$p');
        expect(c.showPause, isFalse, reason: '$p');
      }
    });

    test('the gap between the tap and the first state change waits', () {
      // `setUrl` opens the connection; until it returns there is no
      // player state at all, and the control must not look like PLAY or
      // the reader taps it twice.
      final c = sermonAudioControl(
          playing: false, preparing: true, processing: null);
      expect(c.waiting, isTrue);
      // ...but not once audio is actually coming out, even if a stale
      // `_preparing` were still set.
      expect(
        sermonAudioControl(
                playing: true, preparing: true, processing: null)
            .waiting,
        isFalse,
      );
    });
  });

  group('what the reader is told', () {
    test('a size is shown for every part, because a duration cannot be', () {
      // The host sends no `Access-Control-Allow-Origin`, so on web
      // nothing may `fetch` these URLs to probe a duration — only a
      // media element may play them. The size is the honest stand-in,
      // and it is also what someone on mobile data actually wants.
      for (final entry in audio.entries) {
        for (final f in entry.value) {
          final b = (f as Map<String, dynamic>)['b'] as int;
          expect(b, greaterThan(0), reason: entry.key);
          expect(SermonAudioService.sizeLabel(b), isNotEmpty);
        }
      }
      expect(SermonAudioService.sizeLabel(0), isEmpty);
      expect(SermonAudioService.sizeLabel(6582824), '6.3 MB');
    });

    test('the manifest says where the files came from and when', () {
      final meta = manifest['_meta'] as Map<String, dynamic>;
      expect(meta['source'], contains('christiandiscipleschurch.org'));
      expect(meta['surveyed'], '2026-09-02');
      // The CORS finding is the one that decides what web can and
      // cannot do, so it is recorded beside the data it constrains.
      expect(meta['cors'], contains('Access-Control-Allow-Origin'));
    });
  });
}
