import 'package:dio/dio.dart';
import '../../../../core/network/api_constants.dart';
import '../models/contract_details_model.dart';
import '../models/contracts_response_model.dart';

abstract class OwnerContractsRemoteDataSource {
  Future<ContractsResponseModel> getContracts({int page = 1, String? status});
  Future<ContractDetailsModel> getContractDetails(String id);
}

class OwnerContractsRemoteDataSourceImpl implements OwnerContractsRemoteDataSource {
  final Dio _dio;

  OwnerContractsRemoteDataSourceImpl(this._dio);

  @override
  Future<ContractsResponseModel> getContracts({int page = 1, String? status}) async {
    final queryParams = <String, dynamic>{'page': page};
    if (status != null && status != 'all' && status.isNotEmpty) {
      queryParams['status'] = status;
    }

    final response = await _dio.get(
      '${ApiConstants.baseUrl}${ApiConstants.ownerContracts}',
      queryParameters: queryParams,
    );

    final data = response.data as Map<String, dynamic>? ?? {};
    return ContractsResponseModel.fromJson(data);
  }

  @override
  Future<ContractDetailsModel> getContractDetails(String id) async {
    final response = await _dio.get(
      '${ApiConstants.baseUrl}${ApiConstants.ownerContracts}/$id',
    );

    final data = response.data as Map<String, dynamic>? ?? {};
    return ContractDetailsModel.fromJson(data);
  }
}
