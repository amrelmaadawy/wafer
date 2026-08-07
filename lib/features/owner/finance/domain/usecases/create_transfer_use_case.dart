import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/create_transfer_request_entity.dart';
import '../entities/transfer_entity.dart';
import '../repositories/transfers_repository.dart';

class CreateTransferUseCase {
  final TransfersRepository repository;

  CreateTransferUseCase(this.repository);

  Future<Either<Failure, TransferEntity>> call(CreateTransferRequestEntity request) {
    return repository.createTransfer(request);
  }
}
