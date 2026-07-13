import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/localization/locale_keys.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String username,
    required String password,
    required String deviceName,
    required String deviceToken,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserModel> login({
    required String username,
    required String password,
    required String deviceName,
    required String deviceToken,
  }) async {
    try {
      final response = await dio.post(
        'login',
        data: {
          'username': username,
          'password': password,
          'device_name': deviceName,
          'device_token': deviceToken,
        },
      );

      if (response.data['success'] == true && response.data['data'] != null) {
        return UserModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          response.data['message'] ?? LocaleKeys.errorsLoginFailed.tr(),
        );
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data is Map) {
        final message = e.response?.data['message'] ?? LocaleKeys.errorsConnectionError.tr();
        throw ServerException(message.toString());
      }
      throw ServerException(e.message ?? LocaleKeys.errorsNetworkError.tr());
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }
}
