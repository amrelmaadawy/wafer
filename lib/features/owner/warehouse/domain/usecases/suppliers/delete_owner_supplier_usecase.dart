import 'package:dartz/dartz.dart';
import 'package:wafer/core/error/failures.dart';
import '../../repositories/owner_suppliers_repository.dart';

class DeleteOwnerSupplierUseCase {
  final OwnerSuppliersRepository repository;

  DeleteOwnerSupplierUseCase(this.repository);

  Future<Either<Failure, void>> call(int supplierId) async {
    return await repository.deleteSupplier(supplierId);
  }
}
