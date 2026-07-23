import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/di/service_locator.dart' as di;
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/presentation/widgets/custom_app_bar.dart';
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
        appBar: CustomAppBar(
          title: LocaleKeys.revenueReport.tr(),
        ),
        body: const OwnerRevenueReportView(),
      ),
    );
  }
}
