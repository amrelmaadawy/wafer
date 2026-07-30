import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import '../../../../../features/owner/reports/domain/entities/contracts_movement_summary_entity.dart';
import '../../../../../features/owner/reports/domain/entities/contracts_movement_item_entity.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';

class ContractsMovementExcelBuilder {
  static Future<List<int>> build(
    ContractsMovementSummaryEntity summary,
    List<ContractsMovementItemEntity> items,
  ) async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    sheet.name = 'تقرير حركة العقود';
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
    sheet.getRangeByName('A1').text = 'ملخص حركة العقود';
    sheet.getRangeByName('A1').cellStyle = headerStyle;

    // Summary Data
    sheet.getRangeByName('A2').text = LocaleKeys.contractsMovementTotalMovements
        .tr();
    sheet.getRangeByName('B2').text = LocaleKeys.contractsMovementCreations
        .tr();
    sheet.getRangeByName('C2').text = LocaleKeys.contractsMovementRenewals.tr();
    sheet.getRangeByName('D2').text = LocaleKeys.contractsMovementTerminations
        .tr();

    sheet.getRangeByName('A3').number = summary.totalMovements.toDouble();
    sheet.getRangeByName('B3').number = summary.creations.toDouble();
    sheet.getRangeByName('C3').number = summary.renewals.toDouble();
    sheet.getRangeByName('D3').number = summary.terminations.toDouble();

    // Data Table Headers
    const int startRow = 5;
    final headers = [
      LocaleKeys.contractsMovementContractNo.tr(),
      'المستأجر',
      'العقار',
      'الوحدة',
      'تاريخ الحركة',
      'نوع الحركة',
      'قيمة الإيجار',
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

      final renterName = item.renter.name.isNotEmpty
          ? item.renter.name
          : LocaleKeys.contractsMovementUnknownRenter.tr();
      final propertyName = item.property.name.isNotEmpty
          ? item.property.name
          : item.property.code;
      final unitName = item.unit.name.isNotEmpty
          ? item.unit.name
          : item.unit.unitNumber;

      String typeStr = item.type;
      if (item.type.toLowerCase() == 'creation') {
        typeStr = LocaleKeys.contractsMovementTypeCreation.tr();
      }
      if (item.type.toLowerCase() == 'renewal') {
        typeStr = LocaleKeys.contractsMovementTypeRenewal.tr();
      }
      if (item.type.toLowerCase() == 'termination') {
        typeStr = LocaleKeys.contractsMovementTypeTermination.tr();
      }

      sheet.getRangeByIndex(row, 1).text = item.contractNumber;
      sheet.getRangeByIndex(row, 2).text = renterName;
      sheet.getRangeByIndex(row, 3).text = propertyName;
      sheet.getRangeByIndex(row, 4).text = unitName;
      sheet.getRangeByIndex(row, 5).text = item.date.split(' ').first;
      sheet.getRangeByIndex(row, 6).text = typeStr;
      sheet.getRangeByIndex(row, 7).number = item.rentValue;
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
