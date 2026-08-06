import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import '../../../../features/owner/reports/domain/entities/revenue_report_entity.dart';

class RevenueExcelBuilder {
  static Future<List<int>> build(RevenueReportEntity report) async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    sheet.name = 'تقرير الإيرادات';
    sheet.isRightToLeft = true;

    // Header Styles
    final Style headerStyle = workbook.styles.add('HeaderStyle');
    headerStyle.bold = true;
    headerStyle.hAlign = HAlignType.center;
    headerStyle.vAlign = VAlignType.center;
    headerStyle.backColor = '#1E3A8A';
    headerStyle.fontColor = '#FFFFFF';
    headerStyle.fontSize = 12;

    final Style titleStyle = workbook.styles.add('TitleStyle');
    titleStyle.bold = true;
    titleStyle.hAlign = HAlignType.center;
    titleStyle.vAlign = VAlignType.center;
    titleStyle.fontSize = 16;
    titleStyle.fontColor = '#1E3A8A';

    final Style normalStyle = workbook.styles.add('NormalStyle');
    normalStyle.hAlign = HAlignType.center;
    normalStyle.vAlign = VAlignType.center;
    normalStyle.fontSize = 11;
    normalStyle.numberFormat = '#,##0.00';

    // Title
    sheet.getRangeByName('A1:E2').merge();
    sheet.getRangeByName('A1').text = 'تقرير الإيرادات';
    sheet.getRangeByName('A1').cellStyle = titleStyle;

    // Summary Section
    sheet.getRangeByName('A4').text = 'إجمالي المتوقع';
    sheet.getRangeByName('B4').number = report.summary.totalExpected;

    sheet.getRangeByName('A5').text = 'إجمالي المحصل';
    sheet.getRangeByName('B5').number = report.summary.totalCollected;

    sheet.getRangeByName('A6').text = 'المتبقي للتحصيل';
    sheet.getRangeByName('B6').number = report.summary.totalRemaining;

    sheet.getRangeByName('A7').text = 'نسبة التحصيل الكلية';
    sheet.getRangeByName('B7').text =
        '${report.summary.collectionRate.toStringAsFixed(1)}%';

    final Range summaryRange = sheet.getRangeByName('A4:A7');
    summaryRange.cellStyle.bold = true;

    final Range summaryValuesRange = sheet.getRangeByName('B4:B6');
    summaryValuesRange.cellStyle = normalStyle;

    sheet.getRangeByName('B7').cellStyle.hAlign = HAlignType.center;
    sheet.getRangeByName('B7').cellStyle.vAlign = VAlignType.center;
    sheet.getRangeByName('B7').cellStyle.fontSize = 11;

    // Columns Header
    final int startRow = 10;
    final List<String> headers = [
      'الشهر',
      'المتوقع',
      'المحصل',
      'المتبقي',
      'نسبة التحصيل',
    ];

    for (int i = 0; i < headers.length; i++) {
      final Range range = sheet.getRangeByIndex(startRow, i + 1);
      range.text = headers[i];
      range.cellStyle = headerStyle;
    }

    // Adjust column widths
    sheet.setColumnWidthInPixels(1, 150);
    sheet.setColumnWidthInPixels(2, 120);
    sheet.setColumnWidthInPixels(3, 120);
    sheet.setColumnWidthInPixels(4, 120);
    sheet.setColumnWidthInPixels(5, 120);

    // Data Rows
    int row = startRow + 1;
    for (final entry in report.chart) {
      sheet.getRangeByIndex(row, 1).text = entry.month;

      sheet.getRangeByIndex(row, 2).number = entry.expected;
      sheet.getRangeByIndex(row, 2).cellStyle = normalStyle;

      sheet.getRangeByIndex(row, 3).number = entry.collected;
      sheet.getRangeByIndex(row, 3).cellStyle = normalStyle;

      sheet.getRangeByIndex(row, 4).number = entry.remaining;
      sheet.getRangeByIndex(row, 4).cellStyle = normalStyle;

      sheet.getRangeByIndex(row, 5).text =
          '${entry.collectionRate.toStringAsFixed(1)}%';
      sheet.getRangeByIndex(row, 5).cellStyle.hAlign = HAlignType.center;
      sheet.getRangeByIndex(row, 5).cellStyle.vAlign = VAlignType.center;
      sheet.getRangeByIndex(row, 5).cellStyle.fontSize = 11;

      sheet.getRangeByIndex(row, 1).cellStyle.hAlign = HAlignType.center;
      sheet.getRangeByIndex(row, 1).cellStyle.vAlign = VAlignType.center;
      sheet.getRangeByIndex(row, 1).cellStyle.fontSize = 11;

      row++;
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    return bytes;
  }
}
