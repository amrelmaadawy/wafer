import 'package:equatable/equatable.dart';

class SupplierEntity extends Equatable {
  final int id;
  final String supplierCode;
  final String companyName;
  final String? contactPerson;
  final String? taxNumber;
  final String? email;
  final String? phone;
  final String? companyPhone;
  final String? address;
  final bool isActive;
  final String statusLabel;
  final int movementsCount;
  final String createdAt;
  final String updatedAt;

  const SupplierEntity({
    required this.id,
    required this.supplierCode,
    required this.companyName,
    this.contactPerson,
    this.taxNumber,
    this.email,
    this.phone,
    this.companyPhone,
    this.address,
    required this.isActive,
    required this.statusLabel,
    required this.movementsCount,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        supplierCode,
        companyName,
        contactPerson,
        taxNumber,
        email,
        phone,
        companyPhone,
        address,
        isActive,
        statusLabel,
        movementsCount,
        createdAt,
        updatedAt,
      ];
}

class PaginatedSuppliersEntity extends Equatable {
  final List<SupplierEntity> suppliers;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  const PaginatedSuppliersEntity({
    required this.suppliers,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  @override
  List<Object?> get props => [suppliers, currentPage, lastPage, perPage, total];
}
