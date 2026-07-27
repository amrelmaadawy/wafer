import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import '../../../../../features/owner/reports/domain/entities/defaulters_report_item_entity.dart';

class DefaultersExcelBuilder {
  static Future<List<int>> build(
    List<DefaultersReportItemEntity> items,
    double totalRemaining,
    double totalAmount,
    int totalInstallments,
  ) async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    sheet.name = 'تقرير المتأخرات';
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
    sheet.getRangeByName('A1').text = 'ملخص المتأخرات';
    sheet.getRangeByName('A1').cellStyle = headerStyle;
    
    // Summary Data
    sheet.getRangeByName('A2').text = 'إجمالي الأقساط';
    sheet.getRangeByName('B2').text = 'إجمالي المبالغ';
    sheet.getRangeByName('C2').text = 'إجمالي المتبقي';
    
    sheet.getRangeByName('A3').number = totalInstallments.toDouble();
    sheet.getRangeByName('B3').number = totalAmount;
    sheet.getRangeByName('C3').number = totalRemaining;

    // Data Table Headers
    const int startRow = 5;
    final headers = [
      'المستأجر',
      'الوحدة',
      'العقار',
      'رقم العقد',
      'رقم القسط',
      'تاريخ الاستحقاق',
      'قيمة القسط',
      'المدفوع',
      'المتبقي',
      'أيام التأخير',
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
      
      sheet.getRangeByIndex(row, 1).text = item.renter.name.isNotEmpty ? item.renter.name : 'غير محدد';
      sheet.getRangeByIndex(row, 2).text = item.unit.name.isNotEmpty ? item.unit.name : item.unit.unitNumber;
      sheet.getRangeByIndex(row, 3).text = item.property.name.isNotEmpty ? item.property.name : item.property.code;
      sheet.getRangeByIndex(row, 4).text = item.contract.contractNumber;
      sheet.getRangeByIndex(row, 5).number = item.installmentNumber.toDouble();
      sheet.getRangeByIndex(row, 6).text = item.dueDate;
      sheet.getRangeByIndex(row, 7).number = item.amount;
      sheet.getRangeByIndex(row, 8).number = item.paidAmount;
      sheet.getRangeByIndex(row, 9).number = item.remainingAmount;
      sheet.getRangeByIndex(row, 10).number = item.daysOverdue;
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
