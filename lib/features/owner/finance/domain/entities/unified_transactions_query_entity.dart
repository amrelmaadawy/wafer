import 'package:equatable/equatable.dart';

class UnifiedTransactionsQueryEntity extends Equatable {
  final String? search;
  final String? dateFrom;
  final String? dateTo;
  final String? type; // 'all', 'receipt', 'payment', 'transfer', 'adjustment'
  final String? status;
  final int? propertyId;
  final int? unitId;
  final int? contractId;
  final int? accountId;
  final int page;
  final int limit;

  const UnifiedTransactionsQueryEntity({
    this.search,
    this.dateFrom,
    this.dateTo,
    this.type,
    this.status,
    this.propertyId,
    this.unitId,
    this.contractId,
    this.accountId,
    this.page = 1,
    this.limit = 15,
  });

  UnifiedTransactionsQueryEntity copyWith({
    String? search,
    String? dateFrom,
    String? dateTo,
    String? type,
    String? status,
    int? propertyId,
    int? unitId,
    int? contractId,
    int? accountId,
    int? page,
    int? limit,
  }) {
    return UnifiedTransactionsQueryEntity(
      search: search ?? this.search,
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
      type: type ?? this.type,
      status: status ?? this.status,
      propertyId: propertyId ?? this.propertyId,
      unitId: unitId ?? this.unitId,
      contractId: contractId ?? this.contractId,
      accountId: accountId ?? this.accountId,
      page: page ?? this.page,
      limit: limit ?? this.limit,
    );
  }

  @override
  List<Object?> get props => [
        search,
        dateFrom,
        dateTo,
        type,
        status,
        propertyId,
        unitId,
        contractId,
        accountId,
        page,
        limit,
      ];
}
