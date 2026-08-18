import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/services/excel/builders/units_status_excel_builder.dart';
import '../../../../../core/services/excel/excel_export_service.dart';
import '../../../../../core/services/pdf/builders/units_status_pdf_builder.dart';
import '../../../../../core/services/pdf/pdf_generator_service.dart';
import '../cubit/owner_units_status_cubit.dart';
import '../cubit/owner_units_status_state.dart';
import 'report_export_button.dart';

class UnitsStatusExportActions extends StatelessWidget {
  const UnitsStatusExportActions({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OwnerUnitsStatusCubit, OwnerUnitsStatusState>(
      builder: (context, state) {
        if (state is! OwnerUnitsStatusLoaded) return const SizedBox.shrink();
        return ReportExportButton(
          onPdfPressed: () async {
            final pdf = await UnitsStatusPdfBuilder.build(state.report);
            if (context.mounted) {
              await PdfGeneratorService.exportAndPrint(
                context: context,
                pdf: pdf,
                fileName: 'portfolio_units.pdf',
              );
            }
          },
          onExcelPressed: () async {
            final bytes = await UnitsStatusExcelBuilder.build(state.report);
            if (context.mounted) {
              await ExcelExportService.saveAndShare(
                context: context,
                bytes: bytes,
                fileName: 'portfolio_units.xlsx',
              );
            }
          },
        );
      },
    );
  }
}
