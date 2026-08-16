import 'package:equatable/equatable.dart';
import '../../domain/entities/search_results_grouped_entity.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {
  const SearchInitial();
}

class SearchLoading extends SearchState {
  const SearchLoading();
}

class SearchLoaded extends SearchState {
  final SearchResultsGroupedEntity results;
  final String query;

  const SearchLoaded({required this.results, required this.query});

  @override
  List<Object?> get props => [results, query];
}

class SearchEmpty extends SearchState {
  final String query;

  const SearchEmpty({required this.query});

  @override
  List<Object?> get props => [query];
}

class SearchError extends SearchState {
  final String message;

  const SearchError({required this.message});

  @override
  List<Object?> get props => [message];
}
