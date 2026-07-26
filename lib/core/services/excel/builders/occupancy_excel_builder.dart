import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import '../../../../features/owner/reports/domain/entities/occupancy_property_entity.dart';

class OccupancyExcelBuilder {
  static Future<List<int>> build(
    List<OccupancyPropertyEntity> properties,
    double overallRate,
    int totalUnits,
    int totalRented,
    int totalVacant,
  ) async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    sheet.name = 'تقرير الإشغال';
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
    sheet.getRangeByName('A1').text = 'تقرير الإشغال';
    sheet.getRangeByName('A1').cellStyle = titleStyle;

    // Summary Section
    sheet.getRangeByName('A4').text = 'إجمالي العقارات';
    sheet.getRangeByName('B4').number = properties.length.toDouble();
    
    sheet.getRangeByName('A5').text = 'إجمالي الوحدات';
    sheet.getRangeByName('B5').number = totalUnits.toDouble();
    
    sheet.getRangeByName('A6').text = 'الوحدات المؤجرة';
    sheet.getRangeByName('B6').number = totalRented.toDouble();

    sheet.getRangeByName('A7').text = 'الوحدات الشاغرة';
    sheet.getRangeByName('B7').number = totalVacant.toDouble();

    sheet.getRangeByName('A8').text = 'نسبة الإشغال الكلية';
    sheet.getRangeByName('B8').text = '${overallRate.toStringAsFixed(1)}%';

    final Range summaryRange = sheet.getRangeByName('A4:A8');
    summaryRange.cellStyle.bold = true;
    sheet.getRangeByName('B4:B8').cellStyle = normalStyle;

    // Columns Header
    final int startRow = 11;
    final List<String> headers = [
      'اسم العقار',
      'الكود',
      'إجمالي الوحدات',
      'الوحدات المؤجرة',
      'الوحدات الشاغرة',
      'نسبة الإشغال',
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
    sheet.setColumnWidthInPixels(6, 120);

    // Data Rows
    int row = startRow + 1;
    for (final prop in properties) {
      sheet.getRangeByIndex(row, 1).text = prop.propertyName.isEmpty ? 'عقار ${prop.propertyId}' : prop.propertyName;
      sheet.getRangeByIndex(row, 2).text = prop.code;
      sheet.getRangeByIndex(row, 3).number = prop.totalUnits.toDouble();
      sheet.getRangeByIndex(row, 4).number = prop.rentedUnits.toDouble();
      sheet.getRangeByIndex(row, 5).number = prop.vacantUnits.toDouble();
      sheet.getRangeByIndex(row, 6).text = '${prop.occupancyRate.toStringAsFixed(1)}%';

      sheet.getRangeByIndex(row, 1, row, 6).cellStyle = normalStyle;
      row++;
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    return bytes;
  }
}
