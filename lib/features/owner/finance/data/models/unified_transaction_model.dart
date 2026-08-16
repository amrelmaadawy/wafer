import '../../domain/entities/unified_transaction_entity.dart';

class UnifiedTransactionModel extends UnifiedTransactionEntity {
  const UnifiedTransactionModel({
    required super.id,
    required super.referenceNumber,
    required super.type,
    required super.date,
    required super.amount,
    required super.isPositive,
    super.propertyName,
    super.unitName,
    super.contractNumber,
    required super.status,
    super.partyName,
    super.notes,
  });

  factory UnifiedTransactionModel.fromJson(Map<String, dynamic> json) {
    final typeStr = (json['type'] ?? json['transaction_type'] ?? 'receipt')
        .toString()
        .toLowerCase();
    UnifiedTransactionType type;
    bool isPositive;

    switch (typeStr) {
      case 'payment':
        type = UnifiedTransactionType.payment;
        isPositive = false;
        break;
      case 'transfer':
        type = UnifiedTransactionType.transfer;
        isPositive = false;
        break;
      case 'adjustment':
        type = UnifiedTransactionType.adjustment;
        isPositive = (json['is_positive'] == true) || ((json['amount'] ?? 0) >= 0);
        break;
      case 'receipt':
      default:
        type = UnifiedTransactionType.receipt;
        isPositive = true;
        break;
    }

    final rawAmount = json['amount'] ?? json['total_amount'] ?? 0;
    final num amount = rawAmount is num ? rawAmount : (num.tryParse(rawAmount.toString()) ?? 0);

    return UnifiedTransactionModel(
      id: json['id'] is int ? json['id'] : (int.tryParse(json['id']?.toString() ?? '0') ?? 0),
      referenceNumber: json['reference_number'] ??
          json['receipt_number'] ??
          json['payment_number'] ??
          json['transfer_number'] ??
          '#${json['id'] ?? ''}',
      type: type,
      date: json['date'] ?? json['receipt_date'] ?? json['payment_date'] ?? json['transfer_date'] ?? json['created_at'] ?? '',
      amount: amount.abs(),
      isPositive: isPositive,
      propertyName: json['property_name'] ?? json['property']?['name'],
      unitName: json['unit_name'] ?? json['unit']?['name'],
      contractNumber: json['contract_number'] ?? json['contract']?['contract_number'],
      status: json['status'] ?? 'pending',
      partyName: json['party_name'] ??
          json['payee']?['name'] ??
          json['owner']?['name'] ??
          json['tenant']?['name'],
      notes: json['notes'],
    );
  }
}
