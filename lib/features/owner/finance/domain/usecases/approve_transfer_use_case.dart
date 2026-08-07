import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/transfer_entity.dart';
import '../repositories/transfers_repository.dart';

class ApproveTransferUseCase implements UseCase<TransferEntity, int> {
  final TransfersRepository repository;

  ApproveTransferUseCase(this.repository);

  @override
  Future<Either<Failure, TransferEntity>> call(int transferId) {
    return repository.approveTransfer(transferId);
  }
}
