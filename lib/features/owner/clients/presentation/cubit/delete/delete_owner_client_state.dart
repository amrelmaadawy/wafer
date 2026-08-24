import 'package:equatable/equatable.dart';

enum DeleteOwnerClientStatus { initial, loading, success, failure }

class DeleteOwnerClientState extends Equatable {
  final DeleteOwnerClientStatus status;
  final String? errorMessage;
  final int? deletedClientId;

  const DeleteOwnerClientState({
    this.status = DeleteOwnerClientStatus.initial,
    this.errorMessage,
    this.deletedClientId,
  });

  DeleteOwnerClientState copyWith({
    DeleteOwnerClientStatus? status,
    String? errorMessage,
    int? deletedClientId,
  }) {
    return DeleteOwnerClientState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      deletedClientId: deletedClientId ?? this.deletedClientId,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, deletedClientId];
}
