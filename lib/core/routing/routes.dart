class Routes {
  Routes._();

  static const String home = '/';
  static const String splash = '/splash';
  static const String login = '/login';
  static const String unsupportedAccount = '/unsupported-account';
  static const String routeError = '/route-error';
  static const String ownerMain = '/owner-main';
  static const String ownerDashboard = '/owner-main/dashboard';
  static const String ownerProperties = '/owner-main/properties';
  static const String ownerContracts = '/owner-main/contracts';
  static const String ownerContractDetails = '/owner-contracts/:id';
  static const String ownerContractInstallments =
      '/owner-contracts/:id/installments';
  static const String ownerFinance = '/owner-main/finance';
  static const String ownerFinanceAccounts = '/owner-main/finance/accounts';
  static const String ownerFinanceAccountCreate =
      '/owner-main/finance/accounts/create';
  static const String ownerFinanceAccountUpdate =
      '/owner-main/finance/accounts/update';
  static const String ownerFinanceAccountDetails =
      '/owner-main/finance/accounts/details/:id';
  static const String ownerFinanceReceipts = '/owner-main/finance/receipts';
  static const String ownerFinanceReceiptCreate =
      '/owner-main/finance/receipts/create';
  static const String ownerFinanceReceiptUpdate =
      '/owner-main/finance/receipts/update';
  static const String ownerFinancePayments = '/owner-main/finance/payments';
  static const String ownerFinancePaymentUpdate =
      '/owner-main/finance/payments/update';
  static const String ownerFinanceCreatePayment =
      '/owner-main/finance/payments/create';
  static const String ownerFinancePaymentDetails =
      '/owner-main/finance/payments/details/:id';
  static const String ownerFinanceTransfers = '/owner-main/finance/transfers';
  static const String ownerFinanceCreateTransfer =
      '/owner-main/finance/transfers/create';
  static const String ownerFinanceUpdateTransfer =
      '/owner-main/finance/transfers/update';
  static const String ownerFinanceJournalEntries =
      '/owner-main/finance/journal-entries';
  static const String ownerFinanceCreateJournalEntry =
      '/owner-main/finance/journal-entries/create';
  static const String ownerFinanceUpdateJournalEntry =
      '/owner-main/finance/journal-entries/update';
  static const String ownerFinanceReceiptDetails =
      '/owner-main/finance/receipts/details/:id';
  static const String ownerProfile = '/owner-main/profile';
  static const String notifications = '/notifications';
  static const String ownerMaintenance = '/owner-maintenance';
  static const String ownerMaintenanceDetails = '/owner-maintenance/details';
  static const String ownerMaintenanceCreate = '/owner-maintenance/create';
  static const String ownerMaintenanceEdit = '/owner-maintenance/edit';
  static const String ownerTechniciansList = '/owner-technicians/list';
  static const String ownerTechnicianCreate = '/owner-technician/create';
  static const String ownerSupervisorsList = '/owner-supervisors/list';
  static const String ownerSupervisorCreate = '/owner-supervisors/create';
  static const String ownerNegotiationsList = '/owner-negotiations/list';
  static const String ownerNegotiationSettings = '/owner-negotiations/settings';
  static const String ownerReportsCenter = '/owner-reports';
  static const String ownerLegalCases = '/owner-legal-cases';
  static const String ownerLegalCaseDetails = 'details/:id';
  static const String ownerLegalCaseCreate = 'create'; // Sub-route
  static const String ownerLegalCaseEdit = 'edit'; // Sub-route
  static const String editProfile = '/edit-profile';
  static const String changePassword = '/change-password';

  // Properties sub-routes
  static const String ownerPropertyDetails = '/owner-property-details';
  static const String ownerPropertyCreate = '/owner-property-create';
  static const String ownerPropertyEdit = '/owner-property-edit';
  static const String ownerPropertyUnitDetails = '/owner-property-unit-details';
  static const String ownerUnitCreate = '/owner-unit-create';
  static const String ownerUnitEdit = '/owner-unit-edit';
  static const String ownerDeeds = '/owner-deeds';
  static const String ownerDeedsCreate = '/owner-deeds-create';
  static const String ownerDeedDetails = '/owner-deed-details';

  static String ownerContractDetailsPath(String id) => '/owner-contracts/$id';

  static String ownerContractInstallmentsPath(String id) =>
      '/owner-contracts/$id/installments';

  // Reports sub-routes
  static const String ownerRevenueReport = '/owner-revenue-report';
  static const String ownerOccupancyReport = '/owner-occupancy-report';
  static const String ownerDefaultersReport = '/owner-defaulters-report';
  static const String ownerUnitsStatusReport = '/owner/reports/units-status';
  static const String ownerContractsReport = '/owner/reports/contracts';
  static const String ownerContractsMovementReport =
      '/owner/reports/contracts-movement';
  static const String ownerReportsApprovals = '/owner/reports/approvals';
  static const String ownerReportsLegalCases = '/owner/reports/legal-cases';
  static const String ownerMaintenanceRequestsReport =
      '/owner/reports/maintenance-requests';
  static const String ownerTechnicianPerformanceReport =
      '/owner/reports/technician-performance';
  static const String ownerEmployeeTasksReport =
      '/owner/reports/employee-tasks';
  static const String ownerTasks = '/owner/tasks';
  static const String ownerActivityLogsReport = '/owner/reports/activity-logs';
}
