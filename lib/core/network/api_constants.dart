class ApiConstants {
  ApiConstants._();

  /// Base URL for mobile API v1
  static const String baseUrl = 'https://codra.cloud/api/v1/mobile/';

  /// Default timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 60);

  /// Headers
  static const String contentTypeHeader = 'Content-Type';
  static const String acceptHeader = 'Accept';
  static const String applicationJson = 'application/json';
  static const String authorizationHeader = 'Authorization';
  static const String bearerPrefix = 'Bearer ';
  static const String localeHeader = 'Accept-Language';

  /// Shared Endpoints
  static const String sharedProfile = 'shared/profile';
  static const String sharedChangePassword = 'shared/change-password';
  static const String sharedUpdateAvatar = 'shared/update-avatar';
  static const String sharedNotifications = 'shared/notifications';
  static const String sharedUnreadCount = 'shared/notifications/unread-count';
  static const String sharedLogout = 'shared/logout';

  /// Owner Endpoints
  static const String ownerDashboard = 'owner/dashboard';
  static const String ownerTransfers = 'owner/accounting/transfers';
  static const String ownerAccountingJournalEntries =
      'owner/accounting/journal-entries';
  static const String ownerContracts = 'owner/contracts';

  // Owner Finance/Accounting
  static const String ownerAccounting = 'owner/accounting';
  static const String ownerAccountingFormData = 'owner/accounting/form-data';
  static const String ownerAccountingAccounts = 'owner/accounting/accounts';
  static String ownerAccountingAccountDetails(int id) =>
      'owner/accounting/accounts/$id';
  static const String ownerAccountingReceipts = 'owner/accounting/receipts';
  static const String ownerAccountingPayments = 'owner/accounting/payments';
  static const String ownerAccountingTransactions = 'owner/accounting/transactions';
  static const String ownerAccountingReceivables = 'owner/accounting/receivables';
  static const String ownerAccountingPayables = 'owner/accounting/payables';

  static const String ownerMaintenance = 'owner/maintenance-requests';
  static String ownerMaintenanceDetails(int id) =>
      'owner/maintenance-requests/$id';
  static String ownerMaintenanceApprove(int id) =>
      'owner/maintenance-requests/$id/approve';
  static const String ownerReportsIndex = 'owner/reports';
  static const String ownerRevenueReport = 'owner/reports/revenue';
  static const String ownerOccupancyReport = 'owner/reports/occupancy';
  static const String ownerOccupancyRatesReport =
      'owner/reports/occupancy-rates';
  static const String ownerUnitsStatusReport = 'owner/reports/units-status';
  static const String ownerContractsReport = 'owner/reports/contracts';
  static const String ownerDefaultersReport = 'owner/reports/defaulters';
  static const String ownerContractsMovementReport =
      'owner/reports/contracts-movement';
  static const String ownerMaintenanceRequestsReport =
      'owner/reports/maintenance-requests';
  static const String ownerTechnicianPerformanceReport =
      'owner/reports/technician-performance';
  static const String ownerEmployeeTasksReport = 'owner/reports/employee-tasks';
  static const String ownerTasksFormData = 'owner/tasks/form-data';
  static const String ownerActivityLogsReport = 'owner/reports/activity-logs';
  static const String ownerReportsLegalCases = 'owner/reports/legal-cases';
  static const String ownerMaintenanceTechniciansFormData =
      'owner/maintenance-technicians/form-data';
  static const String ownerMaintenanceTechnicians =
      'owner/maintenance-technicians';
  static const String ownerMaintenanceSupervisors =
      'owner/maintenance-supervisors';
  static const String ownerMaintenanceSupervisorsFormData =
      'owner/maintenance-supervisors/form-data';

  // Owner Properties & Deeds
  static const String ownerProperties = 'owner/properties';
  static const String ownerDeeds = 'owner/deeds';
  static const String ownerFormData = 'owner/properties/form-data';
  static String ownerDeedDetails(int id) => 'owner/deeds/$id';
  static const String ownerCreateDeed = 'owner/deeds';
  static const String ownerCreateDraftProperty = 'owner/properties/draft';
  static String ownerAutoSaveProperty(int id) =>
      'owner/properties/$id/auto-save';
  static String ownerSyncOwners(int id) => 'owner/properties/$id/owners/sync';
  static const String ownerUploadTempFile = 'owner/properties/upload-temp';
  static String ownerPropertyDetails(int id) => 'owner/properties/$id';
  static String ownerPublishProperty(int id) => 'owner/properties/$id/publish';
  static String ownerCloneProperty(int id) => 'owner/properties/$id/clone';
  static String ownerCloneForDeed(int id) =>
      'owner/properties/$id/clone-for-deed';
  static String ownerDeleteProperty(int id) => 'owner/properties/$id';
  static String ownerPatchProperty(int id) => 'owner/properties/$id';
  static const String ownerStoreProperty = 'owner/properties';

  // Representatives
  static String ownerMakeRepresentative(int propertyId, int ownerId) =>
      'owner/properties/$propertyId/owners/$ownerId/make-representative';
  static String ownerRemoveRepresentative(int propertyId, int ownerId) =>
      'owner/properties/$propertyId/owners/$ownerId/remove-representative';

  // Units
  static String ownerPropertyUnits(int propertyId) =>
      'owner/properties/$propertyId/units';
  static String ownerCreateDraftUnit(int propertyId) =>
      'owner/properties/$propertyId/units/draft';
  static String ownerAutoSaveUnit(int propertyId, int unitId) =>
      'owner/properties/$propertyId/units/$unitId';
  static String ownerShowUnit(int propertyId, int unitId) =>
      'owner/properties/$propertyId/units/$unitId';
  static String ownerPublishUnit(int propertyId, int unitId) =>
      'owner/properties/$propertyId/units/$unitId/publish';

  static const String ownerUnitsFormData = 'owner/units/form-data';
  static String ownerUpdateUnit(int unitId) => 'owner/units/$unitId';
  static String ownerDeleteUnit(int unitId) => 'owner/units/$unitId';
}
