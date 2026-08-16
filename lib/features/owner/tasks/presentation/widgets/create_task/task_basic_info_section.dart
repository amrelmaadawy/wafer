import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/presentation/widgets/app_surface_card.dart';
import '../../../../../../core/utils/widgets/custom_text_field.dart';

class TaskBasicInfoSection extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController notesController;
  final String? Function(String) getError;

  const TaskBasicInfoSection({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.notesController,
    required this.getError,
  });

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.tasks_basic_info.tr(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: titleController,
            label: LocaleKeys.tasks_title_input.tr(),
            errorText: getError('title'),
            validator: (val) => val == null || val.trim().isEmpty ? LocaleKeys.tasks_validation_required.tr() : null,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: descriptionController,
            label: LocaleKeys.tasks_description_input.tr(),
            errorText: getError('description'),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: notesController,
            label: LocaleKeys.tasks_notes_input.tr(),
            errorText: getError('notes'),
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}

