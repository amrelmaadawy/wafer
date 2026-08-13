import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../domain/entities/contract_item_entity.dart';
import '../cubit/list/owner_contracts_cubit.dart';
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
    return RefreshIndicator(
      color: context.primaryColor,
      onRefresh: () =>
          context.read<OwnerContractsCubit>().getContracts(forceRefresh: true),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemCount = contracts.length + (isFetchingMore ? 1 : 0);
          if (constraints.maxWidth >= 900) {
            return GridView.builder(
              controller: controller,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(top: 12, bottom: 40),
              itemCount: itemCount,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 560,
                mainAxisExtent: 220,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemBuilder: (context, index) =>
                  _buildItem(context, index, contracts.length),
            );
          }
          return ListView.separated(
            controller: controller,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 12, bottom: 40),
            itemCount: itemCount,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) =>
                _buildItem(context, index, contracts.length),
          );
        },
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index, int contractsCount) {
    if (index == contractsCount) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator(),
        ),
      );
    }
    final contract = contracts[index];
    return ContractCard(
      contract: contract,
      onTap: () => context.push(Routes.ownerContractDetailsPath(contract.id)),
    );
  }
}
