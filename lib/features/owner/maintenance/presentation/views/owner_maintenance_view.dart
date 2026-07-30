import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wafer/features/owner/maintenance/domain/entities/maintenance_sub_entities.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/color_utils.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../cubit/owner_maintenance_cubit.dart';
import '../cubit/owner_maintenance_state.dart';
import '../screens/owner_maintenance_details_screen.dart';
import '../widgets/maintenance_card.dart';
import '../widgets/maintenance_empty_widget.dart';
import '../widgets/maintenance_header.dart';
import '../widgets/maintenance_shimmer.dart';
import '../widgets/maintenance_stats_widget.dart';

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
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialStatusFilter != null &&
          widget.initialStatusFilter!.isNotEmpty &&
          widget.initialStatusFilter != 'all') {
        context
            .read<OwnerMaintenanceCubit>()
            .changeStatusFilter(widget.initialStatusFilter!, force: true);
      } else {
        context.read<OwnerMaintenanceCubit>().getMaintenanceRequests();
      }
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<OwnerMaintenanceCubit>().loadNextPage();
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(Routes.ownerMaintenanceCreate).then((value) {
            if (value == true && context.mounted) {
              context.read<OwnerMaintenanceCubit>().getMaintenanceRequests(forceRefresh: true);
            }
          });
        },
        backgroundColor: context.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const MaintenanceHeader(),
            Expanded(child: _buildBody(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<OwnerMaintenanceCubit, OwnerMaintenanceState>(
      builder: (context, state) {
        MaintenanceStatsEntity? stats;
        String activeStatus = 'all';

        if (state is OwnerMaintenanceLoaded) {
          stats = state.stats;
          activeStatus = state.activeStatus;
        } else if (state is OwnerMaintenanceEmpty) {
          stats = state.stats;
          activeStatus = state.activeStatus;
        }

        return Column(
          children: [
            if (stats != null)
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 4),
                child: MaintenanceStatsWidget(
                  stats: stats,
                  activeStatus: activeStatus,
                  onStatusSelected: (s) => context
                      .read<OwnerMaintenanceCubit>()
                      .changeStatusFilter(s),
                ),
              ),
            Expanded(
              child: _buildStateContent(context, state),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStateContent(BuildContext context, OwnerMaintenanceState state) {
    if (state is OwnerMaintenanceLoading || state is OwnerMaintenanceInitial) {
      return const MaintenanceShimmer();
    } else if (state is OwnerMaintenanceError) {
      return CustomErrorWidget(
        message: state.message,
        onRetry: () => context
            .read<OwnerMaintenanceCubit>()
            .getMaintenanceRequests(forceRefresh: true),
      );
    } else if (state is OwnerMaintenanceEmpty) {
      return MaintenanceEmptyWidget(
        onRefresh: () => context
            .read<OwnerMaintenanceCubit>()
            .changeStatusFilter('all', force: true),
      );
    } else if (state is OwnerMaintenanceLoaded) {
      return RefreshIndicator(
        color: context.primaryColor,
        onRefresh: () => context
            .read<OwnerMaintenanceCubit>()
            .getMaintenanceRequests(forceRefresh: true),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          controller: _scrollController,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 80),
          itemCount: state.items.length + (state.isFetchingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == state.items.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              );
            }
            final item = state.items[index];
            return MaintenanceCard(
              item: item,
              onTap: () async {
                final result = await Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (_) => OwnerMaintenanceDetailsScreen(item: item),
                  ),
                );
                if (result == true && context.mounted) {
                  context.read<OwnerMaintenanceCubit>().getMaintenanceRequests(forceRefresh: true);
                }
              },
            );
          },
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
