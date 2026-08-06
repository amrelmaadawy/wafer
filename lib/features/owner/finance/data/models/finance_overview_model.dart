import '../../domain/entities/finance_overview_entity.dart';

class FinanceOverviewModel extends FinanceOverviewEntity {
  const FinanceOverviewModel({
    required super.summary,
    required super.resources,
  });

  factory FinanceOverviewModel.fromJson(Map<String, dynamic> json) {
    final summaryJson = json['summary'] as Map<String, dynamic>? ?? {};
    final resourcesJson = json['resources'] as Map<String, dynamic>? ?? {};

    final Map<String, FinanceResourceModel> parsedResources = {};
    resourcesJson.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        parsedResources[key] = FinanceResourceModel.fromJson(value);
      }
    });

    return FinanceOverviewModel(
      summary: FinanceSummaryModel.fromJson(summaryJson),
      resources: parsedResources,
    );
  }
}

class FinanceSummaryModel extends FinanceSummaryEntity {
  const FinanceSummaryModel({
    required super.receiptsTotal,
    required super.paymentsTotal,
    required super.netCashFlow,
    required super.pendingReceipts,
    required super.pendingPayments,
    required super.pendingTransfers,
    required super.postedJournalEntries,
  });

  factory FinanceSummaryModel.fromJson(Map<String, dynamic> json) {
    return FinanceSummaryModel(
      receiptsTotal: (json['receipts_total'] as num?)?.toDouble() ?? 0.0,
      paymentsTotal: (json['payments_total'] as num?)?.toDouble() ?? 0.0,
      netCashFlow: (json['net_cash_flow'] as num?)?.toDouble() ?? 0.0,
      pendingReceipts: (json['pending_receipts'] as num?)?.toInt() ?? 0,
      pendingPayments: (json['pending_payments'] as num?)?.toInt() ?? 0,
      pendingTransfers: (json['pending_transfers'] as num?)?.toInt() ?? 0,
      postedJournalEntries:
          (json['posted_journal_entries'] as num?)?.toInt() ?? 0,
    );
  }
}

class FinanceResourceModel extends FinanceResourceEntity {
  const FinanceResourceModel({required super.key, required super.label});

  factory FinanceResourceModel.fromJson(Map<String, dynamic> json) {
    return FinanceResourceModel(
      key: json['key'] as String? ?? '',
      label: json['label'] as String? ?? '',
    );
  }
}
