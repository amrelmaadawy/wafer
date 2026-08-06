import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/payment_entity.dart';
import '../repositories/finance_repository.dart';

class CreateFinancePaymentUseCase {
  final FinanceRepository repository;

  CreateFinancePaymentUseCase(this.repository);

  Future<Either<Failure, PaymentEntity>> call({
    required int payeeId,
    required num amount,
    required String paymentDate,
    required String debitAccountType,
    required int debitAccountId,
    required int creditAccountId,
    int? propertyId,
    int? contractId,
    String? notes,
  }) async {
    final Map<String, dynamic> params = {
      'payee_id': payeeId,
      'amount': amount,
      'payment_date': paymentDate,
      'debit_account_type': debitAccountType,
      'debit_account_id': debitAccountId,
      'credit_account_id': creditAccountId,
      'property_id': ?propertyId,
      'contract_id': ?contractId,
      if (notes != null && notes.isNotEmpty) 'notes': notes,
    };

    return await repository.createPayment(params);
  }
}
