import 'package:equatable/equatable.dart';

class CreateJournalEntryRequestEntity extends Equatable {
  final String entryDate;
  final String description;
  final String status;
  final List<JournalEntryLineRequestEntity> lines;

  const CreateJournalEntryRequestEntity({
    required this.entryDate,
    required this.description,
    this.status = 'draft',
    required this.lines,
  });

  Map<String, dynamic> toJson() {
    return {
      'entry_date': entryDate,
      'description': description,
      'status': status,
      'lines': lines.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [entryDate, description, status, lines];
}

class JournalEntryLineRequestEntity extends Equatable {
  final int accountId;
  final double debit;
  final double credit;
  final String description;
  final int? projectId;
  final int? contractId;

  const JournalEntryLineRequestEntity({
    required this.accountId,
    required this.debit,
    required this.credit,
    required this.description,
    this.projectId,
    this.contractId,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'account_id': accountId,
      'debit': debit,
      'credit': credit,
      'description': description,
    };
    
    if (projectId != null) {
      map['project_id'] = projectId;
    }
    
    if (contractId != null) {
      map['contract_id'] = contractId;
    }
    
    return map;
  }

  @override
  List<Object?> get props => [accountId, debit, credit, description, projectId, contractId];
}
