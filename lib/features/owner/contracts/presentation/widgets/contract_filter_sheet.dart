import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/presentation/widgets/list/unified_bottom_sheet.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../../../../core/theme/theme_context.dart';
import '../../domain/entities/contract_status_filter.dart';
import '../../domain/entities/contracts_query_filter_entity.dart';
import 'contract_status_filter_label.dart';

class ContractFilterSheet extends StatefulWidget {
  final ContractsQueryFilterEntity initialFilter;
  final ValueChanged<ContractsQueryFilterEntity> onApply;

  const ContractFilterSheet({
    super.key,
    required this.initialFilter,
    required this.onApply,
  });

  static Future<void> show(
    BuildContext context, {
    required ContractsQueryFilterEntity currentFilter,
    required ValueChanged<ContractsQueryFilterEntity> onApply,
  }) {
    return UnifiedBottomSheet.show(
      context: context,
      builder: (_) => ContractFilterSheet(
        initialFilter: currentFilter,
        onApply: onApply,
      ),
    );
  }

  @override
  State<ContractFilterSheet> createState() => _ContractFilterSheetState();
}

class _ContractFilterSheetState extends State<ContractFilterSheet> {
  late ContractStatusFilter _status;
  late final TextEditingController _propertyController;
  late final TextEditingController _tenantController;

  @override
  void initState() {
    super.initState();
    _status = widget.initialFilter.status;
    _propertyController = TextEditingController(
      text: widget.initialFilter.propertyName,
    );
    _tenantController = TextEditingController(
      text: widget.initialFilter.tenantName,
    );
  }

  @override
  void dispose() {
    _propertyController.dispose();
    _tenantController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.primaryColor;

    return UnifiedBottomSheet(
      titleLocaleKey: LocaleKeys.filterOptionsTitle,
      onReset: () {
        setState(() {
          _status = ContractStatusFilter.all;
          _propertyController.clear();
          _tenantController.clear();
        });
        widget.onApply(const ContractsQueryFilterEntity());
      },
      onApply: () {
        final pName = _propertyController.text.trim();
        final tName = _tenantController.text.trim();
        widget.onApply(
          widget.initialFilter.copyWith(
            status: _status,
            propertyName: () => pName.isNotEmpty ? pName : null,
            tenantName: () => tName.isNotEmpty ? tName : null,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.filterStatus.tr(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: context.appOnSurfaceColor,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ContractStatusFilter.values.map((s) {
              final isSelected = _status == s;
              return ChoiceChip(
                label: Text(s.localizedLabel),
                selected: isSelected,
                selectedColor: primaryColor,
                backgroundColor: context.appSurfaceColor,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : context.appOnSurfaceColor,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 13,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.circularFull,
                  side: BorderSide(
                    color: isSelected ? primaryColor : AppColors.borderLight,
                  ),
                ),
                onSelected: (selected) {
                  if (selected) setState(() => _status = s);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            LocaleKeys.filterProperty.tr(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: context.appOnSurfaceColor,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _InputField(
            controller: _propertyController,
            hintKey: LocaleKeys.filterProperty,
            icon: Icons.business_rounded,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            LocaleKeys.filterTenant.tr(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: context.appOnSurfaceColor,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _InputField(
            controller: _tenantController,
            hintKey: LocaleKeys.filterTenant,
            icon: Icons.person_rounded,
          ),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintKey;
  final IconData icon;

  const _InputField({
    required this.controller,
    required this.hintKey,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.appSurfaceColor,
        borderRadius: AppRadius.circularLg,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(
          fontSize: 14,
          color: context.appOnSurfaceColor,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hintKey.tr(),
          hintStyle: TextStyle(
            fontSize: 13,
            color: context.appSecondaryTextColor,
          ),
          prefixIcon: Icon(
            icon,
            size: 20,
            color: context.appSecondaryTextColor,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}
