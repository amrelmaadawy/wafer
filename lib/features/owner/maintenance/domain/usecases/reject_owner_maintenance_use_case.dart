import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../repositories/owner_maintenance_repository.dart';

class RejectOwnerMaintenanceParams {
  final int id;
  final String supervisorNotes;

  const RejectOwnerMaintenanceParams({
    required this.id,
    required this.supervisorNotes,
  });

  Map<String, dynamic> toJson() {
    return {'supervisor_notes': supervisorNotes};
  }
}

class RejectOwnerMaintenanceUseCase {
  final OwnerMaintenanceRepository _repository;

  RejectOwnerMaintenanceUseCase(this._repository);

  Future<Either<Failure, void>> call(
    RejectOwnerMaintenanceParams params,
  ) async {
    return await _repository.rejectMaintenanceRequest(params);
  }
}
