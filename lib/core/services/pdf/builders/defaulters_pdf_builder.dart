import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import '../pdf_generator_service.dart';
import '../../../../features/owner/reports/domain/entities/defaulter_entity.dart';

class DefaultersPdfBuilder {
  static Future<pw.Document> build(List<DefaulterEntity> defaulters, double totalOverdue, int totalDefaulters) async {
    return PdfGeneratorService.createReportDocument(
      title: 'تقرير المتعثرين',
      subtitle: 'المستأجرين المتأخرين عن السداد',
      buildContent: (theme) {
        return [
          _buildSummaryCards(totalOverdue, totalDefaulters, theme),
          pw.SizedBox(height: 24),
          _buildTable(defaulters, theme),
        ];
      },
    );
  }

  static pw.Widget _buildSummaryCards(double totalOverdue, int totalDefaulters, pw.ThemeData theme) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.start,
      children: [
        _buildSummaryCard('إجمالي المتأخرات', '${totalOverdue.toStringAsFixed(2)} ر.س', theme, color: PdfColor.fromInt(0xFFEF4444)),
        _buildSummaryCard('عدد المتعثرين', '$totalDefaulters', theme),
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

  static pw.Widget _buildTable(List<DefaulterEntity> defaulters, pw.ThemeData theme) {
    if (defaulters.isEmpty) {
      return pw.Center(
        child: pw.Text(
          'لا يوجد متعثرين حالياً.',
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
      headers: ['اسم المستأجر', 'الوحدة', 'العقار', 'إجمالي المتأخرات', 'تأخير منذ'],
      data: defaulters.map((d) {
        return [
          d.tenantName,
          d.unitName,
          d.propertyName,
          '${d.overdueAmount.toStringAsFixed(2)} ر.س',
          d.overdueSince,
        ];
      }).toList(),
    );
  }
}
