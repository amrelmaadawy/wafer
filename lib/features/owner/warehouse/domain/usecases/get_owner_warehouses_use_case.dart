import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/warehouse_list_response_entity.dart';
import '../repositories/owner_warehouse_repository.dart';

class GetOwnerWarehousesUseCase
    extends UseCase<WarehouseListResponseEntity, NoParams> {
  final OwnerWarehouseRepository repository;

  GetOwnerWarehousesUseCase(this.repository);

  @override
  Future<Either<Failure, WarehouseListResponseEntity>> call(NoParams params) {
    return repository.getWarehouses();
  }
}
