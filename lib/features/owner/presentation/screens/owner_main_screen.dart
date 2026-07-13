import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/service_locator.dart';
import '../cubit/owner_nav_cubit.dart';
import '../cubit/owner_nav_state.dart';
import '../views/owner_dashboard_view.dart';
import '../views/owner_properties_view.dart';
import '../views/owner_leases_view.dart';
import '../views/owner_finance_view.dart';
import '../views/owner_more_view.dart';
import '../widgets/owner_bottom_nav_widget.dart';

class OwnerMainScreen extends StatelessWidget {
  const OwnerMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider<OwnerNavCubit>(
        create: (context) => sl<OwnerNavCubit>(),
        child: const _OwnerMainContent(),
      ),
    );
  }
}

class _OwnerMainContent extends StatelessWidget {
  const _OwnerMainContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OwnerNavCubit, OwnerNavState>(
      builder: (context, state) {
        return Scaffold(
          body: IndexedStack(
            index: state.currentIndex,
            children: const [
              OwnerDashboardView(),
              OwnerPropertiesView(),
              OwnerLeasesView(),
              OwnerFinanceView(),
              OwnerMoreView(),
            ],
          ),
          bottomNavigationBar: OwnerBottomNavWidget(
            currentIndex: state.currentIndex,
            onTabChanged: (index) {
              context.read<OwnerNavCubit>().changeTab(index);
            },
          ),
        );
      },
    );
  }
}
