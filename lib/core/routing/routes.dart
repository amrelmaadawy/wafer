class Routes {
  Routes._();

  // --- Auth & Common ---
  static const String home = '/';
  static const String splash = '/splash';
  static const String login = '/login';
  static const String unsupportedAccount = '/unsupported-account';
  static const String routeError = '/route-error';
  static const String changePassword = '/change-password';
  static const String editProfile = '/edit-profile';
  static const String notifications = '/notifications';

  // --- Shell (Bottom Nav Tabs) ---
  static const String ownerMain = '/owner-main';
  static const String ownerDashboard = '/owner-main/dashboard';
  static const String ownerProperties = '/owner-main/properties';
  static const String ownerContracts = '/owner-main/contracts';
  static const String ownerFinance = '/owner-main/finance';
  static const String ownerProfile = '/owner-main/profile';
  static const String ownerSettings = '/owner-main/settings';

  // --- Finance Sub-sections (Keep as is) ---
  static const String ownerFinanceAccounts = '/owner-main/finance/accounts';
  static const String ownerFinanceAccountCreate = '/owner-main/finance/accounts/create';
  static const String ownerFinanceAccountUpdate = '/owner-main/finance/accounts/update';
  static const String ownerFinanceAccountDetails = '/owner-main/finance/accounts/details/:id';
  static const String ownerFinanceReceipts = '/owner-main/finance/receipts';
  static const String ownerFinanceReceiptCreate = '/owner-main/finance/receipts/create';
  static const String ownerFinanceReceiptUpdate = '/owner-main/finance/receipts/update';
  static const String ownerFinanceReceiptDetails = '/owner-main/finance/receipts/details/:id';
  static const String ownerFinancePayments = '/owner-main/finance/payments';
  static const String ownerFinancePaymentUpdate = '/owner-main/finance/payments/update';
  static const String ownerFinanceCreatePayment = '/owner-main/finance/payments/create';
  static const String ownerFinancePaymentDetails = '/owner-main/finance/payments/details/:id';
  static const String ownerFinanceTransfers = '/owner-main/finance/transfers';
  static const String ownerFinanceCreateTransfer = '/owner-main/finance/transfers/create';
  static const String ownerFinanceUpdateTransfer = '/owner-main/finance/transfers/update';
  static const String ownerFinanceJournalEntries = '/owner-main/finance/journal-entries';
  static const String ownerFinanceCreateJournalEntry = '/owner-main/finance/journal-entries/create';
  static const String ownerFinanceUpdateJournalEntry = '/owner-main/finance/journal-entries/update';


  // --- Contracts ---
  static const String ownerContractDetails = '/owner/contracts/:contractId';
  static const String ownerContractInstallments = '/owner/contracts/:contractId/installments';
  static String ownerContractDetailsPath(String id) => '/owner/contracts/$id';
  static String ownerContractInstallmentsPath(String id) => '/owner/contracts/$id/installments';

  // --- Properties ---
  static const String ownerPropertyDetails = '/owner/properties/:propertyId';
  static const String ownerPropertyCreate = '/owner/properties/create';
  static const String ownerPropertyEdit = '/owner/properties/:propertyId/edit';
  static const String ownerPropertyUnitDetails = '/owner/properties/:propertyId/units/:unitId';
  static const String ownerUnitCreate = '/owner/properties/:propertyId/units/create';
  static const String ownerUnitEdit = '/owner/properties/:propertyId/units/:unitId/edit';
  
  static String ownerPropertyDetailsPath(String id) => '/owner/properties/$id';
  static String ownerPropertyEditPath(String id) => '/owner/properties/$id/edit';
  static String ownerUnitDetailsPath(String propId, String unitId) => '/owner/properties/$propId/units/$unitId';
  static String ownerUnitCreatePath(String propId) => '/owner/properties/$propId/units/create';
  static String ownerUnitEditPath(String propId, String unitId) => '/owner/properties/$propId/units/$unitId/edit';

  // --- Maintenance ---
  static const String ownerMaintenance = '/owner/maintenance';
  static const String ownerMaintenanceDetails = '/owner/maintenance/:maintenanceId';
  static const String ownerMaintenanceCreate = '/owner/maintenance/create';
  static const String ownerMaintenanceEdit = '/owner/maintenance/:maintenanceId/edit';
  static String ownerMaintenanceDetailsPath(String id) => '/owner/maintenance/$id';
  static String ownerMaintenanceEditPath(String id) => '/owner/maintenance/$id/edit';

  // --- Tasks ---
  static const String ownerTasks = '/owner/tasks';
  static const String ownerTaskDetails = '/owner/tasks/:taskId';
  static const String ownerTasksCreate = '/owner/tasks/create';
  static const String ownerTasksEdit = '/owner/tasks/:taskId/edit';
  static String ownerTaskDetailsPath(String id) => '/owner/tasks/$id';
  static String ownerTaskEditPath(String id) => '/owner/tasks/$id/edit';

  // --- Legal Cases ---
  static const String ownerLegalCases = '/owner/legal-cases';
  static const String ownerLegalCaseDetails = '/owner/legal-cases/:caseId';
  static const String ownerLegalCaseCreate = '/owner/legal-cases/create';
  static const String ownerLegalCaseEdit = '/owner/legal-cases/:caseId/edit';
  static String ownerLegalCaseDetailsPath(String id) => '/owner/legal-cases/$id';
  static String ownerLegalCaseEditPath(String id) => '/owner/legal-cases/$id/edit';

  // --- Deeds ---
  static const String ownerDeeds = '/owner/deeds';
  static const String ownerDeedDetails = '/owner/deeds/:deedId';
  static const String ownerDeedsCreate = '/owner/deeds/create';
  static String ownerDeedDetailsPath(String id) => '/owner/deeds/$id';

  // --- Technicians & Supervisors ---
  static const String ownerTechniciansList = '/owner/technicians';
  static const String ownerTechnicianCreate = '/owner/technicians/create';
  static const String ownerSupervisorsList = '/owner/supervisors';
  static const String ownerSupervisorCreate = '/owner/supervisors/create';

  // --- Clients ---
  static const String ownerClientsList = '/owner/clients';
  static const String ownerClientsSearch = '/owner/clients/search';
  static const String ownerClientDetails = '/owner/clients/:clientId';
  static const String ownerClientStatement = '/owner/clients/:clientId/statement';
  static String ownerClientDetailsPath(String id) => '/owner/clients/$id';
  static String ownerClientStatementPath(String id) => '/owner/clients/$id/statement';

  // --- Negotiations ---
  static const String ownerNegotiationsList = '/owner/negotiations';
  static const String ownerNegotiationSettings = '/owner/negotiations/settings';

  // --- Reports ---
  static const String ownerReportsCenter = '/owner/reports';
  static const String ownerRevenueReport = '/owner/reports/revenue';
  static const String ownerOccupancyReport = '/owner/reports/occupancy';
  static const String ownerDefaultersReport = '/owner/reports/defaulters';
  static const String ownerUnitsStatusReport = '/owner/reports/units-status';
  static const String ownerUnitsList = '/owner/units-list';
  static const String ownerContractsReport = '/owner/reports/contracts';
  static const String ownerContractsMovementReport = '/owner/reports/contracts-movement';
  static const String ownerReportsApprovals = '/owner/reports/approvals';
  static const String ownerReportsLegalCases = '/owner/reports/legal-cases';
  static const String ownerMaintenanceRequestsReport = '/owner/reports/maintenance-requests';
  static const String ownerTechnicianPerformanceReport = '/owner/reports/technician-performance';
  static const String ownerEmployeeTasksReport = '/owner/reports/employee-tasks';
  static const String ownerActivityLogsReport = '/owner/reports/activity-logs';

  // --- Search ---
  static const String ownerSearch = '/owner/search';

  // --- Warehouse ---
  static const String ownerWarehouse = '/owner/warehouse';
  static const String ownerWarehouseItems = '/owner/warehouse/items';
}
