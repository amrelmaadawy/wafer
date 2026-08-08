import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/create_transfer_request_entity.dart';
import '../../domain/entities/transfer_entity.dart';
import '../../domain/repositories/transfers_repository.dart';
import '../datasources/transfers_remote_data_source.dart';
import '../../../../../core/data/base_repository.dart';

class TransfersRepositoryImpl extends BaseRepository implements TransfersRepository {
  final TransfersRemoteDataSource remoteDataSource;

  TransfersRepositoryImpl({
    required this.remoteDataSource,
    required super.networkInfo,
  });

  @override
  Future<Either<Failure, List<TransferEntity>>> getTransfers({required int page}) async {
    return executeApiCall<List<TransferEntity>>(
      call: () => remoteDataSource.getTransfers(page: page),
    );
  }

  @override
  Future<Either<Failure, TransferEntity>> createTransfer(CreateTransferRequestEntity request) async {
    return executeApiCall<TransferEntity>(
      call: () => remoteDataSource.createTransfer(request),
    );
  }

  @override
  Future<Either<Failure, TransferEntity>> updateTransfer(
      int transferId, Map<String, dynamic> data) async {
    return executeApiCall<TransferEntity>(
      call: () => remoteDataSource.updateTransfer(transferId, data),
    );
  }

  @override
  Future<Either<Failure, TransferEntity>> approveTransfer(int transferId) async {
    return executeApiCall<TransferEntity>(
      call: () => remoteDataSource.approveTransfer(transferId),
    );
  }
}