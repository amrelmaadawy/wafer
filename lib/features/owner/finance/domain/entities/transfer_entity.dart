import 'package:equatable/equatable.dart';

class TransferEntity extends Equatable {
  final int id;
  final String transferNumber;
  final String transferDate;
  final double amount;
  final TransferAccountEntity? fromAccount;
  final TransferAccountEntity? toAccount;
  final String? referenceNumber;
  final String status;
  final String? notes;
  final String? createdAt;

  const TransferEntity({
    required this.id,
    required this.transferNumber,
    required this.transferDate,
    required this.amount,
    this.fromAccount,
    this.toAccount,
    this.referenceNumber,
    required this.status,
    this.notes,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        transferNumber,
        transferDate,
        amount,
        fromAccount,
        toAccount,
        referenceNumber,
        status,
        notes,
        createdAt,
      ];
}

class TransferAccountEntity extends Equatable {
  final int id;
  final String code;
  final String nameAr;
  final String nameEn;
  final String type;

  const TransferAccountEntity({
    required this.id,
    required this.code,
    required this.nameAr,
    required this.nameEn,
    required this.type,
  });

  @override
  List<Object?> get props => [id, code, nameAr, nameEn, type];
}
