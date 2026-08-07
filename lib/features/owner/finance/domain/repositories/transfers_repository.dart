import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/create_transfer_request_entity.dart';
import '../entities/transfer_entity.dart';

abstract class TransfersRepository {
  Future<Either<Failure, List<TransferEntity>>> getTransfers({
    required int page,
  });

  Future<Either<Failure, TransferEntity>> createTransfer(
    CreateTransferRequestEntity request,
  );

  Future<Either<Failure, TransferEntity>> updateTransfer(
    int transferId,
    Map<String, dynamic> data,
  );

  Future<Either<Failure, TransferEntity>> approveTransfer(int transferId);
}
