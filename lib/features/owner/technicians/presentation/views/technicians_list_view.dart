import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../../../../core/utils/widgets/app_shimmer.dart';
import '../../../../../../core/utils/widgets/custom_button.dart';
import '../cubit/list/technicians_list_cubit.dart';
import '../cubit/list/technicians_list_state.dart';
import '../widgets/technician_card.dart';

class TechniciansListView extends StatefulWidget {
  const TechniciansListView({super.key});

  @override
  State<TechniciansListView> createState() => _TechniciansListViewState();
}

class _TechniciansListViewState extends State<TechniciansListView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<TechniciansListCubit>().loadTechnicians(forceRefresh: true);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<TechniciansListCubit>().loadTechnicians();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await context
        .read<TechniciansListCubit>()
        .loadTechnicians(forceRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          LocaleKeys.techniciansList.tr(),
          style: const TextStyle(
            color: AppColors.textPrimaryLight,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textPrimaryLight),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add_circle_outline,
              color: context.primaryColor,
            ),
            onPressed: () {
              context.push(Routes.ownerTechnicianCreate).then((_) {
                _onRefresh();
              });
            },
          )
        ],
      ),
      body: BlocBuilder<TechniciansListCubit, TechniciansListState>(
        builder: (context, state) {
          if (state.status == TechniciansListStatus.initial ||
              (state.status == TechniciansListStatus.loading &&
                  state.technicians.isEmpty)) {
            return _buildShimmerLoading();
          }

          if (state.status == TechniciansListStatus.failure &&
              state.technicians.isEmpty) {
            return _buildErrorState(state.errorMessage ?? LocaleKeys.commonError.tr(), context);
          }

          if (state.technicians.isEmpty) {
            return _buildEmptyState(context);
          }

          return RefreshIndicator(
            onRefresh: _onRefresh,
            color: context.primaryColor,
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: state.technicians.length +
                  (state.status == TechniciansListStatus.loadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= state.technicians.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final technician = state.technicians[index];
                return TechnicianCard(technician: technician);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: AppShimmer.box(
            height: 140,
            width: double.infinity,
          ),
        );
      },
    );
  }

  Widget _buildErrorState(String message, BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: AppColors.error,
              size: 64,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textPrimaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            CustomButton(
              text: LocaleKeys.retry.tr(),
              onPressed: _onRefresh,
            ),
          ],
        ),
      ),
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
              Icons.engineering_outlined,
              size: 80,
              color: AppColors.textSecondaryLight.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              LocaleKeys.noTechniciansFound.tr(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              LocaleKeys.noTechniciansFoundDesc.tr(),
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            CustomButton(
              text: LocaleKeys.addTechnician.tr(),
              onPressed: () {
                context.push(Routes.ownerTechnicianCreate).then((_) {
                  _onRefresh();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
