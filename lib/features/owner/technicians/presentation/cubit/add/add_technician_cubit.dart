import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/add_technician_use_case.dart';
import 'add_technician_state.dart';

class AddTechnicianCubit extends Cubit<AddTechnicianState> {
  final AddTechnicianUseCase addTechnicianUseCase;

  AddTechnicianCubit(this.addTechnicianUseCase) : super(AddTechnicianInitial());

  Future<void> submit({
    required String name,
    required String phone,
    required String specialty,
    required String companyName,
    required bool isActive,
  }) async {
    emit(AddTechnicianLoading());

    final params = AddTechnicianParams(
      name: name,
      phone: phone,
      specialty: specialty,
      companyName: companyName,
      isActive: isActive,
    );

    final result = await addTechnicianUseCase(params);

    result.fold(
      (failure) => emit(AddTechnicianFailure(failure.message)),
      (technician) => emit(AddTechnicianSuccess(technician)),
    );
  }
}
