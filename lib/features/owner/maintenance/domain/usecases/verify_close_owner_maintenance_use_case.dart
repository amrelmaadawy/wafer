import 'package:equatable/equatable.dart';
import '../../../../../../core/error/failures.dart';
import 'package:dartz/dartz.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/maintenance_item_entity.dart';
import '../repositories/owner_maintenance_repository.dart';

class VerifyCloseOwnerMaintenanceUseCase
    implements
        UseCase<MaintenanceItemEntity, VerifyCloseOwnerMaintenanceParams> {
  final OwnerMaintenanceRepository repository;

  VerifyCloseOwnerMaintenanceUseCase(this.repository);

  @override
  Future<Either<Failure, MaintenanceItemEntity>> call(
    VerifyCloseOwnerMaintenanceParams params,
  ) {
    return repository.verifyCloseMaintenanceRequest(params);
  }
}

class VerifyCloseOwnerMaintenanceParams extends Equatable {
  final int id;
  final String qaCode;
  final double actualCost;
  final String notes;

  const VerifyCloseOwnerMaintenanceParams({
    required this.id,
    required this.qaCode,
    required this.actualCost,
    required this.notes,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'qa_code': qaCode.toString(),
      'notes': notes,
    };
    
    if (actualCost % 1 == 0) {
      data['actual_cost'] = actualCost.toInt();
    } else {
      data['actual_cost'] = actualCost;
    }
    
    return data;
  }

  @override
  List<Object?> get props => [id, qaCode, actualCost, notes];
}
