import 'package:wafer/core/theme/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/presentation/widgets/app_surface_card.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/theme_context.dart';

class TaskProgressSection extends StatelessWidget {
  final double progress;
  final ValueChanged<double> onChanged;

  const TaskProgressSection({
    super.key,
    required this.progress,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.progress.tr(),
                style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w700, color: context.appOnSurfaceColor),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: context.primaryColor.withValues(alpha: 0.1),
                  borderRadius: AppRadius.circularLg,
                ),
                child: Text(
                  '${progress.toInt()}%',
                  style: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.w800, color: context.primaryColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 8,
              activeTrackColor: context.primaryColor,
              inactiveTrackColor: context.primaryColor.withValues(alpha: 0.1),
              tickMarkShape: SliderTickMarkShape.noTickMark,
              overlayColor: context.primaryColor.withValues(alpha: 0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14, elevation: 4),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
              trackShape: const RoundedRectSliderTrackShape(),
            ),
            child: Slider(
              value: progress,
              min: 0,
              max: 100,
              divisions: 20,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}


