import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import '../../../../../features/owner/reports/domain/entities/maintenance_requests_summary_entity.dart';
import '../../../../../features/owner/reports/domain/entities/maintenance_requests_item_entity.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';

class MaintenanceRequestsExcelBuilder {
  static Future<List<int>> build(
    MaintenanceRequestsSummaryEntity summary,
    List<MaintenanceRequestsItemEntity> items,
  ) async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    sheet.name = 'تقرير طلبات الصيانة';
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
    sheet.getRangeByName('A1:D1').merge();
    sheet.getRangeByName('A1').text = 'ملخص طلبات الصيانة';
    sheet.getRangeByName('A1').cellStyle = headerStyle;
    
    // Summary Data
    sheet.getRangeByName('A2').text = LocaleKeys.maintenanceRequestsTotal.tr();
    sheet.getRangeByName('B2').text = LocaleKeys.maintenanceRequestsOpen.tr();
    sheet.getRangeByName('C2').text = LocaleKeys.maintenanceRequestsInProgress.tr();
    sheet.getRangeByName('D2').text = LocaleKeys.maintenanceRequestsCompleted.tr();
    
    sheet.getRangeByName('A3').number = summary.total.toDouble();
    sheet.getRangeByName('B3').number = summary.open.toDouble();
    sheet.getRangeByName('C3').number = summary.inProgress.toDouble();
    sheet.getRangeByName('D3').number = summary.completed.toDouble();

    // Data Table Headers
    const int startRow = 5;
    final headers = [
      LocaleKeys.maintenanceRequestsRequestNo.tr(),
      LocaleKeys.maintenanceRequestsClient.tr(),
      'رقم الهاتف',
      'العقار',
      'الوحدة',
      'تاريخ الطلب',
      'الوصف',
      'الحالة',
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
      
      final clientName = item.clientName.isNotEmpty ? item.clientName : LocaleKeys.maintenanceRequestsUnknownRenter.tr();
      final propertyName = item.property.name.isNotEmpty ? item.property.name : item.property.code;
      final unitName = item.unit.name.isNotEmpty ? item.unit.name : item.unit.unitNumber;

      sheet.getRangeByIndex(row, 1).text = item.requestNumber;
      sheet.getRangeByIndex(row, 2).text = clientName;
      sheet.getRangeByIndex(row, 3).text = item.clientPhone;
      sheet.getRangeByIndex(row, 4).text = propertyName;
      sheet.getRangeByIndex(row, 5).text = unitName;
      sheet.getRangeByIndex(row, 6).text = item.createdAt.split(' ').first;
      sheet.getRangeByIndex(row, 7).text = item.description;
      sheet.getRangeByIndex(row, 8).text = item.statusLabel;
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
