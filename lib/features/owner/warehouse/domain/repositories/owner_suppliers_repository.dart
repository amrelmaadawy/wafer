import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/suppliers/supplier_entity.dart';
import '../entities/suppliers/create_owner_supplier_params.dart';
import '../entities/suppliers/update_owner_supplier_params.dart';

abstract class OwnerSuppliersRepository {
  Future<Either<Failure, PaginatedSuppliersEntity>> getSuppliers(int page);
  Future<Either<Failure, SupplierEntity>> getSupplierDetails(int supplierId);
  Future<Either<Failure, SupplierEntity>> createSupplier(CreateOwnerSupplierParams params);
  Future<Either<Failure, SupplierEntity>> updateSupplier(int supplierId, UpdateOwnerSupplierParams params);
  Future<Either<Failure, void>> deleteSupplier(int supplierId);
}
