import 'package:flutter/material.dart';
import '../../../../../core/presentation/widgets/app_responsive_content.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../../../../core/utils/widgets/app_shimmer.dart';

class OwnerDashboardSkeletonWidget extends StatelessWidget {
  const OwnerDashboardSkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: AppSpacing.md, bottom: 120),
      physics: const NeverScrollableScrollPhysics(),
      child: AppResponsiveContent(
        child: Column(
          children: [
            _card(context, 220),
            const SizedBox(height: AppSpacing.md),
            _card(context, 150),
            const SizedBox(height: AppSpacing.md),
            _actions(context),
            const SizedBox(height: AppSpacing.md),
            _alerts,
            const SizedBox(height: AppSpacing.md),
            _card(context, 130),
          ],
        ),
      ),
    );
  }

  Widget _card(BuildContext context, double height) {
    return AppShimmer(
      child: Container(
        height: height,
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: context.appSurfaceColor,
          borderRadius: AppRadius.circularXxl,
          border: Border.all(color: context.appBorderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            AppShimmer.box(width: 150, height: 16),
            AppShimmer.box(width: 220, height: 30),
            AppShimmer.box(height: 42),
          ],
        ),
      ),
    );
  }

  Widget _actions(BuildContext context) {
    return AppShimmer(
      child: Row(
        children: [
          for (var index = 0; index < 3; index++) ...[
            if (index > 0) const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: AppShimmer.box(
                height: 80,
                borderRadius: AppRadius.circularLg,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget get _alerts => AppShimmer(
    child: Row(
      children: [
        Expanded(
          child: AppShimmer.box(
            height: 110,
            borderRadius: AppRadius.circularXl,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: AppShimmer.box(
            height: 110,
            borderRadius: AppRadius.circularXl,
          ),
        ),
      ],
    ),
  );
}
