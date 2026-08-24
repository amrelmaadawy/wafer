import 'package:equatable/equatable.dart';
import 'client_entity.dart';
import 'statement_period_entity.dart';
import 'statement_summary_entity.dart';
import 'statement_transaction_entity.dart';

class ClientStatementResponseEntity extends Equatable {
  final ClientEntity client;
  final StatementPeriodEntity period;
  final StatementSummaryEntity summary;
  final List<StatementTransactionEntity> transactions;

  const ClientStatementResponseEntity({
    required this.client,
    required this.period,
    required this.summary,
    required this.transactions,
  });

  @override
  List<Object?> get props => [client, period, summary, transactions];
}
