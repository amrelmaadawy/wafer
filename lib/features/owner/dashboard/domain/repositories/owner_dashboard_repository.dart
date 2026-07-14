import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/owner_dashboard_entity.dart';

abstract class OwnerDashboardRepository {
  Future<Either<Failure, OwnerDashboardEntity>> getDashboardStats({bool forceRefresh = false});
}
