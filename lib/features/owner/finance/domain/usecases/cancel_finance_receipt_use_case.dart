import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/receipt_entity.dart';
import '../repositories/finance_repository.dart';

class CancelFinanceReceiptUseCase
    implements UseCase<ReceiptEntity, CancelFinanceReceiptParams> {
  final FinanceRepository repository;

  CancelFinanceReceiptUseCase(this.repository);

  @override
  Future<Either<Failure, ReceiptEntity>> call(
      CancelFinanceReceiptParams params) async {
    return await repository.cancelReceipt(params.receiptId, params.reason);
  }
}

class CancelFinanceReceiptParams {
  final int receiptId;
  final String reason;

  CancelFinanceReceiptParams({required this.receiptId, required this.reason});
}
