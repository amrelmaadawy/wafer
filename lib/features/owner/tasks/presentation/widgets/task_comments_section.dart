import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/presentation/widgets/app_surface_card.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../../../../core/utils/widgets/custom_text_field.dart';
import '../../domain/entities/task_entity.dart';
import '../cubits/add_comment/add_task_comment_cubit.dart';
import '../cubits/add_comment/add_task_comment_state.dart';

class TaskCommentsSection extends StatefulWidget {
  final int taskId;
  final List<TaskCommentEntity> comments;

  const TaskCommentsSection({
    super.key,
    required this.taskId,
    required this.comments,
  });

  @override
  State<TaskCommentsSection> createState() => _TaskCommentsSectionState();
}

class _TaskCommentsSectionState extends State<TaskCommentsSection> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(Icons.chat_bubble_outline_rounded, color: Theme.of(context).primaryColor, size: 22),
            const SizedBox(width: AppSpacing.sm),
            Text(
              LocaleKeys.comments.tr(),
              style: AppTextStyles.h3.copyWith(
                fontWeight: FontWeight.w800,
                color: context.appOnSurfaceColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        
        if (widget.comments.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
            child: Center(
              child: Text(
                LocaleKeys.no_comments_yet.tr(),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: context.appSecondaryTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.comments.length,
            separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final comment = widget.comments[index];
              return AppSurfaceCard(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                          child: Icon(Icons.person_rounded, size: 16, color: Theme.of(context).primaryColor),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            comment.user?.name ?? '-',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w700,
                              color: context.appOnSurfaceColor,
                            ),
                          ),
                        ),
                        Text(
                          comment.createdAt ?? '',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: context.appSecondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      comment.content ?? '',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: context.appOnSurfaceColor,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          
        const SizedBox(height: AppSpacing.lg),
        BlocBuilder<AddTaskCommentCubit, AddTaskCommentState>(
          builder: (context, state) {
            final isLoading = state is AddTaskCommentLoading;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: CustomTextField(
                    label: '',
                    hintText: LocaleKeys.write_comment_here.tr(),
                    controller: _commentController,
                    maxLines: 3,
                    readOnly: isLoading,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: AppRadius.circularMd,
                  ),
                  child: isLoading
                      ? const Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                          ),
                        )
                      : IconButton(
                          icon: const Icon(Icons.send_rounded, color: Colors.white),
                          onPressed: () {
                            if (_commentController.text.trim().isEmpty) return;
                            context.read<AddTaskCommentCubit>().addComment(widget.taskId, _commentController.text.trim());
                            _commentController.clear();
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
