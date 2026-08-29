import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../domain/entities/property_list_item_entity.dart';
import '../cubit/list/properties_list_cubit.dart';
import '../cubit/list/properties_list_state.dart';
import '../../../../../core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../shell/presentation/widgets/owner_top_app_bar.dart';
import '../widgets/list/properties_empty_widget.dart';
import '../widgets/list/properties_filter_bar.dart';
import '../widgets/list/properties_loaded_list.dart';
import '../widgets/list/properties_stats_header_widget.dart';
import '../widgets/list/property_skeleton_card.dart';

class OwnerPropertiesView extends StatefulWidget {
  const OwnerPropertiesView({super.key});

  @override
  State<OwnerPropertiesView> createState() => _OwnerPropertiesViewState();
}

class _OwnerPropertiesViewState extends State<OwnerPropertiesView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PropertiesListCubit>().getProperties();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<PropertiesListCubit>().loadNextPage();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onAddNewProperty() async {
    final cubit = context.read<PropertiesListCubit>();
    await context.push(Routes.ownerPropertyCreate);
    if (mounted) {
      cubit.getProperties(forceRefresh: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appBackgroundColor,
      appBar: OwnerTopAppBar(
        title: LocaleKeys.propertiesTitle.tr(),
          forceDrawerButton: true,
        subtitle: LocaleKeys.propertiesSubtitle.tr(),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null, 
        onPressed: _onAddNewProperty,
        backgroundColor: context.primaryColor,
        elevation: 4,
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
      body: SafeArea(
        child: Column(
          children: [
            BlocBuilder<PropertiesListCubit, PropertiesListState>(
              builder: (context, state) {
                if (state is PropertiesListLoaded && state.stats != null) {
                  return PropertiesStatsHeaderWidget(stats: state.stats!);
                }
                return const SizedBox.shrink();
              },
            ),
            const PropertiesFilterBar(),
            Expanded(child: _buildBody(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<PropertiesListCubit, PropertiesListState>(
      builder: (context, state) {
        if (state is PropertiesListLoading || state is PropertiesListInitial) {
          return const PropertySkeletonCard();
        } else if (state is PropertiesListError) {
          return CustomErrorWidget(
            message: state.message,
            onRetry: () => context.read<PropertiesListCubit>().getProperties(
              forceRefresh: true,
            ),
          );
        } else if (state is PropertiesListEmpty) {
          return PropertiesEmptyWidget(
            reason: state.reason,
            onAddProperty: _onAddNewProperty,
            onResetSearch: () =>
                context.read<PropertiesListCubit>().searchProperties(''),
            onResetFilter: () =>
                context.read<PropertiesListCubit>().changeStatusFilter('all'),
          );
        } else if (state is PropertiesListLoaded) {
          return PropertiesLoadedList(
            state: state,
            controller: _scrollController,
            onRefresh: () => context.read<PropertiesListCubit>().getProperties(
              forceRefresh: true,
            ),
            onPropertyTap: _openProperty,
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Future<void> _openProperty(PropertyListItemEntity property) async {
    final cubit = context.read<PropertiesListCubit>();
    await context.push(Routes.ownerPropertyDetailsPath(property.id.toString()));
    if (mounted) cubit.getProperties(forceRefresh: true);
  }
}
