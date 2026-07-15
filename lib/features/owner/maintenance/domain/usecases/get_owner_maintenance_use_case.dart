import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/maintenance_response_entity.dart';
import '../repositories/owner_maintenance_repository.dart';

class GetOwnerMaintenanceParams extends Equatable {
  final int page;
  final String? status;
  final bool forceRefresh;

  const GetOwnerMaintenanceParams({
    this.page = 1,
    this.status,
    this.forceRefresh = false,
  });

  @override
  List<Object?> get props => [page, status, forceRefresh];
}

class GetOwnerMaintenanceUseCase
    implements UseCase<MaintenanceResponseEntity, GetOwnerMaintenanceParams> {
  final OwnerMaintenanceRepository _repository;

  GetOwnerMaintenanceUseCase(this._repository);

  @override
  Future<Either<Failure, MaintenanceResponseEntity>> call(
      GetOwnerMaintenanceParams params) {
    return _repository.getMaintenanceRequests(
      page: params.page,
      status: params.status,
      forceRefresh: params.forceRefresh,
    );
  }
}
