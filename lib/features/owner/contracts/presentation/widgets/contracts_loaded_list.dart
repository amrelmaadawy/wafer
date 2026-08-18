import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/presentation/widgets/list/paginated_list_view.dart';
import '../../../../../core/routing/routes.dart';
import '../../domain/entities/contract_item_entity.dart';
import '../cubit/list/owner_contracts_cubit.dart';
import '../cubit/list/owner_contracts_state.dart';
import 'contract_card.dart';

class ContractsLoadedList extends StatelessWidget {
  final List<ContractItemEntity> contracts;
  final ScrollController controller;
  final bool isFetchingMore;

  const ContractsLoadedList({
    super.key,
    required this.contracts,
    required this.controller,
    required this.isFetchingMore,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OwnerContractsCubit>();
    final state = cubit.state;
    final hasReachedMax = state is OwnerContractsLoaded
        ? !state.meta.hasMore
        : false;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isLargeScreen = constraints.maxWidth >= 900;

        return PaginatedListView<ContractItemEntity>(
          controller: controller,
          items: contracts,
          isFetchingMore: isFetchingMore,
          hasReachedMax: hasReachedMax,
          onRefresh: () => cubit.getContracts(forceRefresh: true),
          onLoadMore: cubit.loadNextPage,
          isGrid: isLargeScreen,
          padding: const EdgeInsets.only(top: 12, bottom: 40),
          gridDelegate: isLargeScreen
              ? const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 560,
                  mainAxisExtent: 220,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                )
              : null,
          separatorBuilder: isLargeScreen
              ? null
              : (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index, contract) {
            return ContractCard(
              contract: contract,
              onTap: () => context.push(
                Routes.ownerContractDetailsPath(contract.id),
              ),
            );
          },
        );
      },
    );
  }
}
