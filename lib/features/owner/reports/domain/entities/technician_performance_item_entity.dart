import 'package:equatable/equatable.dart';

class TechnicianPerformanceItemEntity extends Equatable {
  final int id;
  final String name;
  final String phone;
  final int completedRequestsCount;
  final int pendingRequestsCount;

  const TechnicianPerformanceItemEntity({
    required this.id,
    required this.name,
    required this.phone,
    required this.completedRequestsCount,
    required this.pendingRequestsCount,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    phone,
    completedRequestsCount,
    pendingRequestsCount,
  ];
}
