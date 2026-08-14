import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/services/excel/builders/employee_tasks_excel_builder.dart';
import '../../../../../core/services/excel/excel_export_service.dart';
import '../../../../../core/services/pdf/builders/employee_tasks_pdf_builder.dart';
import '../../../../../core/services/pdf/pdf_generator_service.dart';
import '../cubit/owner_employee_tasks_cubit.dart';
import '../cubit/owner_employee_tasks_state.dart';

class EmployeeTasksExportActions extends StatelessWidget {
  const EmployeeTasksExportActions({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OwnerEmployeeTasksCubit, OwnerEmployeeTasksState>(
      builder: (context, state) {
        if (state is! OwnerEmployeeTasksLoaded) return const SizedBox.shrink();
        return Row(
          children: [
            IconButton(
              tooltip: LocaleKeys.tasksExportPdf.tr(),
              icon: const Icon(Icons.picture_as_pdf_outlined),
              onPressed: () => _exportPdf(context, state),
            ),
            IconButton(
              tooltip: LocaleKeys.tasksExportExcel.tr(),
              icon: const Icon(Icons.table_view_outlined),
              onPressed: () => _exportExcel(context, state),
            ),
          ],
        );
      },
    );
  }

  Future<void> _exportPdf(
    BuildContext context,
    OwnerEmployeeTasksLoaded state,
  ) async {
    final bytes = await EmployeeTasksPdfBuilder.build(
      state.report.summary,
      state.report.items,
    );
    if (!context.mounted) return;
    await PdfGeneratorService.exportAndPrint(
      context: context,
      pdf: bytes,
      fileName: 'team_tasks.pdf',
    );
  }

  Future<void> _exportExcel(
    BuildContext context,
    OwnerEmployeeTasksLoaded state,
  ) async {
    final bytes = await EmployeeTasksExcelBuilder.build(
      state.report.summary,
      state.report.items,
    );
    if (!context.mounted) return;
    await ExcelExportService.saveAndShare(
      context: context,
      bytes: bytes,
      fileName: 'team_tasks.xlsx',
    );
  }
}
