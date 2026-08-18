import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/di/service_locator.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/presentation/widgets/list/unified_bottom_sheet.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../../../../core/theme/theme_context.dart';
import '../../domain/entities/finance_query_filter_entity.dart';
import '../cubit/form_data/finance_form_data_cubit.dart';
import '../cubit/form_data/finance_form_data_state.dart';
import 'finance_date_picker_tile.dart';
import 'finance_filter_dropdown_section.dart';

class FinanceFilterSheet extends StatefulWidget {
  final FinanceQueryFilterEntity initialFilter;
  final ValueChanged<FinanceQueryFilterEntity> onApply;

  const FinanceFilterSheet({
    super.key,
    required this.initialFilter,
    required this.onApply,
  });

  static Future<void> show(
    BuildContext context, {
    required FinanceQueryFilterEntity currentFilter,
    required ValueChanged<FinanceQueryFilterEntity> onApply,
  }) {
    return UnifiedBottomSheet.show(
      context: context,
      builder: (_) => BlocProvider(
        create: (_) => sl<FinanceFormDataCubit>()..fetchFormData(),
        child: FinanceFilterSheet(
          initialFilter: currentFilter,
          onApply: onApply,
        ),
      ),
    );
  }

  @override
  State<FinanceFilterSheet> createState() => _FinanceFilterSheetState();
}

class _FinanceFilterSheetState extends State<FinanceFilterSheet> {
  String? _selectedAccount;
  String? _selectedProperty;
  late String? _fromDate;
  late String? _toDate;

  @override
  void initState() {
    super.initState();
    _selectedAccount = widget.initialFilter.accountName;
    _selectedProperty = widget.initialFilter.propertyName;
    _fromDate = widget.initialFilter.fromDate;
    _toDate = widget.initialFilter.toDate;
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.primaryColor;

    return UnifiedBottomSheet(
      titleLocaleKey: LocaleKeys.filterOptionsTitle,
      titleIcon: Icons.tune_rounded,
      onReset: () {
        setState(() {
          _selectedAccount = null;
          _selectedProperty = null;
          _fromDate = null;
          _toDate = null;
        });
        widget.onApply(const FinanceQueryFilterEntity());
      },
      onApply: () {
        widget.onApply(
          widget.initialFilter.copyWith(
            accountName: () => _selectedAccount,
            propertyName: () => _selectedProperty,
            fromDate: () => _fromDate,
            toDate: () => _toDate,
          ),
        );
      },
      child: BlocBuilder<FinanceFormDataCubit, FinanceFormDataState>(
        builder: (context, state) {
          final isLoading = state is FinanceFormDataLoading;
          final isArabic = context.locale.languageCode == 'ar';
          final accounts = state is FinanceFormDataSuccess
              ? state.formData.accounts
                  .map((a) => isArabic ? a.nameAr : (a.nameEn.isNotEmpty ? a.nameEn : a.nameAr))
                  .where((name) => name.isNotEmpty)
                  .toSet()
                  .toList()
              : <String>[];

          final properties = state is FinanceFormDataSuccess
              ? state.formData.properties
                  .map((p) => p.label)
                  .where((lbl) => lbl.isNotEmpty)
                  .toSet()
                  .toList()
              : <String>[];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FinanceFilterDropdownSection(
                title: LocaleKeys.filterAccount.tr(),
                isLoading: isLoading,
                items: accounts,
                selectedValue: _selectedAccount,
                hint: LocaleKeys.filterAccount.tr(),
                onSelected: (value) => setState(() => _selectedAccount = value),
              ),
              const SizedBox(height: AppSpacing.lg),
              FinanceFilterDropdownSection(
                title: LocaleKeys.filterProperty.tr(),
                isLoading: isLoading,
                items: properties,
                selectedValue: _selectedProperty,
                hint: LocaleKeys.filterProperty.tr(),
                onSelected: (value) => setState(() => _selectedProperty = value),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                LocaleKeys.filterDateRange.tr(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: context.appOnSurfaceColor,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: FinanceDatePickerTile(
                      label: _fromDate ?? LocaleKeys.filterFromDate.tr(),
                      hasValue: _fromDate != null,
                      primaryColor: primaryColor,
                      onTap: () => _pickDate(isFrom: true),
                      onClear: () => setState(() => _fromDate = null),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FinanceDatePickerTile(
                      label: _toDate ?? LocaleKeys.filterToDate.tr(),
                      hasValue: _toDate != null,
                      primaryColor: primaryColor,
                      onTap: () => _pickDate(isFrom: false),
                      onClear: () => setState(() => _toDate = null),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() {
        final formatted = DateFormat('yyyy-MM-dd').format(picked);
        if (isFrom) {
          _fromDate = formatted;
        } else {
          _toDate = formatted;
        }
      });
    }
  }
}
