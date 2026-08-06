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
    super.propertyId,
    super.contractId,
    super.journalEntry,
    super.notes,
    super.createdAt,
    super.updatedAt,
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
      propertyId: json['property_id'] is int ? json['property_id'] : int.tryParse(json['property_id']?.toString() ?? ''),
      contractId: json['contract_id'] is int ? json['contract_id'] : int.tryParse(json['contract_id']?.toString() ?? ''),
      journalEntry: json['journal_entry'] != null ? JournalEntryModel.fromJson(json['journal_entry']) : null,
      notes: json['notes'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
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

class JournalEntryModel extends JournalEntryEntity {
  const JournalEntryModel({
    required super.id,
    required super.entryNumber,
    required super.entryDate,
    required super.status,
    required super.totalDebit,
    required super.totalCredit,
  });

  factory JournalEntryModel.fromJson(Map<String, dynamic> json) {
    return JournalEntryModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      entryNumber: json['entry_number'] ?? '',
      entryDate: json['entry_date'] ?? '',
      status: json['status'] ?? '',
      totalDebit: json['total_debit'] is num ? json['total_debit'] : num.tryParse(json['total_debit']?.toString() ?? '0') ?? 0.0,
      totalCredit: json['total_credit'] is num ? json['total_credit'] : num.tryParse(json['total_credit']?.toString() ?? '0') ?? 0.0,
    );
  }
}
