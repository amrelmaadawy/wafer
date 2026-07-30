import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../features/owner/reports/domain/entities/maintenance_requests_summary_entity.dart';
import '../../../../features/owner/reports/domain/entities/maintenance_requests_item_entity.dart';
import '../pdf_generator_service.dart';

class MaintenanceRequestsPdfBuilder {
  static Future<pw.Document> build(
    MaintenanceRequestsSummaryEntity summary,
    List<MaintenanceRequestsItemEntity> items,
  ) async {
    return PdfGeneratorService.createReportDocument(
      title: LocaleKeys.maintenanceRequestsTitle.tr(),
      subtitle: 'ملخص وحالة طلبات الصيانة',
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
    MaintenanceRequestsSummaryEntity summary,
    pw.ThemeData theme,
  ) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        _buildSummaryCard(
          LocaleKeys.maintenanceRequestsTotal.tr(),
          summary.total.toString(),
          theme,
        ),
        _buildSummaryCard(
          LocaleKeys.maintenanceRequestsOpen.tr(),
          summary.open.toString(),
          theme,
          color: PdfColor.fromInt(0xFF3B82F6),
        ),
        _buildSummaryCard(
          LocaleKeys.maintenanceRequestsInProgress.tr(),
          summary.inProgress.toString(),
          theme,
          color: PdfColor.fromInt(0xFFF59E0B),
        ),
        _buildSummaryCard(
          LocaleKeys.maintenanceRequestsCompleted.tr(),
          summary.completed.toString(),
          theme,
          color: PdfColor.fromInt(0xFF10B981),
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
          color: PdfColors.white,
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(12)),
          border: pw.Border.all(color: PdfColors.grey300),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text(
              title,
              style: pw.TextStyle(
                fontSize: 10,
                color: PdfColors.grey600,
                font: theme.defaultTextStyle.font,
              ),
              textAlign: pw.TextAlign.center,
            ),
            pw.SizedBox(height: 8),
            pw.Text(
              value,
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
                color: color ?? PdfGeneratorService.primaryColor,
                font: theme.defaultTextStyle.fontBold,
              ),
              textAlign: pw.TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  static pw.Widget _buildTable(
    List<MaintenanceRequestsItemEntity> items,
    pw.ThemeData theme,
  ) {
    if (items.isEmpty) {
      return pw.Center(
        child: pw.Text(
          LocaleKeys.maintenanceRequestsNoData.tr(),
          style: pw.TextStyle(
            fontSize: 14,
            color: PdfColors.grey500,
            font: theme.defaultTextStyle.font,
          ),
        ),
      );
    }

    final headers = [
      LocaleKeys.maintenanceRequestsRequestNo.tr(),
      LocaleKeys.maintenanceRequestsClient.tr(),
      'الهاتف',
      'العقار/الوحدة',
      'تاريخ الطلب',
      'الحالة',
    ];

    final data = items.map((item) {
      final clientName = item.clientName.isNotEmpty
          ? item.clientName
          : LocaleKeys.maintenanceRequestsUnknownRenter.tr();
      final propertyName = item.property.name.isNotEmpty
          ? item.property.name
          : item.property.code;
      final unitName = item.unit.name.isNotEmpty
          ? item.unit.name
          : item.unit.unitNumber;
      final location = '$propertyName - $unitName';

      return [
        item.requestNumber,
        clientName,
        item.clientPhone.isNotEmpty ? item.clientPhone : '-',
        location,
        item.createdAt.split(' ').first,
        item.statusLabel,
      ];
    }).toList();

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
      headers: headers,
      data: data,
    );
  }
}
