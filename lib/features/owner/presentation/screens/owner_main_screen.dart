import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/service_locator.dart';
import '../cubit/owner_contracts_cubit.dart';
import '../cubit/owner_dashboard_cubit.dart';
import '../cubit/owner_nav_cubit.dart';
import '../cubit/owner_nav_state.dart';
import '../views/owner_dashboard_view.dart';
import '../views/owner_properties_view.dart';
import '../views/owner_leases_view.dart';
import '../views/owner_finance_view.dart';
import '../../../profile/presentation/cubit/profile_cubit.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../widgets/owner_bottom_nav_widget.dart';
import '../widgets/owner_page_switcher.dart';

class OwnerMainScreen extends StatelessWidget {
  const OwnerMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<OwnerNavCubit>(create: (_) => sl<OwnerNavCubit>()),
          BlocProvider<OwnerDashboardCubit>(create: (_) => sl<OwnerDashboardCubit>()),
          BlocProvider<OwnerContractsCubit>(create: (_) => sl<OwnerContractsCubit>()),
          BlocProvider<ProfileCubit>(create: (_) => sl<ProfileCubit>()..fetchProfile()),
        ],
        child: const _OwnerMainContent(),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Content
// ---------------------------------------------------------------------------

class _OwnerMainContent extends StatefulWidget {
  const _OwnerMainContent();

  @override
  State<_OwnerMainContent> createState() => _OwnerMainContentState();
}

class _OwnerMainContentState extends State<_OwnerMainContent> {
  int _previousIndex = 0;

  static const _views = [
    OwnerDashboardView(),
    OwnerPropertiesView(),
    OwnerLeasesView(),
    OwnerFinanceView(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OwnerNavCubit, OwnerNavState>(
      listener: (context, state) {
        if (state.currentIndex != _previousIndex) {
          setState(() => _previousIndex = state.currentIndex);
        }
      },
      builder: (context, state) {
        final current = state.currentIndex;
        final isForward = current > _previousIndex;

        return Scaffold(
          extendBody: true,
          body: OwnerPageSwitcher(
            currentIndex: current,
            previousIndex: _previousIndex,
            isForward: isForward,
            child: _views[current],
          ),
          bottomNavigationBar: OwnerBottomNavWidget(
            currentIndex: current,
            onTabChanged: (i) => context.read<OwnerNavCubit>().changeTab(i),
          ),
        );
      },
    );
  }
}

