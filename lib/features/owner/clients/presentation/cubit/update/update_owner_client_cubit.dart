import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/update_owner_client_use_case.dart';
import 'update_owner_client_state.dart';

class UpdateOwnerClientCubit extends Cubit<UpdateOwnerClientState> {
  final UpdateOwnerClientUseCase updateOwnerClientUseCase;

  UpdateOwnerClientCubit({required this.updateOwnerClientUseCase})
      : super(const UpdateOwnerClientState());

  Future<void> updateClient({
    required int clientId,
    required String phone,
    required String status,
  }) async {
    emit(state.copyWith(status: UpdateOwnerClientStatus.loading));

    final params = UpdateOwnerClientParams(
      clientId: clientId,
      body: {
        'phone': phone,
        'status': status,
      },
    );

    final result = await updateOwnerClientUseCase(params);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: UpdateOwnerClientStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (client) {
        emit(
          state.copyWith(
            status: UpdateOwnerClientStatus.success,
            updatedClient: client,
          ),
        );
      },
    );
  }
}
