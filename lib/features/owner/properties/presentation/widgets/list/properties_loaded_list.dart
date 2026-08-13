import 'package:flutter/material.dart';
import '../../../../../../core/presentation/widgets/animations/staggered_list_item.dart';
import '../../../../../../core/theme/app_breakpoints.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../domain/entities/property_display_mode.dart';
import '../../../domain/entities/property_list_item_entity.dart';
import '../../cubit/list/properties_list_state.dart';
import 'property_card.dart';
import 'property_compact_card.dart';
import 'property_skeleton_card.dart';

class PropertiesLoadedList extends StatelessWidget {
  final PropertiesListLoaded state;
  final PropertyDisplayMode mode;
  final ScrollController controller;
  final RefreshCallback onRefresh;
  final ValueChanged<PropertyListItemEntity> onPropertyTap;

  const PropertiesLoadedList({
    super.key,
    required this.state,
    required this.mode,
    required this.controller,
    required this.onRefresh,
    required this.onPropertyTap,
  });

  @override
  Widget build(BuildContext context) {
    final itemCount = state.properties.length + (state.isFetchingMore ? 1 : 0);
    final useGrid =
        mode == PropertyDisplayMode.comfortable && context.isExpanded;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: useGrid
          ? GridView.builder(
              controller: controller,
              padding: _padding(context),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppSpacing.md,
                mainAxisSpacing: AppSpacing.xs,
                mainAxisExtent: 184,
              ),
              itemCount: itemCount,
              itemBuilder: (context, index) => _item(context, index),
            )
          : ListView.builder(
              controller: controller,
              padding: _padding(context),
              itemCount: itemCount,
              itemBuilder: (context, index) => _item(context, index),
            ),
    );
  }

  EdgeInsets _padding(BuildContext context) => EdgeInsets.fromLTRB(
    context.pagePadding,
    0,
    context.pagePadding,
    AppSpacing.xxxl,
  );

  Widget _item(BuildContext context, int index) {
    if (index == state.properties.length) {
      return const PropertySkeletonItem();
    }
    final property = state.properties[index];
    return StaggeredListItem(
      index: index,
      child: mode == PropertyDisplayMode.compact
          ? PropertyCompactCard(
              property: property,
              onTap: () => onPropertyTap(property),
            )
          : PropertyCard(
              property: property,
              onTap: () => onPropertyTap(property),
            ),
    );
  }
}
