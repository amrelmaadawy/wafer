import '../../../../core/di/service_locator.dart';
import '../properties/presentation/cubit/clone_for_deed/clone_for_deed_cubit.dart';
// Dashboard
import '../dashboard/data/datasources/owner_dashboard_remote_data_source.dart';
import '../dashboard/data/repositories/owner_dashboard_repository_impl.dart';
import '../dashboard/domain/repositories/owner_dashboard_repository.dart';
import '../dashboard/domain/usecases/get_owner_dashboard_use_case.dart';
import '../dashboard/presentation/cubit/owner_dashboard_cubit.dart';
// Contracts
import '../contracts/data/datasources/owner_contracts_remote_data_source.dart';
import '../contracts/data/repositories/owner_contracts_repository_impl.dart';
import '../contracts/domain/repositories/owner_contracts_repository.dart';
import '../contracts/domain/usecases/get_owner_contracts_use_case.dart';
import '../contracts/domain/usecases/get_owner_contract_details_use_case.dart';
import '../contracts/domain/usecases/get_owner_contract_installments_use_case.dart';
import '../contracts/presentation/cubit/list/owner_contracts_cubit.dart';
import '../contracts/presentation/cubit/details/owner_contract_details_cubit.dart';
import '../contracts/presentation/cubit/installments/owner_contract_installments_cubit.dart';
// Maintenance
import '../maintenance/data/datasources/owner_maintenance_remote_data_source.dart';
import '../maintenance/data/repositories/owner_maintenance_repository_impl.dart';
import '../maintenance/domain/repositories/owner_maintenance_repository.dart';
import '../maintenance/domain/usecases/get_owner_maintenance_use_case.dart';
import '../maintenance/domain/usecases/get_owner_maintenance_details_use_case.dart';
import 'package:wafer/features/owner/maintenance/domain/usecases/approve_owner_maintenance_use_case.dart';
import 'package:wafer/features/owner/maintenance/domain/usecases/reject_owner_maintenance_use_case.dart';
import 'package:wafer/features/owner/maintenance/domain/usecases/create_owner_maintenance_use_case.dart';
import '../maintenance/domain/usecases/get_owner_maintenance_form_data_use_case.dart';
import '../maintenance/presentation/cubit/owner_maintenance_cubit.dart';
import '../maintenance/presentation/cubit/details/owner_maintenance_details_cubit.dart';
import 'package:wafer/features/owner/maintenance/presentation/cubit/approve_maintenance/owner_approve_maintenance_cubit.dart';
import 'package:wafer/features/owner/maintenance/presentation/cubit/reject_maintenance/owner_reject_maintenance_cubit.dart';
import 'package:wafer/features/owner/maintenance/presentation/cubit/create_maintenance/owner_create_maintenance_cubit.dart';
import '../maintenance/domain/usecases/update_owner_maintenance_use_case.dart';
import '../maintenance/presentation/cubit/update_maintenance/owner_update_maintenance_cubit.dart';
import '../maintenance/domain/usecases/delete_owner_maintenance_use_case.dart';
import '../maintenance/presentation/cubit/delete_maintenance/owner_delete_maintenance_cubit.dart';
import '../maintenance/domain/usecases/assign_owner_maintenance_use_case.dart';
import '../maintenance/domain/usecases/complete_owner_maintenance_task_use_case.dart';
import '../maintenance/presentation/cubit/assign_maintenance/owner_assign_maintenance_cubit.dart';
import '../maintenance/presentation/cubit/complete_task/owner_complete_task_cubit.dart';
import '../maintenance/domain/usecases/execute_owner_maintenance_use_case.dart';
import '../maintenance/presentation/cubit/execute_maintenance/owner_execute_maintenance_cubit.dart';
import '../maintenance/domain/usecases/verify_close_owner_maintenance_use_case.dart';
import '../maintenance/domain/usecases/forward_owner_maintenance_use_case.dart';
import '../maintenance/presentation/cubit/verify_close_maintenance/owner_verify_close_maintenance_cubit.dart';
import '../maintenance/presentation/cubit/forward_maintenance/owner_forward_maintenance_cubit.dart';
// Finance
import '../finance/data/datasources/finance_remote_data_source.dart';
import '../finance/data/repositories/finance_repository_impl.dart';
import '../finance/data/repositories/transfers_repository_impl.dart';
import '../finance/data/repositories/journal_entries_repository_impl.dart';
import '../finance/data/datasources/journal_entries_remote_data_source.dart';
import '../finance/domain/repositories/finance_repository.dart';
import '../finance/domain/repositories/transfers_repository.dart';
import '../finance/domain/repositories/journal_entries_repository.dart';
import '../finance/domain/usecases/get_finance_overview_usecase.dart';
import '../finance/domain/usecases/get_finance_accounts_use_case.dart';
import '../finance/domain/usecases/create_finance_account_use_case.dart';
import '../finance/domain/usecases/update_finance_account_use_case.dart';
import '../finance/domain/usecases/get_finance_account_details_use_case.dart';
import '../finance/domain/usecases/get_finance_receipts_use_case.dart';
import '../finance/domain/usecases/create_finance_receipt_use_case.dart';
import '../finance/domain/usecases/update_finance_receipt_use_case.dart';
import '../finance/domain/usecases/get_finance_receipt_details_use_case.dart';
import '../finance/domain/usecases/get_finance_payment_details_use_case.dart';
import '../finance/domain/usecases/get_finance_payments_use_case.dart';
import '../finance/domain/usecases/create_finance_payment_use_case.dart';
import '../finance/domain/usecases/update_finance_payment_use_case.dart';
import '../finance/domain/usecases/cancel_finance_payment_use_case.dart';
import '../finance/domain/usecases/cancel_finance_receipt_use_case.dart';
import '../finance/domain/usecases/get_finance_form_data_use_case.dart';
import '../finance/domain/usecases/create_journal_entry_use_case.dart';
import '../finance/domain/usecases/update_journal_entry_use_case.dart';
import '../finance/domain/usecases/get_journal_entries_use_case.dart';
import '../finance/presentation/cubit/finance_overview_cubit.dart';
import '../finance/presentation/cubit/accounts/finance_accounts_cubit.dart';
import '../finance/data/datasources/transfers_remote_data_source.dart';
import '../finance/domain/usecases/create_transfer_use_case.dart';
import '../finance/domain/usecases/get_transfers_use_case.dart';
import '../finance/domain/usecases/update_transfer_use_case.dart';
import '../finance/domain/usecases/approve_transfer_use_case.dart';
import '../finance/presentation/cubit/transfers/create_transfer_cubit.dart';
import '../finance/presentation/cubit/transfers/update_transfer_cubit.dart';
import '../finance/presentation/cubit/transfers/approve_transfer_cubit.dart';
import '../finance/presentation/cubit/transfers/transfers_cubit.dart';
import '../finance/presentation/cubit/journal_entries/journal_entries_cubit.dart';
import '../finance/presentation/cubit/journal_entries/create_journal_entry_cubit.dart';
import '../finance/presentation/cubit/journal_entries/update_journal_entry_cubit.dart';
import '../finance/presentation/cubit/journal_entries/post_journal_entry_cubit.dart';
import '../finance/presentation/cubit/journal_entries/reverse_journal_entry_cubit.dart';
import '../finance/presentation/cubit/accounts/create_finance_account_cubit.dart';
import '../finance/presentation/cubit/accounts/update_finance_account_cubit.dart';
import '../finance/presentation/cubit/accounts/finance_account_details_cubit.dart';
import '../finance/presentation/cubit/receipts/finance_receipts_cubit.dart';
import '../finance/presentation/cubit/receipts/create_finance_receipt_cubit.dart';
import '../finance/presentation/cubit/receipts/update_finance_receipt_cubit.dart';
import '../finance/presentation/cubit/receipts/finance_receipt_details_cubit.dart';
import '../finance/presentation/cubit/payments/finance_payment_details_cubit.dart';
import '../finance/presentation/cubit/receipts/cancel_finance_receipt_cubit.dart';
import '../finance/presentation/cubit/payments/finance_payments_cubit.dart';
import '../finance/presentation/cubit/payments/create_finance_payment_cubit.dart';
import '../finance/presentation/cubit/payments/update_finance_payment_cubit.dart';
import '../finance/domain/usecases/post_journal_entry_use_case.dart';
import '../finance/domain/usecases/reverse_journal_entry_use_case.dart';
import '../finance/presentation/cubit/payments/cancel_finance_payment_cubit.dart';
import '../finance/presentation/cubit/form_data/finance_form_data_cubit.dart';
// Reports
import '../reports/domain/usecases/get_owner_reports_index_usecase.dart';
import '../reports/presentation/cubit/owner_reports_index_cubit.dart';
import '../reports/data/datasources/owner_reports_remote_data_source.dart';
import '../reports/data/repositories/owner_reports_repository_impl.dart';
import '../reports/domain/repositories/owner_reports_repository.dart';
import '../reports/domain/usecases/get_legal_cases_report_use_case.dart';
import '../reports/domain/usecases/get_owner_defaulters_report_use_case.dart';
import '../reports/domain/usecases/get_owner_occupancy_report_use_case.dart';
import '../reports/domain/usecases/get_owner_revenue_report_use_case.dart';
import '../reports/domain/usecases/get_owner_units_status_report_usecase.dart';
import '../reports/presentation/cubit/owner_defaulters_cubit.dart';
import '../reports/presentation/cubit/owner_occupancy_cubit.dart';
import '../reports/presentation/cubit/owner_revenue_cubit.dart';
import '../reports/presentation/cubit/owner_units_status_cubit.dart';
import '../reports/domain/usecases/get_contracts_report_use_case.dart';
import '../reports/presentation/cubit/owner_contracts_report_cubit.dart';
import '../reports/domain/usecases/get_owner_contracts_movement_report_use_case.dart';
import '../reports/presentation/cubit/owner_contracts_movement_cubit.dart';
import '../reports/domain/usecases/get_owner_maintenance_requests_report_use_case.dart';
import '../reports/presentation/cubit/owner_maintenance_requests_cubit.dart';
import '../reports/domain/usecases/get_owner_technician_performance_report_use_case.dart';
import '../reports/presentation/cubit/owner_technician_performance_cubit.dart';
import '../reports/domain/usecases/get_owner_employee_tasks_report_use_case.dart';
import '../reports/presentation/cubit/owner_employee_tasks_cubit.dart';
import '../reports/domain/usecases/get_owner_activity_logs_report_use_case.dart';
import '../reports/presentation/cubit/owner_activity_logs_cubit.dart';
import '../reports/domain/usecases/get_approvals_report_use_case.dart';
import '../reports/presentation/cubit/owner_approvals_report_cubit.dart';
import '../reports/presentation/cubit/legal_cases/owner_legal_cases_report_cubit.dart';

// Properties
import '../properties/data/datasources/properties_remote_data_source.dart';
import '../properties/data/datasources/deeds_remote_data_source.dart';
import '../properties/data/datasources/property_display_preferences_local_data_source.dart';
import '../properties/data/repositories/properties_repository_impl.dart';
import '../properties/data/repositories/deeds_repository_impl.dart';
import '../properties/data/repositories/property_display_preferences_repository_impl.dart';
import '../properties/domain/repositories/properties_repository.dart';
import '../properties/domain/repositories/deeds_repository.dart';
import '../properties/domain/repositories/property_display_preferences_repository.dart';
import '../properties/domain/usecases/get_properties_list_use_case.dart';
import '../properties/domain/usecases/get_property_display_mode_use_case.dart';
import '../properties/domain/usecases/save_property_display_mode_use_case.dart';
import '../properties/domain/usecases/get_property_form_options_use_case.dart';
import '../properties/domain/usecases/get_property_details_use_case.dart';
import '../properties/domain/usecases/get_deeds_list_use_case.dart';
import '../properties/domain/usecases/create_deed_use_case.dart';
import '../properties/domain/usecases/create_draft_property_use_case.dart';
import '../properties/domain/usecases/auto_save_property_step_use_case.dart';
import '../properties/domain/usecases/get_property_form_data_use_case.dart';
import '../properties/domain/usecases/sync_owners_use_case.dart';
import '../properties/domain/usecases/upload_temp_file_use_case.dart';
import '../properties/domain/usecases/publish_property_use_case.dart';
import '../properties/domain/usecases/get_unit_details_use_case.dart';
import '../properties/domain/usecases/delete_unit_use_case.dart';
import '../properties/presentation/cubit/list/properties_list_cubit.dart';
import '../properties/presentation/cubit/display/property_display_cubit.dart';
import '../properties/presentation/cubit/filter_options/property_filter_options_cubit.dart';
import '../properties/presentation/cubit/details/property_details_cubit.dart';
import '../properties/presentation/cubit/create/property_create_cubit.dart';
import '../properties/presentation/cubit/publish/publish_property_cubit.dart';
import '../properties/presentation/cubit/delete_unit/unit_delete_cubit.dart';
import '../properties/presentation/cubit/unit_details/unit_details_cubit.dart';

// Units
import '../properties/data/datasources/units_remote_data_source.dart';
import '../properties/data/repositories/units_repository_impl.dart';
import '../properties/domain/repositories/units_repository.dart';
import '../properties/domain/usecases/get_property_units_use_case.dart';
import '../properties/domain/usecases/create_draft_unit_use_case.dart';
import '../properties/domain/usecases/auto_save_unit_use_case.dart';
import '../properties/domain/usecases/publish_unit_use_case.dart';
import '../properties/domain/usecases/create_unit_usecase.dart';
import '../properties/domain/usecases/get_units_form_data_use_case.dart';
import '../properties/domain/usecases/update_unit_use_case.dart';
import '../properties/presentation/cubit/units/units_list_cubit.dart';
import '../properties/presentation/cubit/units/unit_create_cubit.dart';
import '../properties/presentation/cubit/edit_unit/unit_edit_cubit.dart';

import '../properties/domain/usecases/clone_property_use_case.dart';
import '../properties/domain/usecases/auto_save_type_step_use_case.dart';
import '../properties/domain/usecases/auto_save_deed_step_use_case.dart';
import '../properties/domain/usecases/make_representative_use_case.dart';
import '../properties/domain/usecases/remove_representative_use_case.dart';
import '../properties/domain/usecases/delete_property_use_case.dart';
import '../properties/domain/usecases/patch_property_use_case.dart';
import '../properties/presentation/cubit/edit/property_edit_cubit.dart';
import '../properties/presentation/cubit/owners/sync_owners_cubit.dart';
import '../properties/presentation/cubit/delete/delete_property_cubit.dart';
import '../maintenance/domain/usecases/start_owner_maintenance_use_case.dart';
import '../maintenance/presentation/cubit/start_maintenance/owner_start_maintenance_cubit.dart';
import '../deeds/di/deeds_di.dart';
import '../technicians/di/technicians_di.dart';
import '../supervisors/di/supervisors_di.dart';
import '../legal_cases/di/legal_cases_di.dart';

import '../maintenance_negotiations/data/datasources/maintenance_negotiation_remote_data_source.dart';
import '../maintenance_negotiations/data/repositories/maintenance_negotiation_repository_impl.dart';
import '../maintenance_negotiations/domain/repositories/maintenance_negotiation_repository.dart';
import '../maintenance_negotiations/domain/usecases/get_negotiation_form_data_use_case.dart';
import '../maintenance_negotiations/domain/usecases/get_negotiations_list_use_case.dart';
import '../maintenance_negotiations/domain/usecases/create_negotiation_use_case.dart';
import '../maintenance_negotiations/presentation/cubit/form_data/negotiation_form_data_cubit.dart';
import '../maintenance_negotiations/presentation/cubit/list/negotiations_list_cubit.dart';
import '../maintenance_negotiations/presentation/cubit/create/create_negotiation_cubit.dart';
import '../tasks/domain/use_cases/get_tasks_use_case.dart';
import '../tasks/domain/use_cases/get_task_details_use_case.dart';
import '../tasks/domain/usecases/create_task_usecase.dart';
import '../tasks/domain/usecases/update_task_usecase.dart';
import '../tasks/domain/usecases/get_task_form_data_usecase.dart';
import '../tasks/domain/usecases/update_task_status_usecase.dart';
import '../tasks/domain/use_cases/delete_task_use_case.dart';
import '../tasks/presentation/cubit/list/tasks_list_cubit.dart';
import '../tasks/presentation/cubit/details/task_details_cubit.dart';
import '../tasks/presentation/cubit/create_task/create_task_cubit.dart';
import '../tasks/presentation/cubits/update_task/update_task_cubit.dart';
import '../tasks/presentation/cubits/form_data/task_form_data_cubit.dart';
import '../tasks/presentation/cubits/update_status/update_task_status_cubit.dart';
import '../tasks/domain/usecases/update_task_progress_usecase.dart';
import '../tasks/presentation/cubits/update_progress/update_task_progress_cubit.dart';
import '../tasks/domain/usecases/update_task_priority_usecase.dart';
import '../tasks/presentation/cubits/update_priority/update_task_priority_cubit.dart';
import '../tasks/domain/usecases/update_task_dates_usecase.dart';
import '../tasks/presentation/cubits/update_dates/update_task_dates_cubit.dart';
import '../tasks/domain/usecases/add_task_comment_usecase.dart';
import '../tasks/presentation/cubits/add_comment/add_task_comment_cubit.dart';
import '../tasks/domain/usecases/add_task_assignee_usecase.dart';
import '../tasks/presentation/cubits/add_assignee/add_task_assignee_cubit.dart';
import '../tasks/domain/usecases/remove_task_assignee_usecase.dart';
import '../tasks/presentation/cubits/remove_assignee/remove_task_assignee_cubit.dart';
import '../tasks/presentation/cubit/delete/delete_task_cubit.dart';
// Tasks
import '../tasks/data/datasources/tasks_remote_data_source.dart';
import '../tasks/data/repositories/tasks_repository_impl.dart';
import '../tasks/domain/repositories/tasks_repository.dart';

void initOwnerModule() {
  _initDashboard();
  _initProperties();
  _initUnits();
  _initContracts();
  _initMaintenance();
  _initFinance();
  _initReports();
  initDeeds();
  initTechnicians();
  initSupervisors();
  _initMaintenanceNegotiations();
  initLegalCases();
  _initTasks();
}

void _initFinance() {
  if (!sl.isRegistered<FinanceRemoteDataSource>()) {
    sl.registerLazySingleton<FinanceRemoteDataSource>(
      () => FinanceRemoteDataSourceImpl(sl()),
    );
  }
  if (!sl.isRegistered<FinanceRepository>()) {
    sl.registerLazySingleton<FinanceRepository>(
      () => FinanceRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
    );
  }
  if (!sl.isRegistered<GetFinanceOverviewUseCase>()) {
    sl.registerLazySingleton(() => GetFinanceOverviewUseCase(sl()));
  }
  if (!sl.isRegistered<GetFinanceFormDataUseCase>()) {
    sl.registerLazySingleton(() => GetFinanceFormDataUseCase(sl()));
  }
  if (!sl.isRegistered<FinanceOverviewCubit>()) {
    sl.registerFactory(
      () => FinanceOverviewCubit(getFinanceOverviewUseCase: sl()),
    );
  }
  if (!sl.isRegistered<GetFinanceAccountsUseCase>()) {
    sl.registerLazySingleton(() => GetFinanceAccountsUseCase(sl()));
  }
  if (!sl.isRegistered<CreateFinanceAccountUseCase>()) {
    sl.registerLazySingleton(() => CreateFinanceAccountUseCase(sl()));
  }
  if (!sl.isRegistered<UpdateFinanceAccountUseCase>()) {
    sl.registerLazySingleton(() => UpdateFinanceAccountUseCase(sl()));
  }
  if (!sl.isRegistered<GetFinanceAccountDetailsUseCase>()) {
    sl.registerLazySingleton(() => GetFinanceAccountDetailsUseCase(sl()));
  }
  if (!sl.isRegistered<GetFinanceReceiptsUseCase>()) {
    sl.registerLazySingleton(() => GetFinanceReceiptsUseCase(sl()));
  }
  if (!sl.isRegistered<CreateFinanceReceiptUseCase>()) {
    sl.registerLazySingleton(() => CreateFinanceReceiptUseCase(sl()));
  }
  if (!sl.isRegistered<UpdateFinanceReceiptUseCase>()) {
    sl.registerLazySingleton(() => UpdateFinanceReceiptUseCase(sl()));
  }
  if (!sl.isRegistered<UpdateFinancePaymentUseCase>()) {
    sl.registerLazySingleton(() => UpdateFinancePaymentUseCase(sl()));
  }
  if (!sl.isRegistered<GetFinanceReceiptDetailsUseCase>()) {
    sl.registerLazySingleton(() => GetFinanceReceiptDetailsUseCase(sl()));
  }

  if (!sl.isRegistered<GetFinancePaymentDetailsUseCase>()) {
    sl.registerLazySingleton(() => GetFinancePaymentDetailsUseCase(sl()));
  }
  if (!sl.isRegistered<CancelFinancePaymentUseCase>()) {
    sl.registerLazySingleton(() => CancelFinancePaymentUseCase(sl()));
  }
  if (!sl.isRegistered<CancelFinanceReceiptUseCase>()) {
    sl.registerLazySingleton(() => CancelFinanceReceiptUseCase(sl()));
  }
  if (!sl.isRegistered<GetFinancePaymentsUseCase>()) {
    sl.registerLazySingleton(() => GetFinancePaymentsUseCase(sl()));
  }
  if (!sl.isRegistered<CreateFinancePaymentUseCase>()) {
    sl.registerLazySingleton(() => CreateFinancePaymentUseCase(sl()));
  }

  // Cubits
  if (!sl.isRegistered<FinanceFormDataCubit>()) {
    sl.registerFactory(() => FinanceFormDataCubit(sl()));
  }
  if (!sl.isRegistered<FinanceAccountsCubit>()) {
    sl.registerFactory(() => FinanceAccountsCubit(sl()));
  }
  if (!sl.isRegistered<CreateFinanceAccountCubit>()) {
    sl.registerFactory(() => CreateFinanceAccountCubit(sl()));
  }
  if (!sl.isRegistered<UpdateFinanceAccountCubit>()) {
    sl.registerFactory(
      () => UpdateFinanceAccountCubit(updateAccountUseCase: sl()),
    );
  }
  if (!sl.isRegistered<FinanceAccountDetailsCubit>()) {
    sl.registerFactory(
      () => FinanceAccountDetailsCubit(getAccountDetailsUseCase: sl()),
    );
  }
  if (!sl.isRegistered<FinanceReceiptsCubit>()) {
    sl.registerFactory(() => FinanceReceiptsCubit(sl()));
  }
  if (!sl.isRegistered<CreateFinanceReceiptCubit>()) {
    sl.registerFactory(() => CreateFinanceReceiptCubit(sl()));
  }
  if (!sl.isRegistered<UpdateFinanceReceiptCubit>()) {
    sl.registerFactory(
      () => UpdateFinanceReceiptCubit(updateFinanceReceiptUseCase: sl()),
    );
  }
  if (!sl.isRegistered<UpdateFinancePaymentCubit>()) {
    sl.registerFactory(
      () => UpdateFinancePaymentCubit(updateFinancePaymentUseCase: sl()),
    );
  }
  if (!sl.isRegistered<FinanceReceiptDetailsCubit>()) {
    sl.registerFactory(
      () => FinanceReceiptDetailsCubit(getFinanceReceiptDetailsUseCase: sl()),
    );
  }

  if (!sl.isRegistered<FinancePaymentDetailsCubit>()) {
    sl.registerFactory(
      () => FinancePaymentDetailsCubit(getPaymentDetailsUseCase: sl()),
    );
  }
  if (!sl.isRegistered<CancelFinancePaymentCubit>()) {
    sl.registerFactory(
      () => CancelFinancePaymentCubit(cancelFinancePaymentUseCase: sl()),
    );
  }
  if (!sl.isRegistered<CancelFinanceReceiptCubit>()) {
    sl.registerFactory(
      () => CancelFinanceReceiptCubit(cancelFinanceReceiptUseCase: sl()),
    );
  }
  if (!sl.isRegistered<FinancePaymentsCubit>()) {
    sl.registerFactory(() => FinancePaymentsCubit(sl()));
  }
  if (!sl.isRegistered<CreateFinancePaymentCubit>()) {
    sl.registerFactory(() => CreateFinancePaymentCubit(sl()));
  }

  // Transfers
  if (!sl.isRegistered<TransfersRemoteDataSource>()) {
    sl.registerLazySingleton<TransfersRemoteDataSource>(
      () => TransfersRemoteDataSourceImpl(sl()),
    );
  }
  if (!sl.isRegistered<JournalEntriesRemoteDataSource>()) {
    sl.registerLazySingleton<JournalEntriesRemoteDataSource>(
      () => JournalEntriesRemoteDataSourceImpl(sl()),
    );
  }
  if (!sl.isRegistered<JournalEntriesRepository>()) {
    sl.registerLazySingleton<JournalEntriesRepository>(
      () => JournalEntriesRepositoryImpl(
        remoteDataSource: sl(),
        networkInfo: sl(),
      ),
    );
  }
  if (!sl.isRegistered<TransfersRepository>()) {
    sl.registerLazySingleton<TransfersRepository>(
      () => TransfersRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
    );
  }
  if (!sl.isRegistered<GetTransfersUseCase>()) {
    sl.registerLazySingleton(() => GetTransfersUseCase(sl()));
  }
  if (!sl.isRegistered<CreateTransferUseCase>()) {
    sl.registerLazySingleton(() => CreateTransferUseCase(sl()));
  }
  if (!sl.isRegistered<UpdateTransferUseCase>()) {
    sl.registerLazySingleton(() => UpdateTransferUseCase(sl()));
  }
  if (!sl.isRegistered<ApproveTransferUseCase>()) {
    sl.registerLazySingleton(() => ApproveTransferUseCase(sl()));
  }
  if (!sl.isRegistered<TransfersCubit>()) {
    sl.registerFactory(() => TransfersCubit(sl()));
  }
  if (!sl.isRegistered<CreateTransferCubit>()) {
    sl.registerFactory(() => CreateTransferCubit(sl()));
  }
  if (!sl.isRegistered<UpdateTransferCubit>()) {
    sl.registerFactory(() => UpdateTransferCubit(updateTransferUseCase: sl()));
  }
  if (!sl.isRegistered<ApproveTransferCubit>()) {
    sl.registerFactory(
      () => ApproveTransferCubit(approveTransferUseCase: sl()),
    );
  }
  if (!sl.isRegistered<GetJournalEntriesUseCase>()) {
    sl.registerLazySingleton(() => GetJournalEntriesUseCase(sl()));
    sl.registerLazySingleton(() => CreateJournalEntryUseCase(sl()));
    sl.registerLazySingleton(() => UpdateJournalEntryUseCase(sl()));
    sl.registerLazySingleton(() => PostJournalEntryUseCase(sl()));
    sl.registerLazySingleton(() => ReverseJournalEntryUseCase(sl()));

    // Cubits
    sl.registerFactory(() => JournalEntriesCubit(sl()));
    sl.registerFactory(
      () => CreateJournalEntryCubit(createJournalEntryUseCase: sl()),
    );
    sl.registerFactory(
      () => UpdateJournalEntryCubit(updateJournalEntryUseCase: sl()),
    );
    sl.registerFactory(
      () => PostJournalEntryCubit(postJournalEntryUseCase: sl()),
    );
    sl.registerFactory(
      () => ReverseJournalEntryCubit(reverseJournalEntryUseCase: sl()),
    );
  }
}

void _initMaintenanceNegotiations() {
  if (!sl.isRegistered<MaintenanceNegotiationRemoteDataSource>()) {
    sl.registerLazySingleton<MaintenanceNegotiationRemoteDataSource>(
      () => MaintenanceNegotiationRemoteDataSourceImpl(dio: sl()),
    );
  }
  if (!sl.isRegistered<MaintenanceNegotiationRepository>()) {
    sl.registerLazySingleton<MaintenanceNegotiationRepository>(
      () => MaintenanceNegotiationRepositoryImpl(remoteDataSource: sl()),
    );
  }
  if (!sl.isRegistered<GetNegotiationFormDataUseCase>()) {
    sl.registerLazySingleton(() => GetNegotiationFormDataUseCase(sl()));
  }
  if (!sl.isRegistered<GetNegotiationsListUseCase>()) {
    sl.registerLazySingleton(() => GetNegotiationsListUseCase(sl()));
  }
  if (!sl.isRegistered<CreateNegotiationUseCase>()) {
    sl.registerLazySingleton(() => CreateNegotiationUseCase(sl()));
  }

  // Cubits
  if (!sl.isRegistered<NegotiationFormDataCubit>()) {
    sl.registerFactory(() => NegotiationFormDataCubit(sl()));
  }
  if (!sl.isRegistered<NegotiationsListCubit>()) {
    sl.registerFactory(() => NegotiationsListCubit(sl()));
  }
  if (!sl.isRegistered<CreateNegotiationCubit>()) {
    sl.registerFactory(
      () => CreateNegotiationCubit(createNegotiationUseCase: sl()),
    );
  }
}

void _initUnits() {
  if (!sl.isRegistered<UnitsRemoteDataSource>()) {
    sl.registerLazySingleton<UnitsRemoteDataSource>(
      () => UnitsRemoteDataSourceImpl(sl()),
    );
  }
  if (!sl.isRegistered<UnitsRepository>()) {
    sl.registerLazySingleton<UnitsRepository>(() => UnitsRepositoryImpl(sl()));
  }
  if (!sl.isRegistered<GetPropertyUnitsUseCase>()) {
    sl.registerLazySingleton(() => GetPropertyUnitsUseCase(sl()));
  }
  if (!sl.isRegistered<GetUnitDetailsUseCase>()) {
    sl.registerLazySingleton(() => GetUnitDetailsUseCase(sl()));
  }
  if (!sl.isRegistered<CreateDraftUnitUseCase>()) {
    sl.registerLazySingleton(() => CreateDraftUnitUseCase(sl()));
  }
  if (!sl.isRegistered<CreateUnitUseCase>()) {
    sl.registerLazySingleton(() => CreateUnitUseCase(sl()));
  }
  if (!sl.isRegistered<AutoSaveUnitUseCase>()) {
    sl.registerLazySingleton(() => AutoSaveUnitUseCase(sl()));
  }
  if (!sl.isRegistered<PublishUnitUseCase>()) {
    sl.registerLazySingleton(() => PublishUnitUseCase(sl()));
  }
  if (!sl.isRegistered<UnitsListCubit>()) {
    sl.registerFactory(() => UnitsListCubit(sl()));
  }
  if (!sl.isRegistered<UnitDetailsCubit>()) {
    sl.registerFactory(() => UnitDetailsCubit(sl()));
  }
  if (!sl.isRegistered<UnitDeleteCubit>()) {
    sl.registerFactory(() => UnitDeleteCubit(sl()));
  }
  if (!sl.isRegistered<DeleteUnitUseCase>()) {
    sl.registerLazySingleton(() => DeleteUnitUseCase(sl()));
  }
  if (!sl.isRegistered<UnitCreateCubit>()) {
    sl.registerFactory(() => UnitCreateCubit(sl(), sl()));
  }
  if (!sl.isRegistered<GetUnitsFormDataUseCase>()) {
    sl.registerLazySingleton(() => GetUnitsFormDataUseCase(sl()));
  }
  if (!sl.isRegistered<UpdateUnitUseCase>()) {
    sl.registerLazySingleton(() => UpdateUnitUseCase(sl()));
  }
  if (!sl.isRegistered<UnitEditCubit>()) {
    sl.registerFactory(() => UnitEditCubit(sl(), sl(), sl()));
  }
}

void _initProperties() {
  if (!sl.isRegistered<PropertyDisplayPreferencesLocalDataSource>()) {
    sl.registerLazySingleton<PropertyDisplayPreferencesLocalDataSource>(
      () => PropertyDisplayPreferencesLocalDataSourceImpl(sl()),
    );
  }
  if (!sl.isRegistered<PropertyDisplayPreferencesRepository>()) {
    sl.registerLazySingleton<PropertyDisplayPreferencesRepository>(
      () => PropertyDisplayPreferencesRepositoryImpl(sl()),
    );
  }
  if (!sl.isRegistered<GetPropertyDisplayModeUseCase>()) {
    sl.registerLazySingleton(() => GetPropertyDisplayModeUseCase(sl()));
  }
  if (!sl.isRegistered<SavePropertyDisplayModeUseCase>()) {
    sl.registerLazySingleton(() => SavePropertyDisplayModeUseCase(sl()));
  }
  if (!sl.isRegistered<PropertyDisplayCubit>()) {
    sl.registerFactory(() => PropertyDisplayCubit(sl(), sl()));
  }
  if (!sl.isRegistered<PropertyFilterOptionsCubit>()) {
    sl.registerFactory(() => PropertyFilterOptionsCubit(sl()));
  }
  if (!sl.isRegistered<PropertiesRemoteDataSource>()) {
    sl.registerLazySingleton<PropertiesRemoteDataSource>(
      () => PropertiesRemoteDataSourceImpl(sl()),
    );
  }
  if (!sl.isRegistered<DeedsRemoteDataSource>()) {
    sl.registerLazySingleton<DeedsRemoteDataSource>(
      () => DeedsRemoteDataSourceImpl(sl()),
    );
  }
  if (!sl.isRegistered<PropertiesRepository>()) {
    sl.registerLazySingleton<PropertiesRepository>(
      () => PropertiesRepositoryImpl(remoteDataSource: sl()),
    );
  }
  if (!sl.isRegistered<DeedsRepository>()) {
    sl.registerLazySingleton<DeedsRepository>(() => DeedsRepositoryImpl(sl()));
  }
  if (!sl.isRegistered<GetPropertiesListUseCase>()) {
    sl.registerLazySingleton(() => GetPropertiesListUseCase(sl()));
  }
  if (!sl.isRegistered<GetPropertyFormOptionsUseCase>()) {
    sl.registerLazySingleton(() => GetPropertyFormOptionsUseCase(sl()));
  }
  if (!sl.isRegistered<GetPropertyFormDataUseCase>()) {
    sl.registerLazySingleton(() => GetPropertyFormDataUseCase(sl()));
  }
  if (!sl.isRegistered<GetPropertyDetailsUseCase>()) {
    sl.registerLazySingleton(() => GetPropertyDetailsUseCase(sl()));
  }
  if (!sl.isRegistered<GetDeedsListUseCase>()) {
    sl.registerLazySingleton(() => GetDeedsListUseCase(sl()));
  }
  if (!sl.isRegistered<CreateDeedUseCase>()) {
    sl.registerLazySingleton(() => CreateDeedUseCase(sl()));
  }
  if (!sl.isRegistered<CreateDraftPropertyUseCase>()) {
    sl.registerLazySingleton(() => CreateDraftPropertyUseCase(sl()));
  }
  if (!sl.isRegistered<AutoSavePropertyStepUseCase>()) {
    sl.registerLazySingleton(() => AutoSavePropertyStepUseCase(sl()));
  }
  if (!sl.isRegistered<SyncOwnersUseCase>()) {
    sl.registerLazySingleton(() => SyncOwnersUseCase(sl()));
  }
  if (!sl.isRegistered<UploadTempFileUseCase>()) {
    sl.registerLazySingleton(() => UploadTempFileUseCase(sl()));
  }
  if (!sl.isRegistered<PublishPropertyUseCase>()) {
    sl.registerLazySingleton(() => PublishPropertyUseCase(sl()));
  }
  if (!sl.isRegistered<PublishPropertyCubit>()) {
    sl.registerFactory(() => PublishPropertyCubit(sl()));
  }
  if (!sl.isRegistered<CloneForDeedCubit>()) {
    sl.registerFactory(() => CloneForDeedCubit(sl()));
  }
  if (!sl.isRegistered<PropertiesListCubit>()) {
    sl.registerFactory(() => PropertiesListCubit(sl()));
  }
  if (!sl.isRegistered<PropertyDetailsCubit>()) {
    sl.registerFactory(() => PropertyDetailsCubit(sl(), sl(), sl()));
  }
  if (!sl.isRegistered<PropertyCreateCubit>()) {
    sl.registerLazySingleton(
      () => PropertyCreateCubit(
        createDraft: sl(),
        getFormData: sl(),
        autoSavePropertyStep: sl(),
        uploadTempFile: sl(),
        syncOwners: sl(),
        publishProperty: sl(),
      ),
    );
  }
  if (!sl.isRegistered<ClonePropertyUseCase>()) {
    sl.registerLazySingleton(() => ClonePropertyUseCase(sl()));
  }
  if (!sl.isRegistered<MakeRepresentativeUseCase>()) {
    sl.registerLazySingleton(() => MakeRepresentativeUseCase(sl()));
  }
  if (!sl.isRegistered<RemoveRepresentativeUseCase>()) {
    sl.registerLazySingleton(() => RemoveRepresentativeUseCase(sl()));
  }
  if (!sl.isRegistered<DeletePropertyUseCase>()) {
    sl.registerLazySingleton(() => DeletePropertyUseCase(sl()));
  }
  if (!sl.isRegistered<PatchPropertyUseCase>()) {
    sl.registerLazySingleton(() => PatchPropertyUseCase(sl()));
  }
  if (!sl.isRegistered<AutoSaveDeedStepUseCase>()) {
    sl.registerLazySingleton(() => AutoSaveDeedStepUseCase(sl()));
  }
  if (!sl.isRegistered<AutoSaveTypeStepUseCase>()) {
    sl.registerLazySingleton(() => AutoSaveTypeStepUseCase(sl()));
  }
  if (!sl.isRegistered<PropertyEditCubit>()) {
    sl.registerFactory(
      () => PropertyEditCubit(
        patchProperty: sl(),
        getFormData: sl(),
        autoSaveDeedStep: sl(),
        autoSaveTypeStep: sl(),
      ),
    );
  }
  if (!sl.isRegistered<DeletePropertyCubit>()) {
    sl.registerFactory(() => DeletePropertyCubit(sl()));
  }
  if (!sl.isRegistered<SyncOwnersCubit>()) {
    sl.registerFactory(() => SyncOwnersCubit(sl(), sl()));
  }
}

void _initDashboard() {
  if (!sl.isRegistered<OwnerDashboardRemoteDataSource>()) {
    sl.registerLazySingleton<OwnerDashboardRemoteDataSource>(
      () => OwnerDashboardRemoteDataSourceImpl(sl()),
    );
  }
  if (!sl.isRegistered<OwnerDashboardRepository>()) {
    sl.registerLazySingleton<OwnerDashboardRepository>(
      () => OwnerDashboardRepositoryImpl(sl()),
    );
  }
  if (!sl.isRegistered<GetOwnerDashboardUseCase>()) {
    sl.registerLazySingleton(() => GetOwnerDashboardUseCase(sl()));
  }
  if (!sl.isRegistered<OwnerDashboardCubit>()) {
    sl.registerFactory(() => OwnerDashboardCubit(sl(), sl()));
  }
}

void _initContracts() {
  if (!sl.isRegistered<OwnerContractsRemoteDataSource>()) {
    sl.registerLazySingleton<OwnerContractsRemoteDataSource>(
      () => OwnerContractsRemoteDataSourceImpl(sl()),
    );
  }
  if (!sl.isRegistered<OwnerContractsRepository>()) {
    sl.registerLazySingleton<OwnerContractsRepository>(
      () => OwnerContractsRepositoryImpl(sl()),
    );
  }
  if (!sl.isRegistered<GetOwnerContractsUseCase>()) {
    sl.registerLazySingleton(() => GetOwnerContractsUseCase(sl()));
  }
  if (!sl.isRegistered<GetOwnerContractDetailsUseCase>()) {
    sl.registerLazySingleton(() => GetOwnerContractDetailsUseCase(sl()));
  }
  if (!sl.isRegistered<GetOwnerContractInstallmentsUseCase>()) {
    sl.registerLazySingleton(() => GetOwnerContractInstallmentsUseCase(sl()));
  }
  if (!sl.isRegistered<OwnerContractsCubit>()) {
    sl.registerFactory(() => OwnerContractsCubit(sl()));
  }
  if (!sl.isRegistered<OwnerContractDetailsCubit>()) {
    sl.registerFactory(() => OwnerContractDetailsCubit(sl()));
  }
  if (!sl.isRegistered<OwnerContractInstallmentsCubit>()) {
    sl.registerFactory(() => OwnerContractInstallmentsCubit(sl()));
  }
}

void _initMaintenance() {
  if (!sl.isRegistered<OwnerMaintenanceRemoteDataSource>()) {
    sl.registerLazySingleton<OwnerMaintenanceRemoteDataSource>(
      () => OwnerMaintenanceRemoteDataSourceImpl(sl()),
    );
  }
  if (!sl.isRegistered<OwnerMaintenanceRepository>()) {
    sl.registerLazySingleton<OwnerMaintenanceRepository>(
      () => OwnerMaintenanceRepositoryImpl(sl()),
    );
  }
  if (!sl.isRegistered<GetOwnerMaintenanceUseCase>()) {
    sl.registerLazySingleton(() => GetOwnerMaintenanceUseCase(sl()));
  }
  if (!sl.isRegistered<GetOwnerMaintenanceDetailsUseCase>()) {
    sl.registerLazySingleton(() => GetOwnerMaintenanceDetailsUseCase(sl()));
  }
  if (!sl.isRegistered<CreateOwnerMaintenanceUseCase>()) {
    sl.registerLazySingleton(() => CreateOwnerMaintenanceUseCase(sl()));
  }
  if (!sl.isRegistered<OwnerMaintenanceCubit>()) {
    sl.registerFactory(() => OwnerMaintenanceCubit(sl()));
  }
  if (!sl.isRegistered<OwnerMaintenanceDetailsCubit>()) {
    sl.registerFactory(() => OwnerMaintenanceDetailsCubit(sl()));
  }
  if (!sl.isRegistered<GetOwnerMaintenanceFormDataUseCase>()) {
    sl.registerLazySingleton(() => GetOwnerMaintenanceFormDataUseCase(sl()));
  }
  if (!sl.isRegistered<OwnerCreateMaintenanceCubit>()) {
    sl.registerFactory(() => OwnerCreateMaintenanceCubit(sl(), sl()));
  }
  if (!sl.isRegistered<UpdateOwnerMaintenanceUseCase>()) {
    sl.registerLazySingleton(() => UpdateOwnerMaintenanceUseCase(sl()));
  }
  if (!sl.isRegistered<OwnerUpdateMaintenanceCubit>()) {
    sl.registerFactory(() => OwnerUpdateMaintenanceCubit(sl(), sl()));
  }
  if (!sl.isRegistered<DeleteOwnerMaintenanceUseCase>()) {
    sl.registerLazySingleton(() => DeleteOwnerMaintenanceUseCase(sl()));
  }
  if (!sl.isRegistered<OwnerDeleteMaintenanceCubit>()) {
    sl.registerFactory(() => OwnerDeleteMaintenanceCubit(sl()));
  }
  if (!sl.isRegistered<ApproveOwnerMaintenanceUseCase>()) {
    sl.registerLazySingleton(() => ApproveOwnerMaintenanceUseCase(sl()));
  }

  if (!sl.isRegistered<RejectOwnerMaintenanceUseCase>()) {
    sl.registerLazySingleton(() => RejectOwnerMaintenanceUseCase(sl()));
  }

  if (!sl.isRegistered<OwnerApproveMaintenanceCubit>()) {
    sl.registerFactory(() => OwnerApproveMaintenanceCubit(sl()));
  }

  if (!sl.isRegistered<OwnerRejectMaintenanceCubit>()) {
    sl.registerFactory(() => OwnerRejectMaintenanceCubit(sl()));
  }

  if (!sl.isRegistered<AssignOwnerMaintenanceUseCase>()) {
    sl.registerLazySingleton(() => AssignOwnerMaintenanceUseCase(sl()));
  }

  if (!sl.isRegistered<OwnerAssignMaintenanceCubit>()) {
    sl.registerFactory(() => OwnerAssignMaintenanceCubit(sl()));
  }

  if (!sl.isRegistered<StartOwnerMaintenanceUseCase>()) {
    sl.registerLazySingleton(() => StartOwnerMaintenanceUseCase(sl()));
  }

  if (!sl.isRegistered<OwnerStartMaintenanceCubit>()) {
    sl.registerFactory(() => OwnerStartMaintenanceCubit(sl()));
  }

  if (!sl.isRegistered<CompleteOwnerMaintenanceTaskUseCase>()) {
    sl.registerLazySingleton(() => CompleteOwnerMaintenanceTaskUseCase(sl()));
  }
  if (!sl.isRegistered<ExecuteOwnerMaintenanceUseCase>()) {
    sl.registerLazySingleton(() => ExecuteOwnerMaintenanceUseCase(sl()));
  }

  if (!sl.isRegistered<VerifyCloseOwnerMaintenanceUseCase>()) {
    sl.registerLazySingleton(() => VerifyCloseOwnerMaintenanceUseCase(sl()));
  }
  if (!sl.isRegistered<ForwardOwnerMaintenanceUseCase>()) {
    sl.registerLazySingleton(() => ForwardOwnerMaintenanceUseCase(sl()));
  }

  if (!sl.isRegistered<OwnerCompleteTaskCubit>()) {
    sl.registerFactory(() => OwnerCompleteTaskCubit(sl()));
  }

  if (!sl.isRegistered<OwnerExecuteMaintenanceCubit>()) {
    sl.registerFactory(
      () => OwnerExecuteMaintenanceCubit(executeMaintenanceUseCase: sl()),
    );
  }

  if (!sl.isRegistered<OwnerVerifyCloseMaintenanceCubit>()) {
    sl.registerFactory(
      () => OwnerVerifyCloseMaintenanceCubit(verifyCloseUseCase: sl()),
    );
  }
  if (!sl.isRegistered<OwnerForwardMaintenanceCubit>()) {
    sl.registerFactory(() => OwnerForwardMaintenanceCubit(sl()));
  }
}

void _initReports() {
  if (!sl.isRegistered<OwnerReportsRemoteDataSource>()) {
    sl.registerLazySingleton<OwnerReportsRemoteDataSource>(
      () => OwnerReportsRemoteDataSourceImpl(sl()),
    );
  }
  if (!sl.isRegistered<OwnerReportsRepository>()) {
    sl.registerLazySingleton<OwnerReportsRepository>(
      () => OwnerReportsRepositoryImpl(sl()),
    );
  }
  if (!sl.isRegistered<GetOwnerRevenueReportUseCase>()) {
    sl.registerLazySingleton(() => GetOwnerRevenueReportUseCase(sl()));
  }
  if (!sl.isRegistered<GetOwnerReportsIndexUseCase>()) {
    sl.registerLazySingleton(() => GetOwnerReportsIndexUseCase(sl()));
  }
  if (!sl.isRegistered<OwnerReportsIndexCubit>()) {
    sl.registerFactory(
      () => OwnerReportsIndexCubit(getReportsIndexUseCase: sl()),
    );
  }
  if (!sl.isRegistered<GetOwnerOccupancyReportUseCase>()) {
    sl.registerLazySingleton(() => GetOwnerOccupancyReportUseCase(sl()));
  }
  if (!sl.isRegistered<GetOwnerDefaultersReportUseCase>()) {
    sl.registerLazySingleton(() => GetOwnerDefaultersReportUseCase(sl()));
  }
  if (!sl.isRegistered<GetOwnerUnitsStatusReportUseCase>()) {
    sl.registerLazySingleton(() => GetOwnerUnitsStatusReportUseCase(sl()));
  }
  if (!sl.isRegistered<OwnerRevenueCubit>()) {
    sl.registerFactory(() => OwnerRevenueCubit(sl()));
  }
  if (!sl.isRegistered<OwnerOccupancyCubit>()) {
    sl.registerFactory(() => OwnerOccupancyCubit(sl()));
  }
  if (!sl.isRegistered<OwnerDefaultersCubit>()) {
    sl.registerFactory(() => OwnerDefaultersCubit(sl()));
  }
  if (!sl.isRegistered<OwnerUnitsStatusCubit>()) {
    sl.registerFactory(() => OwnerUnitsStatusCubit(sl()));
  }
  if (!sl.isRegistered<GetContractsReportUseCase>()) {
    sl.registerLazySingleton(() => GetContractsReportUseCase(sl()));
  }
  if (!sl.isRegistered<OwnerContractsReportCubit>()) {
    sl.registerFactory(
      () => OwnerContractsReportCubit(getContractsReportUseCase: sl()),
    );
  }

  // Owner Contracts Movement Report
  sl.registerLazySingleton<GetOwnerContractsMovementReportUseCase>(
    () => GetOwnerContractsMovementReportUseCase(sl()),
  );
  sl.registerFactory<OwnerContractsMovementCubit>(
    () => OwnerContractsMovementCubit(sl()),
  );

  // Owner Maintenance Requests Report
  sl.registerLazySingleton<GetOwnerMaintenanceRequestsReportUseCase>(
    () => GetOwnerMaintenanceRequestsReportUseCase(sl()),
  );
  sl.registerFactory<OwnerMaintenanceRequestsCubit>(
    () => OwnerMaintenanceRequestsCubit(sl()),
  );

  // Owner Technician Performance Report
  sl.registerLazySingleton<GetOwnerTechnicianPerformanceReportUseCase>(
    () => GetOwnerTechnicianPerformanceReportUseCase(sl()),
  );
  sl.registerFactory<OwnerTechnicianPerformanceCubit>(
    () => OwnerTechnicianPerformanceCubit(sl()),
  );

  // Owner Employee Tasks Report
  sl.registerLazySingleton<GetOwnerEmployeeTasksReportUseCase>(
    () => GetOwnerEmployeeTasksReportUseCase(sl()),
  );
  sl.registerFactory<OwnerEmployeeTasksCubit>(
    () => OwnerEmployeeTasksCubit(sl()),
  );

  // Owner Activity Logs Report
  sl.registerLazySingleton<GetOwnerActivityLogsReportUseCase>(
    () => GetOwnerActivityLogsReportUseCase(sl()),
  );
  sl.registerFactory<OwnerActivityLogsCubit>(
    () => OwnerActivityLogsCubit(sl()),
  );

  // Owner Approvals Report
  sl.registerLazySingleton<GetApprovalsReportUseCase>(
    () => GetApprovalsReportUseCase(sl()),
  );
  sl.registerFactory<OwnerApprovalsReportCubit>(
    () => OwnerApprovalsReportCubit(getApprovalsReportUseCase: sl()),
  );

  sl.registerLazySingleton<GetLegalCasesReportUseCase>(
    () => GetLegalCasesReportUseCase(sl()),
  );
  sl.registerFactory<OwnerLegalCasesReportCubit>(
    () => OwnerLegalCasesReportCubit(getLegalCasesReportUseCase: sl()),
  );
}

void _initTasks() {
  if (!sl.isRegistered<TasksRemoteDataSource>()) {
    sl.registerLazySingleton<TasksRemoteDataSource>(
      () => TasksRemoteDataSourceImpl(dio: sl()),
    );
  }
  if (!sl.isRegistered<TasksRepository>()) {
    sl.registerLazySingleton<TasksRepository>(
      () => TasksRepositoryImpl(remoteDataSource: sl()),
    );
  }
  if (!sl.isRegistered<GetTasksUseCase>()) {
    sl.registerLazySingleton(() => GetTasksUseCase(sl()));
  }
  if (!sl.isRegistered<TasksListCubit>()) {
    sl.registerFactory(() => TasksListCubit(sl()));
  }
  if (!sl.isRegistered<GetTaskDetailsUseCase>()) {
    sl.registerLazySingleton(() => GetTaskDetailsUseCase(sl()));
  }
  if (!sl.isRegistered<TaskDetailsCubit>()) {
    sl.registerFactory(() => TaskDetailsCubit(sl()));
  }
  if (!sl.isRegistered<CreateTaskUseCase>()) {
    sl.registerLazySingleton(() => CreateTaskUseCase(sl()));
  }
  if (!sl.isRegistered<GetTaskFormDataUseCase>()) {
    sl.registerLazySingleton(() => GetTaskFormDataUseCase(sl()));
  }
  if (!sl.isRegistered<CreateTaskCubit>()) {
    sl.registerFactory(() => CreateTaskCubit(createTaskUseCase: sl()));
  }
  if (!sl.isRegistered<TaskFormDataCubit>()) {
    sl.registerFactory(() => TaskFormDataCubit(getTaskFormDataUseCase: sl()));
  }
  if (!sl.isRegistered<UpdateTaskUseCase>()) {
    sl.registerLazySingleton(() => UpdateTaskUseCase(sl()));
  }
  if (!sl.isRegistered<UpdateTaskCubit>()) {
    sl.registerFactory(() => UpdateTaskCubit(sl()));
  }
  if (!sl.isRegistered<DeleteTaskUseCase>()) {
    sl.registerLazySingleton(() => DeleteTaskUseCase(repository: sl()));
  }
  if (!sl.isRegistered<DeleteTaskCubit>()) {
    sl.registerFactory(() => DeleteTaskCubit(sl()));
  }
  if (!sl.isRegistered<UpdateTaskStatusUseCase>()) {
    sl.registerLazySingleton(() => UpdateTaskStatusUseCase(sl()));
  }
  if (!sl.isRegistered<UpdateTaskStatusCubit>()) {
    sl.registerFactory(() => UpdateTaskStatusCubit(updateTaskStatusUseCase: sl()));
  }
  if (!sl.isRegistered<UpdateTaskProgressUseCase>()) {
    sl.registerLazySingleton(() => UpdateTaskProgressUseCase(sl()));
  }
  if (!sl.isRegistered<UpdateTaskProgressCubit>()) {
    sl.registerFactory(() => UpdateTaskProgressCubit(updateTaskProgressUseCase: sl()));
  }
  if (!sl.isRegistered<UpdateTaskPriorityUseCase>()) {
    sl.registerLazySingleton(() => UpdateTaskPriorityUseCase(sl()));
  }
  if (!sl.isRegistered<UpdateTaskPriorityCubit>()) {
    sl.registerFactory(() => UpdateTaskPriorityCubit(updateTaskPriorityUseCase: sl()));
  }
  if (!sl.isRegistered<UpdateTaskDatesUseCase>()) {
    sl.registerLazySingleton(() => UpdateTaskDatesUseCase(sl()));
  }
  if (!sl.isRegistered<UpdateTaskDatesCubit>()) {
    sl.registerFactory(() => UpdateTaskDatesCubit(updateTaskDatesUseCase: sl()));
  }
  if (!sl.isRegistered<AddTaskCommentUseCase>()) {
    sl.registerLazySingleton(() => AddTaskCommentUseCase(sl()));
  }
  if (!sl.isRegistered<AddTaskCommentCubit>()) {
    sl.registerFactory(() => AddTaskCommentCubit(addTaskCommentUseCase: sl()));
  }
  if (!sl.isRegistered<AddTaskAssigneeUseCase>()) {
    sl.registerLazySingleton(() => AddTaskAssigneeUseCase(sl()));
  }
  if (!sl.isRegistered<AddTaskAssigneeCubit>()) {
    sl.registerFactory(() => AddTaskAssigneeCubit(addTaskAssigneeUseCase: sl()));
  }
  if (!sl.isRegistered<RemoveTaskAssigneeUseCase>()) {
    sl.registerLazySingleton(() => RemoveTaskAssigneeUseCase(sl()));
  }
  if (!sl.isRegistered<RemoveTaskAssigneeCubit>()) {
    sl.registerFactory(() => RemoveTaskAssigneeCubit(removeTaskAssigneeUseCase: sl()));
  }
}
