import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import '../../../../features/owner/reports/domain/entities/contracts_report_item_entity.dart';

class ContractsExcelBuilder {
  static Future<List<int>> build(
    List<ContractsReportItemEntity> contracts,
    int totalExpiring,
    double totalRentValue,
    int days,
  ) async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    sheet.name = 'تقرير العقود';
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

    // Title
    sheet.getRangeByName('A1:F2').merge();
    sheet.getRangeByName('A1').text = 'ملخص تقرير العقود';
    sheet.getRangeByName('A1').cellStyle = titleStyle;

    // Summary Section
    sheet.getRangeByName('A4').text = 'العقود المنتهية خلال $days يوم';
    sheet.getRangeByName('B4').number = totalExpiring.toDouble();

    sheet.getRangeByName('A5').text = 'إجمالي الإيجارات';
    sheet.getRangeByName('B5').number = totalRentValue;

    final Range summaryRange = sheet.getRangeByName('A4:A5');
    summaryRange.cellStyle.bold = true;
    sheet.getRangeByName('B4:B5').cellStyle = normalStyle;

    // Data Table Headers
    final int startRow = 8;
    final headers = [
      'العقار',
      'الوحدة',
      'المستأجر',
      'تاريخ البداية',
      'تاريخ النهاية',
      'قيمة الإيجار',
      'الأيام المتبقية',
      'الحالة',
    ];

    for (int i = 0; i < headers.length; i++) {
      final cell = sheet.getRangeByIndex(startRow, i + 1);
      cell.text = headers[i];
      cell.cellStyle = headerStyle;
    }

    // Adjust column widths
    for (int i = 1; i <= headers.length; i++) {
      sheet.setColumnWidthInPixels(i, 120);
    }

    // Data Rows
    for (int i = 0; i < contracts.length; i++) {
      final c = contracts[i];
      final row = startRow + 1 + i;

      sheet.getRangeByIndex(row, 1).text = c.propertyName.isNotEmpty
          ? c.propertyName
          : 'غير محدد';
      sheet.getRangeByIndex(row, 2).text = c.unitName.isNotEmpty
          ? c.unitName
          : 'غير محدد';
      sheet.getRangeByIndex(row, 3).text = c.renterName.isNotEmpty
          ? c.renterName
          : 'غير محدد';
      sheet.getRangeByIndex(row, 4).text = c.startDate;
      sheet.getRangeByIndex(row, 5).text = c.endDate;
      sheet.getRangeByIndex(row, 6).number = c.rentValue;
      sheet.getRangeByIndex(row, 7).number = c.daysRemaining.toDouble();
      sheet.getRangeByIndex(row, 8).text = c.status;

      sheet.getRangeByIndex(row, 1, row, headers.length).cellStyle =
          normalStyle;
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    return bytes;
  }
}
