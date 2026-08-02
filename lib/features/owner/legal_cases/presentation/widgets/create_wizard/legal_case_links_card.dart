import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../domain/entities/legal_case_form_data_entity.dart';
import '../../../domain/entities/legal_case_complex_sub_entities.dart';
import 'legal_case_wizard_card.dart';
import 'labeled_dropdown_widget.dart';

class LegalCaseLinksCard extends StatelessWidget {
  final LegalCaseOptionsEntity? options;
  final int? selectedPropertyId;
  final int? selectedUnitId;
  final int? selectedContractId;
  final ValueChanged<int?> onPropertySelected;
  final ValueChanged<int?> onUnitSelected;
  final ValueChanged<int?> onContractSelected;

  const LegalCaseLinksCard({
    super.key,
    this.options,
    this.selectedPropertyId,
    this.selectedUnitId,
    this.selectedContractId,
    required this.onPropertySelected,
    required this.onUnitSelected,
    required this.onContractSelected,
  });

  @override
  Widget build(BuildContext context) {
    final properties = options?.properties ?? [];
    final units = options?.units ?? [];
    final contracts = options?.contracts ?? [];

    return LegalCaseWizardCard(
      title: LocaleKeys.links.tr(),
      children: [
        LabeledDropdownWidget<LegalCasePropertyEntity>(
          label: LocaleKeys.property.tr(),
          hint: LocaleKeys.select_property.tr(),
          value: properties
              .where((p) => p.id == selectedPropertyId)
              .firstOrNull,
          items: properties
              .where(
                (p) =>
                    p.id != null && p.name != null && p.name!.trim().isNotEmpty,
              )
              .toList(),
          itemLabelBuilder: (p) => p.name ?? '',
          onSelected: (p) {
            onPropertySelected(p.id);
            // In the original view, changing property reset unit and contract.
            // We expect the parent to handle that logic when onPropertySelected is called.
          },
        ),
        const SizedBox(height: AppSpacing.md),
        LabeledDropdownWidget<LegalCaseUnitEntity>(
          label: LocaleKeys.unit.tr(),
          hint: LocaleKeys.select_unit.tr(),
          value: units.where((u) => u.id == selectedUnitId).firstOrNull,
          items: () {
            var filtered = units
                .where(
                  (u) =>
                      u.id != null &&
                      u.name != null &&
                      u.name!.trim().isNotEmpty,
                )
                .toList();
            if (selectedPropertyId != null) {
              filtered = filtered
                  .where((u) => u.propertyId == selectedPropertyId)
                  .toList();
            }
            return filtered;
          }(),
          itemLabelBuilder: (u) => u.name ?? '',
          onSelected: (u) {
            onUnitSelected(u.id);
            // We expect the parent to handle related logic when onUnitSelected is called.
          },
        ),
        const SizedBox(height: AppSpacing.md),
        LabeledDropdownWidget<LegalCaseContractEntity>(
          label: LocaleKeys.contract.tr(),
          hint: LocaleKeys.select_contract.tr(),
          value: contracts.where((c) => c.id == selectedContractId).firstOrNull,
          items: () {
            var filtered = contracts
                .where(
                  (c) =>
                      c.id != null &&
                      c.contractNumber != null &&
                      c.contractNumber!.trim().isNotEmpty,
                )
                .toList();
            if (selectedUnitId != null) {
              filtered = filtered
                  .where((c) => c.unitId == selectedUnitId)
                  .toList();
            } else if (selectedPropertyId != null) {
              filtered = filtered
                  .where((c) => c.propertyId == selectedPropertyId)
                  .toList();
            }
            return filtered;
          }(),
          itemLabelBuilder: (c) => c.contractNumber ?? '',
          onSelected: (c) => onContractSelected(c.id),
        ),
      ],
    );
  }
}
