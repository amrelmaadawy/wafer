import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import '../pdf_generator_service.dart';
import '../../../../features/owner/reports/domain/entities/revenue_report_entity.dart';

class RevenuePdfBuilder {
  static Future<pw.Document> build(RevenueReportEntity report) async {
    return PdfGeneratorService.createReportDocument(
      title: 'تقرير الإيرادات',
      subtitle: 'عرض إيرادات العقارات والوحدات',
      buildContent: (theme) {
        return [
          _buildSummaryCards(report.summary, theme),
          pw.SizedBox(height: 24),
          _buildTable(report, theme),
        ];
      },
    );
  }

  static pw.Widget _buildSummaryCards(
    RevenueSummaryEntity summary,
    pw.ThemeData theme,
  ) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        _buildSummaryCard(
          'إجمالي المتوقع',
          '${summary.totalExpected.toStringAsFixed(2)} ر.س',
          theme,
        ),
        _buildSummaryCard(
          'إجمالي المحصل',
          '${summary.totalCollected.toStringAsFixed(2)} ر.س',
          theme,
        ),
        _buildSummaryCard(
          'إجمالي المتبقي',
          '${summary.totalRemaining.toStringAsFixed(2)} ر.س',
          theme,
        ),
        _buildSummaryCard(
          'نسبة التحصيل',
          '${summary.collectionRate.toStringAsFixed(1)}%',
          theme,
        ),
      ],
    );
  }

  static pw.Widget _buildSummaryCard(
    String title,
    String value,
    pw.ThemeData theme,
  ) {
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
                fontSize: 12,
                color: PdfGeneratorService.primaryColor,
              ),
              textDirection: pw.TextDirection.rtl,
            ),
          ],
        ),
      ),
    );
  }

  static pw.Widget _buildTable(RevenueReportEntity report, pw.ThemeData theme) {
    if (report.chart.isEmpty) {
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
        color: PdfColor.fromInt(
          0xFF1E3A8A,
        ).withAlpha(0.1), // primary with alpha
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
      headers: ['الشهر', 'المتوقع', 'المحصل', 'المتبقي', 'نسبة التحصيل'],
      data: report.chart.map((entry) {
        return [
          entry.month,
          '${entry.expected.toStringAsFixed(2)} ر.س',
          '${entry.collected.toStringAsFixed(2)} ر.س',
          '${entry.remaining.toStringAsFixed(2)} ر.س',
          '${entry.collectionRate.toStringAsFixed(1)}%',
        ];
      }).toList(),
    );
  }
}
