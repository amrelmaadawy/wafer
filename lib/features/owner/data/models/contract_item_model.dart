import '../../domain/entities/contract_item_entity.dart';

class ContractItemModel extends ContractItemEntity {
  const ContractItemModel({
    required super.id,
    required super.contractNumber,
    required super.propertyName,
    required super.unitName,
    required super.tenantName,
    required super.startDate,
    required super.endDate,
    required super.rentAmount,
    required super.paymentCycle,
    required super.status,
  });

  factory ContractItemModel.fromJson(Map<String, dynamic> json) {
    // ID parsing
    final id = json['id'] != null ? json['id'].toString() : '';

    // Contract number/code
    final contractNumber = (json['contract_number'] ?? json['code'] ?? json['number'] ?? 'CNT-$id').toString();

    // Property name parsing (nested or flat)
    String propertyName = 'عقار عام';
    if (json['property_name'] != null) {
      propertyName = json['property_name'].toString();
    } else if (json['property'] is Map<String, dynamic>) {
      final propMap = json['property'] as Map<String, dynamic>;
      propertyName = (propMap['name'] ?? propMap['title'] ?? 'عقار غير محدد').toString();
    } else if (json['title'] != null) {
      propertyName = json['title'].toString();
    }

    // Unit name parsing (nested or flat)
    String unitName = '';
    if (json['unit_name'] != null) {
      unitName = json['unit_name'].toString();
    } else if (json['unit'] is Map<String, dynamic>) {
      final unitMap = json['unit'] as Map<String, dynamic>;
      unitName = (unitMap['name'] ?? unitMap['unit_number'] ?? unitMap['number'] ?? 'وحدة').toString();
    }

    // Tenant name parsing
    String tenantName = 'مستأجر غير محدد';
    if (json['tenant_name'] != null) {
      tenantName = json['tenant_name'].toString();
    } else if (json['tenant'] is Map<String, dynamic>) {
      final tenantMap = json['tenant'] as Map<String, dynamic>;
      tenantName = (tenantMap['name'] ?? tenantMap['full_name'] ?? 'مستأجر').toString();
    } else if (json['party_name'] != null) {
      tenantName = json['party_name'].toString();
    }

    // Dates
    final startDate = (json['start_date'] ?? json['from_date'] ?? '').toString();
    final endDate = (json['end_date'] ?? json['to_date'] ?? '').toString();

    // Rent amount
    double rentAmount = 0.0;
    if (json['rent_amount'] != null) {
      rentAmount = double.tryParse(json['rent_amount'].toString()) ?? 0.0;
    } else if (json['total_amount'] != null) {
      rentAmount = double.tryParse(json['total_amount'].toString()) ?? 0.0;
    } else if (json['price'] != null) {
      rentAmount = double.tryParse(json['price'].toString()) ?? 0.0;
    }

    // Payment cycle
    final paymentCycle = (json['payment_cycle'] ?? json['cycle'] ?? json['frequency'] ?? 'monthly').toString();

    // Status
    final status = (json['status'] ?? 'active').toString();

    return ContractItemModel(
      id: id,
      contractNumber: contractNumber,
      propertyName: propertyName,
      unitName: unitName,
      tenantName: tenantName,
      startDate: startDate,
      endDate: endDate,
      rentAmount: rentAmount,
      paymentCycle: paymentCycle,
      status: status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contract_number': contractNumber,
      'property_name': propertyName,
      'unit_name': unitName,
      'tenant_name': tenantName,
      'start_date': startDate,
      'end_date': endDate,
      'rent_amount': rentAmount,
      'payment_cycle': paymentCycle,
      'status': status,
    };
  }
}
