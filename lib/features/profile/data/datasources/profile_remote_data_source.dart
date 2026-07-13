import 'package:dio/dio.dart';
import '../../../../core/network/api_constants.dart';
import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();
  Future<ProfileModel> updateProfile({
    required String name,
    required String phone,
    required String gender,
  });
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  });
  Future<ProfileModel> updateAvatar({required String imagePath});
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio _dio;

  ProfileRemoteDataSourceImpl(this._dio);

  @override
  Future<ProfileModel> getProfile() async {
    final response = await _dio.get('${ApiConstants.baseUrl}${ApiConstants.sharedProfile}');
    final data = response.data['data'] as Map<String, dynamic>;
    return ProfileModel.fromJson(data);
  }

  @override
  Future<ProfileModel> updateProfile({
    required String name,
    required String phone,
    required String gender,
  }) async {
    final response = await _dio.put(
      '${ApiConstants.baseUrl}${ApiConstants.sharedProfile}',
      data: {
        'name': name,
        'phone': phone,
        'gender': gender,
      },
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return ProfileModel.fromJson(data);
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    await _dio.post(
      '${ApiConstants.baseUrl}${ApiConstants.sharedChangePassword}',
      data: {
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirmation': newPasswordConfirmation,
      },
    );
  }

  @override
  Future<ProfileModel> updateAvatar({required String imagePath}) async {
    final formData = FormData.fromMap({
      'avatar': await MultipartFile.fromFile(imagePath),
    });
    final response = await _dio.post(
      '${ApiConstants.baseUrl}${ApiConstants.sharedUpdateAvatar}',
      data: formData,
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return ProfileModel.fromJson(data);
  }
}
