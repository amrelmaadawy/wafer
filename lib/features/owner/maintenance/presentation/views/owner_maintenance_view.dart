import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../core/presentation/widgets/list/paginated_list_view.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../domain/entities/maintenance_item_entity.dart';
import '../cubit/owner_maintenance_cubit.dart';
import '../cubit/owner_maintenance_state.dart';
import '../widgets/maintenance_card.dart';
import '../widgets/maintenance_empty_widget.dart';
import '../widgets/maintenance_filter_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';

import '../../../shell/presentation/widgets/owner_top_app_bar.dart';
import '../widgets/maintenance_shimmer.dart';

class OwnerMaintenanceView extends StatefulWidget {
  final String? initialStatusFilter;

  const OwnerMaintenanceView({super.key, this.initialStatusFilter});

  @override
  State<OwnerMaintenanceView> createState() => _OwnerMaintenanceViewState();
}

class _OwnerMaintenanceViewState extends State<OwnerMaintenanceView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialStatusFilter != null &&
          widget.initialStatusFilter!.isNotEmpty &&
          widget.initialStatusFilter != 'all') {
        context.read<OwnerMaintenanceCubit>().changeStatusFilter(
          widget.initialStatusFilter!,
          force: true,
        );
      } else {
        context.read<OwnerMaintenanceCubit>().getMaintenanceRequests();
      }
    });
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
      appBar: OwnerTopAppBar(
        title: LocaleKeys.maintenanceTitle.tr(),
        extraIconActions: [
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(100),
            child: InkWell(
              onTap: () => context.push(Routes.ownerNegotiationsList),
              borderRadius: BorderRadius.circular(100),
              child: SizedBox(
                width: 40,
                height: 40,
                child: Icon(
                  Icons.gavel_rounded,
                  color: context.primaryColor,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(heroTag: null, 
        onPressed: () {
          context.push(Routes.ownerMaintenanceCreate).then((value) {
            if (value == true && context.mounted) {
              context.read<OwnerMaintenanceCubit>().getMaintenanceRequests(
                forceRefresh: true,
              );
            }
          });
        },
        backgroundColor: context.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const MaintenanceFilterBar(),
            Expanded(child: _buildBody(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<OwnerMaintenanceCubit, OwnerMaintenanceState>(
      builder: (context, state) {
        final cubit = context.read<OwnerMaintenanceCubit>();

        if (state is OwnerMaintenanceLoading ||
            state is OwnerMaintenanceInitial) {
          return const MaintenanceShimmer();
        }

        if (state is OwnerMaintenanceError) {
          return CustomErrorWidget(
            message: state.message,
            onRetry: () => cubit.getMaintenanceRequests(forceRefresh: true),
          );
        }


        final items = state is OwnerMaintenanceLoaded ? state.items : const <MaintenanceItemEntity>[];
        final isFetchingMore = state is OwnerMaintenanceLoaded && state.isFetchingMore;
        final hasMore = state is OwnerMaintenanceLoaded && state.meta.hasMore;

        return Column(
          children: [

            Expanded(
              child: PaginatedListView<MaintenanceItemEntity>(
                controller: _scrollController,
                items: items,
                isFetchingMore: isFetchingMore,
                hasReachedMax: !hasMore,
                onRefresh: () => cubit.getMaintenanceRequests(forceRefresh: true),
                onLoadMore: cubit.loadNextPage,
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 80),
                emptyWidget: MaintenanceEmptyWidget(
                  onRefresh: () => cubit.changeStatusFilter('all', force: true),
                ),
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index, item) {
                  return MaintenanceCard(
                    item: item,
                    onTap: () async {
                      final result = await context.push(
                        Routes.ownerMaintenanceDetails,
                        extra: item,
                      );
                      if (result == true && context.mounted) {
                        cubit.getMaintenanceRequests(forceRefresh: true);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
