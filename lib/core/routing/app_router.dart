import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
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
import '../../features/owner/properties/presentation/screens/property_edit_screen.dart';
import '../../features/owner/properties/presentation/cubit/edit/property_edit_cubit.dart';
import '../../features/owner/contracts/presentation/views/owner_leases_view.dart';
import '../../features/owner/finance/presentation/views/owner_finance_view.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/owner/maintenance/presentation/views/owner_maintenance_view.dart';
import '../../features/owner/reports/presentation/screens/owner_reports_center_screen.dart';
import '../../features/owner/maintenance/presentation/cubit/owner_maintenance_cubit.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/change_password_screen.dart';
import '../../features/profile/presentation/cubit/profile_cubit.dart';
import '../../features/owner/deeds/presentation/cubit/list/deeds_list_cubit.dart';
import '../../features/owner/deeds/presentation/screens/deeds_list_screen.dart';
import '../../features/owner/deeds/presentation/screens/create_deed_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../di/service_locator.dart';
import 'routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: Routes.login,
    routes: [
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
        builder: (context, state) => BlocProvider<PropertyCreateCubit>(
          create: (_) => sl<PropertyCreateCubit>()..initWizard(),
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
          final tab = int.tryParse(state.uri.queryParameters['tab'] ?? '0') ?? 0;
          return OwnerReportsCenterScreen(initialTabIndex: tab);
        },
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
