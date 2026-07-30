import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../utils/widgets/app_toast.dart';

class ExcelExportService {
  static Future<void> saveAndShare({
    required BuildContext context,
    required List<int> bytes,
    required String fileName,
  }) async {
    try {
      final Directory directory = await getTemporaryDirectory();
      final String path = '${directory.path}/$fileName';
      final File file = File(path);
      await file.writeAsBytes(bytes, flush: true);

      if (context.mounted) {
        AppToast.showSuccess(context, 'تم تجهيز ملف الإكسل بنجاح');
      }

      final result = await OpenFilex.open(path);
      if (result.type != ResultType.done) {
        // Fallback: If no application is available to open Excel file directly,
        // use SharePlus.instance.share so the user can save to Files/Drive or share via WhatsApp/Email.
        await SharePlus.instance.share(
          ShareParams(files: [XFile(path)], text: fileName),
        );
      }
    } catch (e) {
      if (context.mounted) {
        AppToast.showError(context, 'حدث خطأ أثناء تصدير الملف: $e');
      }
    }
  }
}
