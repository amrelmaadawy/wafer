import 'package:flutter/material.dart';
import '../../../../../../core/presentation/widgets/animations/staggered_list_item.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../domain/entities/unit_entity.dart';
import '../units/unit_card.dart';

class PropertyUnitsTab extends StatelessWidget {
  final List<UnitEntity> units;

  const PropertyUnitsTab({
    super.key,
    required this.units,
  });

  @override
  Widget build(BuildContext context) {
    if (units.isEmpty) {
      return _buildEmptyState(context);
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Show Add Unit Bottom Sheet
        },
        backgroundColor: context.primaryColor,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(
          LocaleKeys.propertyDetailsAddUnit.tr(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 80),
        itemCount: units.length,
        itemBuilder: (context, index) {
          final unit = units[index];
          return UnitCard(
            unit: unit,
            onTap: () {},
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StaggeredListItem(
              index: 0,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: context.primarySubtle.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: context.primaryColor.withValues(alpha: 0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.meeting_room_rounded,
                    size: 56,
                    color: context.primaryColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            StaggeredListItem(
              index: 1,
              child: Text(
                LocaleKeys.propertyDetailsNoUnitsTitle.tr(),
                style: const TextStyle(
                  color: AppColors.textPrimaryLight,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 8),
            StaggeredListItem(
              index: 2,
              child: Text(
                LocaleKeys.propertyDetailsNoUnitsSubtitle.tr(),
                style: const TextStyle(
                  color: AppColors.textSecondaryLight,
                  fontSize: 14,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            StaggeredListItem(
              index: 3,
              child: ElevatedButton.icon(
                onPressed: () {}, // TODO: Show Add Unit Bottom Sheet
                icon: const Icon(Icons.add_rounded, size: 20),
                label: Text(LocaleKeys.propertyDetailsAddUnit.tr(), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  elevation: 4,
                  shadowColor: context.primaryColor.withValues(alpha: 0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.circularFull,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
