import '../../domain/entities/receipt_entity.dart';
import 'finance_account_model.dart';

class ReceiptModel extends ReceiptEntity {
  const ReceiptModel({
    required super.id,
    required super.receiptNumber,
    required super.receiptDate,
    required super.amount,
    required super.paymentMethod,
    required super.creditAccountType,
    required super.status,
    required super.owner,
    super.debitAccount,
    super.creditAccount,
    super.notes,
  });

  factory ReceiptModel.fromJson(Map<String, dynamic> json) {
    return ReceiptModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      receiptNumber: json['receipt_number'] ?? '',
      receiptDate: json['receipt_date'] ?? '',
      amount: json['amount'] is num ? json['amount'] : num.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
      paymentMethod: ReceiptTypeModel.fromJson(json['payment_method'] ?? {}),
      creditAccountType:
          ReceiptTypeModel.fromJson(json['credit_account_type'] ?? {}),
      status: json['status'] ?? 'unknown',
      owner: ReceiptOwnerModel.fromJson(json['owner'] ?? {}),
      debitAccount: json['debit_account'] != null
          ? FinanceAccountModel.fromJson(json['debit_account'])
          : null,
      creditAccount: json['credit_account'] != null
          ? FinanceAccountModel.fromJson(json['credit_account'])
          : null,
      notes: json['notes'],
    );
  }
}

class ReceiptTypeModel extends ReceiptTypeEntity {
  const ReceiptTypeModel({
    required super.value,
    required super.label,
  });

  factory ReceiptTypeModel.fromJson(Map<String, dynamic> json) {
    return ReceiptTypeModel(
      value: json['value']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
    );
  }
}

class ReceiptOwnerModel extends ReceiptOwnerEntity {
  const ReceiptOwnerModel({
    required super.id,
    required super.name,
    super.email,
    super.phone,
    required super.userType,
  });

  factory ReceiptOwnerModel.fromJson(Map<String, dynamic> json) {
    return ReceiptOwnerModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name'] ?? '',
      email: json['email'],
      phone: json['phone'],
      userType: json['user_type'] ?? '',
    );
  }
}
