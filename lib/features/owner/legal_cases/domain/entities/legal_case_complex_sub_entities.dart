import 'package:equatable/equatable.dart';

class LegalCaseOptionEntity extends Equatable {
  final String? value;
  final String? label;
  final String? color;
  final String? icon;

  const LegalCaseOptionEntity({
    this.value,
    this.label,
    this.color,
    this.icon,
  });

  @override
  List<Object?> get props => [value, label, color, icon];
}

class LegalCaseBranchEntity extends Equatable {
  final int? id;
  final String? name;
  final String? city;
  final String? district;
  final String? status;

  const LegalCaseBranchEntity({
    this.id,
    this.name,
    this.city,
    this.district,
    this.status,
  });

  @override
  List<Object?> get props => [id, name, city, district, status];
}

class LegalCasePropertyEntity extends Equatable {
  final int? id;
  final String? name;
  final String? code;
  final String? city;
  final String? district;
  final LegalCaseBranchEntity? branch;
  final List<LegalCaseUnitEntity>? units;

  const LegalCasePropertyEntity({
    this.id,
    this.name,
    this.code,
    this.city,
    this.district,
    this.branch,
    this.units,
  });

  @override
  List<Object?> get props => [id, name, code, city, district, branch, units];
}

class LegalCaseUnitEntity extends Equatable {
  final int? id;
  final int? propertyId;
  final String? propertyName;
  final String? name;
  final String? unitNumber;
  final String? code;
  final String? unitStatus;

  const LegalCaseUnitEntity({
    this.id,
    this.propertyId,
    this.propertyName,
    this.name,
    this.unitNumber,
    this.code,
    this.unitStatus,
  });

  @override
  List<Object?> get props => [
        id,
        propertyId,
        propertyName,
        name,
        unitNumber,
        code,
        unitStatus,
      ];
}

class LegalCaseRenterEntity extends Equatable {
  final int? id;
  final String? name;
  final String? phone;

  const LegalCaseRenterEntity({
    this.id,
    this.name,
    this.phone,
  });

  @override
  List<Object?> get props => [id, name, phone];
}

class LegalCaseContractEntity extends Equatable {
  final int? id;
  final String? contractNumber;
  final int? propertyId;
  final int? unitId;
  final String? status;
  final LegalCaseRenterEntity? renter;

  const LegalCaseContractEntity({
    this.id,
    this.contractNumber,
    this.propertyId,
    this.unitId,
    this.status,
    this.renter,
  });

  @override
  List<Object?> get props => [
        id,
        contractNumber,
        propertyId,
        unitId,
        status,
        renter,
      ];
}

class LegalCaseInvoiceEntity extends Equatable {
  final int? id;
  final String? invoiceNumber;
  final int? contractId;
  final num? amount;
  final String? status;
  final LegalCaseRenterEntity? renter;

  const LegalCaseInvoiceEntity({
    this.id,
    this.invoiceNumber,
    this.contractId,
    this.amount,
    this.status,
    this.renter,
  });

  @override
  List<Object?> get props => [
        id,
        invoiceNumber,
        contractId,
        amount,
        status,
        renter,
      ];
}
