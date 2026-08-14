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
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Center(
            child: IconButton(
              tooltip: LocaleKeys.reports_unitsExportPdf.tr(),
              onPressed: () async {
                final pdf = await UnitsStatusPdfBuilder.build(state.report);
                if (!context.mounted) return;
                await PdfGeneratorService.exportAndPrint(
                  context: context,
                  pdf: pdf,
                  fileName: 'portfolio_units.pdf',
                );
              },
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: Icon(
                Icons.picture_as_pdf_rounded,
                color: Theme.of(context).primaryColor,
                size: 22,
              ),
            ),
          ),
        );
      },
    );
  }
}
