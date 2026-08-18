import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/presentation/widgets/list/paginated_list_view.dart';
import '../../../../../../core/theme/app_breakpoints.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../domain/entities/property_list_item_entity.dart';
import '../../cubit/list/properties_list_cubit.dart';
import '../../cubit/list/properties_list_state.dart';
import 'property_card.dart';

class PropertiesLoadedList extends StatelessWidget {
  final PropertiesListLoaded state;
  final ScrollController controller;
  final RefreshCallback onRefresh;
  final ValueChanged<PropertyListItemEntity> onPropertyTap;

  const PropertiesLoadedList({
    super.key,
    required this.state,
    required this.controller,
    required this.onRefresh,
    required this.onPropertyTap,
  });

  @override
  Widget build(BuildContext context) {
    final useGrid = context.isExpanded;
    final cubit = context.read<PropertiesListCubit>();

    return PaginatedListView<PropertyListItemEntity>(
      controller: controller,
      items: state.properties,
      isFetchingMore: state.isFetchingMore,
      hasReachedMax: !state.meta.hasMore,
      onRefresh: onRefresh,
      onLoadMore: cubit.loadNextPage,
      isGrid: useGrid,
      useStaggeredAnimation: true,
      padding: EdgeInsets.fromLTRB(
        context.pagePadding,
        0,
        context.pagePadding,
        AppSpacing.xxxl,
      ),
      gridDelegate: useGrid
          ? const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.xs,
              mainAxisExtent: 184,
            )
          : null,
      separatorBuilder: useGrid ? null : (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index, property) {
        return PropertyCard(
          property: property,
          onTap: () => onPropertyTap(property),
        );
      },
    );
  }
}
