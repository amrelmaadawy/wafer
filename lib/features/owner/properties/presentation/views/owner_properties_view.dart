import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/color_utils.dart';
import '../cubit/list/properties_list_cubit.dart';
import '../cubit/list/properties_list_state.dart';
import '../widgets/list/properties_empty_widget.dart';
import '../widgets/list/properties_filter_bar.dart';
import '../widgets/list/properties_stats_header_widget.dart';
import '../widgets/list/property_card.dart';
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
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<PropertiesListCubit>().loadNextPage();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onAddNewProperty() {
    context.push(Routes.ownerPropertyCreate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 110.0),
        child: FloatingActionButton(
          onPressed: _onAddNewProperty,
          backgroundColor: context.primaryColor,
          elevation: 4,
          child: const Icon(
            Icons.add_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            BlocBuilder<PropertiesListCubit, PropertiesListState>(
              builder: (context, state) {
                if (state is PropertiesListLoaded && state.stats != null) {
                  return PropertiesStatsHeaderWidget(stats: state.stats!);
                }
                return const SizedBox.shrink();
              },
            ),
            const PropertiesFilterBar(),
            const SizedBox(height: 8),
            Expanded(child: _buildBody(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.propertiesTitle.tr(),
                style: const TextStyle(
                  color: AppColors.textPrimaryLight,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                LocaleKeys.propertiesSubtitle.tr(),
                style: const TextStyle(
                  color: AppColors.textSecondaryLight,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          BlocBuilder<PropertiesListCubit, PropertiesListState>(
            builder: (context, state) {
              int total = 0;
              if (state is PropertiesListLoaded) total = state.meta.total;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: context.primarySubtle,
                  borderRadius: AppRadius.circularFull,
                ),
                child: Text(
                  '${LocaleKeys.propertiesTotalCount.tr()}: $total',
                  style: TextStyle(
                    color: context.primaryColor,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<PropertiesListCubit, PropertiesListState>(
      builder: (context, state) {
        if (state is PropertiesListLoading || state is PropertiesListInitial) {
          return const PropertySkeletonCard();
        } else if (state is PropertiesListError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.message),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => context.read<PropertiesListCubit>().getProperties(forceRefresh: true),
                  child: Text(LocaleKeys.commonRetry.tr()),
                ),
              ],
            ),
          );
        } else if (state is PropertiesListEmpty) {
          return PropertiesEmptyWidget(onAddProperty: _onAddNewProperty);
        } else if (state is PropertiesListLoaded) {
          return RefreshIndicator(
            color: context.primaryColor,
            onRefresh: () => context.read<PropertiesListCubit>().getProperties(forceRefresh: true),
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
              itemCount: state.properties.length + (state.isFetchingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == state.properties.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  );
                }
                final property = state.properties[index];
                return PropertyCard(
                  property: property,
                  onTap: () {
                    context.push('${Routes.ownerPropertyDetails}?id=${property.id}');
                  },
                );
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
