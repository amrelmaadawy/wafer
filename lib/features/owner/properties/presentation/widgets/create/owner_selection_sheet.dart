import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/color_utils.dart';

class OwnerSelectionSheet extends StatefulWidget {
  final List<dynamic> availableOwners;
  final Set<int> addedOwnerIds;
  final Function(dynamic) onSelect;

  const OwnerSelectionSheet({
    super.key,
    required this.availableOwners,
    required this.addedOwnerIds,
    required this.onSelect,
  });

  @override
  State<OwnerSelectionSheet> createState() => _OwnerSelectionSheetState();
}

class _OwnerSelectionSheetState extends State<OwnerSelectionSheet> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.availableOwners.where((o) {
      final matchesSearch = o.name.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      return matchesSearch && !widget.addedOwnerIds.contains(o.id);
    }).toList();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFCBD5E1),
                borderRadius: AppRadius.circularFull,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    LocaleKeys.propertyOwnersSelectOwner.tr(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimaryLight,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: TextField(
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: InputDecoration(
                  hintText: LocaleKeys.propertyCreateOwnerSearchHint.tr(),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.textSecondaryLight,
                  ),
                  filled: true,
                  fillColor: AppColors.surfaceLight,
                  border: OutlineInputBorder(
                    borderRadius: AppRadius.circularMd,
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),
            const Divider(height: 1, color: Color(0xFFE2E8F0)),
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text(
                        LocaleKeys.propertyOwnersNoAvailable.tr(),
                        style: const TextStyle(
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(20),
                      itemCount: filtered.length,
                      separatorBuilder: (_, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final owner = filtered[index];
                        return InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            widget.onSelect(owner);
                          },
                          borderRadius: AppRadius.circularLg,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceLight,
                              border: Border.all(
                                color: const Color(0xFFE2E8F0),
                              ),
                              borderRadius: AppRadius.circularLg,
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: context.primarySubtle,
                                  child: Text(
                                    owner.name.isNotEmpty ? owner.name[0] : '?',
                                    style: TextStyle(
                                      color: context.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    owner.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.add_circle_outline,
                                  color: context.primaryColor,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
