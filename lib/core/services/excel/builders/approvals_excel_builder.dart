import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import '../../../../features/owner/reports/domain/entities/approvals_report_entity.dart';

class ApprovalsExcelBuilder {
  static Future<List<int>> build(ApprovalsReportEntity report) async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    sheet.name = 'تقرير الموافقات';
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
    sheet.getRangeByName('A1').text = 'تقرير الموافقات والاعتمادات';
    sheet.getRangeByName('A1').cellStyle = titleStyle;

    // Summary Section
    sheet.getRangeByName('A4').text = 'إجمالي الطلبات';
    sheet.getRangeByName('B4').number = report.summary.total.toDouble();

    sheet.getRangeByName('A5').text = 'المعتمدة';
    sheet.getRangeByName('B5').number = report.summary.approved.toDouble();

    sheet.getRangeByName('A6').text = 'المعلقة';
    sheet.getRangeByName('B6').number = report.summary.pending.toDouble();

    sheet.getRangeByName('A7').text = 'المرفوضة';
    sheet.getRangeByName('B7').number = report.summary.rejected.toDouble();

    final Range summaryRange = sheet.getRangeByName('A4:A7');
    summaryRange.cellStyle.bold = true;
    sheet.getRangeByName('B4:B7').cellStyle = normalStyle;

    // Columns Header
    final int startRow = 9;
    final List<String> headers = [
      'العنوان',
      'النوع',
      'المستخدم',
      'المبلغ',
      'التاريخ',
      'الحالة',
    ];

    for (int i = 0; i < headers.length; i++) {
      final Range range = sheet.getRangeByIndex(startRow, i + 1);
      range.text = headers[i];
      range.cellStyle = headerStyle;
    }

    sheet.setColumnWidthInPixels(1, 180);
    sheet.setColumnWidthInPixels(2, 130);
    sheet.setColumnWidthInPixels(3, 140);
    sheet.setColumnWidthInPixels(4, 110);
    sheet.setColumnWidthInPixels(5, 120);
    sheet.setColumnWidthInPixels(6, 110);

    // Data Rows
    int row = startRow + 1;
    for (final item in report.items) {
      sheet.getRangeByIndex(row, 1).text = item.title ?? '-';
      sheet.getRangeByIndex(row, 2).text =
          item.typeLabel ?? item.typeValue ?? '-';
      sheet.getRangeByIndex(row, 3).text = item.userName ?? '-';
      sheet.getRangeByIndex(row, 4).text =
          item.amount != null ? '${item.amount} ر.س' : '-';
      sheet.getRangeByIndex(row, 5).text = item.date ?? '-';
      sheet.getRangeByIndex(row, 6).text = item.statusLabel ?? item.status;

      sheet.getRangeByIndex(row, 1, row, 6).cellStyle = normalStyle;
      row++;
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    return bytes;
  }
}
