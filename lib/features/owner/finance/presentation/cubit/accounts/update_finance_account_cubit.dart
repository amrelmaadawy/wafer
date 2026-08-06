import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/error/failures.dart';
import '../../../domain/usecases/update_finance_account_use_case.dart';
import 'update_finance_account_state.dart';

class UpdateFinanceAccountCubit extends Cubit<UpdateFinanceAccountState> {
  final UpdateFinanceAccountUseCase updateAccountUseCase;

  UpdateFinanceAccountCubit({required this.updateAccountUseCase})
      : super(UpdateFinanceAccountInitial());

  Future<void> updateAccount({
    required int id,
    String? code,
    String? nameAr,
    String? nameEn,
    String? type,
    bool? isPostable,
    bool? isActive,
    String? descriptionAr,
    int? parentId,
  }) async {
    emit(UpdateFinanceAccountLoading());

    final params = UpdateFinanceAccountParams(
      id: id,
      code: code,
      nameAr: nameAr,
      nameEn: nameEn,
      type: type,
      isPostable: isPostable,
      isActive: isActive,
      descriptionAr: descriptionAr,
      parentId: parentId,
    );

    final result = await updateAccountUseCase(params);

    result.fold(
      (failure) {
        String message = 'Unexpected Error';
        if (failure is ServerFailure) {
          message = failure.message;
        } else if (failure is NetworkFailure) {
          message = failure.message;
        }
        emit(UpdateFinanceAccountError(message));
      },
      (account) {
        emit(const UpdateFinanceAccountSuccess('تم تعديل الحساب بنجاح'));
      },
    );
  }
}
