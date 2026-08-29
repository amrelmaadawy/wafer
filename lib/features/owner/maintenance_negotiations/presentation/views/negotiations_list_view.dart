import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../../core/utils/widgets/app_shimmer.dart';
import '../../../../../../core/di/service_locator.dart';
import '../../domain/entities/negotiation_form_data_entity.dart';
import '../cubit/list/negotiations_list_cubit.dart';
import '../cubit/list/negotiations_list_state.dart';
import '../../../shell/presentation/widgets/owner_top_app_bar.dart';

class NegotiationsListView extends StatefulWidget {
  const NegotiationsListView({super.key});

  @override
  State<NegotiationsListView> createState() => _NegotiationsListViewState();
}

class _NegotiationsListViewState extends State<NegotiationsListView> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<NegotiationsListCubit>().fetchNegotiations();
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
    return BlocProvider(
      create: (_) => sl<NegotiationsListCubit>()..fetchNegotiations(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: OwnerTopAppBar(
              title: LocaleKeys.drawerNavNegotiations.tr(),
          forceDrawerButton: true,
            ),
            floatingActionButton: FloatingActionButton(heroTag: null, 
              onPressed: () async {
                final result = await context.push(
                  Routes.ownerNegotiationSettings,
                );
                if (result == true && mounted && context.mounted) {
                  context.read<NegotiationsListCubit>().fetchNegotiations(
                    isRefresh: true,
                  );
                }
              },
              backgroundColor: context.primaryColor,
              child: const Icon(Icons.settings, color: Colors.white),
            ),
            body: BlocBuilder<NegotiationsListCubit, NegotiationsListState>(
              builder: (context, state) {
                if (state.status == NegotiationsListStatus.initial ||
                    (state.status == NegotiationsListStatus.loading &&
                        state.negotiations.isEmpty)) {
                  return const _NegotiationsListSkeleton();
                }

                if (state.status == NegotiationsListStatus.failure &&
                    state.negotiations.isEmpty) {
                  return CustomErrorWidget(
                    message: state.errorMessage ?? '',
                    onRetry: () => context
                        .read<NegotiationsListCubit>()
                        .fetchNegotiations(isRefresh: true),
                  );
                }

                if (state.negotiations.isEmpty) {
                  return _EmptyStateWidget(
                    title: LocaleKeys.negotiation_empty_list.tr(),
                    subtitle: LocaleKeys.negotiation_empty_list_sub.tr(),
                    icon: Icons.list_alt,
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async => context
                      .read<NegotiationsListCubit>()
                      .fetchNegotiations(isRefresh: true),
                  child: ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    itemCount: state.hasReachedMax
                        ? state.negotiations.length
                        : state.negotiations.length + 1,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, index) {
                      if (index >= state.negotiations.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(AppSpacing.md),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final item = state.negotiations[index];
                      return _NegotiationCard(negotiation: item);
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _NegotiationCard extends StatelessWidget {
  final NegotiationEntity negotiation;

  const _NegotiationCard({required this.negotiation});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.circularMd,
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: context.primaryShadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: context.primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.gavel_rounded,
              color: context.primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        negotiation.owner?.name ?? '-',
                        style: AppTextStyles.h4,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    _buildStatusBadge(context),
                  ],
                ),
                if (negotiation.owner?.email != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    negotiation.owner!.email!,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    const Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 16,
                      color: AppColors.textSecondaryLight,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${LocaleKeys.negotiation_approval_limit.tr()}: ${negotiation.approvalLimit}',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final isActive = negotiation.isActive;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.success.withValues(alpha: 0.1)
            : AppColors.error.withValues(alpha: 0.1),
        borderRadius: AppRadius.circularSm,
      ),
      child: Text(
        isActive
            ? LocaleKeys.negotiation_active_status.tr()
            : LocaleKeys.negotiation_inactive_status.tr(),
        style: AppTextStyles.bodyMedium.copyWith(
          color: isActive ? AppColors.success : AppColors.error,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _NegotiationsListSkeleton extends StatelessWidget {
  const _NegotiationsListSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: 5,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) => Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: AppRadius.circularMd,
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppShimmer.circle(size: 48),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppShimmer.box(width: 120, height: 16),
                      AppShimmer.box(
                        width: 60,
                        height: 20,
                        borderRadius: AppRadius.circularSm,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppShimmer.box(width: 180, height: 14),
                  const SizedBox(height: AppSpacing.md),
                  AppShimmer.box(width: 140, height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyStateWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _EmptyStateWidget({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: AppColors.textSecondaryLight.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(title, style: AppTextStyles.h3, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.sm),
            Text(
              subtitle,
              style: AppTextStyles.bodyMedium.copyWith(
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
