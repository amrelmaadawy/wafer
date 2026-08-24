import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/warehouse_summary_entity.dart';
import '../repositories/owner_warehouse_repository.dart';

class GetOwnerWarehouseSummaryUseCase
    implements UseCase<WarehouseSummaryEntity, NoParams> {
  final OwnerWarehouseRepository repository;

  GetOwnerWarehouseSummaryUseCase(this.repository);

  @override
  Future<Either<Failure, WarehouseSummaryEntity>> call(NoParams params) async {
    return await repository.getWarehouseSummary();
  }
}
