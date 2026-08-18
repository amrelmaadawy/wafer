import 'package:equatable/equatable.dart';
import 'contract_status_filter.dart';

enum ContractSortField { expiryDate, startDate, rentAmount, contractNumber }

class ContractsQueryFilterEntity extends Equatable {
  final String? search;
  final ContractStatusFilter status;
  final String? propertyName;
  final String? tenantName;
  final ContractSortField? sortBy;
  final bool sortAscending;
  final int page;

  const ContractsQueryFilterEntity({
    this.search,
    this.status = ContractStatusFilter.all,
    this.propertyName,
    this.tenantName,
    this.sortBy,
    this.sortAscending = true,
    this.page = 1,
  });

  ContractsQueryFilterEntity copyWith({
    String? Function()? search,
    ContractStatusFilter? status,
    String? Function()? propertyName,
    String? Function()? tenantName,
    ContractSortField? Function()? sortBy,
    bool? sortAscending,
    int? page,
  }) {
    return ContractsQueryFilterEntity(
      search: search != null ? search() : this.search,
      status: status ?? this.status,
      propertyName: propertyName != null ? propertyName() : this.propertyName,
      tenantName: tenantName != null ? tenantName() : this.tenantName,
      sortBy: sortBy != null ? sortBy() : this.sortBy,
      sortAscending: sortAscending ?? this.sortAscending,
      page: page ?? this.page,
    );
  }

  bool get hasAdvancedFilters =>
      (propertyName != null && propertyName!.trim().isNotEmpty) ||
      (tenantName != null && tenantName!.trim().isNotEmpty) ||
      sortBy != null;

  int get activeFiltersCount {
    int count = 0;
    if (propertyName != null && propertyName!.trim().isNotEmpty) count++;
    if (tenantName != null && tenantName!.trim().isNotEmpty) count++;
    if (status != ContractStatusFilter.all) count++;
    return count;
  }

  @override
  List<Object?> get props => [
    search,
    status,
    propertyName,
    tenantName,
    sortBy,
    sortAscending,
    page,
  ];
}
