import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../repositories/owner_maintenance_repository.dart';

class ApproveOwnerMaintenanceParams {
  final int id;
  final num estimatedCost;
  final num? advancePayment;
  final String costBearer;
  final String? supervisorNotes;

  const ApproveOwnerMaintenanceParams({
    required this.id,
    required this.estimatedCost,
    this.advancePayment,
    required this.costBearer,
    this.supervisorNotes,
  });

  Map<String, dynamic> toJson() {
    return {
      'estimated_cost': estimatedCost,
      if (advancePayment != null) 'advance_payment': advancePayment,
      'cost_bearer': costBearer,
      if (supervisorNotes != null && supervisorNotes!.trim().isNotEmpty)
        'supervisor_notes': supervisorNotes,
    };
  }
}

class ApproveOwnerMaintenanceUseCase {
  final OwnerMaintenanceRepository _repository;

  ApproveOwnerMaintenanceUseCase(this._repository);

  Future<Either<Failure, void>> call(ApproveOwnerMaintenanceParams params) {
    return _repository.approveMaintenanceRequest(params);
  }
}
