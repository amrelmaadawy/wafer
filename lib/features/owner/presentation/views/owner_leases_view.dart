import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/color_utils.dart';

class OwnerLeasesView extends StatelessWidget {
  const OwnerLeasesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'العقود والتأجير',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimaryLight,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                'إدارة وتتبع عقود الإيجار النشطة والموشكة على الانتهاء',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondaryLight,
                    ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: AppRadius.circularLg,
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.description_outlined,
                      size: 48,
                      color: context.primaryColor.withValues(alpha: 0.2),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'سجل عقود الإيجار',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimaryLight,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'سيتم عرض العقود وخيارات التجديد والإلغاء وتنزيل PDF هنا',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondaryLight,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
