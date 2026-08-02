import '../../domain/entities/legal_case_complex_sub_entities.dart';

class LegalCaseOptionModel extends LegalCaseOptionEntity {
  const LegalCaseOptionModel({
    super.value,
    super.label,
    super.color,
    super.icon,
  });

  factory LegalCaseOptionModel.fromJson(Map<String, dynamic> json) {
    return LegalCaseOptionModel(
      value: json['value'] as String?,
      label: json['label'] as String?,
      color: json['color'] as String?,
      icon: json['icon'] as String?,
    );
  }
}

class LegalCaseBranchModel extends LegalCaseBranchEntity {
  const LegalCaseBranchModel({
    super.id,
    super.name,
    super.city,
    super.district,
    super.status,
  });

  factory LegalCaseBranchModel.fromJson(Map<String, dynamic> json) {
    return LegalCaseBranchModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      city: json['city'] as String?,
      district: json['district'] as String?,
      status: json['status'] as String?,
    );
  }
}

class LegalCasePropertyModel extends LegalCasePropertyEntity {
  const LegalCasePropertyModel({
    super.id,
    super.name,
    super.code,
    super.city,
    super.district,
    super.branch,
    super.units,
  });

  factory LegalCasePropertyModel.fromJson(Map<String, dynamic> json) {
    return LegalCasePropertyModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      code: json['code'] as String?,
      city: json['city'] as String?,
      district: json['district'] as String?,
      branch: (json['branch'] != null && json['branch'] is Map)
          ? LegalCaseBranchModel.fromJson(json['branch'])
          : null,
      units: (json['units'] != null && json['units'] is List)
          ? (json['units'] as List)
                .map((e) => LegalCaseUnitModel.fromJson(e))
                .toList()
          : null,
    );
  }
}

class LegalCaseUnitModel extends LegalCaseUnitEntity {
  const LegalCaseUnitModel({
    super.id,
    super.propertyId,
    super.propertyName,
    super.name,
    super.unitNumber,
    super.code,
    super.unitStatus,
  });

  factory LegalCaseUnitModel.fromJson(Map<String, dynamic> json) {
    return LegalCaseUnitModel(
      id: json['id'] as int?,
      propertyId: json['property_id'] as int?,
      propertyName: json['property_name'] as String?,
      name: json['name'] as String?,
      unitNumber: json['unit_number'] as String?,
      code: json['code'] as String?,
      unitStatus: json['unit_status'] as String?,
    );
  }
}

class LegalCaseRenterModel extends LegalCaseRenterEntity {
  const LegalCaseRenterModel({super.id, super.name, super.phone});

  factory LegalCaseRenterModel.fromJson(Map<String, dynamic> json) {
    return LegalCaseRenterModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
    );
  }
}

class LegalCaseContractModel extends LegalCaseContractEntity {
  const LegalCaseContractModel({
    super.id,
    super.contractNumber,
    super.propertyId,
    super.unitId,
    super.status,
    super.renter,
  });

  factory LegalCaseContractModel.fromJson(Map<String, dynamic> json) {
    return LegalCaseContractModel(
      id: json['id'] as int?,
      contractNumber: json['contract_number'] as String?,
      propertyId: json['property_id'] as int?,
      unitId: json['unit_id'] as int?,
      status: json['status'] as String?,
      renter: (json['renter'] != null && json['renter'] is Map)
          ? LegalCaseRenterModel.fromJson(json['renter'])
          : null,
    );
  }
}

class LegalCaseInvoiceModel extends LegalCaseInvoiceEntity {
  const LegalCaseInvoiceModel({
    super.id,
    super.invoiceNumber,
    super.contractId,
    super.amount,
    super.status,
    super.renter,
  });

  factory LegalCaseInvoiceModel.fromJson(Map<String, dynamic> json) {
    return LegalCaseInvoiceModel(
      id: json['id'] as int?,
      invoiceNumber: json['invoice_number'] as String?,
      contractId: json['contract_id'] as int?,
      amount: json['amount'] as num?,
      status: json['status'] as String?,
      renter: json['renter'] != null
          ? LegalCaseRenterModel.fromJson(json['renter'])
          : null,
    );
  }
}
