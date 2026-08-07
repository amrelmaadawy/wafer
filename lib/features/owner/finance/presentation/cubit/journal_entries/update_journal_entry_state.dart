import 'package:equatable/equatable.dart';
import '../../../domain/entities/journal_entry_entity.dart';

abstract class UpdateJournalEntryState extends Equatable {
  const UpdateJournalEntryState();

  @override
  List<Object> get props => [];
}

class UpdateJournalEntryInitial extends UpdateJournalEntryState {}

class UpdateJournalEntryLoading extends UpdateJournalEntryState {}

class UpdateJournalEntrySuccess extends UpdateJournalEntryState {
  final JournalEntryEntity journalEntry;

  const UpdateJournalEntrySuccess(this.journalEntry);

  @override
  List<Object> get props => [journalEntry];
}

class UpdateJournalEntryError extends UpdateJournalEntryState {
  final String message;

  const UpdateJournalEntryError(this.message);

  @override
  List<Object> get props => [message];
}
