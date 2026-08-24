import 'package:equatable/equatable.dart';
import '../../../domain/entities/client_entity.dart';

abstract class SearchOwnerClientsState extends Equatable {
  const SearchOwnerClientsState();

  @override
  List<Object?> get props => [];
}

class SearchOwnerClientsInitial extends SearchOwnerClientsState {}

class SearchOwnerClientsLoading extends SearchOwnerClientsState {}

class SearchOwnerClientsLoaded extends SearchOwnerClientsState {
  final List<ClientEntity> clients;

  const SearchOwnerClientsLoaded({required this.clients});

  @override
  List<Object?> get props => [clients];
}

class SearchOwnerClientsError extends SearchOwnerClientsState {
  final String message;
  final String keyword;

  const SearchOwnerClientsError({
    required this.message,
    required this.keyword,
  });

  @override
  List<Object?> get props => [message, keyword];
}
