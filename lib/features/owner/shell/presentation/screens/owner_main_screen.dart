import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wafer/core/di/service_locator.dart';
import 'package:wafer/features/owner/contracts/presentation/cubit/list/owner_contracts_cubit.dart';
import 'package:wafer/features/owner/maintenance/presentation/cubit/owner_maintenance_cubit.dart';
import 'package:wafer/features/owner/dashboard/presentation/cubit/owner_dashboard_cubit.dart';
import 'package:wafer/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:wafer/features/owner/shell/presentation/widgets/owner_bottom_nav_widget.dart';


class OwnerMainScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const OwnerMainScreen({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<OwnerDashboardCubit>(create: (_) => sl<OwnerDashboardCubit>()),
          BlocProvider<OwnerContractsCubit>(create: (_) => sl<OwnerContractsCubit>()),
          BlocProvider<OwnerMaintenanceCubit>(create: (_) => sl<OwnerMaintenanceCubit>()),
          BlocProvider<ProfileCubit>(create: (_) => sl<ProfileCubit>()..fetchProfile()),
        ],
        child: Scaffold(
          extendBody: true,
          body: navigationShell,
          bottomNavigationBar: OwnerBottomNavWidget(
            currentIndex: navigationShell.currentIndex,
            onTabChanged: (i) {
              navigationShell.goBranch(
                i,
                initialLocation: i == navigationShell.currentIndex,
              );
            },
          ),
        ),
      ),
    );
  }
}
