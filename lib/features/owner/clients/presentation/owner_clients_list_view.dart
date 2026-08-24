import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/routes.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/localization/locale_keys.dart';
import '../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/di/service_locator.dart' as di;
import 'cubit/list/owner_clients_list_cubit.dart';
import 'cubit/list/owner_clients_list_state.dart';
import 'cubit/delete/delete_owner_client_cubit.dart';
import 'cubit/delete/delete_owner_client_state.dart';
import '../../../../core/utils/widgets/app_toast.dart';
import '../../../../core/presentation/widgets/app_loading_overlay.dart';
import 'widgets/owner_client_card.dart';
import 'widgets/client_shimmer_card.dart';

class OwnerClientsListView extends StatelessWidget {
  const OwnerClientsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<OwnerClientsListCubit>()..loadClients(forceRefresh: true),
        ),
        BlocProvider(
          create: (_) => di.sl<DeleteOwnerClientCubit>(),
        ),
      ],
      child: const _OwnerClientsListViewContent(),
    );
  }
}

class _OwnerClientsListViewContent extends StatefulWidget {
  const _OwnerClientsListViewContent();

  @override
  State<_OwnerClientsListViewContent> createState() => _OwnerClientsListViewContentState();
}

class _OwnerClientsListViewContentState extends State<_OwnerClientsListViewContent> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<OwnerClientsListCubit>().loadClients();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll - 200);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeleteOwnerClientCubit, DeleteOwnerClientState>(
      listener: (context, state) {
        if (state.status == DeleteOwnerClientStatus.success) {
          AppToast.showSuccess(context, LocaleKeys.commonSuccess.tr()); // or a specific message
          context.read<OwnerClientsListCubit>().loadClients(forceRefresh: true);
        } else if (state.status == DeleteOwnerClientStatus.failure) {
          AppToast.showError(context, state.errorMessage ?? LocaleKeys.commonError.tr());
        }
      },
      builder: (context, deleteState) {
        return AppLoadingOverlay(
          isLoading: deleteState.status == DeleteOwnerClientStatus.loading,
          child: Scaffold(
            appBar: CustomAppBar(
              title: LocaleKeys.clients.tr(),
              showBackButton: false,
              showMenuButton: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.search_rounded),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    context.push(Routes.ownerClientsSearch);
                  },
                ),
              ],
            ),
      body: BlocBuilder<OwnerClientsListCubit, OwnerClientsListState>(
        builder: (context, state) {
          if (state.status == OwnerClientsListStatus.loading) {
            return const ClientsListShimmer();
          }

          if (state.status == OwnerClientsListStatus.failure &&
              state.clients.isEmpty) {
            return CustomErrorWidget(
              message: state.errorMessage ?? LocaleKeys.commonError.tr(),
              onRetry: () => context.read<OwnerClientsListCubit>().loadClients(forceRefresh: true),
            );
          }

          if (state.clients.isEmpty) {
            return _buildEmptyState(context);
          }

          return RefreshIndicator(
            onRefresh: () async => context.read<OwnerClientsListCubit>().loadClients(forceRefresh: true),
            color: Theme.of(context).primaryColor,
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: state.clients.length +
                  (state.status == OwnerClientsListStatus.loadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= state.clients.length) {
                  return const Padding(
                    padding: EdgeInsets.only(bottom: AppSpacing.md),
                    child: ClientShimmerCard(),
                  );
                }

                final client = state.clients[index];
                return OwnerClientCard(
                  client: client,
                  onTap: () {
                    context.push(
                      Routes.ownerClientStatementPath(client.id.toString()),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 80,
              color: AppColors.textSecondaryLight.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              LocaleKeys.noClientsFound.tr(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              LocaleKeys.contractsNoSubtitle.tr(),
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
