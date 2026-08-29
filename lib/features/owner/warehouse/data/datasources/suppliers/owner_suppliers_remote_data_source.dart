import 'package:dio/dio.dart';
import '../../models/suppliers/supplier_model.dart';
import '../../../domain/entities/suppliers/create_owner_supplier_params.dart';
import '../../../domain/entities/suppliers/update_owner_supplier_params.dart';

abstract class OwnerSuppliersRemoteDataSource {
  Future<PaginatedSuppliersModel> getSuppliers(int page);
  Future<SupplierModel> getSupplierDetails(int supplierId);
  Future<SupplierModel> createSupplier(CreateOwnerSupplierParams params);
  Future<SupplierModel> updateSupplier(int supplierId, UpdateOwnerSupplierParams params);
  Future<void> deleteSupplier(int supplierId);
}

class OwnerSuppliersRemoteDataSourceImpl implements OwnerSuppliersRemoteDataSource {
  final Dio dio;

  OwnerSuppliersRemoteDataSourceImpl({required this.dio});

  @override
  Future<PaginatedSuppliersModel> getSuppliers(int page) async {
    final response = await dio.get(
      'owner/warehouse/suppliers',
      queryParameters: {'page': page},
    );

    return PaginatedSuppliersModel.fromJson(response.data);
  }

  @override
  Future<SupplierModel> createSupplier(CreateOwnerSupplierParams params) async {
    final response = await dio.post(
      'owner/warehouse/suppliers',
      data: params.toJson(),
    );
    return SupplierModel.fromJson(response.data['data']['supplier']);
  }

  @override
  Future<SupplierModel> getSupplierDetails(int supplierId) async {
    final response = await dio.get('owner/warehouse/suppliers/$supplierId');
    return SupplierModel.fromJson(response.data['data']['supplier']);
  }

  @override
  Future<SupplierModel> updateSupplier(int supplierId, UpdateOwnerSupplierParams params) async {
    final response = await dio.put(
      'owner/warehouse/suppliers/$supplierId',
      data: params.toJson(),
    );
    return SupplierModel.fromJson(response.data['data']['supplier']);
  }

  @override
  Future<void> deleteSupplier(int supplierId) async {
    await dio.delete('owner/warehouse/suppliers/$supplierId');
  }
}
