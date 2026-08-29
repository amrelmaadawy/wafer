import 'package:equatable/equatable.dart';

class UpdateOwnerSupplierParams extends Equatable {
  final String? supplierCode;
  final String? companyName;
  final String? contactPerson;
  final String? taxNumber;
  final String? email;
  final String? phone;
  final String? companyPhone;
  final String? address;
  final bool? isActive;

  const UpdateOwnerSupplierParams({
    this.supplierCode,
    this.companyName,
    this.contactPerson,
    this.taxNumber,
    this.email,
    this.phone,
    this.companyPhone,
    this.address,
    this.isActive,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (supplierCode != null) map['supplier_code'] = supplierCode;
    if (companyName != null) map['company_name'] = companyName;
    if (contactPerson != null) map['contact_person'] = contactPerson;
    if (taxNumber != null) map['tax_number'] = taxNumber;
    if (email != null) map['email'] = email;
    if (phone != null) map['phone'] = phone;
    if (companyPhone != null) map['company_phone'] = companyPhone;
    if (address != null) map['address'] = address;
    if (isActive != null) map['is_active'] = isActive;
    return map;
  }

  @override
  List<Object?> get props => [
        supplierCode,
        companyName,
        contactPerson,
        taxNumber,
        email,
        phone,
        companyPhone,
        address,
        isActive,
      ];
}
