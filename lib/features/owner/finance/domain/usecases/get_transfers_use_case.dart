import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/transfer_entity.dart';
import '../repositories/transfers_repository.dart';

class GetTransfersUseCase {
  final TransfersRepository repository;

  GetTransfersUseCase(this.repository);

  Future<Either<Failure, List<TransferEntity>>> call({required int page}) {
    return repository.getTransfers(page: page);
  }
}
