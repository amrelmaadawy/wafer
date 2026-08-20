import 'package:dio/dio.dart';
import '../../../../../core/network/api_constants.dart';
import '../models/clients_list_response_model.dart';

abstract class OwnerClientsRemoteDataSource {
  Future<ClientsListResponseModel> getClients({
    int page = 1,
    Map<String, dynamic>? filters,
  });
}

class OwnerClientsRemoteDataSourceImpl implements OwnerClientsRemoteDataSource {
  final Dio _dio;

  OwnerClientsRemoteDataSourceImpl(this._dio);

  @override
  Future<ClientsListResponseModel> getClients({
    int page = 1,
    Map<String, dynamic>? filters,
  }) async {
    final queryParameters = <String, dynamic>{'page': page};
    if (filters != null) {
      queryParameters.addAll(filters);
    }

    final response = await _dio.get(
      ApiConstants.ownerClients,
      queryParameters: queryParameters,
    );

    return ClientsListResponseModel.fromJson(response.data);
  }
}
