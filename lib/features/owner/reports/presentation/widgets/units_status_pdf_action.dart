import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/services/pdf/builders/units_status_pdf_builder.dart';
import '../../../../../core/services/pdf/pdf_generator_service.dart';
import '../cubit/owner_units_status_cubit.dart';
import '../cubit/owner_units_status_state.dart';

class UnitsStatusPdfAction extends StatelessWidget {
  const UnitsStatusPdfAction({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OwnerUnitsStatusCubit, OwnerUnitsStatusState>(
      builder: (context, state) {
        if (state is! OwnerUnitsStatusLoaded) return const SizedBox.shrink();
        return IconButton(
          tooltip: LocaleKeys.reports_unitsExportPdf.tr(),
          icon: const Icon(Icons.picture_as_pdf_outlined),
          onPressed: () async {
            final pdf = await UnitsStatusPdfBuilder.build(state.report);
            if (!context.mounted) return;
            await PdfGeneratorService.exportAndPrint(
              context: context,
              pdf: pdf,
              fileName: 'portfolio_units.pdf',
            );
          },
        );
      },
    );
  }
}
