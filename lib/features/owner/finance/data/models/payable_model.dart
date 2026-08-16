import '../../domain/entities/payable_entity.dart';

class PayableModel extends PayableEntity {
  const PayableModel({
    required super.id,
    required super.partyName,
    required super.totalAmount,
    required super.paidAmount,
    required super.remainingAmount,
    super.propertyName,
    super.unitName,
    required super.dueDate,
    required super.status,
    super.notes,
  });

  factory PayableModel.fromJson(Map<String, dynamic> json) {
    final total = json['total_amount'] ?? json['amount'] ?? 0;
    final paid = json['paid_amount'] ?? 0;
    final remaining = json['remaining_amount'] ?? ((total is num && paid is num) ? total - paid : 0);

    return PayableModel(
      id: json['id'] is int ? json['id'] : (int.tryParse(json['id']?.toString() ?? '0') ?? 0),
      partyName: json['party_name'] ?? json['payee']?['name'] ?? json['vendor']?['name'] ?? '',
      totalAmount: total is num ? total : (num.tryParse(total.toString()) ?? 0),
      paidAmount: paid is num ? paid : (num.tryParse(paid.toString()) ?? 0),
      remainingAmount: remaining is num ? remaining : (num.tryParse(remaining.toString()) ?? 0),
      propertyName: json['property_name'] ?? json['property']?['name'],
      unitName: json['unit_name'] ?? json['unit']?['name'],
      dueDate: json['due_date'] ?? json['date'] ?? '',
      status: json['status'] ?? 'pending',
      notes: json['notes'],
    );
  }
}
