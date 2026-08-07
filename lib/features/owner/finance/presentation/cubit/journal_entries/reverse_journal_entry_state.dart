import 'package:equatable/equatable.dart';
import '../../../domain/entities/journal_entry_entity.dart';

abstract class ReverseJournalEntryState extends Equatable {
  const ReverseJournalEntryState();

  @override
  List<Object> get props => [];
}

class ReverseJournalEntryInitial extends ReverseJournalEntryState {}

class ReverseJournalEntryLoading extends ReverseJournalEntryState {
  final int journalEntryId;

  const ReverseJournalEntryLoading(this.journalEntryId);

  @override
  List<Object> get props => [journalEntryId];
}

class ReverseJournalEntrySuccess extends ReverseJournalEntryState {
  final JournalEntryEntity journalEntry;

  const ReverseJournalEntrySuccess(this.journalEntry);

  @override
  List<Object> get props => [journalEntry];
}

class ReverseJournalEntryError extends ReverseJournalEntryState {
  final String message;
  final int journalEntryId;

  const ReverseJournalEntryError(this.message, this.journalEntryId);

  @override
  List<Object> get props => [message, journalEntryId];
}
