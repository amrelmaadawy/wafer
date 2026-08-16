import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/entities/task_status_extension.dart';

class TaskDetailsBottomBar extends StatelessWidget {
  final TaskEntity task;
  final VoidCallback onStartWork;
  final VoidCallback onCompleteTask;

  const TaskDetailsBottomBar({
    super.key,
    required this.task,
    required this.onStartWork,
    required this.onCompleteTask,
  });

  @override
  Widget build(BuildContext context) {
    if (task.canStart) {
      return _buildContainer(
        child: ElevatedButton.icon(
          onPressed: onStartWork,
          style: _buttonStyle(context.primaryColor),
          icon: const Icon(Icons.play_arrow_rounded, color: Colors.white),
          label: Text(
            LocaleKeys.taskStartWork.tr(),
            style: AppTextStyles.h4.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      );
    } else if (task.canComplete) {
      return _buildContainer(
        child: ElevatedButton.icon(
          onPressed: onCompleteTask,
          style: _buttonStyle(AppColors.success),
          icon: const Icon(Icons.check_circle_outline_rounded, color: Colors.white),
          label: Text(
            LocaleKeys.taskCompleteTask.tr(),
            style: AppTextStyles.h4.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(child: child),
    );
  }

  ButtonStyle _buttonStyle(Color bg) {
    return ElevatedButton.styleFrom(
      backgroundColor: bg,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.circularLg),
      elevation: 0,
    );
  }
}
