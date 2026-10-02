import 'package:url_launcher/url_launcher.dart';

bool openIsAvailable() => true;
Future<bool> openUrl(String url) async {
  final uri = Uri.tryParse(url);
  if (uri == null ||
      !const [
        'https',
        'http',
        'mailto',
        'ms-windows-store',
        'itms-apps',
        'macappstore'
      ].contains(uri.scheme)) {
    return false;
  }
  try {
    return await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (_) {
    return false;
  }
}
