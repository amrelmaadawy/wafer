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
    super.propertyName,
    super.unitId,
    super.unitName,
    super.contractId,
    super.contractNumber,
    super.tenantId,
    super.tenantName,
    super.journalEntry,
    super.notes,
    super.createdAt,
    super.updatedAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    final propertyMap = json['property'] is Map<String, dynamic> ? json['property'] as Map<String, dynamic> : null;
    final unitMap = json['unit'] is Map<String, dynamic> ? json['unit'] as Map<String, dynamic> : null;
    final contractMap = json['contract'] is Map<String, dynamic> ? json['contract'] as Map<String, dynamic> : null;
    final tenantMap = json['tenant'] is Map<String, dynamic> ? json['tenant'] as Map<String, dynamic> : null;

    return PaymentModel(
      id: json['id'],
      paymentNumber: json['payment_number']?.toString() ?? '',
      paymentDate: json['payment_date']?.toString() ?? '',
      amount: json['amount'] ?? 0,
      paymentMethod: ReceiptTypeModel.fromJson(json['payment_method'] ?? {}),
      debitAccountType: ReceiptTypeModel.fromJson(json['debit_account_type'] ?? {}),
      status: json['status']?.toString() ?? '',
      payee: PaymentPayeeModel.fromJson(json['payee'] ?? {}),
      debitAccount: json['debit_account'] != null
          ? FinanceAccountModel.fromJson(json['debit_account'])
          : null,
      creditAccount: json['credit_account'] != null
          ? FinanceAccountModel.fromJson(json['credit_account'])
          : null,
      propertyId: json['property_id'] ?? propertyMap?['id'],
      propertyName: json['property_name'] ?? propertyMap?['name'],
      unitId: json['unit_id'] ?? unitMap?['id'],
      unitName: json['unit_name'] ?? unitMap?['name'] ?? unitMap?['unit_number'],
      contractId: json['contract_id'] ?? contractMap?['id'],
      contractNumber: json['contract_number'] ?? contractMap?['contract_number'] ?? contractMap?['number'],
      tenantId: json['tenant_id'] ?? tenantMap?['id'],
      tenantName: json['tenant_name'] ?? tenantMap?['name'],
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
