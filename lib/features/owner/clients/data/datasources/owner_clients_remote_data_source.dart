import 'package:dio/dio.dart';
import '../../../../../core/network/api_constants.dart';
import '../models/clients_list_response_model.dart';
import '../models/client_model.dart';
import '../models/client_statement_response_model.dart';

abstract class OwnerClientsRemoteDataSource {
  Future<ClientsListResponseModel> getClients({
    int page = 1,
    Map<String, dynamic>? filters,
  });

  Future<ClientModel> updateClient({
    required int clientId,
    required Map<String, dynamic> body,
  });

  Future<ClientModel> getClientDetails(int clientId);
  Future<void> deleteClient(int clientId);
  Future<List<ClientModel>> searchClients(String keyword);

  Future<ClientStatementResponseModel> getClientStatement({
    required int clientId,
    String? startDate,
    String? endDate,
    String? transactionType,
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

  @override
  Future<List<ClientModel>> searchClients(String keyword) async {
    final response = await _dio.get(
      ApiConstants.ownerClientsSearch,
      queryParameters: {'keyword': keyword},
    );

    final List<dynamic> clientsList = response.data['data']['clients'] ?? [];
    return clientsList.map((client) => ClientModel.fromJson(client)).toList();
  }

  @override
  Future<ClientStatementResponseModel> getClientStatement({
    required int clientId,
    String? startDate,
    String? endDate,
    String? transactionType,
  }) async {
    final Map<String, dynamic> queryParams = {};
    if (startDate != null) queryParams['start_date'] = startDate;
    if (endDate != null) queryParams['end_date'] = endDate;
    if (transactionType != null) queryParams['transaction_type'] = transactionType;

    final response = await _dio.get(
      ApiConstants.ownerClientStatement(clientId),
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
    return ClientStatementResponseModel.fromJson(response.data['data']);
  }

  @override
  Future<ClientModel> getClientDetails(int clientId) {
    // TODO: implement getClientDetails
    throw UnimplementedError();
  }
}
