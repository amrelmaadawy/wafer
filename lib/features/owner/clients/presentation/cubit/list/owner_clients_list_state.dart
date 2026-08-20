import 'package:equatable/equatable.dart';
import '../../../domain/entities/clients_pagination_entity.dart';
import '../../../domain/entities/client_entity.dart';

enum OwnerClientsListStatus { initial, loading, success, failure, loadingMore }

class OwnerClientsListState extends Equatable {
  final OwnerClientsListStatus status;
  final List<ClientEntity> clients;
  final ClientsPaginationEntity? pagination;
  final bool hasReachedMax;
  final String? errorMessage;

  const OwnerClientsListState({
    this.status = OwnerClientsListStatus.initial,
    this.clients = const [],
    this.pagination,
    this.hasReachedMax = false,
    this.errorMessage,
  });

  OwnerClientsListState copyWith({
    OwnerClientsListStatus? status,
    List<ClientEntity>? clients,
    ClientsPaginationEntity? pagination,
    bool? hasReachedMax,
    String? errorMessage,
  }) {
    return OwnerClientsListState(
      status: status ?? this.status,
      clients: clients ?? this.clients,
      pagination: pagination ?? this.pagination,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        clients,
        pagination,
        hasReachedMax,
        errorMessage,
      ];
}
