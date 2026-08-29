import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/create_owner_warehouse_params.dart';
import '../entities/warehouse_entity.dart';
import '../repositories/owner_warehouse_repository.dart';

class CreateOwnerWarehouseUseCase
    implements UseCase<WarehouseEntity, CreateOwnerWarehouseParams> {
  final OwnerWarehouseRepository repository;

  CreateOwnerWarehouseUseCase(this.repository);

  @override
  Future<Either<Failure, WarehouseEntity>> call(
      CreateOwnerWarehouseParams params) {
    return repository.createWarehouse(params);
  }
}
