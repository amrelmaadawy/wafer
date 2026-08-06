import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/theme/color_utils.dart';
import '../../../../../../../core/utils/widgets/custom_text_field.dart';
import '../../../cubit/units/unit_create_cubit.dart';
import '../../../cubit/units/unit_create_state.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../../core/localization/locale_keys.dart';

class Step5FinancialsView extends StatelessWidget {
  const Step5FinancialsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UnitCreateCubit, UnitCreateState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.unitsFinancialsTitle.tr(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              CustomTextField(
                label: LocaleKeys.unitsAnnualRentMonthlyLabel.tr(),
                hintText: LocaleKeys.unitsAnnualRentMonthlyHint.tr(),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                initialValue: state.annualRentMonthly?.toString(),
                onChanged: (val) => context
                    .read<UnitCreateCubit>()
                    .updateFinancials(monthly: double.tryParse(val)),
              ),
              const SizedBox(height: 16),

              CustomTextField(
                label: LocaleKeys.unitsAnnualRent2PaymentsLabel.tr(),
                hintText: LocaleKeys.unitsAnnualRent2PaymentsHint.tr(),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                initialValue: state.annualRent2Payments?.toString(),
                onChanged: (val) => context
                    .read<UnitCreateCubit>()
                    .updateFinancials(twoPayments: double.tryParse(val)),
              ),
              const SizedBox(height: 16),

              CustomTextField(
                label: LocaleKeys.unitsAnnualRent4PaymentsLabel.tr(),
                hintText: LocaleKeys.unitsAnnualRent4PaymentsHint.tr(),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                initialValue: state.annualRent4Payments?.toString(),
                onChanged: (val) => context
                    .read<UnitCreateCubit>()
                    .updateFinancials(fourPayments: double.tryParse(val)),
              ),
              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocaleKeys.unitsUsePriceForMortgage.tr(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: AppColors.textPrimaryLight,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            LocaleKeys.unitsUsePriceForMortgageDesc.tr(),
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CupertinoSwitch(
                      value: state.usePriceForMortgage,
                      activeTrackColor: context.primaryColor,
                      onChanged: (val) => context
                          .read<UnitCreateCubit>()
                          .updateFinancials(useMortgage: val),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
