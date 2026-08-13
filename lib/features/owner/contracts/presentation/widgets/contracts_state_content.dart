import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../cubit/list/owner_contracts_cubit.dart';
import '../cubit/list/owner_contracts_state.dart';
import 'contracts_empty_widget.dart';
import 'contracts_loaded_list.dart';
import 'contracts_skeleton_widget.dart';

class ContractsStateContent extends StatelessWidget {
  final OwnerContractsState state;
  final ScrollController scrollController;

  const ContractsStateContent({
    super.key,
    required this.state,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      OwnerContractsInitial() ||
      OwnerContractsLoading() => const ContractsSkeletonWidget(),
      OwnerContractsError(:final message) => CustomErrorWidget(
        message: message,
        onRetry: () => context.read<OwnerContractsCubit>().getContracts(
          forceRefresh: true,
        ),
      ),
      OwnerContractsEmpty() => ContractsEmptyWidget(
        onRefresh: () => context.read<OwnerContractsCubit>().getContracts(
          forceRefresh: true,
        ),
      ),
      OwnerContractsLoaded(:final contracts, :final isFetchingMore) =>
        ContractsLoadedList(
          contracts: contracts,
          controller: scrollController,
          isFetchingMore: isFetchingMore,
        ),
      _ => const SizedBox.shrink(),
    };
  }
}
