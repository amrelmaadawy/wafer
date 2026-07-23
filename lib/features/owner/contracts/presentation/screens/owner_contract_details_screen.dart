import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/di/service_locator.dart' as di;
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../core/theme/color_utils.dart';
import '../cubit/details/owner_contract_details_cubit.dart';
import '../cubit/details/owner_contract_details_state.dart';
import '../widgets/details/contract_details_financial_card.dart';
import '../widgets/details/contract_details_header_card.dart';
import '../widgets/details/contract_details_installments_action_card.dart';
import '../widgets/details/contract_details_property_card.dart';
import '../widgets/details/contract_details_renter_card.dart';
import '../widgets/details/contract_details_skeleton_widget.dart';

class OwnerContractDetailsScreen extends StatelessWidget {
  final String contractId;

  const OwnerContractDetailsScreen({super.key, required this.contractId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<OwnerContractDetailsCubit>()..getContractDetails(contractId),
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: CustomAppBar(
          title: LocaleKeys.contractsDetailsTitle.tr(),
        ),
        body: BlocBuilder<OwnerContractDetailsCubit, OwnerContractDetailsState>(
          builder: (context, state) {
            if (state is OwnerContractDetailsLoading || state is OwnerContractDetailsInitial) {
              return const ContractDetailsSkeletonWidget();
            } else if (state is OwnerContractDetailsError) {
              return CustomErrorWidget(
                message: state.message,
                onRetry: () => context.read<OwnerContractDetailsCubit>().getContractDetails(contractId),
              );
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
}
