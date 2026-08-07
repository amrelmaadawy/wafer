import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/payment_entity.dart';
import '../repositories/finance_repository.dart';

class UpdateFinancePaymentParams {
  final int paymentId;
  final num amount;
  final String paymentDate;
  final String? notes;

  UpdateFinancePaymentParams({
    required this.paymentId,
    required this.amount,
    required this.paymentDate,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'payment_date': paymentDate,
      if (notes != null && notes!.isNotEmpty) 'notes': notes,
    };
  }
}

class UpdateFinancePaymentUseCase implements UseCase<PaymentEntity, UpdateFinancePaymentParams> {
  final FinanceRepository repository;

  UpdateFinancePaymentUseCase(this.repository);

  @override
  Future<Either<Failure, PaymentEntity>> call(UpdateFinancePaymentParams params) {
    return repository.updatePayment(params.paymentId, params.toJson());
  }
}
