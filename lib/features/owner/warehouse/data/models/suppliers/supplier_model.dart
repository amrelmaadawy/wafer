import '../../../domain/entities/suppliers/supplier_entity.dart';

class SupplierModel extends SupplierEntity {
  const SupplierModel({
    required super.id,
    required super.supplierCode,
    required super.companyName,
    super.contactPerson,
    super.taxNumber,
    super.email,
    super.phone,
    super.companyPhone,
    super.address,
    required super.isActive,
    required super.statusLabel,
    required super.movementsCount,
    required super.createdAt,
    required super.updatedAt,
  });

  factory SupplierModel.fromJson(Map<String, dynamic> json) {
    return SupplierModel(
      id: json['id'] ?? 0,
      supplierCode: json['supplier_code'] ?? '',
      companyName: json['company_name'] ?? '',
      contactPerson: json['contact_person'],
      taxNumber: json['tax_number'],
      email: json['email'],
      phone: json['phone'],
      companyPhone: json['company_phone'],
      address: json['address'],
      isActive: json['is_active'] ?? true,
      statusLabel: json['status_label'] ?? '',
      movementsCount: json['movements_count'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

class PaginatedSuppliersModel extends PaginatedSuppliersEntity {
  const PaginatedSuppliersModel({
    required super.suppliers,
    required super.currentPage,
    required super.lastPage,
    required super.perPage,
    required super.total,
  });

  factory PaginatedSuppliersModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final suppliersList = (data['suppliers'] as List?)
            ?.map((e) => SupplierModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    final pagination = data['pagination'] ?? {};

    return PaginatedSuppliersModel(
      suppliers: suppliersList,
      currentPage: pagination['current_page'] ?? 1,
      lastPage: pagination['last_page'] ?? 1,
      perPage: pagination['per_page'] ?? 15,
      total: pagination['total'] ?? 0,
    );
  }
}
