import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import '../pdf_generator_service.dart';
import '../../../../features/owner/reports/domain/entities/units_status_report_entity.dart';
import '../../../../features/owner/reports/domain/entities/units_status_summary_entity.dart';

class UnitsStatusPdfBuilder {
  static Future<pw.Document> build(UnitsStatusReportEntity report) async {
    return PdfGeneratorService.createReportDocument(
      title: 'تقرير حالة الوحدات',
      subtitle: 'نظرة عامة على حالة جميع الوحدات العقارية',
      buildContent: (theme) {
        return [
          _buildSummaryCards(report.summary, theme),
          pw.SizedBox(height: 24),
          _buildTable(report, theme),
        ];
      },
    );
  }

  static pw.Widget _buildSummaryCards(UnitsStatusSummaryEntity summary, pw.ThemeData theme) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        _buildSummaryCard('إجمالي الوحدات', '${summary.total}', theme),
        _buildSummaryCard('مؤجرة', '${summary.rented}', theme, color: PdfColor.fromInt(0xFF10B981)), // Green
        _buildSummaryCard('شاغرة', '${summary.vacant}', theme, color: PdfColor.fromInt(0xFFF59E0B)), // Orange
        _buildSummaryCard('صيانة', '${summary.maintenance}', theme, color: PdfColor.fromInt(0xFFEF4444)), // Red
      ],
    );
  }

  static pw.Widget _buildSummaryCard(String title, String value, pw.ThemeData theme, {PdfColor? color}) {
    return pw.Expanded(
      child: pw.Container(
        margin: const pw.EdgeInsets.symmetric(horizontal: 4),
        padding: const pw.EdgeInsets.all(12),
        decoration: pw.BoxDecoration(
          color: PdfGeneratorService.backgroundLight,
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
          border: pw.Border.all(color: PdfGeneratorService.borderLight),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              title,
              style: pw.TextStyle(
                font: theme.defaultTextStyle.font,
                fontSize: 10,
                color: PdfGeneratorService.textSecondary,
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              value,
              style: pw.TextStyle(
                font: theme.defaultTextStyle.fontBold,
                fontSize: 14,
                color: color ?? PdfGeneratorService.primaryColor,
              ),
              textDirection: pw.TextDirection.rtl,
            ),
          ],
        ),
      ),
    );
  }

  static pw.Widget _buildTable(UnitsStatusReportEntity report, pw.ThemeData theme) {
    if (report.items.isEmpty) {
      return pw.Center(
        child: pw.Text(
          'لا توجد بيانات متاحة لهذا التقرير.',
          style: pw.TextStyle(font: theme.defaultTextStyle.font, fontSize: 14),
        ),
      );
    }

    return pw.TableHelper.fromTextArray(
      context: null,
      cellAlignment: pw.Alignment.centerRight,
      headerDecoration: pw.BoxDecoration(
        color: PdfColor.fromInt(0xFF1E3A8A).withAlpha(0.1),
      ),
      headerHeight: 35,
      cellHeight: 35,
      headerStyle: pw.TextStyle(
        font: theme.defaultTextStyle.fontBold,
        fontSize: 10,
        color: PdfGeneratorService.primaryColor,
      ),
      cellStyle: pw.TextStyle(
        font: theme.defaultTextStyle.font,
        fontSize: 10,
        color: PdfGeneratorService.textPrimary,
      ),
      rowDecoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            color: PdfGeneratorService.borderLight,
            width: 0.5,
          ),
        ),
      ),
      headers: ['اسم الوحدة', 'العقار', 'الطابق', 'الحالة'],
      data: report.items.map((item) {
        return [
          item.name.isNotEmpty ? item.name : item.unitNumber,
          item.property.name.isNotEmpty ? item.property.name : item.property.code,
          item.floorNumber != null ? '${item.floorNumber}' : '-',
          item.statusLabel,
        ];
      }).toList(),
    );
  }
}
