import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/di/service_locator.dart' as di;
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../core/theme/app_colors.dart';
import '../cubit/details/owner_contract_details_cubit.dart';
import '../cubit/details/owner_contract_details_state.dart';
import '../cubit/installments/owner_contract_installments_cubit.dart';
import '../cubit/payments/contract_payments_cubit.dart';
import '../widgets/details/contract_activity_tab.dart';
import '../widgets/details/contract_details_skeleton_widget.dart';
import '../widgets/details/contract_details_sliver_app_bar.dart';
import '../widgets/details/contract_documents_tab.dart';
import '../widgets/details/contract_installments_tab.dart';
import '../widgets/details/contract_overview_tab.dart';
import '../widgets/details/contract_payments_tab.dart';

class OwnerContractDetailsScreen extends StatefulWidget {
  final String contractId;

  const OwnerContractDetailsScreen({super.key, required this.contractId});

  @override
  State<OwnerContractDetailsScreen> createState() =>
      _OwnerContractDetailsScreenState();
}

class _OwnerContractDetailsScreenState extends State<OwnerContractDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<OwnerContractDetailsCubit>()
            ..getContractDetails(widget.contractId),
        ),
        BlocProvider(
          create: (_) => di.sl<OwnerContractInstallmentsCubit>(),
        ),
        BlocProvider(
          create: (_) => di.sl<ContractPaymentsCubit>(),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        body: BlocBuilder<OwnerContractDetailsCubit, OwnerContractDetailsState>(
          builder: (context, state) {
            if (state is OwnerContractDetailsLoading ||
                state is OwnerContractDetailsInitial) {
              return const ContractDetailsSkeletonWidget();
            }
            if (state is OwnerContractDetailsError) {
              return CustomErrorWidget(
                message: state.message,
                onRetry: () => context
                    .read<OwnerContractDetailsCubit>()
                    .getContractDetails(widget.contractId),
              );
            }
            if (state is! OwnerContractDetailsLoaded) {
              return const SizedBox.shrink();
            }

            final contract = state.contract;
            final contractNumericId = int.tryParse(widget.contractId) ?? 0;

            return NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  ContractDetailsSliverAppBar(
                    contract: contract,
                    tabController: _tabController,
                  ),
                ];
              },
              body: Container(
                color: AppColors.backgroundLight,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    ContractOverviewTab(contract: contract),
                    ContractInstallmentsTab(contractId: widget.contractId),
                    ContractPaymentsTab(contractId: contractNumericId),
                    ContractDocumentsTab(contract: contract),
                    const ContractActivityTab(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
