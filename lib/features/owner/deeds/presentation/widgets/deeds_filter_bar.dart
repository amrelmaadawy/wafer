import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../cubit/list/deeds_list_cubit.dart';
import '../cubit/list/deeds_list_state.dart';

class DeedsFilterBar extends StatefulWidget {
  const DeedsFilterBar({super.key});

  @override
  State<DeedsFilterBar> createState() => _DeedsFilterBarState();
}

class _DeedsFilterBarState extends State<DeedsFilterBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeedsListCubit, DeedsListState>(
      builder: (context, state) {
        final cubit = context.read<DeedsListCubit>();
        final currentBranchId = cubit.currentFilter.branchId;

        // In a real scenario, branches would be fetched from an API or a generic service.
        // For now, we mock some branch IDs for demonstration or assume specific ones.
        // E.g., null = All, 1 = Branch 1, 2 = Branch 2
        final branches = [
          {'id': -1, 'name': LocaleKeys.deeds_filter_all_branches.tr()},
          {'id': 1, 'name': 'فرع الادارة'},
          {'id': 2, 'name': 'الإدارة'},
        ];

        final resolvedBranchId = currentBranchId ?? -1;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => cubit.searchDeeds(val),
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    hintText: LocaleKeys.deeds_search_hint.tr(),
                    prefixIcon: const Icon(Icons.search_rounded, size: 20, color: AppColors.textSecondaryLight),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close_rounded, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              cubit.searchDeeds('');
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
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: Container(
                  height: 44, // Match TextField approximate height
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: AppRadius.circularXl,
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      focusColor: Colors.transparent,
                    ),
                    child: PopupMenuButton<int>(
                      initialValue: resolvedBranchId,
                      color: Colors.white,
                      elevation: 4,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      position: PopupMenuPosition.under,
                      offset: const Offset(0, 4),
                      onSelected: (int newValue) {
                        cubit.filterByBranch(newValue == -1 ? null : newValue);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                branches.firstWhere(
                                  (b) => b['id'] == resolvedBranchId,
                                  orElse: () => branches.first,
                                )['name'] as String,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimaryLight,
                                ),
                              ),
                            ),
                            const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondaryLight, size: 18),
                          ],
                        ),
                      ),
                      itemBuilder: (context) {
                        return branches.map((branch) {
                          final isSelected = resolvedBranchId == branch['id'];
                          return PopupMenuItem<int>(
                            value: branch['id'] as int,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: isSelected ? context.primaryColor.withValues(alpha: 0.08) : Colors.transparent,
                                borderRadius: AppRadius.circularMd,
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      branch['name'] as String,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: isSelected ? context.primaryColor : AppColors.textPrimaryLight,
                                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  if (isSelected)
                                    Icon(Icons.check_circle_rounded, color: context.primaryColor, size: 16),
                                ],
                              ),
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
