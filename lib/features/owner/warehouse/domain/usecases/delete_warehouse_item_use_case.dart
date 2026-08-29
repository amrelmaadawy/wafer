import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/owner_warehouse_repository.dart';

class DeleteWarehouseItemUseCase extends UseCase<void, int> {
  final OwnerWarehouseRepository repository;

  DeleteWarehouseItemUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(int id) async {
    return await repository.deleteWarehouseItem(id);
  }
}
