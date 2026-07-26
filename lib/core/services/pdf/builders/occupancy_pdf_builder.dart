import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import '../pdf_generator_service.dart';
import '../../../../features/owner/reports/domain/entities/occupancy_property_entity.dart';

class OccupancyPdfBuilder {
  static Future<pw.Document> build(List<OccupancyPropertyEntity> properties, double overallRate, int totalUnits, int totalRented, int totalVacant) async {
    return PdfGeneratorService.createReportDocument(
      title: 'تقرير الإشغال',
      subtitle: 'تحليل الإشغال والشاغر للعقارات',
      buildContent: (theme) {
        return [
          _buildSummaryCards(overallRate, totalUnits, totalRented, totalVacant, theme),
          pw.SizedBox(height: 24),
          _buildTable(properties, theme),
        ];
      },
    );
  }

  static pw.Widget _buildSummaryCards(double rate, int total, int rented, int vacant, pw.ThemeData theme) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        _buildSummaryCard('إجمالي الوحدات', '$total', theme),
        _buildSummaryCard('مؤجرة', '$rented', theme, color: PdfColor.fromInt(0xFF10B981)),
        _buildSummaryCard('شاغرة', '$vacant', theme, color: PdfColor.fromInt(0xFFF59E0B)),
        _buildSummaryCard('نسبة الإشغال الإجمالية', '${rate.toStringAsFixed(1)}%', theme, color: PdfGeneratorService.primaryColor),
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
                color: color ?? PdfGeneratorService.textPrimary,
              ),
              textDirection: pw.TextDirection.rtl,
            ),
          ],
        ),
      ),
    );
  }

  static pw.Widget _buildTable(List<OccupancyPropertyEntity> properties, pw.ThemeData theme) {
    if (properties.isEmpty) {
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
      headers: ['اسم العقار', 'إجمالي الوحدات', 'مؤجرة', 'شاغرة', 'نسبة الإشغال'],
      data: properties.map((prop) {
        return [
          prop.propertyName,
          '${prop.totalUnits}',
          '${prop.rentedUnits}',
          '${prop.vacantUnits}',
          '${prop.occupancyRate.toStringAsFixed(1)}%',
        ];
      }).toList(),
    );
  }
}
