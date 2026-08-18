import 'package:equatable/equatable.dart';

enum FinanceSortField { date, amount }

class FinanceQueryFilterEntity extends Equatable {
  final String? search;
  final String? accountName;
  final String? propertyName;
  final String? status;
  final String? fromDate;
  final String? toDate;
  final FinanceSortField? sortBy;
  final bool sortAscending;

  const FinanceQueryFilterEntity({
    this.search,
    this.accountName,
    this.propertyName,
    this.status,
    this.fromDate,
    this.toDate,
    this.sortBy,
    this.sortAscending = false,
  });

  FinanceQueryFilterEntity copyWith({
    String? Function()? search,
    String? Function()? accountName,
    String? Function()? propertyName,
    String? Function()? status,
    String? Function()? fromDate,
    String? Function()? toDate,
    FinanceSortField? Function()? sortBy,
    bool? sortAscending,
  }) {
    return FinanceQueryFilterEntity(
      search: search != null ? search() : this.search,
      accountName: accountName != null ? accountName() : this.accountName,
      propertyName: propertyName != null ? propertyName() : this.propertyName,
      status: status != null ? status() : this.status,
      fromDate: fromDate != null ? fromDate() : this.fromDate,
      toDate: toDate != null ? toDate() : this.toDate,
      sortBy: sortBy != null ? sortBy() : this.sortBy,
      sortAscending: sortAscending ?? this.sortAscending,
    );
  }

  bool get hasAdvancedFilters =>
      (accountName != null && accountName!.isNotEmpty) ||
      (propertyName != null && propertyName!.isNotEmpty) ||
      (status != null && status!.isNotEmpty) ||
      (fromDate != null && fromDate!.isNotEmpty) ||
      (toDate != null && toDate!.isNotEmpty) ||
      sortBy != null;

  int get activeFiltersCount {
    int count = 0;
    if (accountName != null && accountName!.isNotEmpty) count++;
    if (propertyName != null && propertyName!.isNotEmpty) count++;
    if (status != null && status != 'all' && status!.isNotEmpty) count++;
    if (fromDate != null && fromDate!.isNotEmpty) count++;
    if (toDate != null && toDate!.isNotEmpty) count++;
    return count;
  }

  bool get isSortActive => sortBy != null;

  @override
  List<Object?> get props => [
    search,
    accountName,
    propertyName,
    status,
    fromDate,
    toDate,
    sortBy,
    sortAscending,
  ];
}
