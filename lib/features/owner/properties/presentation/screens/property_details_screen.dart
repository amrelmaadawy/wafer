import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:wafer/core/theme/app_radius.dart';
import 'package:wafer/core/theme/color_utils.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../domain/entities/property_details_entity.dart';
import '../cubit/details/property_details_cubit.dart';
import '../cubit/details/property_details_state.dart';
import '../cubit/units/units_list_cubit.dart';
import '../widgets/details/property_actions_sheet.dart';

import '../widgets/details/property_details_header.dart';
import '../widgets/details/property_details_skeleton.dart';
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
      builder: (_) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: PropertyActionsSheet(
          property: property,
          onEdit: () => context.push(Routes.ownerPropertyEdit, extra: property),
          onClone: () {},
          onMakeRepresentative: () {},
          onDelete: () => context.pop(),
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
            final statusColor = property.isDraft ? AppColors.warning : AppColors.success;
            
            return NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 210,
                    pinned: true,
                    elevation: 0,
                    backgroundColor: Colors.transparent, // Let flexibleSpace gradient show
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 22),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 0.15),
                        ),
                      ),
                    ),
                    actions: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.15),
                          borderRadius: AppRadius.circularFull,
                          border: Border.all(
                            color: statusColor.withValues(alpha: 0.3),
                            width: 1.2,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: statusColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: statusColor.withValues(alpha: 0.6),
                                    blurRadius: 4,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              property.statusLabel,
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                        child: IconButton(
                          onPressed: () => _showActionsSheet(context, property),
                          icon: const Icon(Icons.more_vert_rounded, color: Colors.white, size: 22),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white.withValues(alpha: 0.15),
                          ),
                        ),
                      ),
                    ],
                    flexibleSpace: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [context.primaryColor, const Color(0xFF0F172A)],
                        ),
                      ),
                      child: FlexibleSpaceBar(
                        background: PropertyDetailsHeader(property: property),
                      ),
                    ),
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(70),
                      child: Container(
                        height: 70,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: const BoxDecoration(
                          color: Colors.transparent, // Fix: Gradient shows through
                        ),
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: AppRadius.circularXl,
                          ),
                          child: TabBar(
                            controller: _tabController,
                            labelColor: context.primaryColor,
                            unselectedLabelColor: Colors.white,
                            labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                            indicatorSize: TabBarIndicatorSize.tab,
                            dividerColor: Colors.transparent,
                            indicatorPadding: const EdgeInsets.all(4),
                            indicator: BoxDecoration(
                              color: Colors.white,
                              borderRadius: AppRadius.circularLg,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            tabs: [
                              Tab(text: LocaleKeys.propertyDetailsOverview.tr()),
                              Tab(text: LocaleKeys.propertyDetailsUnits.tr()),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ];
              },
              body: Container(
                color: AppColors.backgroundLight,
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
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
