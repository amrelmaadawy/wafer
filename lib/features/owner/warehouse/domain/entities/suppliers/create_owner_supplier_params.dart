import 'package:equatable/equatable.dart';

class CreateOwnerSupplierParams extends Equatable {
  final String supplierCode;
  final String companyName;
  final String? contactPerson;
  final String? taxNumber;
  final String? email;
  final String? phone;
  final String? companyPhone;
  final String? address;
  final bool isActive;

  const CreateOwnerSupplierParams({
    required this.supplierCode,
    required this.companyName,
    this.contactPerson,
    this.taxNumber,
    this.email,
    this.phone,
    this.companyPhone,
    this.address,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'supplier_code': supplierCode,
      'company_name': companyName,
      if (contactPerson != null && contactPerson!.isNotEmpty) 'contact_person': contactPerson,
      if (taxNumber != null && taxNumber!.isNotEmpty) 'tax_number': taxNumber,
      if (email != null && email!.isNotEmpty) 'email': email,
      if (phone != null && phone!.isNotEmpty) 'phone': phone,
      if (companyPhone != null && companyPhone!.isNotEmpty) 'company_phone': companyPhone,
      if (address != null && address!.isNotEmpty) 'address': address,
      'is_active': isActive,
    };
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
