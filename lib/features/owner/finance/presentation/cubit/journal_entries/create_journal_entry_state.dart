import 'package:equatable/equatable.dart';
import '../../../domain/entities/journal_entry_entity.dart';

abstract class CreateJournalEntryState extends Equatable {
  const CreateJournalEntryState();

  @override
  List<Object> get props => [];
}

class CreateJournalEntryInitial extends CreateJournalEntryState {}

class CreateJournalEntryLoading extends CreateJournalEntryState {}

class CreateJournalEntrySuccess extends CreateJournalEntryState {
  final JournalEntryEntity journalEntry;

  const CreateJournalEntrySuccess(this.journalEntry);

  @override
  List<Object> get props => [journalEntry];
}

class CreateJournalEntryError extends CreateJournalEntryState {
  final String message;

  const CreateJournalEntryError(this.message);

  @override
  List<Object> get props => [message];
}
