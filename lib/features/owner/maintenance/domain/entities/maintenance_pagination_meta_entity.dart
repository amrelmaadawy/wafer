import 'package:equatable/equatable.dart';

class MaintenancePaginationMetaEntity extends Equatable {
  final int currentPage;
  final int lastPage;
  final int total;
  final int perPage;

  const MaintenancePaginationMetaEntity({
    required this.currentPage,
    required this.lastPage,
    required this.total,
    required this.perPage,
  });

  bool get hasMore => currentPage < lastPage;

  @override
  List<Object?> get props => [currentPage, lastPage, total, perPage];
}
