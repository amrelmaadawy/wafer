import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../domain/entities/form_deed_entity.dart';

class DeedSelectorWidget extends StatefulWidget {
  final List<FormDeedEntity> deeds;
  final int? selectedDeedId;
  final ValueChanged<int> onSelect;
  final VoidCallback onCreateNew;
  final String? errorText;

  const DeedSelectorWidget({
    super.key,
    required this.deeds,
    required this.selectedDeedId,
    required this.onSelect,
    required this.onCreateNew,
    this.errorText,
  });

  @override
  State<DeedSelectorWidget> createState() => _DeedSelectorWidgetState();
}

class _DeedSelectorWidgetState extends State<DeedSelectorWidget> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredDeeds = widget.deeds
        .where((d) =>
            d.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            d.code.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (d.documentNumber ?? '').contains(_searchQuery))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              LocaleKeys.propertyCreateSelectDeed.tr(),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            TextButton.icon(
              onPressed: widget.onCreateNew,
              icon: Icon(Icons.add_rounded, size: 18, color: context.primaryColor),
              label: Text(
                LocaleKeys.propertyCreateNewDeed.tr(),
                style: TextStyle(color: context.primaryColor, fontWeight: FontWeight.w600),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (widget.deeds.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: AppRadius.circularLg,
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                const Icon(Icons.description_outlined, size: 40, color: AppColors.textSecondaryLight),
                const SizedBox(height: 12),
                Text(
                  LocaleKeys.propertyCreateNoDeeds.tr(),
                  style: const TextStyle(color: AppColors.textSecondaryLight, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          )
        else ...[
          // Search Box
          TextFormField(
            decoration: InputDecoration(
              hintText: LocaleKeys.propertyCreateSearchDeeds.tr(),
              prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondaryLight),
              filled: true,
              fillColor: AppColors.backgroundLight,
              border: OutlineInputBorder(
                borderRadius: AppRadius.circularLg,
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.circularLg,
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onChanged: (val) => setState(() => _searchQuery = val),
          ),
          const SizedBox(height: 12),
          // List of Deeds
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: AppRadius.circularLg,
              border: Border.all(
                color: widget.errorText != null ? Colors.red : const Color(0xFFE2E8F0),
              ),
            ),
            child: filteredDeeds.isEmpty
                ? Center(
                    child: Text(
                      'لا توجد نتائج',
                      style: const TextStyle(color: AppColors.textSecondaryLight),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(8),
                    itemCount: filteredDeeds.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final deed = filteredDeeds[index];
                      final isSelected = widget.selectedDeedId == deed.id;
                      
                      return InkWell(
                        onTap: () => widget.onSelect(deed.id),
                        borderRadius: AppRadius.circularMd,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected ? context.primaryColor.withValues(alpha: 0.05) : Colors.white,
                            borderRadius: AppRadius.circularMd,
                            border: Border.all(
                              color: isSelected ? context.primaryColor : const Color(0xFFE2E8F0),
                              width: isSelected ? 1.5 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: isSelected ? context.primaryColor.withValues(alpha: 0.1) : AppColors.backgroundLight,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.description_rounded,
                                  color: isSelected ? context.primaryColor : AppColors.textSecondaryLight,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      deed.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                        color: isSelected ? context.primaryColor : AppColors.textPrimaryLight,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text(
                                          deed.code,
                                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
                                        ),
                                        if (deed.documentNumber != null) ...[
                                          const SizedBox(width: 8),
                                          Container(
                                            width: 4,
                                            height: 4,
                                            decoration: const BoxDecoration(
                                              color: AppColors.textSecondaryLight,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            deed.documentNumber!,
                                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                Icon(Icons.check_circle_rounded, color: context.primaryColor),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          if (widget.errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 8, right: 16, left: 16),
              child: Text(
                widget.errorText!,
                style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
        ],
      ],
    );
  }
}
