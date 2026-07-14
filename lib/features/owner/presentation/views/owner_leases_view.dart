import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/localization/locale_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/color_utils.dart';
import '../cubit/owner_contracts_cubit.dart';
import '../cubit/owner_contracts_state.dart';
import '../widgets/contracts/contract_card.dart';
import '../widgets/contracts/contracts_empty_widget.dart';
import '../widgets/contracts/contracts_filter_bar.dart';
import '../widgets/contracts/contracts_skeleton_widget.dart';

class OwnerLeasesView extends StatefulWidget {
  const OwnerLeasesView({super.key});

  @override
  State<OwnerLeasesView> createState() => _OwnerLeasesViewState();
}

class _OwnerLeasesViewState extends State<OwnerLeasesView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OwnerContractsCubit>().getContracts();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<OwnerContractsCubit>().loadNextPage();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            const ContractsFilterBar(),
            Expanded(child: _buildBody(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            LocaleKeys.contractsTitle.tr(),
            style: const TextStyle(
              color: AppColors.textPrimaryLight,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          BlocBuilder<OwnerContractsCubit, OwnerContractsState>(
            builder: (context, state) {
              int total = 0;
              if (state is OwnerContractsLoaded) total = state.meta.total;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: context.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${LocaleKeys.contractsTotalCount.tr()}: $total',
                  style: TextStyle(
                    color: context.primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<OwnerContractsCubit, OwnerContractsState>(
      builder: (context, state) {
        if (state is OwnerContractsLoading || state is OwnerContractsInitial) {
          return const ContractsSkeletonWidget();
        } else if (state is OwnerContractsError) {
          return Center(child: Text(state.message));
        } else if (state is OwnerContractsEmpty) {
          return ContractsEmptyWidget(
            onRefresh: () => context.read<OwnerContractsCubit>().changeStatusFilter('all', force: true),
          );
        } else if (state is OwnerContractsLoaded) {
          return RefreshIndicator(
            color: context.primaryColor,
            onRefresh: () => context.read<OwnerContractsCubit>().getContracts(forceRefresh: true),
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 80),
              itemCount: state.contracts.length + (state.isFetchingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == state.contracts.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  );
                }
                return ContractCard(contract: state.contracts[index]);
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
