import 'package:url_launcher/url_launcher.dart';

class LauncherUtils {
  LauncherUtils._();

  static Future<bool> makePhoneCall(String phoneNumber) async {
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'\s+|-|\(|\)'), '');
    final url = Uri.parse('tel:$cleanPhone');
    try {
      final launched = await launchUrl(url);
      if (launched) return true;
    } catch (_) {}

    try {
      if (await canLaunchUrl(url)) {
        return await launchUrl(url);
      }
    } catch (_) {}
    return false;
  }

  static Future<bool> openWhatsApp(String phoneNumber, {String? message}) async {
    String cleanPhone = phoneNumber.replaceAll(RegExp(r'\s+|-|\(|\)|\+'), '');
    if (cleanPhone.startsWith('0') && cleanPhone.length == 11 && cleanPhone.startsWith('01')) {
      cleanPhone = '20${cleanPhone.substring(1)}';
    } else if (cleanPhone.startsWith('0') && cleanPhone.length == 10 && cleanPhone.startsWith('05')) {
      cleanPhone = '966${cleanPhone.substring(1)}';
    }

    final queryMsg = message != null && message.isNotEmpty ? '&text=${Uri.encodeComponent(message)}' : '';
    final whatsappAppUrl = Uri.parse('whatsapp://send?phone=$cleanPhone$queryMsg');
    final webUrl = Uri.parse('https://wa.me/$cleanPhone${queryMsg.isNotEmpty ? "?text=${Uri.encodeComponent(message!)}" : ""}');

    try {
      final launchedApp = await launchUrl(whatsappAppUrl, mode: LaunchMode.externalApplication);
      if (launchedApp) return true;
    } catch (_) {}

    try {
      final launchedWeb = await launchUrl(webUrl, mode: LaunchMode.externalApplication);
      if (launchedWeb) return true;
    } catch (_) {}

    try {
      if (await canLaunchUrl(whatsappAppUrl)) {
        return await launchUrl(whatsappAppUrl, mode: LaunchMode.externalApplication);
      }
      if (await canLaunchUrl(webUrl)) {
        return await launchUrl(webUrl, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}

    return false;
  }
}
