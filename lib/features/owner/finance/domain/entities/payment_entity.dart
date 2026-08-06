import 'package:equatable/equatable.dart';

import 'finance_account_entity.dart';
import 'receipt_entity.dart';

class PaymentEntity extends Equatable {
  final int id;
  final String paymentNumber;
  final String paymentDate;
  final num amount;
  final ReceiptTypeEntity paymentMethod;
  final ReceiptTypeEntity debitAccountType;
  final String status;
  final PaymentPayeeEntity payee;
  final FinanceAccountEntity? debitAccount;
  final FinanceAccountEntity? creditAccount;
  final int? propertyId;
  final int? contractId;
  final JournalEntryEntity? journalEntry;
  final String? notes;
  final String? createdAt;
  final String? updatedAt;

  const PaymentEntity({
    required this.id,
    required this.paymentNumber,
    required this.paymentDate,
    required this.amount,
    required this.paymentMethod,
    required this.debitAccountType,
    required this.status,
    required this.payee,
    this.debitAccount,
    this.creditAccount,
    this.propertyId,
    this.contractId,
    this.journalEntry,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        paymentNumber,
        paymentDate,
        amount,
        paymentMethod,
        debitAccountType,
        status,
        payee,
        debitAccount,
        creditAccount,
        propertyId,
        contractId,
        journalEntry,
        notes,
        createdAt,
        updatedAt,
      ];
}

class PaymentPayeeEntity extends Equatable {
  final int id;
  final String name;
  final String? email;
  final String? phone;
  final String userType;

  const PaymentPayeeEntity({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    required this.userType,
  });

  @override
  List<Object?> get props => [id, name, email, phone, userType];
}
