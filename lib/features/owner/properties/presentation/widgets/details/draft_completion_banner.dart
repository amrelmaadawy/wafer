import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/di/service_locator.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../domain/entities/property_details_entity.dart';
import '../../cubit/details/property_details_cubit.dart';
import '../../cubit/publish/publish_property_cubit.dart';
import '../publish/publish_property_sheet.dart';

class DraftCompletionBanner extends StatelessWidget {
  final PropertyDetailsEntity property;
  final VoidCallback onContinue;

  const DraftCompletionBanner({
    super.key,
    required this.property,
    required this.onContinue,
  });

  void _showPublishSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider(
        create: (_) => sl<PublishPropertyCubit>(),
        child: PublishPropertySheet(
          propertyId: property.id,
          onSuccess: () {
            // We reload details to ensure all stats/status are freshly fetched
            context.read<PropertyDetailsCubit>().loadDetails(property.id);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!property.isDraft) return const SizedBox.shrink();

    final isReady = property.completionPercentage == 100;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isReady
            ? AppColors.success.withValues(alpha: 0.1)
            : AppColors.warning.withValues(alpha: 0.1),
        borderRadius: AppRadius.circularLg,
        border: Border.all(
          color: isReady
              ? AppColors.success.withValues(alpha: 0.3)
              : AppColors.warning.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isReady
                    ? Icons.check_circle_outline_rounded
                    : Icons.info_outline_rounded,
                color: isReady ? AppColors.success : AppColors.warning,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isReady
                      ? LocaleKeys.propertyDetailsReadyToPublish.tr()
                      : LocaleKeys.propertyDraftIncomplete.tr(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isReady
                        ? AppColors.success
                        : AppColors.textPrimaryLight,
                  ),
                ),
              ),
            ],
          ),
          if (!isReady) ...[
            const SizedBox(height: 12),
            Text(
              LocaleKeys.propertyDraftIncompleteDesc.tr(),
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondaryLight,
                height: 1.5,
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              if (!isReady)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            LocaleKeys.propertyDraftProgress.tr(),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondaryLight,
                            ),
                          ),
                          Text(
                            '${property.completionPercentage}%',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.warning,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: AppRadius.circularFull,
                        child: LinearProgressIndicator(
                          value: property.completionPercentage / 100,
                          minHeight: 6,
                          backgroundColor: AppColors.warning.withValues(
                            alpha: 0.2,
                          ),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.warning,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (!isReady) const SizedBox(width: 16),
              Expanded(
                flex: isReady ? 1 : 0,
                child: ElevatedButton(
                  onPressed: isReady
                      ? () => _showPublishSheet(context)
                      : onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isReady
                        ? AppColors.success
                        : AppColors.warning,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.circularMd,
                    ),
                  ),
                  child: Text(
                    isReady
                        ? LocaleKeys.propertyDetailsPublishNow.tr()
                        : LocaleKeys.propertyDraftContinue.tr(),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
