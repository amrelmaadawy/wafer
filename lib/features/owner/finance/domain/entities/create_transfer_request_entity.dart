import 'package:equatable/equatable.dart';

class CreateTransferRequestEntity extends Equatable {
  final String transferDate;
  final double amount;
  final int fromAccountId;
  final int toAccountId;
  final String? referenceNumber;
  final String? notes;

  const CreateTransferRequestEntity({
    required this.transferDate,
    required this.amount,
    required this.fromAccountId,
    required this.toAccountId,
    this.referenceNumber,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'transfer_date': transferDate,
      'amount': amount,
      'from_account_id': fromAccountId,
      'to_account_id': toAccountId,
      if (referenceNumber != null && referenceNumber!.isNotEmpty) 'reference_number': referenceNumber,
      if (notes != null && notes!.isNotEmpty) 'notes': notes,
    };
  }

  @override
  List<Object?> get props => [
        transferDate,
        amount,
        fromAccountId,
        toAccountId,
        referenceNumber,
        notes,
      ];
}
