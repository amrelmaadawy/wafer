import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/utils/widgets/custom_text_field.dart';
import '../../../domain/entities/legal_case_form_data_entity.dart';
import '../../../domain/entities/legal_case_complex_sub_entities.dart';
import 'legal_case_wizard_card.dart';
import 'labeled_dropdown_widget.dart';

class LegalCaseGeneralInfoCard extends StatelessWidget {
  final LegalCaseOptionsEntity? options;
  final TextEditingController caseNumberController;
  final int? selectedBranchId;
  final String? selectedCaseType;
  final String? selectedStatus;
  final ValueChanged<int?> onBranchSelected;
  final ValueChanged<String?> onCaseTypeSelected;
  final ValueChanged<String?> onStatusSelected;

  const LegalCaseGeneralInfoCard({
    super.key,
    this.options,
    required this.caseNumberController,
    this.selectedBranchId,
    this.selectedCaseType,
    this.selectedStatus,
    required this.onBranchSelected,
    required this.onCaseTypeSelected,
    required this.onStatusSelected,
  });

  @override
  Widget build(BuildContext context) {
    final branches = options?.branches ?? [];
    final caseTypes = options?.caseTypes ?? [];
    final statuses = options?.statuses ?? [];

    return LegalCaseWizardCard(
      title: LocaleKeys.general_info.tr(),
      children: [
        CustomTextField(
          controller: caseNumberController,
          label: LocaleKeys.case_number.tr(),
          hintText: LocaleKeys.enter_case_number.tr(),
          validator: (v) =>
              v == null || v.isEmpty ? LocaleKeys.required_field.tr() : null,
        ),
        const SizedBox(height: AppSpacing.md),
        LabeledDropdownWidget<LegalCaseBranchEntity>(
          label: LocaleKeys.branch.tr(),
          hint: LocaleKeys.select_branch.tr(),
          value: branches.where((b) => b.id == selectedBranchId).firstOrNull,
          items: branches
              .where(
                (b) =>
                    b.id != null && b.name != null && b.name!.trim().isNotEmpty,
              )
              .toList(),
          itemLabelBuilder: (b) => b.name ?? '',
          onSelected: (b) => onBranchSelected(b.id),
        ),
        const SizedBox(height: AppSpacing.md),
        LabeledDropdownWidget<LegalCaseOptionEntity>(
          label: LocaleKeys.case_type.tr(),
          hint: LocaleKeys.select_case_type.tr(),
          value: caseTypes
              .where((t) => t.value == selectedCaseType)
              .firstOrNull,
          items: caseTypes
              .where(
                (t) =>
                    t.value != null &&
                    t.label != null &&
                    t.label!.trim().isNotEmpty,
              )
              .toList(),
          itemLabelBuilder: (t) => t.label ?? '',
          onSelected: (t) => onCaseTypeSelected(t.value),
        ),
        const SizedBox(height: AppSpacing.md),
        LabeledDropdownWidget<LegalCaseOptionEntity>(
          label: LocaleKeys.status.tr(),
          hint: LocaleKeys.select_status.tr(),
          value: statuses.where((s) => s.value == selectedStatus).firstOrNull,
          items: statuses
              .where(
                (s) =>
                    s.value != null &&
                    s.label != null &&
                    s.label!.trim().isNotEmpty,
              )
              .toList(),
          itemLabelBuilder: (s) => s.label ?? '',
          onSelected: (s) {
            if (s.value != null) {
              onStatusSelected(s.value!);
            }
          },
        ),
      ],
    );
  }
}
