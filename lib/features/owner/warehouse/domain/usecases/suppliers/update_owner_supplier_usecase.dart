import 'package:dartz/dartz.dart';
import 'package:wafer/core/error/failures.dart';
import '../../entities/suppliers/update_owner_supplier_params.dart';
import '../../entities/suppliers/supplier_entity.dart';
import '../../repositories/owner_suppliers_repository.dart';

class UpdateOwnerSupplierUseCase {
  final OwnerSuppliersRepository repository;

  UpdateOwnerSupplierUseCase(this.repository);

  Future<Either<Failure, SupplierEntity>> call(int id, UpdateOwnerSupplierParams params) {
    return repository.updateSupplier(id, params);
  }
}
