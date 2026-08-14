import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/create_supervisor_use_case.dart';
import '../../../domain/entities/create_maintenance_supervisor_params.dart';
import 'create_supervisor_state.dart';

class CreateSupervisorCubit extends Cubit<CreateSupervisorState> {
  final CreateSupervisorUseCase createSupervisorUseCase;

  CreateSupervisorCubit({required this.createSupervisorUseCase})
    : super(CreateSupervisorInitial());

  Future<void> createSupervisor(CreateMaintenanceSupervisorParams params) async {
    emit(CreateSupervisorLoading());

    final result = await createSupervisorUseCase(params);

    result.fold(
      (failure) => emit(CreateSupervisorError(failure.message)),
      (_) => emit(const CreateSupervisorSuccess()),
    );
  }
}
