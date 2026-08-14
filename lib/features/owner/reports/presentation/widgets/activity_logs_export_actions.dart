import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/services/excel/builders/activity_logs_excel_builder.dart';
import '../../../../../core/services/excel/excel_export_service.dart';
import '../../../../../core/services/pdf/builders/activity_logs_pdf_builder.dart';
import '../../../../../core/services/pdf/pdf_generator_service.dart';
import '../cubit/owner_activity_logs_cubit.dart';
import '../cubit/owner_activity_logs_state.dart';
import 'report_export_button.dart';

class ActivityLogsExportActions extends StatelessWidget {
  const ActivityLogsExportActions({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OwnerActivityLogsCubit, OwnerActivityLogsState>(
      builder: (context, state) {
        final report = switch (state) {
          OwnerActivityLogsLoaded(:final report) => report,
          OwnerActivityLogsLoading(:final report) => report,
          OwnerActivityLogsEmpty(:final report) => report,
          _ => null,
        };
        if (report == null || report.items.isEmpty) {
          return const SizedBox.shrink();
        }
        return ReportExportButton(
          onPdfPressed: () async {
            final pdf = await ActivityLogsPdfBuilder.build(
              report.summary,
              report.items,
            );
            if (!context.mounted) return;
            await PdfGeneratorService.exportAndPrint(
              context: context,
              pdf: pdf,
              fileName: 'activity_logs_report.pdf',
            );
          },
          onExcelPressed: () async {
            final bytes = await ActivityLogsExcelBuilder.build(
              report.summary,
              report.items,
            );
            if (!context.mounted) return;
            await ExcelExportService.saveAndShare(
              context: context,
              bytes: bytes,
              fileName: 'activity_logs_report.xlsx',
            );
          },
        );
      },
    );
  }
}
