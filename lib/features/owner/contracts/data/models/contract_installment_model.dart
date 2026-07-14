import '../../domain/entities/contract_installment_entity.dart';

class ContractInstallmentModel extends ContractInstallmentEntity {
  const ContractInstallmentModel({
    required super.id,
    required super.installmentNumber,
    required super.dueDate,
    required super.amount,
    required super.paidAmount,
    required super.remaining,
    required super.status,
    required super.statusLabel,
  });

  factory ContractInstallmentModel.fromJson(Map<String, dynamic> json) {
    return ContractInstallmentModel(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      installmentNumber: json['installment_number'] is int
          ? json['installment_number']
          : int.tryParse('${json['installment_number']}') ?? 0,
      dueDate: json['due_date']?.toString() ?? '',
      amount: (json['amount'] is num)
          ? (json['amount'] as num).toDouble()
          : double.tryParse('${json['amount']}') ?? 0.0,
      paidAmount: (json['paid_amount'] is num)
          ? (json['paid_amount'] as num).toDouble()
          : double.tryParse('${json['paid_amount']}') ?? 0.0,
      remaining: (json['remaining'] is num)
          ? (json['remaining'] as num).toDouble()
          : double.tryParse('${json['remaining']}') ?? 0.0,
      status: json['status']?.toString() ?? 'unpaid',
      statusLabel: json['status_label']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'installment_number': installmentNumber,
      'due_date': dueDate,
      'amount': amount,
      'paid_amount': paidAmount,
      'remaining': remaining,
      'status': status,
      'status_label': statusLabel,
    };
  }

  static List<ContractInstallmentModel> fromJsonList(dynamic json) {
    if (json is List) {
      return json
          .whereType<Map<String, dynamic>>()
          .map((item) => ContractInstallmentModel.fromJson(item))
          .toList();
    } else if (json is Map<String, dynamic>) {
      if (json['data'] is List) {
        return (json['data'] as List)
            .whereType<Map<String, dynamic>>()
            .map((item) => ContractInstallmentModel.fromJson(item))
            .toList();
      } else if (json['installments'] is List) {
        return (json['installments'] as List)
            .whereType<Map<String, dynamic>>()
            .map((item) => ContractInstallmentModel.fromJson(item))
            .toList();
      }
    }
    return [];
  }
}
