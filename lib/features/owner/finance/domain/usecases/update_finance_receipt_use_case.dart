import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/receipt_entity.dart';
import '../repositories/finance_repository.dart';

class UpdateFinanceReceiptUseCase implements UseCase<ReceiptEntity, UpdateFinanceReceiptParams> {
  final FinanceRepository repository;

  UpdateFinanceReceiptUseCase(this.repository);

  @override
  Future<Either<Failure, ReceiptEntity>> call(UpdateFinanceReceiptParams params) async {
    return await repository.updateReceipt(params);
  }
}

class UpdateFinanceReceiptParams extends Equatable {
  final int receiptId;
  final num amount;
  final String receiptDate;
  final String? notes;

  const UpdateFinanceReceiptParams({
    required this.receiptId,
    required this.amount,
    required this.receiptDate,
    this.notes,
  });

  @override
  List<Object?> get props => [
        receiptId,
        amount,
        receiptDate,
        notes,
      ];
}
