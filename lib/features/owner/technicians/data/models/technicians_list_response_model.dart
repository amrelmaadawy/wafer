import '../../domain/entities/technicians_list_response_entity.dart';
import 'technician_model.dart';
import 'technicians_pagination_model.dart';

class TechniciansListResponseModel extends TechniciansListResponseEntity {
  const TechniciansListResponseModel({
    required super.technicians,
    required super.pagination,
  });

  factory TechniciansListResponseModel.fromJson(Map<String, dynamic> json) {
    final techniciansList = (json['maintenance_technicians'] as List<dynamic>?)
            ?.map((e) => TechnicianModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    final pagination = TechniciansPaginationModel.fromJson(
        json['pagination'] as Map<String, dynamic>? ?? {});

    return TechniciansListResponseModel(
      technicians: techniciansList,
      pagination: pagination,
    );
  }
}
