import '../../domain/entities/journal_entry_entity.dart';
import 'finance_account_model.dart';

class JournalEntryModel extends JournalEntryEntity {
  const JournalEntryModel({
    required super.id,
    required super.entryNumber,
    required super.entryDate,
    required super.description,
    super.referenceType,
    super.referenceId,
    required super.status,
    required super.totalDebit,
    required super.totalCredit,
    required super.isAuto,
    super.postedAt,
    required super.lines,
    required super.createdAt,
  });

  factory JournalEntryModel.fromJson(Map<String, dynamic> json) {
    return JournalEntryModel(
      id: json['id'] as int,
      entryNumber: json['entry_number'] as String,
      entryDate: json['entry_date'] as String,
      description: json['description'] as String? ?? '',
      referenceType: json['reference_type'] as String?,
      referenceId: json['reference_id'] as int?,
      status: json['status'] as String,
      totalDebit: double.tryParse(json['total_debit']?.toString() ?? '0') ?? 0.0,
      totalCredit: double.tryParse(json['total_credit']?.toString() ?? '0') ?? 0.0,
      isAuto: json['is_auto'] == true,
      postedAt: json['posted_at'] as String?,
      lines: (json['lines'] as List?)?.map((e) => JournalEntryLineModel.fromJson(e)).toList() ?? [],
      createdAt: json['created_at'] as String? ?? '',
    );
  }
}

class JournalEntryLineModel extends JournalEntryLineEntity {
  const JournalEntryLineModel({
    required super.id,
    required super.account,
    required super.debit,
    required super.credit,
    required super.description,
  });

  factory JournalEntryLineModel.fromJson(Map<String, dynamic> json) {
    return JournalEntryLineModel(
      id: json['id'] as int,
      account: FinanceAccountModel.fromJson(json['account']),
      debit: double.tryParse(json['debit']?.toString() ?? '0') ?? 0.0,
      credit: double.tryParse(json['credit']?.toString() ?? '0') ?? 0.0,
      description: json['description'] as String? ?? '',
    );
  }
}
