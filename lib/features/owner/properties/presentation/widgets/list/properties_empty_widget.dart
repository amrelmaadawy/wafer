import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/presentation/widgets/custom_empty_widget.dart';
import '../../cubit/list/properties_list_state.dart';

class PropertiesEmptyWidget extends StatelessWidget {
  final VoidCallback onAddProperty;
  final VoidCallback onResetSearch;
  final VoidCallback onResetFilter;
  final EmptyReason reason;

  const PropertiesEmptyWidget({
    super.key, 
    required this.onAddProperty,
    required this.onResetSearch,
    required this.onResetFilter,
    required this.reason,
  });

  @override
  Widget build(BuildContext context) {
    switch (reason) {
      case EmptyReason.noData:
        return CustomEmptyWidget(
          icon: Icons.home_work_outlined,
          title: LocaleKeys.propertiesEmptyTitle.tr(),
          subtitle: LocaleKeys.propertiesEmptySubtitle.tr(),
          actionLabel: LocaleKeys.propertiesEmptyAction.tr(),
          onAction: onAddProperty,
        );
      case EmptyReason.noSearchResults:
        return CustomEmptyWidget(
          icon: Icons.search_off,
          title: LocaleKeys.propertiesEmptySearch.tr(),
          actionLabel: LocaleKeys.propertiesResetSearch.tr(),
          onAction: onResetSearch,
        );
      case EmptyReason.noFilterResults:
        return CustomEmptyWidget(
          icon: Icons.filter_list_off,
          title: LocaleKeys.propertiesEmptyFilter.tr(),
          actionLabel: LocaleKeys.propertiesResetFilter.tr(),
          onAction: onResetFilter,
        );
    }
  }
}
