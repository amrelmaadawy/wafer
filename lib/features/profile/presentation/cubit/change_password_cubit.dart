import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/change_password_use_case.dart';
import 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final ChangePasswordUseCase _changePasswordUseCase;

  ChangePasswordCubit({
    required ChangePasswordUseCase changePasswordUseCase,
  })  : _changePasswordUseCase = changePasswordUseCase,
        super(const ChangePasswordInitial());

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    if (isClosed) return;
    emit(const ChangePasswordLoading());

    final result = await _changePasswordUseCase(
      currentPassword: currentPassword,
      newPassword: newPassword,
      newPasswordConfirmation: newPasswordConfirmation,
    );

    if (isClosed) return;
    result.fold(
      (failure) => emit(ChangePasswordError(failure.message)),
      (_) => emit(const ChangePasswordSuccess()),
    );
  }
}
