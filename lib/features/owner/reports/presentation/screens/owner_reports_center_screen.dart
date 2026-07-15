import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/di/service_locator.dart' as di;
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/color_utils.dart';
import '../cubit/owner_defaulters_cubit.dart';
import '../cubit/owner_occupancy_cubit.dart';
import '../cubit/owner_revenue_cubit.dart';
import '../views/owner_defaulters_report_view.dart';
import '../views/owner_occupancy_report_view.dart';
import '../views/owner_revenue_report_view.dart';

class OwnerReportsCenterScreen extends StatelessWidget {
  final int initialTabIndex;

  const OwnerReportsCenterScreen({super.key, this.initialTabIndex = 0});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OwnerRevenueCubit>(
          create: (_) => di.sl<OwnerRevenueCubit>()
            ..loadRevenueReport(forceRefresh: true),
        ),
        BlocProvider<OwnerOccupancyCubit>(
          create: (_) => di.sl<OwnerOccupancyCubit>()
            ..loadOccupancyReport(forceRefresh: true),
        ),
        BlocProvider<OwnerDefaultersCubit>(
          create: (_) => di.sl<OwnerDefaultersCubit>()
            ..loadDefaultersReport(forceRefresh: true),
        ),
      ],
      child: DefaultTabController(
        length: 3,
        initialIndex: initialTabIndex.clamp(0, 2),
        child: Scaffold(
          backgroundColor: AppColors.backgroundLight,
          appBar: AppBar(
            title: Text(
              LocaleKeys.dashboardReports.tr(),
              style: const TextStyle(
                color: AppColors.textPrimaryLight,
                fontWeight: FontWeight.w800,
              ),
            ),
            backgroundColor: AppColors.surfaceLight,
            elevation: 0,
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
            centerTitle: true,
            iconTheme: const IconThemeData(color: AppColors.textPrimaryLight),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TabBar(
                  dividerColor: Colors.transparent,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicator: BoxDecoration(
                    color: context.primaryColor,
                    borderRadius: AppRadius.circularXxl,
                    boxShadow: [
                      BoxShadow(
                        color: context.primaryShadow,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: const Color(0xFF64748B),
                  labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                  tabs: [
                    Tab(
                      height: 44,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.attach_money_rounded, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              LocaleKeys.revenueReport.tr(),
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Tab(
                      height: 44,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.pie_chart_rounded, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              LocaleKeys.occupancyReportTitle.tr(),
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Tab(
                      height: 44,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.warning_amber_rounded, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              LocaleKeys.defaultersReportTitle.tr(),
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: const TabBarView(
            children: [
              OwnerRevenueReportView(),
              OwnerOccupancyReportView(),
              OwnerDefaultersReportView(),
            ],
          ),
        ),
      ),
    );
  }
}
