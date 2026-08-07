import 'package:equatable/equatable.dart';
import 'finance_account_entity.dart';

class JournalEntryEntity extends Equatable {
  final int id;
  final String entryNumber;
  final String entryDate;
  final String description;
  final String? referenceType;
  final int? referenceId;
  final String status;
  final double totalDebit;
  final double totalCredit;
  final bool isAuto;
  final String? postedAt;
  final List<JournalEntryLineEntity> lines;
  final String createdAt;

  const JournalEntryEntity({
    required this.id,
    required this.entryNumber,
    required this.entryDate,
    required this.description,
    this.referenceType,
    this.referenceId,
    required this.status,
    required this.totalDebit,
    required this.totalCredit,
    required this.isAuto,
    this.postedAt,
    required this.lines,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        entryNumber,
        entryDate,
        description,
        referenceType,
        referenceId,
        status,
        totalDebit,
        totalCredit,
        isAuto,
        postedAt,
        lines,
        createdAt,
      ];
}

class JournalEntryLineEntity extends Equatable {
  final int id;
  final FinanceAccountEntity account;
  final double debit;
  final double credit;
  final String description;

  const JournalEntryLineEntity({
    required this.id,
    required this.account,
    required this.debit,
    required this.credit,
    required this.description,
  });

  @override
  List<Object?> get props => [
        id,
        account,
        debit,
        credit,
        description,
      ];
}
