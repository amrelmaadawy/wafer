import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import '../pdf_generator_service.dart';
import '../../../../features/owner/reports/domain/entities/approvals_report_entity.dart';

class ApprovalsPdfBuilder {
  static Future<pw.Document> build(ApprovalsReportEntity report) async {
    return PdfGeneratorService.createReportDocument(
      title: 'تقرير الموافقات والاعتمادات',
      subtitle: 'سجل الطلبات والاعتمادات المعلقة والمكتملة',
      buildContent: (theme) {
        return [
          _buildSummaryCards(report.summary, theme),
          pw.SizedBox(height: 24),
          _buildTable(report.items, theme),
        ];
      },
    );
  }

  static pw.Widget _buildSummaryCards(
    ApprovalsSummaryEntity summary,
    pw.ThemeData theme,
  ) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        _buildCard('إجمالي الطلبات', '${summary.total}', theme),
        _buildCard(
          'معتمدة',
          '${summary.approved}',
          theme,
          color: PdfColor.fromInt(0xFF10B981),
        ),
        _buildCard(
          'معلقة',
          '${summary.pending}',
          theme,
          color: PdfColor.fromInt(0xFFF59E0B),
        ),
        _buildCard(
          'مرفوضة',
          '${summary.rejected}',
          theme,
          color: PdfColor.fromInt(0xFFEF4444),
        ),
      ],
    );
  }

  static pw.Widget _buildCard(
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
    List<ApprovalItemEntity> items,
    pw.ThemeData theme,
  ) {
    return pw.TableHelper.fromTextArray(
      headers: ['العنوان', 'النوع', 'المستخدم', 'المبلغ', 'التاريخ', 'الحالة'],
      data: items.map((item) {
        return [
          item.title ?? '-',
          item.typeLabel ?? item.typeValue ?? '-',
          item.userName ?? '-',
          item.amount != null ? '${item.amount} ر.س' : '-',
          item.date ?? '-',
          item.statusLabel ?? item.status,
        ];
      }).toList(),
      headerStyle: pw.TextStyle(
        font: theme.defaultTextStyle.fontBold,
        fontSize: 10,
        color: PdfColors.white,
      ),
      headerDecoration: const pw.BoxDecoration(
        color: PdfGeneratorService.primaryColor,
      ),
      cellStyle: pw.TextStyle(
        font: theme.defaultTextStyle.font,
        fontSize: 9,
      ),
      cellAlignment: pw.Alignment.centerRight,
      headerAlignment: pw.Alignment.centerRight,
      cellPadding: const pw.EdgeInsets.all(6),
    );
  }
}
