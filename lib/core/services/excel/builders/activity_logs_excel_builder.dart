import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import '../../../../../features/owner/reports/domain/entities/activity_logs_summary_entity.dart';
import '../../../../../features/owner/reports/domain/entities/activity_logs_item_entity.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';

class ActivityLogsExcelBuilder {
  static Future<List<int>> build(
    ActivityLogsSummaryEntity summary,
    List<ActivityLogsItemEntity> items,
  ) async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    sheet.name = 'سجلات النشاط';
    sheet.isRightToLeft = true;

    // Header styling
    final Style headerStyle = workbook.styles.add('HeaderStyle');
    headerStyle.bold = true;
    headerStyle.backColor = '#1E3A8A';
    headerStyle.fontColor = '#FFFFFF';
    headerStyle.hAlign = HAlignType.center;
    headerStyle.vAlign = VAlignType.center;
    headerStyle.borders.all.lineStyle = LineStyle.thin;

    // Value styling
    final Style valueStyle = workbook.styles.add('ValueStyle');
    valueStyle.hAlign = HAlignType.center;
    valueStyle.vAlign = VAlignType.center;
    valueStyle.borders.all.lineStyle = LineStyle.thin;

    // Summary Header styling
    final Style summaryHeaderStyle = workbook.styles.add('SummaryHeaderStyle');
    summaryHeaderStyle.bold = true;
    summaryHeaderStyle.backColor = '#F3F4F6';
    summaryHeaderStyle.hAlign = HAlignType.center;
    summaryHeaderStyle.vAlign = VAlignType.center;
    summaryHeaderStyle.borders.all.lineStyle = LineStyle.thin;

    // Title
    sheet.getRangeByName('A1:E1').merge();
    sheet.getRangeByName('A1').setText(LocaleKeys.activityLogsTitle.tr());
    final Style titleStyle = workbook.styles.add('TitleStyle');
    titleStyle.bold = true;
    titleStyle.fontSize = 16;
    titleStyle.hAlign = HAlignType.center;
    titleStyle.vAlign = VAlignType.center;
    sheet.getRangeByName('A1').cellStyle = titleStyle;
    sheet.getRangeByName('A1').rowHeight = 40;

    // Summary
    int currentRow = 3;
    sheet.getRangeByIndex(currentRow, 1).setText(LocaleKeys.activityLogsTotalLogs.tr());
    sheet.getRangeByIndex(currentRow, 2).setText(LocaleKeys.activityLogsCreates.tr());
    sheet.getRangeByIndex(currentRow, 3).setText(LocaleKeys.activityLogsUpdates.tr());
    sheet.getRangeByIndex(currentRow, 4).setText(LocaleKeys.activityLogsDeletes.tr());

    sheet.getRangeByIndex(currentRow, 1, currentRow, 4).cellStyle = summaryHeaderStyle;
    currentRow++;

    sheet.getRangeByIndex(currentRow, 1).setNumber(summary.totalLogs.toDouble());
    sheet.getRangeByIndex(currentRow, 2).setNumber(summary.creates.toDouble());
    sheet.getRangeByIndex(currentRow, 3).setNumber(summary.updates.toDouble());
    sheet.getRangeByIndex(currentRow, 4).setNumber(summary.deletes.toDouble());

    sheet.getRangeByIndex(currentRow, 1, currentRow, 4).cellStyle = valueStyle;
    currentRow += 3;

    // Data Headers
    final headers = [
      LocaleKeys.activityLogsActionMessage.tr(),
      LocaleKeys.activityLogsActionType.tr(),
      LocaleKeys.activityLogsActionUser.tr(),
      LocaleKeys.activityLogsActionIp.tr(),
      LocaleKeys.activityLogsActionDate.tr(),
    ];

    for (int i = 0; i < headers.length; i++) {
      final cell = sheet.getRangeByIndex(currentRow, i + 1);
      cell.setText(headers[i]);
      cell.cellStyle = headerStyle;
    }
    currentRow++;

    // Data Rows
    if (items.isEmpty) {
      sheet.getRangeByIndex(currentRow, 1, currentRow, headers.length).merge();
      sheet.getRangeByIndex(currentRow, 1).setText(LocaleKeys.activityLogsNoData.tr());
      sheet.getRangeByIndex(currentRow, 1).cellStyle = valueStyle;
    } else {
      for (final item in items) {
        sheet.getRangeByIndex(currentRow, 1).setText(item.message);
        sheet.getRangeByIndex(currentRow, 2).setText(item.action.toUpperCase());
        sheet.getRangeByIndex(currentRow, 3).setText(item.user.name);
        sheet.getRangeByIndex(currentRow, 4).setText(item.ipAddress);
        sheet.getRangeByIndex(currentRow, 5).setText(item.createdAt);

        sheet.getRangeByIndex(currentRow, 1, currentRow, headers.length).cellStyle = valueStyle;
        currentRow++;
      }
    }

    // Auto-fit columns
    for (int i = 1; i <= headers.length; i++) {
      sheet.autoFitColumn(i);
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    return bytes;
  }
}
