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
import '../../features/owner/finance/presentation/cubit/finance_overview_cubit.dart';
import '../../features/owner/finance/domain/entities/finance_account_entity.dart';
import '../../features/owner/finance/presentation/cubit/accounts/finance_accounts_cubit.dart';
import '../../features/owner/finance/presentation/cubit/accounts/create_finance_account_cubit.dart';
import '../../features/owner/finance/presentation/cubit/accounts/update_finance_account_cubit.dart';
import '../../features/owner/finance/presentation/cubit/accounts/finance_account_details_cubit.dart';
import '../../features/owner/finance/presentation/views/owner_accounts_view.dart';
import '../../features/owner/finance/presentation/views/create_owner_account_view.dart';
import '../../features/owner/finance/presentation/views/create_owner_receipt_view.dart';

import '../../features/owner/contracts/presentation/cubit/list/owner_contracts_cubit.dart';
import '../../features/owner/finance/presentation/views/update_owner_account_view.dart';
import '../../features/owner/finance/presentation/views/owner_account_details_view.dart';
import '../../features/owner/finance/presentation/views/update_owner_receipt_view.dart';
import '../../features/owner/finance/presentation/views/owner_receipt_details_view.dart';
import '../../features/owner/finance/presentation/cubit/receipts/finance_receipts_cubit.dart';
import '../../features/owner/finance/presentation/cubit/receipts/create_finance_receipt_cubit.dart';
import '../../features/owner/finance/presentation/cubit/receipts/update_finance_receipt_cubit.dart';
import '../../features/owner/finance/presentation/cubit/receipts/finance_receipt_details_cubit.dart';
import '../../features/owner/finance/presentation/views/owner_receipts_view.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/owner/maintenance/presentation/views/owner_maintenance_view.dart';
import '../../features/owner/maintenance/presentation/cubit/owner_maintenance_cubit.dart';
import '../../features/owner/maintenance/presentation/screens/owner_create_maintenance_screen.dart';
import '../../features/owner/maintenance/presentation/screens/owner_update_maintenance_screen.dart';
import '../../features/owner/maintenance/presentation/screens/owner_maintenance_details_screen.dart';
import '../../features/owner/maintenance/domain/entities/maintenance_item_entity.dart';
import '../../features/owner/reports/presentation/screens/owner_reports_center_screen.dart';
import '../../features/owner/reports/presentation/views/owner_revenue_report_view.dart';
import '../../features/owner/reports/presentation/cubit/owner_revenue_cubit.dart';
import '../../features/owner/reports/presentation/views/owner_units_status_report_view.dart';
import '../../features/owner/reports/presentation/cubit/owner_units_status_cubit.dart';
import '../../features/owner/reports/presentation/views/owner_occupancy_report_view.dart';
import '../../features/owner/reports/presentation/cubit/owner_occupancy_cubit.dart';
import '../../features/owner/reports/presentation/views/owner_defaulters_report_view.dart';
import '../../features/owner/reports/presentation/views/owner_contracts_movement_report_view.dart';
import '../../features/owner/reports/presentation/views/owner_maintenance_requests_report_view.dart';
import '../../features/owner/reports/presentation/views/owner_technician_performance_report_view.dart';
import '../../features/owner/reports/presentation/views/owner_employee_tasks_report_view.dart';
import '../../features/owner/reports/presentation/views/owner_activity_logs_report_view.dart';
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
import '../../features/owner/technicians/presentation/views/technicians_list_view.dart';
import '../../features/owner/technicians/presentation/cubit/list/technicians_list_cubit.dart';
import '../../features/owner/technicians/presentation/views/add_technician_view.dart';
import '../../features/owner/supervisors/presentation/views/supervisors_list_view.dart';
import '../../features/owner/legal_cases/presentation/views/legal_cases_list_view.dart';
import '../../features/owner/legal_cases/presentation/views/legal_case_details_view.dart';
import '../../features/owner/legal_cases/presentation/views/legal_case_create_view.dart';
import '../../features/owner/legal_cases/domain/entities/legal_case_item_entity.dart';
import '../../features/owner/maintenance_negotiations/presentation/views/negotiations_list_view.dart';
import '../../features/owner/maintenance_negotiations/presentation/views/negotiation_settings_view.dart';
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
        builder: (context, state) =>
            const LoginScreen(), // Just placeholder or check auth
      ),
      GoRoute(
        path: Routes.companyDashboard,
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('لوحة تحكم الشركات/النظام (قيد التطوير)')),
        ),
      ),
      GoRoute(
        path: Routes.tenantDashboard,
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('لوحة تحكم المستأجر (قيد التطوير)')),
        ),
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
        path: Routes.ownerFinanceAccounts,
        builder: (context, state) => BlocProvider<FinanceAccountsCubit>(
          create: (_) => sl<FinanceAccountsCubit>(),
          child: const OwnerAccountsView(),
        ),
      ),
      GoRoute(
        path: Routes.ownerFinanceAccountCreate,
        builder: (context, state) => BlocProvider(
          create: (_) => sl<CreateFinanceAccountCubit>(),
          child: const CreateOwnerAccountView(),
        ),
      ),
      GoRoute(
        path: Routes.ownerFinanceAccountUpdate,
        builder: (context, state) {
          final account = state.extra as FinanceAccountEntity;
          return BlocProvider(
            create: (_) => sl<UpdateFinanceAccountCubit>(),
            child: UpdateOwnerAccountView(account: account),
          );
        },
      ),
      GoRoute(
        path: Routes.ownerFinanceAccountDetails,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return BlocProvider(
            create: (_) => sl<FinanceAccountDetailsCubit>(),
            child: OwnerAccountDetailsView(accountId: id),
          );
        },
      ),
      GoRoute(
        path: Routes.ownerFinanceReceipts,
        builder: (context, state) => BlocProvider(
          create: (_) => sl<FinanceReceiptsCubit>(),
          child: const OwnerReceiptsView(),
        ),
      ),
      GoRoute(
        path: Routes.ownerFinanceReceiptCreate,
        builder: (context, state) {
          final extraCubit = state.extra as FinanceReceiptsCubit?;
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<CreateFinanceReceiptCubit>()),
              BlocProvider(create: (_) => sl<FinanceAccountsCubit>()),
              BlocProvider(create: (_) => sl<PropertiesListCubit>()),
              BlocProvider(create: (_) => sl<OwnerContractsCubit>()),
              if (extraCubit != null)
                BlocProvider.value(
                  value: extraCubit,
                  key: const ValueKey('finance_receipts_cubit_value'),
                )
              else
                BlocProvider(
                  create: (_) => sl<FinanceReceiptsCubit>(),
                  key: const ValueKey('finance_receipts_cubit_create'),
                ),
            ],
            child: const CreateOwnerReceiptView(),
          );
        },
      ),
      GoRoute(
        path: Routes.ownerFinanceReceiptUpdate,
        builder: (context, state) {
          final extraMap = state.extra as Map<String, dynamic>? ?? {};
          final extraCubit = extraMap['cubit'] as FinanceReceiptsCubit?;
          final receipt = extraMap['receipt']; // ReceiptEntity
          
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<UpdateFinanceReceiptCubit>()),
              if (extraCubit != null)
                BlocProvider.value(
                  value: extraCubit,
                  key: const ValueKey('finance_receipts_cubit_value'),
                )
              else
                BlocProvider(
                  create: (_) => sl<FinanceReceiptsCubit>(),
                  key: const ValueKey('finance_receipts_cubit_create'),
                ),
            ],
            child: UpdateOwnerReceiptView(receipt: receipt),
          );
        },
      ),
      GoRoute(
        path: Routes.ownerFinanceReceiptDetails,
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
          return BlocProvider(
            create: (_) => sl<FinanceReceiptDetailsCubit>(),
            child: OwnerReceiptDetailsView(receiptId: id),
          );
        },
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
          final propertyId =
              int.tryParse(state.uri.queryParameters['propertyId'] ?? '0') ?? 0;
          final unitId =
              int.tryParse(state.uri.queryParameters['unitId'] ?? '0') ?? 0;
          return UnitDetailsScreen(propertyId: propertyId, unitId: unitId);
        },
      ),
      GoRoute(
        path: Routes.ownerUnitCreate,
        builder: (context, state) {
          final propertyId =
              int.tryParse(state.uri.queryParameters['propertyId'] ?? '0') ?? 0;
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
        path: Routes.ownerMaintenanceDetails,
        builder: (context, state) {
          final item = state.extra as MaintenanceItemEntity;
          return OwnerMaintenanceDetailsScreen(item: item);
        },
      ),
      GoRoute(
        path: Routes.ownerMaintenanceCreate,
        builder: (context, state) {
          return const OwnerCreateMaintenanceScreen();
        },
      ),
      GoRoute(
        path: Routes.ownerMaintenanceEdit,
        builder: (context, state) {
          final item = state.extra as MaintenanceItemEntity;
          return OwnerUpdateMaintenanceScreen(maintenanceItem: item);
        },
      ),
      GoRoute(
        path: Routes.ownerTechniciansList,
        builder: (context, state) {
          return BlocProvider<TechniciansListCubit>(
            create: (_) => sl<TechniciansListCubit>(),
            child: const TechniciansListView(),
          );
        },
      ),
      GoRoute(
        path: Routes.ownerTechnicianCreate,
        builder: (context, state) {
          return const AddTechnicianView();
        },
      ),
      GoRoute(
        path: Routes.ownerSupervisorsList,
        builder: (context, state) {
          return const SupervisorsListView();
        },
      ),
      GoRoute(
        path: Routes.ownerReportsCenter,
        builder: (context, state) {
          return const OwnerReportsCenterScreen();
        },
      ),
      GoRoute(
        path: Routes.ownerLegalCases,
        builder: (context, state) {
          return const LegalCasesListView();
        },
        routes: [
          GoRoute(
            path: Routes.ownerLegalCaseCreate,
            builder: (context, state) => const LegalCaseCreateView(),
          ),
          GoRoute(
            path: Routes.ownerLegalCaseEdit,
            builder: (context, state) {
              final extra = state.extra;
              if (extra is! LegalCaseItemEntity) {
                return const LegalCasesListView();
              }
              return LegalCaseCreateView(legalCaseToEdit: extra);
            },
          ),
          GoRoute(
            path: Routes.ownerLegalCaseDetails,
            builder: (context, state) {
              final id = int.tryParse(state.pathParameters['id'] ?? '');
              if (id == null) return const LegalCasesListView();
              return LegalCaseDetailsView(legalCaseId: id);
            },
          ),
        ],
      ),
      GoRoute(
        path: Routes.ownerRevenueReport,
        builder: (context, state) => BlocProvider<OwnerRevenueCubit>(
          create: (_) =>
              sl<OwnerRevenueCubit>()..loadRevenueReport(forceRefresh: true),
          child: const OwnerRevenueReportView(),
        ),
      ),
      GoRoute(
        path: Routes.ownerUnitsStatusReport,
        builder: (context, state) => BlocProvider<OwnerUnitsStatusCubit>(
          create: (_) =>
              sl<OwnerUnitsStatusCubit>()
                ..loadUnitsStatusReport(forceRefresh: true),
          child: const OwnerUnitsStatusReportView(),
        ),
      ),
      GoRoute(
        path: Routes.ownerContractsReport,
        builder: (context, state) => BlocProvider<OwnerContractsReportCubit>(
          create: (_) =>
              sl<OwnerContractsReportCubit>()
                ..loadContractsReport(forceRefresh: true),
          child: const OwnerContractsReportView(),
        ),
      ),
      GoRoute(
        path: Routes.ownerOccupancyReport,
        builder: (context, state) => BlocProvider<OwnerOccupancyCubit>(
          create: (_) =>
              sl<OwnerOccupancyCubit>()
                ..loadOccupancyReport(forceRefresh: true),
          child: const OwnerOccupancyReportView(),
        ),
      ),
      GoRoute(
        path: Routes.ownerDefaultersReport,
        builder: (context, state) => BlocProvider<OwnerDefaultersCubit>(
          create: (_) =>
              sl<OwnerDefaultersCubit>()
                ..loadDefaultersReport(forceRefresh: true),
          child: const OwnerDefaultersReportView(),
        ),
      ),
      GoRoute(
        path: Routes.ownerContractsMovementReport,
        builder: (context, state) => const OwnerContractsMovementReportView(),
      ),
      GoRoute(
        path: Routes.ownerMaintenanceRequestsReport,
        builder: (context, state) => const OwnerMaintenanceRequestsReportView(),
      ),
      GoRoute(
        path: Routes.ownerTechnicianPerformanceReport,
        builder: (context, state) =>
            const OwnerTechnicianPerformanceReportView(),
      ),
      GoRoute(
        path: Routes.ownerEmployeeTasksReport,
        builder: (context, state) => const OwnerEmployeeTasksReportView(),
      ),
      GoRoute(
        path: Routes.ownerActivityLogsReport,
        builder: (context, state) => const OwnerActivityLogsReportView(),
      ),
      GoRoute(
        path: Routes.ownerNegotiationsList,
        builder: (context, state) => const NegotiationsListView(),
      ),
      GoRoute(
        path: Routes.ownerNegotiationSettings,
        builder: (context, state) => const NegotiationSettingsView(),
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
                builder: (context, state) => BlocProvider<FinanceOverviewCubit>(
                  create: (_) => sl<FinanceOverviewCubit>(),
                  child: const OwnerFinanceView(),
                ),
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
