import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/transfer_entity.dart';
import '../repositories/transfers_repository.dart';

class UpdateTransferParams {
  final int transferId;
  final num? amount;
  final String? transferDate;
  final int? fromAccountId;
  final int? toAccountId;
  final String? referenceNumber;
  final String? notes;

  UpdateTransferParams({
    required this.transferId,
    this.amount,
    this.transferDate,
    this.fromAccountId,
    this.toAccountId,
    this.referenceNumber,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (amount != null) map['amount'] = amount;
    if (transferDate != null && transferDate!.isNotEmpty) map['transfer_date'] = transferDate;
    if (fromAccountId != null) map['from_account_id'] = fromAccountId;
    if (toAccountId != null) map['to_account_id'] = toAccountId;
    if (referenceNumber != null) map['reference_number'] = referenceNumber;
    if (notes != null) map['notes'] = notes;
    return map;
  }
}

class UpdateTransferUseCase implements UseCase<TransferEntity, UpdateTransferParams> {
  final TransfersRepository repository;

  UpdateTransferUseCase(this.repository);

  @override
  Future<Either<Failure, TransferEntity>> call(UpdateTransferParams params) {
    return repository.updateTransfer(params.transferId, params.toJson());
  }
}
