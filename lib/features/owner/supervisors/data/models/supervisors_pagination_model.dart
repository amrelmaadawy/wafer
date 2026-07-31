import '../../domain/entities/supervisors_pagination_entity.dart';

class SupervisorsPaginationModel extends SupervisorsPaginationEntity {
  const SupervisorsPaginationModel({
    required super.currentPage,
    required super.lastPage,
    required super.perPage,
    required super.total,
    super.from,
    super.to,
  });

  factory SupervisorsPaginationModel.fromJson(Map<String, dynamic> json) {
    return SupervisorsPaginationModel(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 15,
      total: json['total'] ?? 0,
      from: json['from'],
      to: json['to'],
    );
  }
}
