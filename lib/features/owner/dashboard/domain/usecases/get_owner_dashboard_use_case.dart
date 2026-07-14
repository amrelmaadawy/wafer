import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/owner_dashboard_entity.dart';
import '../repositories/owner_dashboard_repository.dart';

class GetOwnerDashboardUseCase {
  final OwnerDashboardRepository _repository;

  GetOwnerDashboardUseCase(this._repository);

  Future<Either<Failure, OwnerDashboardEntity>> call({bool forceRefresh = false}) {
    return _repository.getDashboardStats(forceRefresh: forceRefresh);
  }
}
