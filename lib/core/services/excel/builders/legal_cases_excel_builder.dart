import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import '../../../../../features/owner/reports/domain/entities/legal_cases_report_entity.dart';

class LegalCasesExcelBuilder {
  static Future<List<int>> build(
    List<LegalCaseItemEntity> items,
    LegalCasesSummaryEntity summary,
  ) async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    sheet.name = 'تقرير القضايا القانونية';
    sheet.isRightToLeft = true;

    // Header styling
    final Style headerStyle = workbook.styles.add('HeaderStyle');
    headerStyle.bold = true;
    headerStyle.backColor = '#1E3A8A';
    headerStyle.fontColor = '#FFFFFF';
    headerStyle.hAlign = HAlignType.center;
    headerStyle.vAlign = VAlignType.center;
    headerStyle.borders.all.lineStyle = LineStyle.thin;

    // Summary Title
    sheet.getRangeByName('A1:C1').merge();
    sheet.getRangeByName('A1').text = 'ملخص القضايا القانونية';
    sheet.getRangeByName('A1').cellStyle = headerStyle;

    // Summary Data
    sheet.getRangeByName('A2').text = 'إجمالي القضايا';
    sheet.getRangeByName('B2').text = 'القضايا النشطة';
    sheet.getRangeByName('C2').text = 'القضايا المحلولة';

    sheet.getRangeByName('A3').number = summary.total.toDouble();
    sheet.getRangeByName('B3').number = summary.active.toDouble();
    sheet.getRangeByName('C3').number = summary.resolved.toDouble();

    // Data Table Headers
    const int startRow = 5;
    final headers = [
      'رقم القضية',
      'المدعي',
      'المدعى عليه',
      'المحكمة',
      'تاريخ الجلسة',
      'تاريخ الجلسة القادمة',
      'الحالة',
      'العقار',
      'الوحدة',
      'رقم العقد',
      'تاريخ الإنشاء'
    ];

    for (int i = 0; i < headers.length; i++) {
      final cell = sheet.getRangeByIndex(startRow, i + 1);
      cell.text = headers[i];
      cell.cellStyle = headerStyle;
    }

    // Data Rows
    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      final row = startRow + 1 + i;

      sheet.getRangeByIndex(row, 1).text = item.caseNumber;
      sheet.getRangeByIndex(row, 2).text = item.plaintiff ?? '-';
      sheet.getRangeByIndex(row, 3).text = item.defendant ?? '-';
      sheet.getRangeByIndex(row, 4).text = item.court ?? '-';
      sheet.getRangeByIndex(row, 5).text = item.hearingDate ?? '-';
      sheet.getRangeByIndex(row, 6).text = item.nextHearingDate ?? '-';
      sheet.getRangeByIndex(row, 7).text = item.status;
      sheet.getRangeByIndex(row, 8).text = item.propertyName ?? '-';
      sheet.getRangeByIndex(row, 9).text = item.unitName ?? '-';
      sheet.getRangeByIndex(row, 10).text = item.contractNumber ?? '-';
      sheet.getRangeByIndex(row, 11).text = item.createdAt;
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
