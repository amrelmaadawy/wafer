import '../../domain/entities/client_statement_response_entity.dart';
import 'client_model.dart';
import 'statement_period_model.dart';
import 'statement_summary_model.dart';
import 'statement_transaction_model.dart';

class ClientStatementResponseModel extends ClientStatementResponseEntity {
  const ClientStatementResponseModel({
    required super.client,
    required super.period,
    required super.summary,
    required super.transactions,
  });

  factory ClientStatementResponseModel.fromJson(Map<String, dynamic> json) {
    return ClientStatementResponseModel(
      client: ClientModel.fromJson(json['client'] ?? {}),
      period: StatementPeriodModel.fromJson(json['period'] ?? {}),
      summary: StatementSummaryModel.fromJson(json['summary'] ?? {}),
      transactions: (json['transactions'] as List?)
              ?.map((e) => StatementTransactionModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}
