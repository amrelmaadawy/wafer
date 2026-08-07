import 'package:equatable/equatable.dart';
import '../../../domain/entities/journal_entry_entity.dart';

abstract class PostJournalEntryState extends Equatable {
  const PostJournalEntryState();

  @override
  List<Object?> get props => [];
}

class PostJournalEntryInitial extends PostJournalEntryState {}

class PostJournalEntryLoading extends PostJournalEntryState {
  final int entryId;

  const PostJournalEntryLoading({required this.entryId});

  @override
  List<Object?> get props => [entryId];
}

class PostJournalEntrySuccess extends PostJournalEntryState {
  final JournalEntryEntity entry;

  const PostJournalEntrySuccess(this.entry);

  @override
  List<Object?> get props => [entry];
}

class PostJournalEntryError extends PostJournalEntryState {
  final String message;

  const PostJournalEntryError(this.message);

  @override
  List<Object?> get props => [message];
}
