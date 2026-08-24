import 'package:equatable/equatable.dart';

class StatementTransactionEntity extends Equatable {
  final String date;
  final String? reference;
  final String? description;
  final num debit;
  final num credit;
  final num balance;
  final String? transactionType;
  final String? transactionTypeLabel;
  final String? sourceType;
  final int? sourceId;

  const StatementTransactionEntity({
    required this.date,
    this.reference,
    this.description,
    required this.debit,
    required this.credit,
    required this.balance,
    this.transactionType,
    this.transactionTypeLabel,
    this.sourceType,
    this.sourceId,
  });

  @override
  List<Object?> get props => [
        date,
        reference,
        description,
        debit,
        credit,
        balance,
        transactionType,
        transactionTypeLabel,
        sourceType,
        sourceId,
      ];
}
