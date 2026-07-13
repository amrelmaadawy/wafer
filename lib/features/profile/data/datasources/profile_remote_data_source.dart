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
}
