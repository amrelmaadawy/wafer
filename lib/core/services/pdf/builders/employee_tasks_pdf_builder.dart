import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../features/owner/reports/domain/entities/employee_tasks_summary_entity.dart';
import '../../../../features/owner/reports/domain/entities/employee_tasks_item_entity.dart';
import '../pdf_generator_service.dart';

class EmployeeTasksPdfBuilder {
  static Future<pw.Document> build(
    EmployeeTasksSummaryEntity summary,
    List<EmployeeTasksItemEntity> items,
  ) async {
    return PdfGeneratorService.createReportDocument(
      title: LocaleKeys.employeeTasksTitle.tr(),
      subtitle: 'ملخص أداء الموظفين وإنجاز المهام',
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
    EmployeeTasksSummaryEntity summary,
    pw.ThemeData theme,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.deepPurple50,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
        border: pw.Border.all(color: PdfColors.deepPurple200),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem(
            LocaleKeys.employeeTasksTotalEmployees.tr(),
            summary.totalEmployees.toString(),
            theme,
          ),
          _buildSummaryItem(
            LocaleKeys.employeeTasksCompleted.tr(),
            summary.totalCompleted.toString(),
            theme,
          ),
          _buildSummaryItem(
            LocaleKeys.employeeTasksPending.tr(),
            summary.totalPending.toString(),
            theme,
          ),
          _buildSummaryItem(
            LocaleKeys.employeeTasksOverdue.tr(),
            summary.totalOverdue.toString(),
            theme,
            isWarning: true,
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSummaryItem(
    String label,
    String value,
    pw.ThemeData theme, {
    bool isWarning = false,
  }) {
    return pw.Column(
      children: [
        pw.Text(
          value,
          style: theme.defaultTextStyle.copyWith(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            color: isWarning ? PdfColors.red800 : PdfColors.deepPurple800,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          label,
          style: theme.defaultTextStyle.copyWith(
            fontSize: 10,
            color: PdfColors.grey700,
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildTable(
    List<EmployeeTasksItemEntity> items,
    pw.ThemeData theme,
  ) {
    if (items.isEmpty) {
      return pw.Center(
        child: pw.Text(
          LocaleKeys.employeeTasksNoData.tr(),
          style: theme.defaultTextStyle.copyWith(
            color: PdfColors.grey600,
            fontSize: 14,
          ),
        ),
      );
    }

    final headers = [
      LocaleKeys.employeeTasksEmployeeName.tr(),
      LocaleKeys.employeeTasksEmployeePhone.tr(),
      LocaleKeys.employeeTasksCompleted.tr(),
      LocaleKeys.employeeTasksPending.tr(),
      LocaleKeys.employeeTasksOverdue.tr(),
    ];

    final data = items.map((item) {
      return [
        item.name.isNotEmpty ? item.name : '-',
        item.phone.isNotEmpty ? item.phone : '-',
        item.completedTasks.toString(),
        item.pendingTasks.toString(),
        item.overdueTasks.toString(),
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
      headerDecoration: const pw.BoxDecoration(color: PdfColors.deepPurple800),
      cellStyle: theme.defaultTextStyle.copyWith(fontSize: 10),
      cellAlignments: {
        0: pw.Alignment.center,
        1: pw.Alignment.center,
        2: pw.Alignment.center,
        3: pw.Alignment.center,
        4: pw.Alignment.center,
      },
      cellPadding: const pw.EdgeInsets.all(6),
      oddRowDecoration: const pw.BoxDecoration(color: PdfColors.grey50),
    );
  }
}
