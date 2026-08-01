class Routes {
  Routes._();

  static const String home = '/';
  static const String splash = '/splash';
  static const String login = '/login';
  static const String ownerMain = '/owner-main';
  static const String ownerDashboard = '/owner-main/dashboard';
  static const String ownerProperties = '/owner-main/properties';
  static const String ownerContracts = '/owner-main/contracts';
  static const String ownerFinance = '/owner-main/finance';
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
  static const String ownerLegalCaseDetails = 'details'; // Sub-route
  static const String editProfile = '/edit-profile';
  static const String changePassword = '/change-password';

  // Properties sub-routes
  static const String ownerPropertyDetails = '/owner-property-details';
  static const String ownerPropertyCreate = '/owner-property-create';
  static const String ownerPropertyEdit = '/owner-property-edit';
  static const String ownerPropertyUnitDetails = '/owner-property-unit-details';
  static const String ownerUnitCreate = '/owner-unit-create';
  static const String ownerDeeds = '/owner-deeds';
  static const String ownerDeedsCreate = '/owner-deeds-create';
  static const String ownerDeedDetails = '/owner-deed-details';

  // Reports sub-routes
  static const String ownerRevenueReport = '/owner-revenue-report';
  static const String ownerOccupancyReport = '/owner-occupancy-report';
  static const String ownerDefaultersReport = '/owner-defaulters-report';
  static const String ownerUnitsStatusReport = '/owner/reports/units-status';
  static const String ownerContractsReport = '/owner/reports/contracts';
  static const String ownerContractsMovementReport =
      '/owner/reports/contracts-movement';
  static const String ownerMaintenanceRequestsReport =
      '/owner/reports/maintenance-requests';
  static const String ownerTechnicianPerformanceReport =
      '/owner/reports/technician-performance';
  static const String ownerEmployeeTasksReport =
      '/owner/reports/employee-tasks';
  static const String ownerActivityLogsReport = '/owner/reports/activity-logs';
}
