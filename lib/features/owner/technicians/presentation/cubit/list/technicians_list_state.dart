import 'package:equatable/equatable.dart';
import 'package:wafer/features/owner/technicians/domain/entities/technician_entity.dart';
import 'package:wafer/features/owner/technicians/domain/entities/technicians_pagination_entity.dart';


enum TechniciansListStatus { initial, loading, success, failure, loadingMore }

class TechniciansListState extends Equatable {
  final TechniciansListStatus status;
  final List<TechnicianEntity> technicians;
  final TechniciansPaginationEntity? pagination;
  final String? errorMessage;
  final bool hasReachedMax;

  const TechniciansListState({
    this.status = TechniciansListStatus.initial,
    this.technicians = const [],
    this.pagination,
    this.errorMessage,
    this.hasReachedMax = false,
  });

  TechniciansListState copyWith({
    TechniciansListStatus? status,
    List<TechnicianEntity>? technicians,
    TechniciansPaginationEntity? pagination,
    String? errorMessage,
    bool? hasReachedMax,
  }) {
    return TechniciansListState(
      status: status ?? this.status,
      technicians: technicians ?? this.technicians,
      pagination: pagination ?? this.pagination,
      errorMessage: errorMessage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [
        status,
        technicians,
        pagination,
        errorMessage,
        hasReachedMax,
      ];
}
