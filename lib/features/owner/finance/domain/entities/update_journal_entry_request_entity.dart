import 'package:equatable/equatable.dart';
import 'create_journal_entry_request_entity.dart';

class UpdateJournalEntryRequestEntity extends Equatable {
  final int journalEntryId;
  final String? entryDate;
  final String? description;
  final List<JournalEntryLineRequestEntity>? lines;

  const UpdateJournalEntryRequestEntity({
    required this.journalEntryId,
    this.entryDate,
    this.description,
    this.lines,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    
    if (entryDate != null) map['entry_date'] = entryDate;
    if (description != null) map['description'] = description;
    if (lines != null) map['lines'] = lines!.map((e) => e.toJson()).toList();
    
    return map;
  }

  @override
  List<Object?> get props => [journalEntryId, entryDate, description, lines];
}
