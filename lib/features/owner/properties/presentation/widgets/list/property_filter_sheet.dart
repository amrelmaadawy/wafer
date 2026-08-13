import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/theme/app_breakpoints.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../domain/entities/properties_query_filter_entity.dart';
import '../../cubit/filter_options/property_filter_options_cubit.dart';
import '../../cubit/filter_options/property_filter_options_state.dart';
import '../../cubit/list/properties_list_cubit.dart';
import 'property_filter_sheet_actions.dart';
import 'property_filter_sheet_body.dart';

class PropertyFilterSheet extends StatefulWidget {
  final PropertiesQueryFilterEntity currentFilter;

  const PropertyFilterSheet({super.key, required this.currentFilter});

  static Future<void> show(
    BuildContext context,
    PropertiesQueryFilterEntity currentFilter,
  ) {
    Widget builder(BuildContext _) => MultiBlocProvider(
      providers: [
        BlocProvider.value(value: context.read<PropertiesListCubit>()),
        BlocProvider.value(value: context.read<PropertyFilterOptionsCubit>()),
      ],
      child: PropertyFilterSheet(currentFilter: currentFilter),
    );

    if (context.isCompact) {
      return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useRootNavigator: true,
        backgroundColor: Colors.transparent,
        builder: builder,
      );
    }
    return showDialog(context: context, builder: builder);
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

  @override
  Widget build(BuildContext context) {
    final optionsState = context.watch<PropertyFilterOptionsCubit>().state;
    final options = optionsState is PropertyFilterOptionsLoaded
        ? optionsState.options
        : null;
    final content = Container(
      constraints: BoxConstraints(
        maxWidth: 640,
        maxHeight: MediaQuery.sizeOf(context).height * 0.88,
      ),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: context.isCompact
            ? AppRadius.topXxl
            : AppRadius.circularXxl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PropertyFilterSheetHeader(onClose: () => context.pop()),
          Flexible(
            child: PropertyFilterSheetBody(
              filter: _filter,
              options: options,
              onChanged: (filter) => setState(() => _filter = filter),
            ),
          ),
          PropertyFilterSheetFooter(
            onReset: () =>
                setState(() => _filter = const PropertiesQueryFilterEntity()),
            onApply: () {
              context.read<PropertiesListCubit>().applyAdvancedFilter(_filter);
              context.pop();
            },
          ),
        ],
      ),
    );
    return context.isCompact ? content : Dialog(child: content);
  }
}
