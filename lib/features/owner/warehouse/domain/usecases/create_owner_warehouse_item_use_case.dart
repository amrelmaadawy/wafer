import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/create_warehouse_item_params.dart';
import '../entities/warehouse_item_entity.dart';
import '../repositories/owner_warehouse_repository.dart';

class CreateOwnerWarehouseItemUseCase
    implements UseCase<WarehouseItemEntity, CreateWarehouseItemParams> {
  final OwnerWarehouseRepository repository;

  CreateOwnerWarehouseItemUseCase(this.repository);

  @override
  Future<Either<Failure, WarehouseItemEntity>> call(
    CreateWarehouseItemParams params,
  ) async {
    return await repository.createWarehouseItem(params);
  }
}
