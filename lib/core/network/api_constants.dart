class ApiConstants {
  ApiConstants._();

  /// Base URL for mobile API v1
  static const String baseUrl = 'https://codra.cloud/api/v1/mobile/';

  /// Default timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

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

  /// Owner Endpoints
  static const String ownerContracts = 'owner/contracts';
  static const String ownerMaintenance = 'owner/maintenance';
  static String ownerMaintenanceDetails(int id) => 'owner/maintenance/$id';
  static const String ownerRevenueReport = 'owner/reports/revenue';
  static const String ownerOccupancyReport = 'owner/reports/occupancy';
}
