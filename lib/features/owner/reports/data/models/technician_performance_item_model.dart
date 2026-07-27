import '../../domain/entities/technician_performance_item_entity.dart';

class TechnicianPerformanceItemModel extends TechnicianPerformanceItemEntity {
  const TechnicianPerformanceItemModel({
    required super.id,
    required super.name,
    required super.phone,
    required super.completedRequestsCount,
    required super.pendingRequestsCount,
  });

  factory TechnicianPerformanceItemModel.fromJson(Map<String, dynamic> json) {
    return TechnicianPerformanceItemModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      completedRequestsCount: json['completed_requests_count'] ?? 0,
      pendingRequestsCount: json['pending_requests_count'] ?? 0,
    );
  }
}
