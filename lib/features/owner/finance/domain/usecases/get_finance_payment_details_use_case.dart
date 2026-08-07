import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/payment_entity.dart';
import '../repositories/finance_repository.dart';

class GetFinancePaymentDetailsUseCase {
  final FinanceRepository repository;

  GetFinancePaymentDetailsUseCase(this.repository);

  Future<Either<Failure, PaymentEntity>> call(int paymentId) async {
    return await repository.getFinancePaymentDetails(paymentId);
  }
}
