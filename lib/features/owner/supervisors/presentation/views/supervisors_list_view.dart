import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/utils/widgets/app_shimmer.dart';
import '../../../../../../core/di/service_locator.dart';
import '../cubit/list/supervisors_list_cubit.dart';
import '../cubit/list/supervisors_list_state.dart';
import '../widgets/supervisor_card.dart';
import '../widgets/add_supervisor_bottom_sheet.dart';

class SupervisorsListView extends StatefulWidget {
  const SupervisorsListView({super.key});

  @override
  State<SupervisorsListView> createState() => _SupervisorsListViewState();
}

class _SupervisorsListViewState extends State<SupervisorsListView> {
  final ScrollController _scrollController = ScrollController();
  late final SupervisorsListCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<SupervisorsListCubit>()..fetchSupervisors();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    // Cubit will be closed by BlocProvider
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      _cubit.fetchSupervisors();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: CustomAppBar(
          title: LocaleKeys.supervisorsList.tr(),
          showBackButton: true,
        ),
        body: BlocBuilder<SupervisorsListCubit, SupervisorsListState>(
          builder: (context, state) {
            if (state.status == SupervisorsListStatus.initial ||
                state.status == SupervisorsListStatus.loading) {
              return const _SupervisorsListSkeleton();
            }

            if (state.status == SupervisorsListStatus.failure) {
              return CustomErrorWidget(
                message: state.errorMessage ?? 'An error occurred',
                onRetry: () => context.read<SupervisorsListCubit>().fetchSupervisors(isRefresh: true),
              );
            }

            if (state.supervisors.isEmpty) {
              return Center(
                child: Text(
                  LocaleKeys.noSupervisorsFound.tr(),
                  style: AppTextStyles.h4.copyWith(color: AppColors.textSecondaryLight),
                ),
              );
            }

            return RefreshIndicator(
              color: context.primaryColor,
              onRefresh: () async {
                context.read<SupervisorsListCubit>().fetchSupervisors(isRefresh: true);
              },
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: state.hasReachedMax
                    ? state.supervisors.length
                    : state.supervisors.length + 1,
                itemBuilder: (context, index) {
                  if (index >= state.supervisors.length) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: CircularProgressIndicator(color: context.primaryColor),
                      ),
                    );
                  }

                  final supervisor = state.supervisors[index];
                  return SupervisorCard(supervisor: supervisor);
                },
              ),
            );
          },
        ),
        floatingActionButton: Builder(
          builder: (ctx) => FloatingActionButton(
            backgroundColor: ctx.primaryColor,
            onPressed: () async {
              final result = await AddSupervisorBottomSheet.show(ctx);
              if (result == true && ctx.mounted) {
                ctx.read<SupervisorsListCubit>().fetchSupervisors(isRefresh: true);
              }
            },
            child: const Icon(Icons.add, color: AppColors.surfaceLight),
          ),
        ),
      ),
    );
  }
}

class _SupervisorsListSkeleton extends StatelessWidget {
  const _SupervisorsListSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
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
              AppShimmer.circle(size: 56),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppShimmer.box(width: 120, height: 16),
                        AppShimmer.box(width: 50, height: 24, borderRadius: AppRadius.circularSm),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppShimmer.box(width: 150, height: 12),
                    const SizedBox(height: AppSpacing.xs),
                    AppShimmer.box(width: 180, height: 12),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
