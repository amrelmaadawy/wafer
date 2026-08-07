import '../../domain/entities/journal_entries_response_entity.dart';
import 'journal_entry_model.dart';

class JournalEntriesResponseModel extends JournalEntriesResponseEntity {
  const JournalEntriesResponseModel({
    required super.data,
    required super.currentPage,
    required super.lastPage,
  });

  factory JournalEntriesResponseModel.fromJson(Map<String, dynamic> json) {
    final pagination = json['pagination'] ?? {};
    final journalEntriesList = json['journal-entries'] as List?;
    
    // Sometimes the API wraps list in 'journal-entries' depending on the response format
    final List listToParse = journalEntriesList ?? (json['data'] is List ? json['data'] : []);

    return JournalEntriesResponseModel(
      data: listToParse.map((e) => JournalEntryModel.fromJson(e)).toList(),
      currentPage: pagination['current_page'] as int? ?? 1,
      lastPage: pagination['last_page'] as int? ?? 1,
    );
  }
}
