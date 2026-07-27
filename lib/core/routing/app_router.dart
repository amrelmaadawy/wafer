import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/owner/shell/presentation/screens/owner_main_screen.dart';
import '../../features/owner/dashboard/presentation/views/owner_dashboard_view.dart';
import '../../features/owner/properties/presentation/views/owner_properties_view.dart';
import '../../features/owner/properties/presentation/cubit/list/properties_list_cubit.dart';
import '../../features/owner/properties/presentation/screens/property_details_screen.dart';
import '../../features/owner/properties/presentation/cubit/details/property_details_cubit.dart';
import '../../features/owner/properties/domain/entities/property_details_entity.dart';
import '../../features/owner/properties/presentation/screens/property_create_screen.dart';
import '../../features/owner/properties/presentation/cubit/create/property_create_cubit.dart';
import '../../features/owner/properties/presentation/screens/unit_details_screen.dart';
import '../../features/owner/properties/presentation/screens/unit_create_screen.dart';
import '../../features/owner/properties/presentation/screens/property_edit_screen.dart';
import '../../features/owner/properties/presentation/cubit/edit/property_edit_cubit.dart';
import '../../features/owner/contracts/presentation/views/owner_leases_view.dart';
import '../../features/owner/finance/presentation/views/owner_finance_view.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/owner/maintenance/presentation/views/owner_maintenance_view.dart';
import '../../features/owner/maintenance/presentation/cubit/owner_maintenance_cubit.dart';
import '../../features/owner/reports/presentation/screens/owner_reports_center_screen.dart';
import '../../features/owner/reports/presentation/views/owner_revenue_report_view.dart';
import '../../features/owner/reports/presentation/cubit/owner_revenue_cubit.dart';
import '../../features/owner/reports/presentation/views/owner_units_status_report_view.dart';
import '../../features/owner/reports/presentation/cubit/owner_units_status_cubit.dart';
import '../../features/owner/reports/presentation/views/owner_occupancy_report_view.dart';
import '../../features/owner/reports/presentation/cubit/owner_occupancy_cubit.dart';
import '../../features/owner/reports/presentation/views/owner_defaulters_report_view.dart';
import '../../features/owner/reports/presentation/cubit/owner_defaulters_cubit.dart';
import '../../features/owner/reports/presentation/cubit/owner_contracts_report_cubit.dart';
import '../../features/owner/reports/presentation/views/owner_contracts_report_view.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/change_password_screen.dart';
import '../../features/profile/presentation/cubit/profile_cubit.dart';
import '../../features/owner/deeds/presentation/cubit/list/deeds_list_cubit.dart';
import '../../features/owner/deeds/presentation/screens/deeds_list_screen.dart';
import '../../features/owner/deeds/presentation/screens/create_deed_screen.dart';
import '../../features/owner/deeds/presentation/screens/deed_details_screen.dart';
import '../../features/owner/deeds/presentation/cubit/details/deed_details_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../di/service_locator.dart';
import 'routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: Routes.splash,
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: Routes.home,
        builder: (context, state) => const LoginScreen(), // Just placeholder or check auth
        redirect: (context, state) => Routes.ownerDashboard,
      ),
      GoRoute(
        path: Routes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: Routes.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),

      GoRoute(
        path: Routes.ownerPropertyDetails,
        builder: (context, state) {
          final id = int.tryParse(state.uri.queryParameters['id'] ?? '0') ?? 0;
          return BlocProvider<PropertyDetailsCubit>(
            create: (_) => sl<PropertyDetailsCubit>(),
            child: PropertyDetailsScreen(propertyId: id),
          );
        },
      ),
      GoRoute(
        path: Routes.ownerPropertyCreate,
        builder: (context, state) => BlocProvider<PropertyCreateCubit>.value(
          value: sl<PropertyCreateCubit>(),
          child: const PropertyCreateScreen(),
        ),
      ),
      GoRoute(
        path: Routes.ownerPropertyEdit,
        builder: (context, state) {
          final property = state.extra as PropertyDetailsEntity;
          return BlocProvider<PropertyEditCubit>(
            create: (_) => sl<PropertyEditCubit>(),
            child: PropertyEditScreen(property: property),
          );
        },
      ),
      GoRoute(
        path: Routes.ownerPropertyUnitDetails,
        builder: (context, state) {
          final propertyId = int.tryParse(state.uri.queryParameters['propertyId'] ?? '0') ?? 0;
          final unitId = int.tryParse(state.uri.queryParameters['unitId'] ?? '0') ?? 0;
          return UnitDetailsScreen(
            propertyId: propertyId,
            unitId: unitId,
          );
        },
      ),
      GoRoute(
        path: Routes.ownerUnitCreate,
        builder: (context, state) {
          final propertyId = int.tryParse(state.uri.queryParameters['propertyId'] ?? '0') ?? 0;
          return UnitCreateScreen(propertyId: propertyId);
        },
      ),
      GoRoute(
        path: Routes.ownerMaintenance,
        builder: (context, state) {
          final filter = state.uri.queryParameters['filter'];
          return BlocProvider<OwnerMaintenanceCubit>(
            create: (_) => sl<OwnerMaintenanceCubit>(),
            child: OwnerMaintenanceView(initialStatusFilter: filter),
          );
        },
      ),
      GoRoute(
        path: Routes.ownerReportsCenter,
        builder: (context, state) {
          return const OwnerReportsCenterScreen();
        },
      ),
      GoRoute(
        path: Routes.ownerRevenueReport,
        builder: (context, state) => BlocProvider<OwnerRevenueCubit>(
          create: (_) => sl<OwnerRevenueCubit>()..loadRevenueReport(forceRefresh: true),
          child: const OwnerRevenueReportView(),
        ),
      ),
      GoRoute(
        path: Routes.ownerUnitsStatusReport,
        builder: (context, state) => BlocProvider<OwnerUnitsStatusCubit>(
          create: (_) => sl<OwnerUnitsStatusCubit>()..loadUnitsStatusReport(forceRefresh: true),
          child: const OwnerUnitsStatusReportView(),
        ),
      ),
      GoRoute(
        path: Routes.ownerContractsReport,
        builder: (context, state) => BlocProvider<OwnerContractsReportCubit>(
          create: (_) => sl<OwnerContractsReportCubit>()..loadContractsReport(forceRefresh: true),
          child: const OwnerContractsReportView(),
        ),
      ),
      GoRoute(
        path: Routes.ownerOccupancyReport,
        builder: (context, state) => BlocProvider<OwnerOccupancyCubit>(
          create: (_) => sl<OwnerOccupancyCubit>()..loadOccupancyReport(forceRefresh: true),
          child: const OwnerOccupancyReportView(),
        ),
      ),
      GoRoute(
        path: Routes.ownerDefaultersReport,
        builder: (context, state) => BlocProvider<OwnerDefaultersCubit>(
          create: (_) => sl<OwnerDefaultersCubit>()..loadDefaultersReport(forceRefresh: true),
          child: const OwnerDefaultersReportView(),
        ),
      ),
      GoRoute(
        path: Routes.editProfile,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return EditProfileScreen(
            cubit: (extra?['cubit'] as ProfileCubit?) ?? sl<ProfileCubit>(),
            profile: extra?['profile'],
          );
        },
      ),
      GoRoute(
        path: Routes.changePassword,
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: Routes.ownerDeeds,
        builder: (context, state) => BlocProvider<DeedsListCubit>(
          create: (_) => sl<DeedsListCubit>(),
          child: const DeedsListScreen(),
        ),
      ),
      GoRoute(
        path: Routes.ownerDeedsCreate,
        builder: (context, state) => const CreateDeedScreen(),
      ),
      GoRoute(
        path: Routes.ownerDeedDetails,
        builder: (context, state) {
          final id = int.tryParse(state.uri.queryParameters['id'] ?? '0') ?? 0;
          return BlocProvider<DeedDetailsCubit>(
            create: (_) => sl<DeedDetailsCubit>(),
            child: DeedDetailsScreen(deedId: id),
          );
        },
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return OwnerMainScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.ownerDashboard,
                builder: (context, state) => const OwnerDashboardView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.ownerProperties,
                builder: (context, state) => BlocProvider<PropertiesListCubit>(
                  create: (_) => sl<PropertiesListCubit>(),
                  child: const OwnerPropertiesView(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.ownerContracts,
                builder: (context, state) => const OwnerLeasesView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.ownerFinance,
                builder: (context, state) => const OwnerFinanceView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.ownerProfile,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
