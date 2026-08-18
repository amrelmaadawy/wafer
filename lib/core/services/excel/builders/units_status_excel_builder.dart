import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import '../../../../features/owner/reports/domain/entities/units_status_report_entity.dart';

class UnitsStatusExcelBuilder {
  static Future<List<int>> build(UnitsStatusReportEntity report) async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    sheet.name = 'تقرير حالات الوحدات';
    sheet.isRightToLeft = true;

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

    // Title
    sheet.getRangeByName('A1:F2').merge();
    sheet.getRangeByName('A1').text = 'تقرير حالة الوحدات';
    sheet.getRangeByName('A1').cellStyle = titleStyle;

    // Summary Section
    sheet.getRangeByName('A4').text = 'إجمالي الوحدات';
    sheet.getRangeByName('B4').number = report.summary.total.toDouble();

    sheet.getRangeByName('A5').text = 'الوحدات الشاغرة';
    sheet.getRangeByName('B5').number = report.summary.vacant.toDouble();

    sheet.getRangeByName('A6').text = 'الوحدات المؤجرة';
    sheet.getRangeByName('B6').number = report.summary.rented.toDouble();

    sheet.getRangeByName('A7').text = 'تحت الصيانة';
    sheet.getRangeByName('B7').number = report.summary.maintenance.toDouble();

    final Range summaryRange = sheet.getRangeByName('A4:A7');
    summaryRange.cellStyle.bold = true;
    sheet.getRangeByName('B4:B7').cellStyle = normalStyle;

    // Columns Header
    final int startRow = 9;
    final List<String> headers = [
      'رقم الوحدة',
      'اسم الوحدة',
      'العقار',
      'الدور',
      'الحالة',
      'تاريخ الإنشاء',
    ];

    for (int i = 0; i < headers.length; i++) {
      final Range range = sheet.getRangeByIndex(startRow, i + 1);
      range.text = headers[i];
      range.cellStyle = headerStyle;
    }

    sheet.setColumnWidthInPixels(1, 120);
    sheet.setColumnWidthInPixels(2, 140);
    sheet.setColumnWidthInPixels(3, 160);
    sheet.setColumnWidthInPixels(4, 80);
    sheet.setColumnWidthInPixels(5, 110);
    sheet.setColumnWidthInPixels(6, 120);

    // Data Rows
    int row = startRow + 1;
    for (final item in report.items) {
      sheet.getRangeByIndex(row, 1).text = item.unitNumber;
      sheet.getRangeByIndex(row, 2).text = item.name;
      sheet.getRangeByIndex(row, 3).text = item.property.name;
      sheet.getRangeByIndex(row, 4).text =
          item.floorNumber != null ? '${item.floorNumber}' : '-';
      sheet.getRangeByIndex(row, 5).text = item.statusLabel;
      sheet.getRangeByIndex(row, 6).text = item.createdAt;

      sheet.getRangeByIndex(row, 1, row, 6).cellStyle = normalStyle;
      row++;
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    return bytes;
  }
}
