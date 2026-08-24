import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/delete_owner_client_use_case.dart';
import 'delete_owner_client_state.dart';

class DeleteOwnerClientCubit extends Cubit<DeleteOwnerClientState> {
  final DeleteOwnerClientUseCase deleteOwnerClientUseCase;

  DeleteOwnerClientCubit({required this.deleteOwnerClientUseCase})
      : super(const DeleteOwnerClientState());

  Future<void> deleteClient(int clientId) async {
    emit(state.copyWith(status: DeleteOwnerClientStatus.loading));

    final result = await deleteOwnerClientUseCase(clientId);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: DeleteOwnerClientStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (_) {
        emit(
          state.copyWith(
            status: DeleteOwnerClientStatus.success,
            deletedClientId: clientId,
          ),
        );
      },
    );
  }
}
