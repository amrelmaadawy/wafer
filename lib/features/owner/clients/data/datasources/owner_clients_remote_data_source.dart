import 'package:dio/dio.dart';
import '../../../../../core/network/api_constants.dart';
import '../models/clients_list_response_model.dart';
import '../models/client_model.dart';

abstract class OwnerClientsRemoteDataSource {
  Future<ClientsListResponseModel> getClients({
    int page = 1,
    Map<String, dynamic>? filters,
  });

  Future<ClientModel> updateClient({
    required int clientId,
    required Map<String, dynamic> body,
  });

  Future<void> deleteClient(int clientId);
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

  @override
  Future<ClientModel> updateClient({
    required int clientId,
    required Map<String, dynamic> body,
  }) async {
    final response = await _dio.patch(
      '${ApiConstants.ownerClients}/$clientId',
      data: body,
    );
    return ClientModel.fromJson(response.data['data']['client']);
  }

  @override
  Future<void> deleteClient(int clientId) async {
    await _dio.delete('${ApiConstants.ownerClients}/$clientId');
  }
}
