import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/create_finance_account_use_case.dart';
import 'create_finance_account_state.dart';

class CreateFinanceAccountCubit extends Cubit<CreateFinanceAccountState> {
  final CreateFinanceAccountUseCase createFinanceAccountUseCase;

  CreateFinanceAccountCubit(this.createFinanceAccountUseCase)
      : super(CreateFinanceAccountInitial());

  Future<void> createAccount({
    int? parentId,
    required String code,
    required String nameAr,
    required String nameEn,
    required String type,
    required bool isPostable,
    required bool isActive,
    String? descriptionAr,
  }) async {
    emit(CreateFinanceAccountLoading());

    final params = CreateFinanceAccountParams(
      parentId: parentId,
      code: code,
      nameAr: nameAr,
      nameEn: nameEn,
      type: type,
      isPostable: isPostable,
      isActive: isActive,
      descriptionAr: descriptionAr,
    );

    final result = await createFinanceAccountUseCase(params);

    result.fold(
      (failure) => emit(CreateFinanceAccountError(failure.message)),
      (account) => emit(const CreateFinanceAccountSuccess('تمت إضافة الحساب بنجاح')),
    );
  }
}
