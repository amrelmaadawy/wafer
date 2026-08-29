import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../cubit/finance_overview_cubit.dart';
import '../cubit/finance_overview_state.dart';
import '../widgets/finance_overview_tab_content.dart';

import '../../../shell/presentation/widgets/owner_top_app_bar.dart';

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
      appBar: OwnerTopAppBar(
        title: LocaleKeys.owner_finance_title.tr(),
          forceDrawerButton: true,
        subtitle: LocaleKeys.owner_finance_subtitle.tr(),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: FinanceOverviewTabContent(onRefresh: _onRefresh),
            ),
          ],
        ),
      ),
    );
  }
}
