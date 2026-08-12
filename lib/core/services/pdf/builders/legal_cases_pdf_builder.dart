import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import '../pdf_generator_service.dart';
import '../../../../features/owner/reports/domain/entities/legal_cases_report_entity.dart';

class LegalCasesPdfBuilder {
  static Future<pw.Document> build(
    List<LegalCaseItemEntity> items,
    LegalCasesSummaryEntity summary,
  ) async {
    return PdfGeneratorService.createReportDocument(
      title: 'تقرير القضايا القانونية',
      subtitle: 'ملخص القضايا والحالات',
      buildContent: (theme) {
        return [
          _buildSummaryCards(summary, theme),
          pw.SizedBox(height: 24),
          _buildTable(items, theme),
        ];
      },
    );
  }

  static pw.Widget _buildSummaryCards(
    LegalCasesSummaryEntity summary,
    pw.ThemeData theme,
  ) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        _buildSummaryCard(
          'إجمالي القضايا',
          '${summary.total}',
          theme,
          color: PdfColor.fromInt(0xFF3B82F6),
        ),
        _buildSummaryCard(
          'القضايا النشطة',
          '${summary.active}',
          theme,
          color: PdfColor.fromInt(0xFFF97316),
        ),
        _buildSummaryCard(
          'القضايا المحلولة',
          '${summary.resolved}',
          theme,
          color: PdfColor.fromInt(0xFF22C55E),
        ),
      ],
    );
  }

  static pw.Widget _buildSummaryCard(
    String title,
    String value,
    pw.ThemeData theme, {
    PdfColor? color,
  }) {
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
                color: color ?? PdfGeneratorService.textPrimary,
              ),
              textDirection: pw.TextDirection.rtl,
            ),
          ],
        ),
      ),
    );
  }

  static pw.Widget _buildTable(
    List<LegalCaseItemEntity> items,
    pw.ThemeData theme,
  ) {
    if (items.isEmpty) {
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
      headers: [
        'رقم القضية',
        'المحكمة',
        'المدعي',
        'المدعى عليه',
        'تاريخ الجلسة',
        'الحالة',
      ],
      data: items.map((item) {
        return [
          item.caseNumber,
          item.court ?? '-',
          item.plaintiff ?? '-',
          item.defendant ?? '-',
          item.hearingDate ?? '-',
          item.status,
        ];
      }).toList(),
    );
  }
}
