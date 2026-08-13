import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../domain/entities/properties_query_filter_entity.dart';
import '../../cubit/list/properties_list_cubit.dart';

class PropertyFilterSheet extends StatefulWidget {
  final PropertiesQueryFilterEntity currentFilter;

  const PropertyFilterSheet({super.key, required this.currentFilter});

  static Future<void> show(BuildContext context, PropertiesQueryFilterEntity currentFilter) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => BlocProvider.value(
        value: context.read<PropertiesListCubit>(),
        child: PropertyFilterSheet(currentFilter: currentFilter),
      ),
    );
  }

  @override
  State<PropertyFilterSheet> createState() => _PropertyFilterSheetState();
}

class _PropertyFilterSheetState extends State<PropertyFilterSheet> {
  late PropertiesQueryFilterEntity _filter;

  @override
  void initState() {
    super.initState();
    _filter = widget.currentFilter;
  }

  void _apply() {
    context.read<PropertiesListCubit>().applyAdvancedFilter(_filter);
    context.pop();
  }

  void _reset() {
    setState(() {
      _filter = const PropertiesQueryFilterEntity();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context),
          const Divider(height: 1, color: AppColors.dividerSubtleLight),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatusSection(),
                  const SizedBox(height: 24),
                  _buildPropertyTypeSection(),
                  const SizedBox(height: 24),
                  _buildUsageTypeSection(),
                  const SizedBox(height: 24),
                  _buildSortBySection(),
                  const SizedBox(height: 24),
                  _buildSortOrderSection(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            LocaleKeys.propertiesFilterTitle.tr(),
            style: AppTextStyles.h3,
          ),
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.close_rounded, color: AppColors.textSecondaryLight),
            tooltip: LocaleKeys.cancel.tr(),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: AppColors.dividerSubtleLight)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _reset,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: AppColors.borderLight),
                shape: RoundedRectangleBorder(borderRadius: AppRadius.circularLg),
              ),
              child: Text(
                LocaleKeys.propertiesResetFilter.tr(),
                style: const TextStyle(color: AppColors.textPrimaryLight),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _apply,
              style: ElevatedButton.styleFrom(
                backgroundColor: context.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: AppRadius.circularLg),
                elevation: 0,
              ),
              child: Text(
                LocaleKeys.commonApply.tr(),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSection() {
    return _FilterGroup(
      title: LocaleKeys.propertiesStatusTitle.tr(),
      children: [
        _FilterChipWidget(
          label: LocaleKeys.commonAll.tr(),
          isSelected: _filter.status == null || _filter.status == 'all',
          onSelected: (selected) {
            if (selected) setState(() => _filter = _filter.copyWith(status: () => null));
          },
        ),
        _FilterChipWidget(
          label: LocaleKeys.propertiesStatusPublished.tr(),
          isSelected: _filter.status == 'published',
          onSelected: (selected) {
            if (selected) setState(() => _filter = _filter.copyWith(status: () => 'published'));
          },
        ),
        _FilterChipWidget(
          label: LocaleKeys.propertiesStatusDraft.tr(),
          isSelected: _filter.status == 'draft',
          onSelected: (selected) {
            if (selected) setState(() => _filter = _filter.copyWith(status: () => 'draft'));
          },
        ),
      ],
    );
  }

  Widget _buildPropertyTypeSection() {
    return _FilterGroup(
      title: LocaleKeys.propertiesTypeTitle.tr(),
      children: [
        _FilterChipWidget(
          label: LocaleKeys.commonAll.tr(),
          isSelected: _filter.propertyType == null || _filter.propertyType == 'all',
          onSelected: (selected) {
            if (selected) setState(() => _filter = _filter.copyWith(propertyType: () => null));
          },
        ),
        _FilterChipWidget(
          label: LocaleKeys.propertiesTypeBuilding.tr(),
          isSelected: _filter.propertyType == 'building',
          onSelected: (selected) {
            if (selected) setState(() => _filter = _filter.copyWith(propertyType: () => 'building'));
          },
        ),
        _FilterChipWidget(
          label: LocaleKeys.propertiesTypeVilla.tr(),
          isSelected: _filter.propertyType == 'villa',
          onSelected: (selected) {
            if (selected) setState(() => _filter = _filter.copyWith(propertyType: () => 'villa'));
          },
        ),
        _FilterChipWidget(
          label: LocaleKeys.propertiesTypeLand.tr(),
          isSelected: _filter.propertyType == 'land',
          onSelected: (selected) {
            if (selected) setState(() => _filter = _filter.copyWith(propertyType: () => 'land'));
          },
        ),
      ],
    );
  }

  Widget _buildUsageTypeSection() {
    return _FilterGroup(
      title: LocaleKeys.propertiesUsageTitle.tr(),
      children: [
        _FilterChipWidget(
          label: LocaleKeys.commonAll.tr(),
          isSelected: _filter.usageType == null || _filter.usageType == 'all',
          onSelected: (selected) {
            if (selected) setState(() => _filter = _filter.copyWith(usageType: () => null));
          },
        ),
        _FilterChipWidget(
          label: LocaleKeys.propertiesUsageResidential.tr(),
          isSelected: _filter.usageType == 'residential',
          onSelected: (selected) {
            if (selected) setState(() => _filter = _filter.copyWith(usageType: () => 'residential'));
          },
        ),
        _FilterChipWidget(
          label: LocaleKeys.propertiesUsageCommercial.tr(),
          isSelected: _filter.usageType == 'commercial',
          onSelected: (selected) {
            if (selected) setState(() => _filter = _filter.copyWith(usageType: () => 'commercial'));
          },
        ),
      ],
    );
  }

  Widget _buildSortBySection() {
    return _FilterGroup(
      title: LocaleKeys.propertiesSortTitle.tr(),
      children: [
        _FilterChipWidget(
          label: LocaleKeys.propertiesSortName.tr(),
          isSelected: _filter.sortBy == 'name',
          onSelected: (selected) {
            if (selected) setState(() => _filter = _filter.copyWith(sortBy: () => 'name'));
          },
        ),
        _FilterChipWidget(
          label: LocaleKeys.propertiesSortArea.tr(),
          isSelected: _filter.sortBy == 'area',
          onSelected: (selected) {
            if (selected) setState(() => _filter = _filter.copyWith(sortBy: () => 'area'));
          },
        ),
        _FilterChipWidget(
          label: LocaleKeys.propertiesSortOccupancy.tr(),
          isSelected: _filter.sortBy == 'occupancy',
          onSelected: (selected) {
            if (selected) setState(() => _filter = _filter.copyWith(sortBy: () => 'occupancy'));
          },
        ),
        _FilterChipWidget(
          label: LocaleKeys.propertiesSortUnits.tr(),
          isSelected: _filter.sortBy == 'units',
          onSelected: (selected) {
            if (selected) setState(() => _filter = _filter.copyWith(sortBy: () => 'units'));
          },
        ),
      ],
    );
  }

  Widget _buildSortOrderSection() {
    if (_filter.sortBy == null) return const SizedBox.shrink();
    
    return _FilterGroup(
      title: LocaleKeys.propertiesSortOrderTitle.tr(),
      children: [
        _FilterChipWidget(
          label: LocaleKeys.propertiesSortAscending.tr(),
          isSelected: _filter.sortAscending,
          onSelected: (selected) {
            if (selected) setState(() => _filter = _filter.copyWith(sortAscending: true));
          },
        ),
        _FilterChipWidget(
          label: LocaleKeys.propertiesSortDescending.tr(),
          isSelected: !_filter.sortAscending,
          onSelected: (selected) {
            if (selected) setState(() => _filter = _filter.copyWith(sortAscending: false));
          },
        ),
      ],
    );
  }
}

class _FilterGroup extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _FilterGroup({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.labelLarge.copyWith(color: AppColors.textPrimaryLight),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 10,
          children: children,
        ),
      ],
    );
  }
}

class _FilterChipWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const _FilterChipWidget({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      labelStyle: TextStyle(
        color: isSelected ? context.primaryColor : AppColors.textSecondaryLight,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
      ),
      backgroundColor: Colors.white,
      selectedColor: context.primaryColor.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.circularLg,
        side: BorderSide(
          color: isSelected ? context.primaryColor : AppColors.borderLight,
        ),
      ),
      showCheckmark: false,
    );
  }
}
