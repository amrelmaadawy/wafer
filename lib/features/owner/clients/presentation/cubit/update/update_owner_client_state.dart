import 'package:equatable/equatable.dart';
import '../../../domain/entities/client_entity.dart';

enum UpdateOwnerClientStatus { initial, loading, success, failure }

class UpdateOwnerClientState extends Equatable {
  final UpdateOwnerClientStatus status;
  final String? errorMessage;
  final ClientEntity? updatedClient;

  const UpdateOwnerClientState({
    this.status = UpdateOwnerClientStatus.initial,
    this.errorMessage,
    this.updatedClient,
  });

  UpdateOwnerClientState copyWith({
    UpdateOwnerClientStatus? status,
    String? errorMessage,
    ClientEntity? updatedClient,
  }) {
    return UpdateOwnerClientState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      updatedClient: updatedClient ?? this.updatedClient,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, updatedClient];
}
