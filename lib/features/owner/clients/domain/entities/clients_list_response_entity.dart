import 'package:equatable/equatable.dart';
import 'clients_pagination_entity.dart';
import 'client_entity.dart';

class ClientsListResponseEntity extends Equatable {
  final List<ClientEntity> clients;
  final ClientsPaginationEntity pagination;

  const ClientsListResponseEntity({
    required this.clients,
    required this.pagination,
  });

  @override
  List<Object?> get props => [clients, pagination];
}
