import 'package:equatable/equatable.dart';
import '../../../domain/entities/journal_entry_entity.dart';

abstract class JournalEntriesState extends Equatable {
  const JournalEntriesState();

  @override
  List<Object> get props => [];
}

class JournalEntriesInitial extends JournalEntriesState {}

class JournalEntriesLoading extends JournalEntriesState {}

class JournalEntriesLoaded extends JournalEntriesState {
  final List<JournalEntryEntity> entries;
  final bool hasReachedMax;

  const JournalEntriesLoaded({
    required this.entries,
    required this.hasReachedMax,
  });

  @override
  List<Object> get props => [entries, hasReachedMax];
}

class JournalEntriesLoadingMore extends JournalEntriesState {
  final List<JournalEntryEntity> entries;
  final bool hasReachedMax;

  const JournalEntriesLoadingMore({
    required this.entries,
    required this.hasReachedMax,
  });

  @override
  List<Object> get props => [entries, hasReachedMax];
}

class JournalEntriesError extends JournalEntriesState {
  final String message;
  final List<JournalEntryEntity> entries;

  const JournalEntriesError({
    required this.message,
    required this.entries,
  });

  @override
  List<Object> get props => [message, entries];
}

class JournalEntriesEmpty extends JournalEntriesState {}
