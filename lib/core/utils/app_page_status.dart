/// Standard status enum for all list/detail pages in the application.
/// Use this in all Cubit states to ensure consistency.
enum AppPageStatus {
  /// Initial state — nothing has been loaded yet
  initial,

  /// Full-screen loading (first load)
  loading,

  /// Data is loaded, pull-to-refresh in progress
  refreshing,

  /// Data loaded successfully
  success,

  /// Data loaded but list is empty
  empty,

  /// An error occurred while loading
  error,

  /// User is not authenticated (401)
  unauthorized,

  /// User doesn't have permission (403)
  forbidden,

  /// No internet connection available
  offline,
}

/// Standard status for form/action operations.
enum AppActionStatus {
  /// Idle — no action in progress
  idle,

  /// Submitting form or performing action
  submitting,

  /// Action completed successfully
  success,

  /// Action failed
  error,
}
