import 'package:equatable/equatable.dart';

import 'receipt_entity.dart';

class ReceiptsResponseEntity extends Equatable {
  final List<ReceiptEntity> receipts;
  final PaginationEntity pagination;
  final FiltersEntity filters;

  const ReceiptsResponseEntity({
    required this.receipts,
    required this.pagination,
    required this.filters,
  });

  @override
  List<Object?> get props => [receipts, pagination, filters];
}

class PaginationEntity extends Equatable {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  const PaginationEntity({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  @override
  List<Object?> get props => [currentPage, lastPage, perPage, total];
}

class FiltersEntity extends Equatable {
  final List<String> applied;
  final List<String> supported;

  const FiltersEntity({
    required this.applied,
    required this.supported,
  });

  @override
  List<Object?> get props => [applied, supported];
}
