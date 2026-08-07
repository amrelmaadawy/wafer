import 'package:equatable/equatable.dart';
import 'journal_entry_entity.dart';

class JournalEntriesResponseEntity extends Equatable {
  final List<JournalEntryEntity> data;
  final int currentPage;
  final int lastPage;

  const JournalEntriesResponseEntity({
    required this.data,
    required this.currentPage,
    required this.lastPage,
  });

  @override
  List<Object?> get props => [data, currentPage, lastPage];
}
