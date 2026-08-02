import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wafer/core/localization/locale_keys.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);

  factory ServerFailure.fromDioException(DioException e) {
    if (e.response != null &&
        e.response!.data != null &&
        e.response!.data is Map<String, dynamic>) {
      final data = e.response!.data as Map<String, dynamic>;

      // If we have validation errors object
      if (data.containsKey('errors') && data['errors'] is Map) {
        final errors = data['errors'] as Map;
        final StringBuffer sb = StringBuffer();
        errors.forEach((key, value) {
          if (value is List) {
            sb.writeln(value.join('\n'));
          } else {
            sb.writeln(value.toString());
          }
        });
        if (sb.isNotEmpty) {
          return ServerFailure(sb.toString().trim());
        }
      }

      // If we have a generic message
      if (data.containsKey('message') && data['message'] != null) {
        return ServerFailure(data['message'].toString());
      }
    }
    
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ServerFailure(LocaleKeys.errorsConnectionError.tr());
      case DioExceptionType.connectionError:
        return ServerFailure(LocaleKeys.errorsNetworkError.tr());
      case DioExceptionType.cancel:
        return ServerFailure(LocaleKeys.errorsRequestCancelled.tr());
      default:
        return ServerFailure(LocaleKeys.errorsServerError.tr());
    }
  }
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}
