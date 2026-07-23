import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../core/utils/widgets/app_shimmer.dart';
import '../cubit/owner_defaulters_cubit.dart';
import '../cubit/owner_defaulters_state.dart';

class OwnerDefaultersReportView extends StatelessWidget {
  const OwnerDefaultersReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OwnerDefaultersCubit, OwnerDefaultersState>(
      builder: (context, state) {
        if (state is OwnerDefaultersLoading || state is OwnerDefaultersInitial) {
          return const SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: _DefaultersSkeleton(),
          );
        } else if (state is OwnerDefaultersError) {
          return _buildErrorView(context, state.message);
        } else if (state is OwnerDefaultersEmpty) {
          return _buildComingSoonView(context);
        } else if (state is OwnerDefaultersLoaded) {
          return _buildComingSoonView(context);
        }
        return _buildComingSoonView(context);
      },
    );
  }

  Widget _buildComingSoonView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF59E0B).withValues(alpha: 0.18),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                size: 44,
                color: Color(0xFFF59E0B),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              LocaleKeys.defaultersReportTitle.tr(),
              style: const TextStyle(
                color: AppColors.textPrimaryLight,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              LocaleKeys.defaultersComingSoon.tr(),
              style: const TextStyle(
                color: AppColors.textSecondaryLight,
                fontSize: 14.5,
                fontWeight: FontWeight.w500,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: AppRadius.circularFull,
                border: Border.all(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.hourglass_top_rounded,
                    color: Color(0xFFB45309),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    LocaleKeys.defaultersEndpointPending.tr(),
                    style: const TextStyle(
                      color: Color(0xFFB45309),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String message) {
    return CustomErrorWidget(
      message: message,
      onRetry: () => context
          .read<OwnerDefaultersCubit>()
          .loadDefaultersReport(forceRefresh: true),
    );
  }
}

class _DefaultersSkeleton extends StatelessWidget {
  const _DefaultersSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppShimmer(
          child: Container(
            height: 170,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: AppRadius.circularXxl,
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    AppShimmer.circle(size: 22),
                    const SizedBox(width: 8),
                    AppShimmer.box(width: 150, height: 16),
                  ],
                ),
                AppShimmer.box(width: 110, height: 36),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppShimmer.box(width: 90, height: 14),
                    AppShimmer.box(width: 90, height: 14),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        AppShimmer(
          child: Container(
            height: 140,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: AppRadius.circularXxl,
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    AppShimmer.circle(size: 40),
                    const SizedBox(width: 14),
                    Expanded(child: AppShimmer.box(height: 16)),
                  ],
                ),
                const Divider(color: AppColors.borderLight),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppShimmer.box(width: 80, height: 14),
                    AppShimmer.box(width: 100, height: 18),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
