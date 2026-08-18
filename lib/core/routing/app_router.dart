import 'package:flutter/material.dart';
import '../../features/owner/tasks/presentation/screens/owner_tasks_screen.dart';
import '../../features/owner/tasks/presentation/cubits/list/tasks_list_cubit.dart';
import '../../features/owner/tasks/presentation/screens/owner_task_details_screen.dart';
import '../../features/owner/tasks/presentation/screens/owner_create_task_screen.dart';
import '../../features/owner/tasks/domain/entities/task_entity.dart';
import '../../features/owner/tasks/presentation/cubits/form_data/task_form_data_cubit.dart';
import '../../features/owner/tasks/presentation/cubits/create_task/create_task_cubit.dart';
import '../../features/owner/tasks/presentation/cubits/update_task/update_task_cubit.dart';
import 'package:go_router/go_router.dart';
import 'package:wafer/features/owner/finance/domain/entities/payment_entity.dart';
import 'package:wafer/features/owner/finance/presentation/cubit/journal_entries/create_journal_entry_cubit.dart';
import 'package:wafer/features/owner/finance/presentation/cubit/journal_entries/post_journal_entry_cubit.dart';
import 'package:wafer/features/owner/finance/presentation/cubit/journal_entries/reverse_journal_entry_cubit.dart';
import 'package:wafer/features/owner/finance/presentation/cubit/journal_entries/update_journal_entry_cubit.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/unsupported_account_screen.dart';
import '../../features/auth/presentation/cubit/auth_state.dart';
import '../../features/auth/domain/entities/user_entity.dart';
import '../presentation/screens/route_error_screen.dart';
import 'app_router_guard.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/owner/shell/presentation/screens/owner_main_screen.dart';
import '../../features/owner/dashboard/presentation/views/owner_dashboard_view.dart';
import '../../features/owner/properties/presentation/views/owner_properties_view.dart';
import '../../features/owner/properties/presentation/cubit/list/properties_list_cubit.dart';
import '../../features/owner/properties/presentation/cubit/display/property_display_cubit.dart';
import '../../features/owner/properties/presentation/cubit/filter_options/property_filter_options_cubit.dart';
import '../../features/owner/properties/presentation/screens/property_details_screen.dart';
import '../../features/owner/properties/presentation/cubit/details/property_details_cubit.dart';
import '../../features/owner/properties/domain/entities/property_details_entity.dart';
import '../../features/owner/properties/presentation/screens/property_create_screen.dart';
import '../../features/owner/properties/presentation/cubit/create/property_create_cubit.dart';
import '../../features/owner/properties/presentation/screens/unit_details_screen.dart';
import '../../features/owner/properties/presentation/screens/unit_create_screen.dart';
import '../../features/owner/properties/presentation/screens/unit_edit_screen.dart';
import '../../features/owner/properties/presentation/screens/property_edit_screen.dart';
import '../../features/owner/properties/presentation/cubit/edit/property_edit_cubit.dart';
import '../../features/owner/contracts/presentation/views/owner_leases_view.dart';
import '../../features/owner/contracts/presentation/cubit/list/owner_contracts_cubit.dart';
import '../../features/owner/contracts/presentation/screens/owner_contract_details_screen.dart';
import '../../features/owner/contracts/presentation/screens/owner_contract_installments_screen.dart';
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

import '../../features/owner/finance/presentation/views/update_owner_account_view.dart';
import '../../features/owner/finance/presentation/views/owner_account_details_view.dart';
import '../../features/owner/finance/presentation/views/update_owner_receipt_view.dart';
import '../../features/owner/finance/presentation/views/owner_payments_view.dart';

import '../../features/owner/finance/presentation/views/create_owner_journal_entry_view.dart';
import '../../features/owner/finance/domain/entities/journal_entry_entity.dart';
import '../../features/owner/finance/presentation/views/create_owner_payment_view.dart';
import '../../features/owner/finance/presentation/views/update_owner_payment_view.dart';
import '../../features/owner/finance/presentation/views/owner_receipt_details_view.dart';
import '../../features/owner/finance/presentation/cubit/receipts/finance_receipts_cubit.dart';
import '../../features/owner/finance/presentation/cubit/receipts/create_finance_receipt_cubit.dart';
import '../../features/owner/finance/presentation/cubit/payments/finance_payments_cubit.dart';
import '../../features/owner/finance/presentation/cubit/payments/create_finance_payment_cubit.dart';
import '../../features/owner/finance/presentation/cubit/payments/update_finance_payment_cubit.dart';
import '../../features/owner/finance/presentation/cubit/receipts/update_finance_receipt_cubit.dart';
import '../../features/owner/finance/presentation/cubit/receipts/finance_receipt_details_cubit.dart';
import '../../features/owner/finance/presentation/cubit/payments/finance_payment_details_cubit.dart';
import '../../features/owner/finance/presentation/cubit/payments/cancel_finance_payment_cubit.dart';
import '../../features/owner/finance/presentation/views/owner_finance_payment_details_view.dart';
import '../../features/owner/finance/presentation/cubit/form_data/finance_form_data_cubit.dart';
import '../../features/owner/finance/presentation/cubit/transfers/create_transfer_cubit.dart';
import '../../features/owner/finance/presentation/cubit/transfers/update_transfer_cubit.dart';
import '../../features/owner/finance/presentation/cubit/transfers/approve_transfer_cubit.dart';
import '../../features/owner/finance/presentation/cubit/journal_entries/journal_entries_cubit.dart';
import '../../features/owner/finance/presentation/cubit/transfers/transfers_cubit.dart';
import '../../features/owner/finance/domain/entities/transfer_entity.dart';
import '../../features/owner/finance/presentation/views/create_owner_transfer_view.dart';
import '../../features/owner/finance/presentation/views/owner_transfers_view.dart';
import '../../features/owner/finance/presentation/views/owner_journal_entries_view.dart';
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
import '../../features/owner/reports/presentation/views/owner_approvals_report_view.dart';
import '../../features/owner/reports/presentation/views/owner_legal_cases_report_view.dart';
import '../../features/owner/reports/presentation/cubit/owner_defaulters_cubit.dart';
import '../../features/owner/reports/presentation/cubit/owner_contracts_report_cubit.dart';
import '../../features/owner/reports/presentation/cubit/owner_approvals_report_cubit.dart';
import '../../features/owner/reports/presentation/cubit/legal_cases/owner_legal_cases_report_cubit.dart';
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
import '../../features/owner/search/presentation/screens/search_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../di/service_locator.dart';
import 'routes.dart';
final _rootNavigatorKey = GlobalKey<NavigatorState>();

// Holds the latest auth state for use in the redirect callback
UserEntity? _currentUser;
bool _isAuthenticated = false;
bool _isLoading = true;
bool _isSessionError = false;

void updateAuthState(AuthState state) {
  if (state is AuthLoading || state is AuthInitial) {
    _isLoading = true;
    _isAuthenticated = false;
    _isSessionError = false;
    _currentUser = null;
  } else if (state is Authenticated) {
    _isLoading = false;
    _isAuthenticated = true;
    _isSessionError = false;
    _currentUser = state.user;
  } else if (state is AuthSessionError) {
    _isLoading = false;
    _isAuthenticated = false;
    _isSessionError = true;
    _currentUser = null;
  } else if (state is AuthLoading || state is AuthInitial) {
    _isLoading = true;
    _isAuthenticated = false;
    _isSessionError = false;
    _currentUser = null;
  } else if (state is Unauthenticated) {
    _isLoading = false;
    _isAuthenticated = false;
    _isSessionError = false;
    _currentUser = null;
  } else {
    _isLoading = false;
    _isAuthenticated = false;
    _isSessionError = false;
    _currentUser = null;
  }
  AppRouter.router.refresh();
}

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: Routes.splash,
    redirect: (context, state) {
      return appRouterGuard(
        state: state,
        currentUser: _currentUser,
        isAuthenticated: _isAuthenticated,
        isLoading: _isLoading,
        isSessionError: _isSessionError,
      );
    },
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: Routes.home,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 600),
        ),
      ),
      GoRoute(
        path: Routes.login,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 600),
        ),
      ),
      GoRoute(
        path: Routes.unsupportedAccount,
        builder: (context, state) => const UnsupportedAccountScreen(),
      ),
      GoRoute(
        path: Routes.routeError,
        builder: (context, state) => const RouteErrorScreen(),
      ),
      GoRoute(
        path: Routes.changePassword,
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: Routes.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: Routes.ownerSearch,
        builder: (context, state) => const SearchScreen(),
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
        path: Routes.ownerFinancePayments,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<FinancePaymentsCubit>()),
            BlocProvider(create: (_) => sl<CancelFinancePaymentCubit>()),
          ],
          child: const OwnerPaymentsView(),
        ),
      ),
      GoRoute(
        path: Routes.ownerFinanceCreatePayment,
        builder: (context, state) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<CreateFinancePaymentCubit>()),
              BlocProvider(create: (_) => sl<FinanceFormDataCubit>()),
            ],
            child: const CreateOwnerPaymentView(),
          );
        },
      ),
      GoRoute(
        path: Routes.ownerFinanceTransfers,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<TransfersCubit>()),
            BlocProvider(create: (_) => sl<ApproveTransferCubit>()),
          ],
          child: const OwnerTransfersView(),
        ),
      ),
      GoRoute(
        path: Routes.ownerFinanceCreateTransfer,
        builder: (context, state) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<CreateTransferCubit>()),
              BlocProvider(create: (_) => sl<FinanceFormDataCubit>()),
            ],
            child: const CreateOwnerTransferView(),
          );
        },
      ),
      GoRoute(
        path: Routes.ownerFinanceUpdateTransfer,
        builder: (context, state) {
          final transfer = state.extra as TransferEntity?;
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<UpdateTransferCubit>()),
              BlocProvider(create: (_) => sl<FinanceFormDataCubit>()),
            ],
            child: CreateOwnerTransferView(transfer: transfer),
          );
        },
      ),
      GoRoute(
        path: Routes.ownerFinanceJournalEntries,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<JournalEntriesCubit>()),
            BlocProvider(create: (_) => sl<PostJournalEntryCubit>()),
            BlocProvider(create: (_) => sl<ReverseJournalEntryCubit>()),
          ],
          child: const OwnerJournalEntriesView(),
        ),
      ),
      GoRoute(
        path: Routes.ownerFinanceCreateJournalEntry,
        builder: (context, state) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<CreateJournalEntryCubit>()),
              BlocProvider(create: (_) => sl<UpdateJournalEntryCubit>()),
              BlocProvider(create: (_) => sl<FinanceFormDataCubit>()),
            ],
            child: const CreateOwnerJournalEntryView(),
          );
        },
      ),
      GoRoute(
        path: Routes.ownerFinanceUpdateJournalEntry,
        builder: (context, state) {
          final entry = state.extra as JournalEntryEntity;
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<CreateJournalEntryCubit>()),
              BlocProvider(create: (_) => sl<UpdateJournalEntryCubit>()),
              BlocProvider(create: (_) => sl<FinanceFormDataCubit>()),
            ],
            child: CreateOwnerJournalEntryView(journalEntry: entry),
          );
        },
      ),
      GoRoute(
        path: Routes.ownerFinanceReceiptCreate,
        builder: (context, state) {
          final extraCubit = state.extra as FinanceReceiptsCubit?;
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<CreateFinanceReceiptCubit>()),
              BlocProvider(create: (_) => sl<FinanceFormDataCubit>()),
              if (extraCubit != null)
                BlocProvider<FinanceReceiptsCubit>.value(
                  value: extraCubit,
                  key: const ValueKey('finance_receipts_cubit_value'),
                )
              else
                BlocProvider<FinanceReceiptsCubit>(
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
                BlocProvider<FinanceReceiptsCubit>.value(
                  value: extraCubit,
                  key: const ValueKey('finance_receipts_cubit_value'),
                )
              else
                BlocProvider<FinanceReceiptsCubit>(
                  create: (_) => sl<FinanceReceiptsCubit>(),
                  key: const ValueKey('finance_receipts_cubit_create'),
                ),
            ],
            child: UpdateOwnerReceiptView(receipt: receipt),
          );
        },
      ),
      GoRoute(
        path: Routes.ownerFinancePaymentUpdate,
        builder: (context, state) {
          final extraMap = state.extra as Map<String, dynamic>? ?? {};
          final extraCubit = extraMap['cubit'] as FinancePaymentsCubit?;
          final payment = extraMap['payment'] as PaymentEntity?;

          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<UpdateFinancePaymentCubit>()),
              if (extraCubit != null)
                BlocProvider<FinancePaymentsCubit>.value(
                  value: extraCubit,
                  key: const ValueKey('finance_payments_cubit_value'),
                )
              else
                BlocProvider<FinancePaymentsCubit>(
                  create: (_) => sl<FinancePaymentsCubit>(),
                  key: const ValueKey('finance_payments_cubit_create'),
                ),
            ],
            child: UpdateOwnerPaymentView(payment: payment),
          );
        },
      ),
      GoRoute(
        path: Routes.ownerFinancePaymentDetails,
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<FinancePaymentDetailsCubit>()),
              BlocProvider(create: (_) => sl<CancelFinancePaymentCubit>()),
            ],
            child: OwnerFinancePaymentDetailsView(paymentId: id),
          );
        },
      ),
      GoRoute(
        path: Routes.ownerFinanceReceiptDetails,
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
          final extraCubit = state.extra as FinanceReceiptsCubit?;
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<FinanceReceiptDetailsCubit>()),
              if (extraCubit != null)
                BlocProvider<FinanceReceiptsCubit>.value(
                  value: extraCubit,
                  key: const ValueKey('finance_receipts_cubit_value'),
                )
              else
                BlocProvider<FinanceReceiptsCubit>(
                  create: (_) => sl<FinanceReceiptsCubit>(),
                  key: const ValueKey('finance_receipts_cubit_create'),
                ),
            ],
            child: OwnerReceiptDetailsView(receiptId: id),
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
        path: Routes.ownerPropertyDetails,
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['propertyId'] ?? '0') ?? 0;
          return BlocProvider<PropertyDetailsCubit>(
            create: (_) => sl<PropertyDetailsCubit>(),
            child: PropertyDetailsScreen(propertyId: id),
          );
        },
      ),
      GoRoute(
        path: Routes.ownerPropertyEdit,
        builder: (context, state) {
          final property = state.extra as PropertyDetailsEntity?;
          if (property == null) return const RouteErrorScreen();
          return BlocProvider<PropertyEditCubit>(
            create: (_) => sl<PropertyEditCubit>(),
            child: PropertyEditScreen(property: property),
          );
        },
      ),
      GoRoute(
        path: Routes.ownerUnitCreate,
        builder: (context, state) {
          final propertyId =
              int.tryParse(state.pathParameters['propertyId'] ?? '0') ?? 0;
          return UnitCreateScreen(propertyId: propertyId);
        },
      ),
      GoRoute(
        path: Routes.ownerPropertyUnitDetails,
        builder: (context, state) {
          final propertyId =
              int.tryParse(state.pathParameters['propertyId'] ?? '0') ?? 0;
          final unitId =
              int.tryParse(state.pathParameters['unitId'] ?? '0') ?? 0;
          return UnitDetailsScreen(propertyId: propertyId, unitId: unitId);
        },
      ),
      GoRoute(
        path: Routes.ownerUnitEdit,
        builder: (context, state) {
          final propertyId =
              int.tryParse(state.pathParameters['propertyId'] ?? '0') ?? 0;
          final unitId =
              int.tryParse(state.pathParameters['unitId'] ?? '0') ?? 0;
          return UnitEditScreen(propertyId: propertyId, unitId: unitId);
        },
      ),
      GoRoute(
        path: Routes.ownerMaintenanceCreate,
        builder: (context, state) {
          return const OwnerCreateMaintenanceScreen();
        },
      ),
      GoRoute(
        path: Routes.ownerMaintenanceDetails,
        builder: (context, state) {
          final item = state.extra as MaintenanceItemEntity?;
          if (item == null) return const RouteErrorScreen();
          return OwnerMaintenanceDetailsScreen(item: item);
        },
      ),
      GoRoute(
        path: Routes.ownerMaintenanceEdit,
        builder: (context, state) {
          final item = state.extra as MaintenanceItemEntity?;
          if (item == null) return const RouteErrorScreen();
          return OwnerUpdateMaintenanceScreen(maintenanceItem: item);
        },
      ),
      GoRoute(
        path: Routes.ownerTechnicianCreate,
        builder: (context, state) {
          return const AddTechnicianView();
        },
      ),
      GoRoute(
        path: Routes.ownerSupervisorCreate,
        builder: (context, state) {
          return const SupervisorsListView();
        },
      ),
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
          final id = int.tryParse(state.pathParameters['caseId'] ?? '');
          if (id == null) return const LegalCasesListView();
          return LegalCaseDetailsView(legalCaseId: id);
        },
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
        path: Routes.ownerTasksCreate,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider<TaskFormDataCubit>(
              create: (_) => sl<TaskFormDataCubit>(),
            ),
            BlocProvider<CreateTaskCubit>(
              create: (_) => sl<CreateTaskCubit>(),
            ),
          ],
          child: const OwnerCreateTaskScreen(),
        ),
      ),
      GoRoute(
        path: Routes.ownerTasksEdit,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider<TaskFormDataCubit>(
              create: (_) => sl<TaskFormDataCubit>(),
            ),
            BlocProvider<UpdateTaskCubit>(
              create: (_) => sl<UpdateTaskCubit>(),
            ),
          ],
          child: OwnerCreateTaskScreen(taskToEdit: state.extra as TaskEntity?),
        ),
      ),
      GoRoute(
        path: Routes.ownerTaskDetails,
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['taskId'] ?? '0') ?? 0;
          return OwnerTaskDetailsScreen(taskId: id);
        },
      ),
      GoRoute(
        path: Routes.ownerActivityLogsReport,
        builder: (context, state) => const OwnerActivityLogsReportView(),
      ),
      GoRoute(
        path: Routes.ownerReportsApprovals,
        builder: (context, state) => BlocProvider.value(
          value: sl<OwnerApprovalsReportCubit>(),
          child: const OwnerApprovalsReportView(),
        ),
      ),
      GoRoute(
        path: Routes.ownerReportsLegalCases,
        builder: (context, state) => BlocProvider(
          create: (context) => sl<OwnerLegalCasesReportCubit>(),
          child: const OwnerLegalCasesReportView(),
        ),
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
        path: Routes.ownerDeedsCreate,
        builder: (context, state) => const CreateDeedScreen(),
      ),
      GoRoute(
        path: Routes.ownerDeedDetails,
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['deedId'] ?? '0') ?? 0;
          return BlocProvider<DeedDetailsCubit>(
            create: (_) => sl<DeedDetailsCubit>(),
            child: DeedDetailsScreen(deedId: id),
          );
        },
      ),
      GoRoute(
        path: Routes.ownerContractDetails,
        builder: (context, state) => OwnerContractDetailsScreen(
          contractId: state.pathParameters['contractId'] ?? '',
        ),
      ),
      GoRoute(
        path: Routes.ownerContractInstallments,
        builder: (context, state) => OwnerContractInstallmentsScreen(
          contractId: state.pathParameters['contractId'] ?? '',
          contractNumber: state.extra as String? ?? '',
        ),
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
                builder: (context, state) => MultiBlocProvider(
                  providers: [
                    BlocProvider<PropertiesListCubit>(
                      create: (_) => sl<PropertiesListCubit>(),
                    ),
                    BlocProvider<PropertyDisplayCubit>(
                      create: (_) => sl<PropertyDisplayCubit>(),
                    ),
                    BlocProvider<PropertyFilterOptionsCubit>(
                      create: (_) => sl<PropertyFilterOptionsCubit>()..load(),
                    ),
                  ],
                  child: const OwnerPropertiesView(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.ownerContracts,
                builder: (context, state) => BlocProvider<OwnerContractsCubit>(
                  create: (_) => sl<OwnerContractsCubit>()..getContracts(),
                  child: const OwnerLeasesView(),
                ),
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
                path: Routes.ownerMaintenance,
                builder: (context, state) {
                  final filter = state.uri.queryParameters['filter'];
                  return BlocProvider<OwnerMaintenanceCubit>(
                    create: (_) => sl<OwnerMaintenanceCubit>(),
                    child: OwnerMaintenanceView(initialStatusFilter: filter),
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.ownerTasks,
                builder: (context, state) => BlocProvider<TasksListCubit>(
                  create: (_) => sl<TasksListCubit>(),
                  child: const OwnerTasksScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.ownerLegalCases,
                builder: (context, state) => const LegalCasesListView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.ownerDeeds,
                builder: (context, state) => BlocProvider<DeedsListCubit>(
                  create: (_) => sl<DeedsListCubit>(),
                  child: const DeedsListScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.ownerTechniciansList,
                builder: (context, state) => BlocProvider<TechniciansListCubit>(
                  create: (_) => sl<TechniciansListCubit>(),
                  child: const TechniciansListView(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.ownerSupervisorsList,
                builder: (context, state) => const SupervisorsListView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.ownerNegotiationsList,
                builder: (context, state) => const NegotiationsListView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.ownerReportsCenter,
                builder: (context, state) => const OwnerReportsCenterScreen(),
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

