import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:wafer/core/theme/app_radius.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../domain/entities/property_details_entity.dart';
import '../cubit/details/property_details_cubit.dart';
import '../cubit/details/property_details_state.dart';
import '../cubit/units/units_list_cubit.dart';
import '../widgets/details/property_actions_sheet.dart';

import '../widgets/details/property_details_header.dart';
import '../widgets/details/property_overview_tab.dart';
import '../widgets/details/property_units_tab.dart';

class PropertyDetailsScreen extends StatefulWidget {
  final int propertyId;
  const PropertyDetailsScreen({super.key, required this.propertyId});

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PropertyDetailsCubit>().loadDetails(widget.propertyId);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showActionsSheet(BuildContext context, PropertyDetailsEntity property) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => PropertyActionsSheet(
        property: property,
        onEdit: () => context.push(Routes.ownerPropertyEdit, extra: property),
        onClone: () {},
        onMakeRepresentative: () {},
        onDelete: () => context.pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: BlocBuilder<PropertyDetailsCubit, PropertyDetailsState>(
        builder: (context, state) {
          if (state is PropertyDetailsLoading || state is PropertyDetailsInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PropertyDetailsError) {
            return Scaffold(
              appBar: AppBar(leading: const BackButton()),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => context.read<PropertyDetailsCubit>().loadDetails(widget.propertyId),
                      child: Text(LocaleKeys.commonRetry.tr()),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is PropertyDetailsLoaded) {
            final property = state.property;
            return Column(
              children: [
                PropertyDetailsHeader(
                  property: property,
                  onBackPressed: () => context.pop(),
                  onMorePressed: () => _showActionsSheet(context, property),
                  tabController: _tabController,
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      PropertyOverviewTab(property: property),
                      BlocProvider(
                        create: (_) => sl<UnitsListCubit>(),
                        child: PropertyUnitsTab(
                          propertyId: property.id,
                          unitsCount: property.unitsCount,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
