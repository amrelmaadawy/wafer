import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/di/service_locator.dart' as di;
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
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
            bottom: TabBar(
              indicatorColor: context.primaryColor,
              indicatorWeight: 3,
              labelColor: context.primaryColor,
              unselectedLabelColor: AppColors.textSecondaryLight,
              isScrollable: true,
              tabAlignment: TabAlignment.center,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12.5,
              ),
              tabs: [
                Tab(
                  icon: const Icon(Icons.attach_money_rounded, size: 20),
                  text: LocaleKeys.revenueReport.tr(),
                ),
                Tab(
                  icon: const Icon(Icons.pie_chart_rounded, size: 20),
                  text: LocaleKeys.occupancyReportTitle.tr(),
                ),
                Tab(
                  icon: const Icon(Icons.warning_amber_rounded, size: 20),
                  text: LocaleKeys.defaultersReportTitle.tr(),
                ),
              ],
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
