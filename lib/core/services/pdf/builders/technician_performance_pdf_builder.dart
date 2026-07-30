import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../features/owner/reports/domain/entities/technician_performance_summary_entity.dart';
import '../../../../features/owner/reports/domain/entities/technician_performance_item_entity.dart';
import '../pdf_generator_service.dart';

class TechnicianPerformancePdfBuilder {
  static Future<pw.Document> build(
    TechnicianPerformanceSummaryEntity summary,
    List<TechnicianPerformanceItemEntity> items,
  ) async {
    return PdfGeneratorService.createReportDocument(
      title: LocaleKeys.technicianPerformanceTitle.tr(),
      subtitle: 'ملخص وأداء الفنيين',
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
    TechnicianPerformanceSummaryEntity summary,
    pw.ThemeData theme,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue50,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
        border: pw.Border.all(color: PdfColors.blue200),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem(
            LocaleKeys.technicianPerformanceTotalTechnicians.tr(),
            summary.totalTechnicians.toString(),
            theme,
          ),
          _buildSummaryItem(
            LocaleKeys.technicianPerformanceTotalPending.tr(),
            summary.totalPending.toString(),
            theme,
          ),
          _buildSummaryItem(
            LocaleKeys.technicianPerformanceTotalCompleted.tr(),
            summary.totalCompleted.toString(),
            theme,
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSummaryItem(
    String label,
    String value,
    pw.ThemeData theme,
  ) {
    return pw.Column(
      children: [
        pw.Text(
          value,
          style: theme.defaultTextStyle.copyWith(
            fontSize: 20,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue800,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          label,
          style: theme.defaultTextStyle.copyWith(
            fontSize: 12,
            color: PdfColors.grey700,
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildTable(
    List<TechnicianPerformanceItemEntity> items,
    pw.ThemeData theme,
  ) {
    if (items.isEmpty) {
      return pw.Center(
        child: pw.Text(
          LocaleKeys.technicianPerformanceNoData.tr(),
          style: theme.defaultTextStyle.copyWith(
            color: PdfColors.grey600,
            fontSize: 14,
          ),
        ),
      );
    }

    final headers = [
      LocaleKeys.technicianPerformanceTechnicianName.tr(),
      LocaleKeys.technicianPerformanceTechnicianPhone.tr(),
      LocaleKeys.technicianPerformancePendingRequests.tr(),
      LocaleKeys.technicianPerformanceCompletedRequests.tr(),
    ];

    final data = items.map((item) {
      return [
        item.name.isNotEmpty ? item.name : '-',
        item.phone.isNotEmpty ? item.phone : '-',
        item.pendingRequestsCount.toString(),
        item.completedRequestsCount.toString(),
      ];
    }).toList();

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: pw.TableBorder.all(color: PdfColors.grey300),
      headerStyle: theme.defaultTextStyle.copyWith(
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.white,
        fontSize: 10,
      ),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blue800),
      cellStyle: theme.defaultTextStyle.copyWith(fontSize: 10),
      cellAlignments: {
        0: pw.Alignment.center,
        1: pw.Alignment.center,
        2: pw.Alignment.center,
        3: pw.Alignment.center,
      },
      cellPadding: const pw.EdgeInsets.all(8),
      oddRowDecoration: const pw.BoxDecoration(color: PdfColors.grey50),
    );
  }
}
