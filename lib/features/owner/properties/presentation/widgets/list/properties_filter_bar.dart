import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../cubit/list/properties_list_cubit.dart';
import '../../cubit/list/properties_list_state.dart';

class PropertiesFilterBar extends StatefulWidget {
  const PropertiesFilterBar({super.key});

  @override
  State<PropertiesFilterBar> createState() => _PropertiesFilterBarState();
}

class _PropertiesFilterBarState extends State<PropertiesFilterBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PropertiesListCubit, PropertiesListState>(
      builder: (context, state) {
        final cubit = context.read<PropertiesListCubit>();
        final currentStatus = cubit.currentFilter.status ?? 'all';

        final filters = [
          {'key': 'all', 'label': LocaleKeys.propertiesFilterAll.tr()},
          {'key': 'published', 'label': LocaleKeys.propertiesFilterPublished.tr()},
          {'key': 'draft', 'label': LocaleKeys.propertiesFilterDraft.tr()},
        ];

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: TextField(
                controller: _searchController,
                onChanged: (val) => cubit.searchProperties(val),
                style: const TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  hintText: LocaleKeys.propertiesSearchHint.tr(),
                  prefixIcon: const Icon(Icons.search_rounded, size: 20, color: AppColors.textSecondaryLight),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close_rounded, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            cubit.searchProperties('');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: AppColors.surfaceLight,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: AppRadius.circularXl,
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppRadius.circularXl,
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: AppRadius.circularXl,
                    borderSide: BorderSide(color: context.primaryColor),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 38,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: filters.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final filter = filters[index];
                  final isSelected = currentStatus == filter['key'];

                  return ChoiceChip(
                    label: Text(filter['label']!),
                    selected: isSelected,
                    onSelected: (selected) {
                      cubit.changeStatusFilter(selected ? filter['key']! : 'all');
                    },
                    selectedColor: context.primaryColor,
                    backgroundColor: AppColors.surfaceLight,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textSecondaryLight,
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.circularFull,
                      side: BorderSide(
                        color: isSelected ? context.primaryColor : const Color(0xFFE2E8F0),
                      ),
                    ),
                    showCheckmark: false,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
