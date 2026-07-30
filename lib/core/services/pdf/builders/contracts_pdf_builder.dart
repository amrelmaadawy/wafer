import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import '../pdf_generator_service.dart';
import '../../../../features/owner/reports/domain/entities/contracts_report_item_entity.dart';

class ContractsPdfBuilder {
  static Future<pw.Document> build(
    List<ContractsReportItemEntity> contracts,
    int totalExpiring,
    double totalRentValue,
    int days,
  ) async {
    return PdfGeneratorService.createReportDocument(
      title: 'تقرير العقود',
      subtitle: 'تفاصيل العقود والإيجارات',
      buildContent: (theme) {
        return [
          _buildSummaryCards(totalExpiring, totalRentValue, days, theme),
          pw.SizedBox(height: 24),
          _buildTable(contracts, theme),
        ];
      },
    );
  }

  static pw.Widget _buildSummaryCards(
    int totalExpiring,
    double totalRentValue,
    int days,
    pw.ThemeData theme,
  ) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        _buildSummaryCard(
          'إجمالي الإيجارات',
          '${totalRentValue.toStringAsFixed(2)} ريال',
          theme,
        ),
        _buildSummaryCard('تاريخ التقرير', '$days يوم', theme),
        _buildSummaryCard(
          'العقود المنتهية',
          '$totalExpiring',
          theme,
          color: PdfColor.fromInt(0xFFF59E0B),
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
    List<ContractsReportItemEntity> contracts,
    pw.ThemeData theme,
  ) {
    if (contracts.isEmpty) {
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
        'العقار',
        'الوحدة',
        'المستأجر',
        'النهاية',
        'الإيجار',
        'الأيام',
        'الحالة',
      ],
      data: contracts.map((c) {
        return [
          c.propertyName.isNotEmpty ? c.propertyName : 'غير محدد',
          c.unitName.isNotEmpty ? c.unitName : 'غير محدد',
          c.renterName.isNotEmpty ? c.renterName : 'غير محدد',
          c.endDate,
          c.rentValue.toStringAsFixed(2),
          c.daysRemaining.toString(),
          c.status,
        ];
      }).toList(),
    );
  }
}
