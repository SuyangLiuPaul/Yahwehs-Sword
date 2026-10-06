// Applying the admin portal's overlays to sermons and links.
// Pure functions over already-parsed lists, so each is tested without a
// network; the fetching lives in [AdminOverlay]. With no overlay every
// function returns its input unchanged.

import 'package:yahwehs_sword/models/sermon.dart';

String? _clean(Object? v) {
  if (v == null) return null;
  final t = v.toString().trim();
  return t.isEmpty ? null : t;
}

/// Sermons: hide, and retitle / re-date / re-topic. (Adding a sermon in
/// the portal is not offered: a sermon needs a body text the portal
/// cannot hold.) The Chinese title edit applies to the Simplified title
/// only — there is no automatic Traditional conversion.
List<Sermon> applySermonOverlay(
    List<Sermon> base, Map<String, Map<String, dynamic>> overlay) {
  if (overlay.isEmpty) return base;
  final out = <Sermon>[];
  for (final s in base) {
    final o = overlay[s.id];
    if (o == null) {
      out.add(s);
      continue;
    }
    if (o['hidden'] == true) continue;
    final p = o['patch'];
    if (p is! Map) {
      out.add(s);
      continue;
    }
    String field(String k, String cur) =>
        p.containsKey(k) ? (_clean(p[k]) ?? cur) : cur;
    final titles = Map<String, String>.of(s.titles);
    final zh = p.containsKey('title') ? _clean(p['title']) : null;
    if (zh != null) titles['zh-CN'] = zh;
    final en = p.containsKey('titleEn') ? _clean(p['titleEn']) : null;
    if (en != null) titles['en'] = en;
    out.add(Sermon(
        id: s.id,
        topic: field('topic', s.topic),
        topicSlug: s.topicSlug,
        date: field('date', s.date),
        parts: s.parts,
        passage: field('passage', s.passage),
        title: zh ?? s.title,
        titles: titles,
        hasEn: s.hasEn,
        hasZhCn: s.hasZhCn,
        hasZhTw: s.hasZhTw,
        condensed: s.condensed));
  }
  return out;
}

/// A link added in the portal (`adm_links`).
class AdminLink {
  final String id;
  final String title;
  final String url;
  final String group; // raw text the admin typed
  final int order;
  const AdminLink(
      {required this.id,
      required this.title,
      required this.url,
      this.group = '',
      this.order = 0});

  /// The home page group this link belongs to: 'frequent' | 'study' |
  /// 'reference' | 'help'. Unrecognised text goes to 'reference'.
  String get slot {
    final g = group.toLowerCase();
    if (g.contains('常用') || g.contains('frequent') || g.contains('common')) {
      return 'frequent';
    }
    if (g.contains('研读') || g.contains('研讀') || g.contains('study')) {
      return 'study';
    }
    if (g.contains('帮助') ||
        g.contains('幫助') ||
        g.contains('反馈') ||
        g.contains('help')) {
      return 'help';
    }
    return 'reference';
  }
}

/// The portal's links for [app] ('words' | 'sword'), hidden and invalid
/// (non-https, untitled) rows removed, in order.
List<AdminLink> parseAdminLinks(
    Map<String, Map<String, dynamic>> overlay, String app) {
  final out = <AdminLink>[];
  overlay.forEach((id, o) {
    if (o['custom'] != true || o['hidden'] == true) return;
    final d = o['data'];
    if (d is! Map) return;
    final title = _clean(d['title']);
    final url = _clean(d['url']);
    if (title == null || url == null || !url.startsWith('https://')) return;
    final target = _clean(d['app']) ?? 'both';
    if (target != 'both' && target != app) return;
    out.add(AdminLink(
        id: id,
        title: title,
        url: url,
        group: _clean(d['group']) ?? '',
        order: int.tryParse('${d['order'] ?? ''}') ?? 0));
  });
  out.sort((a, b) {
    final c = a.order.compareTo(b.order);
    return c != 0 ? c : a.title.compareTo(b.title);
  });
  return out;
}
