import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/di/service_locator.dart';
import '../../domain/entities/property_details_entity.dart';
import '../cubit/details/property_details_cubit.dart';
import '../cubit/details/property_details_state.dart';
import '../cubit/publish/publish_property_cubit.dart';
import '../cubit/clone_for_deed/clone_for_deed_cubit.dart';
import '../widgets/details/property_actions_sheet.dart';
import '../widgets/details/property_details_skeleton.dart';
import '../widgets/details/property_overview_tab.dart';
import '../widgets/details/property_units_tab.dart';
import '../widgets/details/property_contracts_tab.dart';
import '../widgets/details/property_maintenance_tab.dart';
import '../widgets/details/property_owners_tab.dart';
import '../widgets/details/property_details_app_bar.dart';
import '../widgets/details/clone_for_deed_sheet.dart';
import '../widgets/publish/publish_property_sheet.dart';

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
    _tabController = TabController(length: 5, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PropertyDetailsCubit>().loadDetails(widget.propertyId);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showPublishSheet(BuildContext context, PropertyDetailsEntity property) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider(
        create: (_) => sl<PublishPropertyCubit>(),
        child: PublishPropertySheet(
          propertyId: property.id,
          onSuccess: () {
            context.read<PropertyDetailsCubit>().loadDetails(property.id);
          },
        ),
      ),
    );
  }

  void _showCloneForDeedSheet(BuildContext context, PropertyDetailsEntity property) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider(
        create: (_) => sl<CloneForDeedCubit>(),
        child: CloneForDeedSheet(
          propertyId: property.id,
        ),
      ),
    );
  }

  void _showActionsSheet(BuildContext context, PropertyDetailsEntity property) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: PropertyActionsSheet(
          property: property,
          onEdit: () async {
            await context.push(Routes.ownerPropertyEdit, extra: property);
            if (context.mounted) {
              context.read<PropertyDetailsCubit>().loadDetails(property.id);
            }
          },
          onClone: () => _showCloneForDeedSheet(context, property),
          onMakeRepresentative: () {},
          onDelete: () => context.pop(),
          onPublish: () => _showPublishSheet(context, property),
        ),
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
            return const PropertyDetailsSkeleton();
          } else if (state is PropertyDetailsError) {
            return SafeArea(
              child: Column(
                children: [
                  const CustomAppBar(title: ''),
                  Expanded(
                    child: CustomErrorWidget(
                      message: state.message,
                      onRetry: () => context.read<PropertyDetailsCubit>().loadDetails(widget.propertyId),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is PropertyDetailsLoaded) {
            final property = state.property;
            
            return NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  PropertyDetailsSliverAppBar(
                    property: property,
                    tabController: _tabController,
                    onOpenActions: () => _showActionsSheet(context, property),
                  ),
                ];
              },
              body: Container(
                color: AppColors.backgroundLight,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    PropertyOverviewTab(property: property),
                    PropertyUnitsTab(units: property.units, propertyId: widget.propertyId),
                    PropertyContractsTab(contracts: property.contracts),
                    PropertyMaintenanceTab(maintenanceRequests: property.maintenance),
                    PropertyOwnersTab(property: property),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
