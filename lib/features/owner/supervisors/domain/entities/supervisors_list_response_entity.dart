import 'package:equatable/equatable.dart';
import 'supervisor_entity.dart';
import 'supervisors_pagination_entity.dart';

class SupervisorsListResponseEntity extends Equatable {
  final List<SupervisorEntity> supervisors;
  final SupervisorsPaginationEntity pagination;

  const SupervisorsListResponseEntity({
    required this.supervisors,
    required this.pagination,
  });

  @override
  List<Object?> get props => [supervisors, pagination];
}
