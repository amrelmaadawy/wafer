import '../../domain/entities/receivable_entity.dart';

class ReceivableModel extends ReceivableEntity {
  const ReceivableModel({
    required super.id,
    required super.tenantName,
    required super.totalAmount,
    required super.paidAmount,
    required super.remainingAmount,
    super.contractNumber,
    super.propertyName,
    super.unitName,
    required super.dueDate,
    required super.status,
  });

  factory ReceivableModel.fromJson(Map<String, dynamic> json) {
    final total = json['total_amount'] ?? json['amount'] ?? 0;
    final paid = json['paid_amount'] ?? 0;
    final remaining = json['remaining_amount'] ?? ((total is num && paid is num) ? total - paid : 0);

    return ReceivableModel(
      id: json['id'] is int ? json['id'] : (int.tryParse(json['id']?.toString() ?? '0') ?? 0),
      tenantName: json['tenant_name'] ?? json['tenant']?['name'] ?? json['client']?['name'] ?? '',
      totalAmount: total is num ? total : (num.tryParse(total.toString()) ?? 0),
      paidAmount: paid is num ? paid : (num.tryParse(paid.toString()) ?? 0),
      remainingAmount: remaining is num ? remaining : (num.tryParse(remaining.toString()) ?? 0),
      contractNumber: json['contract_number'] ?? json['contract']?['contract_number'],
      propertyName: json['property_name'] ?? json['property']?['name'],
      unitName: json['unit_name'] ?? json['unit']?['name'],
      dueDate: json['due_date'] ?? json['date'] ?? '',
      status: json['status'] ?? 'pending',
    );
  }
}
