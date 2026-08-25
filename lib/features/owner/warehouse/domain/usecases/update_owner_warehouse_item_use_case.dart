import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/update_warehouse_item_params.dart';
import '../entities/warehouse_item_update_result_entity.dart';
import '../repositories/owner_warehouse_repository.dart';

class UpdateOwnerWarehouseItemUseCase
    implements UseCase<WarehouseItemUpdateResultEntity, UpdateWarehouseItemParams> {
  final OwnerWarehouseRepository repository;

  UpdateOwnerWarehouseItemUseCase(this.repository);

  @override
  Future<Either<Failure, WarehouseItemUpdateResultEntity>> call(
      UpdateWarehouseItemParams params) async {
    return await repository.updateWarehouseItem(params);
  }
}
