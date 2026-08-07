import 'package:dio/dio.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_constants.dart';
import '../../domain/entities/create_transfer_request_entity.dart';
import '../models/transfer_model.dart';

abstract class TransfersRemoteDataSource {
  Future<List<TransferModel>> getTransfers({required int page});
  Future<TransferModel> createTransfer(CreateTransferRequestEntity request);
}

class TransfersRemoteDataSourceImpl implements TransfersRemoteDataSource {
  final Dio _dio;

  TransfersRemoteDataSourceImpl(this._dio);

  @override
  Future<List<TransferModel>> getTransfers({required int page}) async {
    final response = await _dio.get(
      ApiConstants.ownerTransfers,
      queryParameters: {'page': page},
    );

    final data = response.data as Map<String, dynamic>? ?? {};
    if (data['success'] == true && data['data'] != null) {
      final List<dynamic> items = data['data']['transfers'] ?? [];
      return items.map((e) => TransferModel.fromJson(e)).toList();
    }
    throw ServerException(data['message'] ?? 'Invalid response format');
  }

  @override
  Future<TransferModel> createTransfer(CreateTransferRequestEntity request) async {
    final response = await _dio.post(
      ApiConstants.ownerTransfers,
      data: request.toJson(),
    );

    final data = response.data as Map<String, dynamic>? ?? {};
    if (data['success'] == true && data['data'] != null) {
      return TransferModel.fromJson(data['data']['transfer']);
    }
    
    throw ServerException(data['message'] ?? 'Validation failed');
  }
}
