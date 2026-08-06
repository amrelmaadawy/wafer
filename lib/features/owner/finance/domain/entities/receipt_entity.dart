import 'package:equatable/equatable.dart';

import 'finance_account_entity.dart';

class ReceiptEntity extends Equatable {
  final int id;
  final String receiptNumber;
  final String receiptDate;
  final num amount;
  final ReceiptTypeEntity paymentMethod;
  final ReceiptTypeEntity creditAccountType;
  final String status;
  final ReceiptOwnerEntity owner;
  final FinanceAccountEntity? debitAccount;
  final FinanceAccountEntity? creditAccount;
  final String? notes;

  const ReceiptEntity({
    required this.id,
    required this.receiptNumber,
    required this.receiptDate,
    required this.amount,
    required this.paymentMethod,
    required this.creditAccountType,
    required this.status,
    required this.owner,
    this.debitAccount,
    this.creditAccount,
    this.notes,
  });

  @override
  List<Object?> get props => [
        id,
        receiptNumber,
        receiptDate,
        amount,
        paymentMethod,
        creditAccountType,
        status,
        owner,
        debitAccount,
        creditAccount,
        notes,
      ];
}

class ReceiptTypeEntity extends Equatable {
  final String value;
  final String label;

  const ReceiptTypeEntity({
    required this.value,
    required this.label,
  });

  @override
  List<Object?> get props => [value, label];
}

class ReceiptOwnerEntity extends Equatable {
  final int id;
  final String name;
  final String? email;
  final String? phone;
  final String userType;

  const ReceiptOwnerEntity({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    required this.userType,
  });

  @override
  List<Object?> get props => [id, name, email, phone, userType];
}
