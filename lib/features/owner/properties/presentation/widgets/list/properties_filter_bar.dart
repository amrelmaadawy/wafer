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
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 42,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: AppRadius.circularFull,
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final selectedIndex = filters.indexWhere((f) => f['key'] == currentStatus);
                    final safeIndex = selectedIndex < 0 ? 0 : selectedIndex;

                    return Stack(
                      children: [
                        AnimatedAlign(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.fastOutSlowIn,
                          alignment: AlignmentDirectional(
                            -1.0 + (safeIndex * (2.0 / (filters.length - 1))),
                            0.0,
                          ),
                          child: FractionallySizedBox(
                            widthFactor: 1 / filters.length,
                            heightFactor: 1.0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: context.primaryColor,
                                borderRadius: AppRadius.circularFull,
                                boxShadow: [
                                  BoxShadow(
                                    color: context.primaryColor.withValues(alpha: 0.35),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: List.generate(filters.length, (index) {
                            final filter = filters[index];
                            final isSelected = safeIndex == index;

                            return Expanded(
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  cubit.changeStatusFilter(filter['key']!);
                                },
                                child: Center(
                                  child: AnimatedDefaultTextStyle(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeInOut,
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : const Color(0xFF64748B),
                                      fontSize: 13,
                                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                      fontFamily: Theme.of(context).textTheme.bodyMedium?.fontFamily,
                                    ),
                                    child: Text(
                                      filter['label']!,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
