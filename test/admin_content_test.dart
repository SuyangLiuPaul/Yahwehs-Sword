import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:yahwehs_sword/models/sermon.dart';
import 'package:yahwehs_sword/services/admin_content.dart';

Sermon _sermon(String id) => Sermon(
    id: id,
    topic: 'Baptism',
    topicSlug: 'Baptism',
    date: '1979-04-08',
    parts: '',
    passage: 'Luke 4:5',
    title: '旧标题',
    titles: const {'zh-CN': '旧标题', 'zh-TW': '舊標題', 'en': 'Old'},
    hasEn: true,
    hasZhCn: true,
    hasZhTw: true);

void main() {
  group('sermons', () {
    final base = [_sermon('004'), _sermon('005')];
    test('hide and patch', () {
      final out = applySermonOverlay(base, {
        '004': {'hidden': true},
        '005': {'patch': {'title': '新标题', 'passage': 'John 1:1', 'titleEn': 'New'}},
      });
      expect(out.map((s) => s.id), ['005']);
      expect(out.single.title, '新标题');
      expect(out.single.titles['zh-CN'], '新标题');
      expect(out.single.titles['zh-TW'], '舊標題'); // no auto-conversion
      expect(out.single.titles['en'], 'New');
      expect(out.single.passage, 'John 1:1');
      expect(out.single.date, '1979-04-08');
    });
    test('an empty patch value keeps the original', () {
      final out = applySermonOverlay(base, {
        '004': {'patch': {'passage': ''}},
      });
      expect(out.first.passage, 'Luke 4:5');
    });
  });

  group('links', () {
    test('valid https rows for this app, ordered, hidden/invalid dropped', () {
      final l = parseAdminLinks({
        'a': {'custom': true, 'data': {'title': 'B', 'url': 'https://b.test', 'order': '2', 'group': '参考资料'}},
        'b': {'custom': true, 'data': {'title': 'A', 'url': 'https://a.test', 'order': '1', 'app': 'words', 'group': 'Study'}},
        'c': {'custom': true, 'data': {'title': 'Sword only', 'url': 'https://s.test', 'app': 'sword'}},
        'd': {'custom': true, 'hidden': true, 'data': {'title': 'H', 'url': 'https://h.test'}},
        'e': {'custom': true, 'data': {'title': 'Bad', 'url': 'http://insecure.test'}},
        'f': {'custom': true, 'data': {'title': '', 'url': 'https://x.test'}},
        'g': {'patch': {}},
      }, 'words');
      expect(l.map((x) => x.title), ['A', 'B']);
      expect(l.map((x) => x.slot), ['study', 'reference']);
      expect(parseAdminLinks({'c': {'custom': true, 'data': {'title': 'S', 'url': 'https://s.test', 'app': 'sword'}}}, 'sword').length, 1);
    });
    test('group text maps to the four home groups', () {
      AdminLink g(String t) => AdminLink(id: 'x', title: 't', url: 'https://x', group: t);
      expect(g('常用').slot, 'frequent');
      expect(g('Frequent').slot, 'frequent');
      expect(g('研讀').slot, 'study');
      expect(g('帮助与反馈').slot, 'help');
      expect(g('whatever').slot, 'reference');
      expect(g('').slot, 'reference');
    });
  });

  test('the app applies each overlay where the data is loaded', () {
    expect(File('lib/services/sermon_service.dart').readAsStringSync(), contains("AdminOverlay.collection('adm_sermons'"));
    expect(File('lib/pages/workbench_page.dart').readAsStringSync(), contains("AdminOverlay.collection('adm_links')"));
  });
}
