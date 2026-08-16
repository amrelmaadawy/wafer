import 'package:dio/dio.dart';
import '../utils/app_page_status.dart';
import 'failures.dart';

/// Maps a Failure or Exception to an AppPageStatus for UI consumption.
/// Keeps error mapping centralized and out of Cubits.
extension FailureToStatus on Object {
  AppPageStatus toPageStatus() {
    if (this is DioException) {
      final dio = this as DioException;
      if (dio.type == DioExceptionType.connectionError ||
          dio.type == DioExceptionType.receiveTimeout ||
          dio.type == DioExceptionType.sendTimeout) {
        return AppPageStatus.offline;
      }
      if (dio.response?.statusCode == 401) return AppPageStatus.unauthorized;
      if (dio.response?.statusCode == 403) return AppPageStatus.forbidden;
    } else if (this is ServerFailure) {
      final failure = this as ServerFailure;
      // Ideally ServerFailure would hold a statusCode or similar,
      // mapping can be extended here.
      if (failure.message.toLowerCase().contains('unauthorized')) {
         return AppPageStatus.unauthorized;
      }
    }
    return AppPageStatus.error;
  }
}
