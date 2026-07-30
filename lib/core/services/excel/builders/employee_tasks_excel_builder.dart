import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import '../../../../../features/owner/reports/domain/entities/employee_tasks_summary_entity.dart';
import '../../../../../features/owner/reports/domain/entities/employee_tasks_item_entity.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';

class EmployeeTasksExcelBuilder {
  static Future<List<int>> build(
    EmployeeTasksSummaryEntity summary,
    List<EmployeeTasksItemEntity> items,
  ) async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    sheet.name = 'تقرير مهام الموظفين';
    sheet.isRightToLeft = true;

    // Header styling
    final Style headerStyle = workbook.styles.add('HeaderStyle');
    headerStyle.bold = true;
    headerStyle.backColor = '#4B0082'; // Deep purple
    headerStyle.fontColor = '#FFFFFF';
    headerStyle.hAlign = HAlignType.center;
    headerStyle.vAlign = VAlignType.center;
    headerStyle.borders.all.lineStyle = LineStyle.thin;

    // Value styling
    final Style valueStyle = workbook.styles.add('ValueStyle');
    valueStyle.hAlign = HAlignType.center;
    valueStyle.vAlign = VAlignType.center;
    valueStyle.borders.all.lineStyle = LineStyle.thin;

    // Summary Section
    sheet.getRangeByName('A1:D1').merge();
    sheet.getRangeByName('A1').text = 'ملخص أداء الموظفين';
    sheet.getRangeByName('A1').cellStyle.bold = true;
    sheet.getRangeByName('A1').cellStyle.hAlign = HAlignType.center;
    sheet.getRangeByName('A1').cellStyle.fontSize = 14;

    final summaryHeaders = [
      LocaleKeys.employeeTasksTotalEmployees.tr(),
      LocaleKeys.employeeTasksTotalCompleted.tr(),
      LocaleKeys.employeeTasksTotalPending.tr(),
      LocaleKeys.employeeTasksTotalOverdue.tr(),
    ];

    final summaryValues = [
      summary.totalEmployees.toString(),
      summary.totalCompleted.toString(),
      summary.totalPending.toString(),
      summary.totalOverdue.toString(),
    ];

    for (int i = 0; i < summaryHeaders.length; i++) {
      final cell = sheet.getRangeByIndex(3, i + 1);
      cell.text = summaryHeaders[i];
      cell.cellStyle = headerStyle;

      final valCell = sheet.getRangeByIndex(4, i + 1);
      valCell.text = summaryValues[i];
      valCell.cellStyle = valueStyle;
    }

    // Items Section
    sheet.getRangeByName('A7:E7').merge();
    sheet.getRangeByName('A7').text = 'بيانات الموظفين';
    sheet.getRangeByName('A7').cellStyle.bold = true;
    sheet.getRangeByName('A7').cellStyle.fontSize = 14;

    final itemHeaders = [
      LocaleKeys.employeeTasksEmployeeName.tr(),
      LocaleKeys.employeeTasksEmployeePhone.tr(),
      LocaleKeys.employeeTasksCompleted.tr(),
      LocaleKeys.employeeTasksPending.tr(),
      LocaleKeys.employeeTasksOverdue.tr(),
    ];

    for (int i = 0; i < itemHeaders.length; i++) {
      final cell = sheet.getRangeByIndex(9, i + 1);
      cell.text = itemHeaders[i];
      cell.cellStyle = headerStyle;
      sheet.setColumnWidthInPixels(i + 1, i == 0 ? 150 : 120);
    }

    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      final row = i + 10;

      sheet.getRangeByIndex(row, 1).text = item.name.isNotEmpty
          ? item.name
          : '-';
      sheet.getRangeByIndex(row, 2).text = item.phone.isNotEmpty
          ? item.phone
          : '-';
      sheet.getRangeByIndex(row, 3).text = item.completedTasks.toString();
      sheet.getRangeByIndex(row, 4).text = item.pendingTasks.toString();
      sheet.getRangeByIndex(row, 5).text = item.overdueTasks.toString();

      for (int j = 1; j <= 5; j++) {
        sheet.getRangeByIndex(row, j).cellStyle = valueStyle;
      }
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    return bytes;
  }
}
