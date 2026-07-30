import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/services/pdf/pdf_generator_service.dart';
import '../../../../features/owner/reports/domain/entities/activity_logs_summary_entity.dart';
import '../../../../features/owner/reports/domain/entities/activity_logs_item_entity.dart';

class ActivityLogsPdfBuilder {
  static Future<pw.Document> build(
    ActivityLogsSummaryEntity summary,
    List<ActivityLogsItemEntity> items,
  ) async {
    return PdfGeneratorService.createReportDocument(
      title: LocaleKeys.activityLogsTitle.tr(),
      subtitle: 'ملخص لسجلات نشاط النظام والمستخدمين',
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
    ActivityLogsSummaryEntity summary,
    pw.ThemeData theme,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfGeneratorService.backgroundLight,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(12)),
        border: pw.Border.all(color: PdfGeneratorService.borderLight),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem(
            LocaleKeys.activityLogsTotalLogs.tr(),
            summary.totalLogs.toString(),
            theme,
          ),
          _buildSummaryItem(
            LocaleKeys.activityLogsCreates.tr(),
            summary.creates.toString(),
            theme,
          ),
          _buildSummaryItem(
            LocaleKeys.activityLogsUpdates.tr(),
            summary.updates.toString(),
            theme,
          ),
          _buildSummaryItem(
            LocaleKeys.activityLogsDeletes.tr(),
            summary.deletes.toString(),
            theme,
            isWarning: true,
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSummaryItem(
    String title,
    String value,
    pw.ThemeData theme, {
    bool isWarning = false,
  }) {
    return pw.Column(
      children: [
        pw.Text(
          title,
          style: theme.defaultTextStyle.copyWith(
            fontSize: 12,
            color: PdfGeneratorService.textSecondary,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          value,
          style: theme.defaultTextStyle.copyWith(
            fontSize: 20,
            fontWeight: pw.FontWeight.bold,
            color: isWarning
                ? const PdfColor.fromInt(0xFFDC2626) // Red for deletes/warnings
                : PdfGeneratorService.primaryColor,
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildTable(
    List<ActivityLogsItemEntity> items,
    pw.ThemeData theme,
  ) {
    if (items.isEmpty) {
      return pw.Center(
        child: pw.Text(
          LocaleKeys.activityLogsNoData.tr(),
          style: theme.defaultTextStyle.copyWith(
            color: PdfGeneratorService.textSecondary,
            fontSize: 14,
          ),
        ),
      );
    }

    final headers = [
      LocaleKeys.activityLogsActionDate.tr(),
      LocaleKeys.activityLogsActionIp.tr(),
      LocaleKeys.activityLogsActionUser.tr(),
      LocaleKeys.activityLogsActionType.tr(),
      LocaleKeys.activityLogsActionMessage.tr(),
    ];

    final data = items.map((item) {
      return [
        item.createdAt,
        item.ipAddress,
        item.user.name,
        item.action.toUpperCase(),
        item.message,
      ];
    }).toList();

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: pw.TableBorder.all(color: PdfGeneratorService.borderLight),
      headerStyle: theme.defaultTextStyle.copyWith(
        color: PdfColors.white,
        fontWeight: pw.FontWeight.bold,
        fontSize: 12,
      ),
      headerDecoration: const pw.BoxDecoration(
        color: PdfGeneratorService.primaryColor,
      ),
      cellStyle: theme.defaultTextStyle.copyWith(
        color: PdfGeneratorService.textPrimary,
        fontSize: 10,
      ),
      cellAlignment: pw.Alignment.center,
      headerAlignment: pw.Alignment.center,
      oddRowDecoration: const pw.BoxDecoration(
        color: PdfGeneratorService.backgroundLight,
      ),
      columnWidths: {
        0: const pw.FlexColumnWidth(1.5), // Date
        1: const pw.FlexColumnWidth(1.5), // IP
        2: const pw.FlexColumnWidth(1.5), // User
        3: const pw.FlexColumnWidth(1.2), // Action Type
        4: const pw.FlexColumnWidth(3), // Message (widest)
      },
    );
  }
}
