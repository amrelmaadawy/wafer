import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/create_supervisor_use_case.dart';
import 'create_supervisor_state.dart';

class CreateSupervisorCubit extends Cubit<CreateSupervisorState> {
  final CreateSupervisorUseCase createSupervisorUseCase;

  CreateSupervisorCubit({required this.createSupervisorUseCase})
    : super(CreateSupervisorInitial());

  Future<void> createSupervisor(Map<String, dynamic> body) async {
    emit(CreateSupervisorLoading());

    final result = await createSupervisorUseCase(body);

    result.fold(
      (failure) => emit(CreateSupervisorError(failure.message)),
      (_) => emit(const CreateSupervisorSuccess()),
    );
  }
}
