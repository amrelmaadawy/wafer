import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/receipt_entity.dart';
import '../repositories/finance_repository.dart';

class GetFinanceReceiptDetailsUseCase
    implements UseCase<ReceiptEntity, GetFinanceReceiptDetailsParams> {
  final FinanceRepository repository;

  GetFinanceReceiptDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, ReceiptEntity>> call(
      GetFinanceReceiptDetailsParams params) async {
    return await repository.getReceiptDetails(params.receiptId);
  }
}

class GetFinanceReceiptDetailsParams {
  final int receiptId;

  GetFinanceReceiptDetailsParams({required this.receiptId});
}
