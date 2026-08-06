import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/receipt_entity.dart';
import '../repositories/finance_repository.dart';

class CreateFinanceReceiptParams extends Equatable {
  final int ownerId;
  final num amount;
  final String receiptDate;
  final int debitAccountId;
  final int creditAccountId;
  final int? propertyId;
  final int? contractId;
  final int? businessSegmentId;
  final String? notes;

  const CreateFinanceReceiptParams({
    required this.ownerId,
    required this.amount,
    required this.receiptDate,
    required this.debitAccountId,
    required this.creditAccountId,
    this.propertyId,
    this.contractId,
    this.businessSegmentId,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'owner_id': ownerId,
      'amount': amount,
      'receipt_date': receiptDate,
      'debit_account_id': debitAccountId,
      'credit_account_id': creditAccountId,
      if (propertyId != null) 'property_id': propertyId,
      if (contractId != null) 'contract_id': contractId,
      if (businessSegmentId != null) 'business_segment_id': businessSegmentId,
      if (notes != null && notes!.isNotEmpty) 'notes': notes,
    };
  }

  @override
  List<Object?> get props => [
        ownerId,
        amount,
        receiptDate,
        debitAccountId,
        creditAccountId,
        propertyId,
        contractId,
        businessSegmentId,
        notes,
      ];
}

class CreateFinanceReceiptUseCase
    implements UseCase<ReceiptEntity, CreateFinanceReceiptParams> {
  final FinanceRepository repository;

  CreateFinanceReceiptUseCase(this.repository);

  @override
  Future<Either<Failure, ReceiptEntity>> call(
    CreateFinanceReceiptParams params,
  ) async {
    return await repository.createReceipt(params);
  }
}
