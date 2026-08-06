import 'package:equatable/equatable.dart';
import '../../../domain/entities/supervisor_entity.dart';
import '../../../domain/entities/supervisors_pagination_entity.dart';

enum SupervisorsListStatus { initial, loading, success, failure, loadingMore }

class SupervisorsListState extends Equatable {
  final SupervisorsListStatus status;
  final List<SupervisorEntity> supervisors;
  final SupervisorsPaginationEntity? pagination;
  final String? errorMessage;
  final bool hasReachedMax;

  const SupervisorsListState({
    this.status = SupervisorsListStatus.initial,
    this.supervisors = const [],
    this.pagination,
    this.errorMessage,
    this.hasReachedMax = false,
  });

  SupervisorsListState copyWith({
    SupervisorsListStatus? status,
    List<SupervisorEntity>? supervisors,
    SupervisorsPaginationEntity? pagination,
    String? errorMessage,
    bool? hasReachedMax,
  }) {
    return SupervisorsListState(
      status: status ?? this.status,
      supervisors: supervisors ?? this.supervisors,
      pagination: pagination ?? this.pagination,
      errorMessage: errorMessage ?? this.errorMessage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [
    status,
    supervisors,
    pagination,
    errorMessage,
    hasReachedMax,
  ];
}
