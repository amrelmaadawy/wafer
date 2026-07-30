import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import '../pdf_generator_service.dart';
import '../../../../features/owner/reports/domain/entities/defaulters_report_item_entity.dart';

class DefaultersPdfBuilder {
  static Future<pw.Document> build(
    List<DefaultersReportItemEntity> items,
    double totalRemaining,
    double totalAmount,
    int totalInstallments,
  ) async {
    return PdfGeneratorService.createReportDocument(
      title: 'تقرير المتأخرات المادية',
      subtitle: 'المبالغ والأقساط المتأخرة',
      buildContent: (theme) {
        return [
          _buildSummaryCards(
            totalRemaining,
            totalAmount,
            totalInstallments,
            theme,
          ),
          pw.SizedBox(height: 24),
          _buildTable(items, theme),
        ];
      },
    );
  }

  static pw.Widget _buildSummaryCards(
    double totalRemaining,
    double totalAmount,
    int totalInstallments,
    pw.ThemeData theme,
  ) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        _buildSummaryCard(
          'إجمالي المتبقي',
          '${totalRemaining.toStringAsFixed(2)} ريال',
          theme,
          color: PdfColor.fromInt(0xFFEF4444),
        ),
        _buildSummaryCard(
          'إجمالي المبالغ',
          '${totalAmount.toStringAsFixed(2)} ريال',
          theme,
        ),
        _buildSummaryCard('إجمالي الأقساط', '$totalInstallments', theme),
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
    List<DefaultersReportItemEntity> items,
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
        'المستأجر',
        'الوحدة',
        'رقم القسط',
        'المتبقي',
        'الاستحقاق',
        'أيام التأخير',
      ],
      data: items.map((item) {
        return [
          item.renter.name.isNotEmpty ? item.renter.name : 'غير محدد',
          item.unit.name.isNotEmpty ? item.unit.name : item.unit.unitNumber,
          item.installmentNumber.toString(),
          item.remainingAmount.toStringAsFixed(2),
          item.dueDate,
          item.daysOverdue.toStringAsFixed(0),
        ];
      }).toList(),
    );
  }
}
