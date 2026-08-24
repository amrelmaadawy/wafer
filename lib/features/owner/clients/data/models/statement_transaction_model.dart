import '../../domain/entities/statement_transaction_entity.dart';

class StatementTransactionModel extends StatementTransactionEntity {
  const StatementTransactionModel({
    required super.date,
    super.reference,
    super.description,
    required super.debit,
    required super.credit,
    required super.balance,
    super.transactionType,
    super.transactionTypeLabel,
    super.sourceType,
    super.sourceId,
  });

  factory StatementTransactionModel.fromJson(Map<String, dynamic> json) {
    return StatementTransactionModel(
      date: json['date'] ?? '',
      reference: json['reference'],
      description: json['description'],
      debit: json['debit'] ?? 0,
      credit: json['credit'] ?? 0,
      balance: json['balance'] ?? 0,
      transactionType: json['transaction_type'],
      transactionTypeLabel: json['transaction_type_label'],
      sourceType: json['source_type'],
      sourceId: json['source_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'reference': reference,
      'description': description,
      'debit': debit,
      'credit': credit,
      'balance': balance,
      'transaction_type': transactionType,
      'transaction_type_label': transactionTypeLabel,
      'source_type': sourceType,
      'source_id': sourceId,
    };
  }
}
