import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../repositories/finance_repository.dart';

class CancelFinancePaymentUseCase {
  final FinanceRepository repository;

  CancelFinancePaymentUseCase(this.repository);

  Future<Either<Failure, void>> call(int paymentId, String reason) async {
    return await repository.cancelFinancePayment(paymentId, reason);
  }
}
