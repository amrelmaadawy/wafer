import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/update_owner_warehouse_params.dart';
import '../entities/warehouse_entity.dart';
import '../repositories/owner_warehouse_repository.dart';

class UpdateOwnerWarehouseUseCase {
  final OwnerWarehouseRepository repository;

  UpdateOwnerWarehouseUseCase(this.repository);

  Future<Either<Failure, WarehouseEntity>> call(int id, UpdateOwnerWarehouseParams params) async {
    return await repository.updateWarehouse(id, params);
  }
}
