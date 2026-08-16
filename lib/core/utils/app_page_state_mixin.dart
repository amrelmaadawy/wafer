import 'app_page_status.dart';

/// Mixin to add to Cubit states that need standard page handling.
/// Provides convenience getters for common status checks.
mixin AppPageStateMixin {
  AppPageStatus get status;

  bool get isInitial => status == AppPageStatus.initial;
  bool get isLoading => status == AppPageStatus.loading;
  bool get isRefreshing => status == AppPageStatus.refreshing;
  bool get isSuccess => status == AppPageStatus.success;
  bool get isEmpty => status == AppPageStatus.empty;
  bool get isError => status == AppPageStatus.error;
  bool get isUnauthorized => status == AppPageStatus.unauthorized;
  bool get isForbidden => status == AppPageStatus.forbidden;
  bool get isOffline => status == AppPageStatus.offline;
  
  bool get isLoadingOrRefreshing => isLoading || isRefreshing;
  bool get showContent => isSuccess || isRefreshing;
}
