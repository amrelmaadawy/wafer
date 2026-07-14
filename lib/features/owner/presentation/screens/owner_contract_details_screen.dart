import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/di/service_locator.dart' as di;
import '../../../../core/localization/locale_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/color_utils.dart';
import '../../../../core/utils/widgets/custom_button.dart';
import '../cubit/owner_contract_details_cubit.dart';
import '../cubit/owner_contract_details_state.dart';
import '../widgets/contracts/details/contract_details_financial_card.dart';
import '../widgets/contracts/details/contract_details_header_card.dart';
import '../widgets/contracts/details/contract_details_installments_action_card.dart';
import '../widgets/contracts/details/contract_details_property_card.dart';
import '../widgets/contracts/details/contract_details_renter_card.dart';
import '../widgets/contracts/details/contract_details_skeleton_widget.dart';

class OwnerContractDetailsScreen extends StatelessWidget {
  final String contractId;

  const OwnerContractDetailsScreen({super.key, required this.contractId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<OwnerContractDetailsCubit>()..getContractDetails(contractId),
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: AppColors.textPrimaryLight),
          title: Text(
            LocaleKeys.contractsDetailsTitle.tr(),
            style: const TextStyle(
              color: AppColors.textPrimaryLight,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(color: AppColors.borderLight.withValues(alpha: 0.6), height: 1),
          ),
        ),
        body: BlocBuilder<OwnerContractDetailsCubit, OwnerContractDetailsState>(
          builder: (context, state) {
            if (state is OwnerContractDetailsLoading || state is OwnerContractDetailsInitial) {
              return const ContractDetailsSkeletonWidget();
            } else if (state is OwnerContractDetailsError) {
              return _buildErrorState(context, state.message);
            } else if (state is OwnerContractDetailsLoaded) {
              final contract = state.contract;
              return RefreshIndicator(
                color: context.primaryColor,
                onRefresh: () => context.read<OwnerContractDetailsCubit>().getContractDetails(contractId),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
                  child: Column(
                    children: [
                      ContractDetailsHeaderCard(contract: contract),
                      const SizedBox(height: 16),
                      ContractDetailsPropertyCard(contract: contract),
                      const SizedBox(height: 16),
                      ContractDetailsRenterCard(contract: contract),
                      const SizedBox(height: 16),
                      ContractDetailsFinancialCard(contract: contract),
                      const SizedBox(height: 16),
                      ContractDetailsInstallmentsActionCard(
                        contractId: contractId,
                        contractNumber: contract.contractNumber,
                        installmentsCount: contract.paymentCount,
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, size: 48, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(fontSize: 14.5, color: AppColors.textPrimaryLight),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: LocaleKeys.commonRetry.tr(),
              width: 150,
              onPressed: () => context.read<OwnerContractDetailsCubit>().getContractDetails(contractId),
            ),
          ],
        ),
      ),
    );
  }
}
