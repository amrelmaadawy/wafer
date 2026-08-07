import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/create_transfer_request_entity.dart';
import '../../../domain/usecases/create_transfer_use_case.dart';

part 'create_transfer_state.dart';

class CreateTransferCubit extends Cubit<CreateTransferState> {
  final CreateTransferUseCase createTransferUseCase;

  CreateTransferCubit(this.createTransferUseCase) : super(CreateTransferInitial());

  Future<void> createTransfer(CreateTransferRequestEntity request) async {
    emit(CreateTransferLoading());

    final result = await createTransferUseCase(request);
    result.fold(
      (failure) {
        // Validation errors are mapped to ServerFailure strings by the repository
        emit(CreateTransferError(message: failure.message));
      },
      (transfer) {
        emit(CreateTransferSuccess());
      },
    );
  }
}
