import 'package:equatable/equatable.dart';
import '../../../../../../core/error/failures.dart';
import 'package:dartz/dartz.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/execute_owner_maintenance_response_entity.dart';
import '../repositories/owner_maintenance_repository.dart';

class ExecuteOwnerMaintenanceUseCase
    implements
        UseCase<
          ExecuteOwnerMaintenanceResponseEntity,
          ExecuteOwnerMaintenanceParams
        > {
  final OwnerMaintenanceRepository repository;

  ExecuteOwnerMaintenanceUseCase(this.repository);

  @override
  Future<Either<Failure, ExecuteOwnerMaintenanceResponseEntity>> call(
    ExecuteOwnerMaintenanceParams params,
  ) {
    return repository.executeMaintenanceRequest(params);
  }
}

class ExecuteOwnerMaintenanceParams extends Equatable {
  final int id;
  final String technicianResponse;
  final double actualCost;

  const ExecuteOwnerMaintenanceParams({
    required this.id,
    required this.technicianResponse,
    required this.actualCost,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'technician_response': technicianResponse,
    };
    
    if (actualCost % 1 == 0) {
      data['actual_cost'] = actualCost.toInt();
    } else {
      data['actual_cost'] = actualCost;
    }
    
    return data;
  }

  @override
  List<Object?> get props => [id, technicianResponse, actualCost];
}
