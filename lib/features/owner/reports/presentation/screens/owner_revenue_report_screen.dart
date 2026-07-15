import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/di/service_locator.dart' as di;
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../cubit/owner_revenue_cubit.dart';
import '../views/owner_revenue_report_view.dart';

class OwnerRevenueReportScreen extends StatelessWidget {
  const OwnerRevenueReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          di.sl<OwnerRevenueCubit>()..loadRevenueReport(forceRefresh: true),
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          title: Text(
            LocaleKeys.revenueReport.tr(),
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
        ),
        body: const OwnerRevenueReportView(),
      ),
    );
  }
}
