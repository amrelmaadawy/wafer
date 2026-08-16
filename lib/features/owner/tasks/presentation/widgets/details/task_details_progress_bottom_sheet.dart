import 'package:wafer/core/theme/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/theme_context.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/utils/widgets/custom_button.dart';
import '../../cubits/update_progress/update_task_progress_cubit.dart';
import '../../cubits/update_progress/update_task_progress_state.dart';

class TaskDetailsProgressBottomSheet extends StatefulWidget {
  final UpdateTaskProgressCubit updateProgressCubit;
  final int taskId;
  final int initialProgress;

  const TaskDetailsProgressBottomSheet({
    super.key,
    required this.updateProgressCubit,
    required this.taskId,
    required this.initialProgress,
  });

  @override
  State<TaskDetailsProgressBottomSheet> createState() => _TaskDetailsProgressBottomSheetState();
}

class _TaskDetailsProgressBottomSheetState extends State<TaskDetailsProgressBottomSheet> {
  late double currentProgress;

  @override
  void initState() {
    super.initState();
    currentProgress = widget.initialProgress.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.updateProgressCubit,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
          top: AppSpacing.xl,
          left: AppSpacing.md,
          right: AppSpacing.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.appOnSurfaceColor.withValues(alpha: 0.2),
                borderRadius: AppRadius.circularSm,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              LocaleKeys.update_progress.tr(),
              style: AppTextStyles.h3.copyWith(
                fontWeight: FontWeight.bold,
                color: context.appOnSurfaceColor,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text(
              '${currentProgress.toInt()}%',
              style: AppTextStyles.h1.copyWith(
                fontWeight: FontWeight.w900,
                color: context.primaryColor,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: context.primaryColor,
                inactiveTrackColor: context.primaryColor.withValues(alpha: 0.15),
                thumbColor: context.primaryColor,
                overlayColor: context.primaryColor.withValues(alpha: 0.2),
                trackHeight: 8.0,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 24.0),
              ),
              child: Slider(
                value: currentProgress,
                min: 0,
                max: 100,
                divisions: 100,
                onChanged: (value) {
                  setState(() {
                    currentProgress = value;
                  });
                },
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            BlocBuilder<UpdateTaskProgressCubit, UpdateTaskProgressState>(
              builder: (context, state) {
                return CustomButton(
                  text: LocaleKeys.common_save.tr(),
                  isLoading: state is UpdateTaskProgressLoading,
                  onPressed: () {
                    if (currentProgress.toInt() == widget.initialProgress) {
                      Navigator.pop(context);
                      return;
                    }
                    widget.updateProgressCubit.updateProgress(widget.taskId, currentProgress.toInt()).then((_) {
                      if (widget.updateProgressCubit.state is UpdateTaskProgressSuccess) {
                        if (context.mounted) Navigator.pop(context);
                      }
                    });
                  },
                  width: double.infinity,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}



