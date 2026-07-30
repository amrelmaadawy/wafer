import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import '../../utils/widgets/app_toast.dart';

class PdfGeneratorService {
  static pw.Font? _regularFont;
  static pw.Font? _boldFont;

  // Theme colors matching Wafer AppColors
  static const PdfColor primaryColor = PdfColor.fromInt(
    0xFF1E3A8A,
  ); // AppColors.primary
  static const PdfColor secondaryColor = PdfColor.fromInt(
    0xFF3B82F6,
  ); // AppColors.secondary
  static const PdfColor textPrimary = PdfColor.fromInt(0xFF1F2937);
  static const PdfColor textSecondary = PdfColor.fromInt(0xFF6B7280);
  static const PdfColor backgroundLight = PdfColor.fromInt(0xFFF9FAFB);
  static const PdfColor borderLight = PdfColor.fromInt(0xFFE5E7EB);

  static Future<void> exportAndPrint({
    required BuildContext context,
    required pw.Document pdf,
    required String fileName,
  }) async {
    AppToast.showInfo(
      context,
      'جاري تجهيز الملف للطباعة/المشاركة...',
      title: 'يرجى الانتظار',
    );
    try {
      await Printing.layoutPdf(
        onLayout: (format) async => pdf.save(),
        name: fileName,
      );
    } catch (e) {
      if (context.mounted) {
        AppToast.showError(context, 'حدث خطأ أثناء تصدير الملف');
      }
    }
  }

  static Future<void> init() async {
    if (_regularFont != null) return;

    final regularData = await rootBundle.load(
      'assets/font/IBMPlexSansArabic-Regular.ttf',
    );
    _regularFont = pw.Font.ttf(regularData);

    final boldData = await rootBundle.load(
      'assets/font/IBMPlexSansArabic-Bold.ttf',
    );
    _boldFont = pw.Font.ttf(boldData);
  }

  static Future<pw.Document> createReportDocument({
    required String title,
    required List<pw.Widget> Function(pw.ThemeData theme) buildContent,
    String? subtitle,
  }) async {
    await init();

    final pdf = pw.Document();

    final theme = pw.ThemeData.withFont(base: _regularFont, bold: _boldFont);

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          theme: theme,
          textDirection: pw.TextDirection.rtl,
          margin: const pw.EdgeInsets.all(32),
          buildBackground: (context) {
            return pw.FullPage(
              ignoreMargins: true,
              child: pw.Container(color: PdfColors.white),
            );
          },
        ),
        header: (context) => _buildHeader(title: title, subtitle: subtitle),
        footer: (context) => _buildFooter(context),
        build: (context) => buildContent(theme),
      ),
    );

    return pdf;
  }

  static pw.Widget _buildHeader({required String title, String? subtitle}) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  title,
                  style: pw.TextStyle(
                    font: _boldFont,
                    fontSize: 24,
                    color: primaryColor,
                  ),
                ),
                if (subtitle != null) ...[
                  pw.SizedBox(height: 4),
                  pw.Text(
                    subtitle,
                    style: pw.TextStyle(
                      font: _regularFont,
                      fontSize: 14,
                      color: textSecondary,
                    ),
                  ),
                ],
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  'وافر لإدارة الأملاك',
                  style: pw.TextStyle(
                    font: _boldFont,
                    fontSize: 16,
                    color: primaryColor,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  'تاريخ التقرير: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}',
                  style: pw.TextStyle(
                    font: _regularFont,
                    fontSize: 10,
                    color: textSecondary,
                  ),
                  textDirection: pw.TextDirection.rtl,
                ),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 16),
        pw.Divider(color: primaryColor, thickness: 2),
        pw.SizedBox(height: 24),
      ],
    );
  }

  static pw.Widget _buildFooter(pw.Context context) {
    return pw.Column(
      children: [
        pw.Divider(color: borderLight, thickness: 1),
        pw.SizedBox(height: 8),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'تم إنشاء هذا التقرير آلياً بواسطة نظام وافر',
              style: pw.TextStyle(
                font: _regularFont,
                fontSize: 10,
                color: textSecondary,
              ),
            ),
            pw.Text(
              'صفحة ${context.pageNumber} من ${context.pagesCount}',
              style: pw.TextStyle(
                font: _regularFont,
                fontSize: 10,
                color: textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
