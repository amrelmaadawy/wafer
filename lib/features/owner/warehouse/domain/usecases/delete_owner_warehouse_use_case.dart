import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../repositories/owner_warehouse_repository.dart';

class DeleteOwnerWarehouseUseCase {
  final OwnerWarehouseRepository repository;

  DeleteOwnerWarehouseUseCase(this.repository);

  Future<Either<Failure, void>> call(int id) async {
    return await repository.deleteWarehouse(id);
  }
}
