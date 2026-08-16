import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/color_utils.dart';
import '../cubit/finance_overview_cubit.dart';
import '../cubit/finance_overview_state.dart';
import '../widgets/finance_overview_tab_content.dart';

class OwnerFinanceView extends StatefulWidget {
  const OwnerFinanceView({super.key});

  @override
  State<OwnerFinanceView> createState() => _OwnerFinanceViewState();
}

class _OwnerFinanceViewState extends State<OwnerFinanceView> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<FinanceOverviewCubit>();
    if (cubit.state is FinanceOverviewInitial) {
      cubit.fetchFinanceOverview();
    }
  }

  Future<void> _onRefresh() async {
    await context.read<FinanceOverviewCubit>().fetchFinanceOverview(
      isRefresh: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.owner_finance_title.tr(),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.primaryLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    LocaleKeys.owner_finance_subtitle.tr(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FinanceOverviewTabContent(onRefresh: _onRefresh),
            ),
          ],
        ),
      ),
    );
  }
}
