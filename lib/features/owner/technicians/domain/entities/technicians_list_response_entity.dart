import 'package:equatable/equatable.dart';
import 'technician_entity.dart';
import 'technicians_pagination_entity.dart';

class TechniciansListResponseEntity extends Equatable {
  final List<TechnicianEntity> technicians;
  final TechniciansPaginationEntity pagination;

  const TechniciansListResponseEntity({
    required this.technicians,
    required this.pagination,
  });

  @override
  List<Object?> get props => [technicians, pagination];
}
