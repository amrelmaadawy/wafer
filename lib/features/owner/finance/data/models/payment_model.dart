import '../../domain/entities/payment_entity.dart';
import 'finance_account_model.dart';
import 'receipt_model.dart';

class PaymentModel extends PaymentEntity {
  const PaymentModel({
    required super.id,
    required super.paymentNumber,
    required super.paymentDate,
    required super.amount,
    required super.paymentMethod,
    required super.debitAccountType,
    required super.status,
    required super.payee,
    super.debitAccount,
    super.creditAccount,
    super.propertyId,
    super.contractId,
    super.journalEntry,
    super.notes,
    super.createdAt,
    super.updatedAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'],
      paymentNumber: json['payment_number'],
      paymentDate: json['payment_date'],
      amount: json['amount'],
      paymentMethod: ReceiptTypeModel.fromJson(json['payment_method']),
      debitAccountType: ReceiptTypeModel.fromJson(json['debit_account_type']),
      status: json['status'],
      payee: PaymentPayeeModel.fromJson(json['payee']),
      debitAccount: json['debit_account'] != null
          ? FinanceAccountModel.fromJson(json['debit_account'])
          : null,
      creditAccount: json['credit_account'] != null
          ? FinanceAccountModel.fromJson(json['credit_account'])
          : null,
      propertyId: json['property_id'],
      contractId: json['contract_id'],
      journalEntry: json['journal_entry'] != null
          ? JournalEntryModel.fromJson(json['journal_entry'])
          : null,
      notes: json['notes'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class PaymentPayeeModel extends PaymentPayeeEntity {
  const PaymentPayeeModel({
    required super.id,
    required super.name,
    super.email,
    super.phone,
    required super.userType,
  });

  factory PaymentPayeeModel.fromJson(Map<String, dynamic> json) {
    return PaymentPayeeModel(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'],
      phone: json['phone'],
      userType: json['user_type'] ?? 'unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'user_type': userType,
    };
  }
}
