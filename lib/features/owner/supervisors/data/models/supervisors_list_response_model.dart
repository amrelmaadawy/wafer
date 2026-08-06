import '../../domain/entities/supervisors_list_response_entity.dart';
import 'supervisor_model.dart';
import 'supervisors_pagination_model.dart';

class SupervisorsListResponseModel extends SupervisorsListResponseEntity {
  const SupervisorsListResponseModel({
    required super.supervisors,
    required super.pagination,
  });

  factory SupervisorsListResponseModel.fromJson(Map<String, dynamic> json) {
    return SupervisorsListResponseModel(
      supervisors:
          (json['maintenance_supervisors'] as List?)
              ?.map((e) => SupervisorModel.fromJson(e))
              .toList() ??
          [],
      pagination: SupervisorsPaginationModel.fromJson(json['pagination'] ?? {}),
    );
  }
}
