import 'package:equatable/equatable.dart';

class FinanceOverviewEntity extends Equatable {
  final FinanceSummaryEntity summary;
  final Map<String, FinanceResourceEntity> resources;

  const FinanceOverviewEntity({required this.summary, required this.resources});

  @override
  List<Object?> get props => [summary, resources];
}

class FinanceSummaryEntity extends Equatable {
  final double receiptsTotal;
  final double paymentsTotal;
  final double netCashFlow;
  final int pendingReceipts;
  final int pendingPayments;
  final int pendingTransfers;
  final int postedJournalEntries;

  const FinanceSummaryEntity({
    required this.receiptsTotal,
    required this.paymentsTotal,
    required this.netCashFlow,
    required this.pendingReceipts,
    required this.pendingPayments,
    required this.pendingTransfers,
    required this.postedJournalEntries,
  });

  @override
  List<Object?> get props => [
    receiptsTotal,
    paymentsTotal,
    netCashFlow,
    pendingReceipts,
    pendingPayments,
    pendingTransfers,
    postedJournalEntries,
  ];
}

class FinanceResourceEntity extends Equatable {
  final String key;
  final String label;

  const FinanceResourceEntity({required this.key, required this.label});

  @override
  List<Object?> get props => [key, label];
}
