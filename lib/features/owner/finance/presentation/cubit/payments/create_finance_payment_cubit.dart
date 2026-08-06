import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/create_finance_payment_use_case.dart';
import 'create_finance_payment_state.dart';

class CreateFinancePaymentCubit extends Cubit<CreateFinancePaymentState> {
  final CreateFinancePaymentUseCase createPaymentUseCase;

  CreateFinancePaymentCubit(this.createPaymentUseCase) : super(CreateFinancePaymentInitial());

  Future<void> createPayment({
    required int payeeId,
    required num amount,
    required String paymentDate,
    required int debitAccountId,
    required int creditAccountId,
    String debitAccountType = 'other',
    int? propertyId,
    int? contractId,
    String? notes,
  }) async {
    emit(CreateFinancePaymentLoading());
    final result = await createPaymentUseCase(
      payeeId: payeeId,
      amount: amount,
      paymentDate: paymentDate,
      debitAccountId: debitAccountId,
      creditAccountId: creditAccountId,
      debitAccountType: debitAccountType,
      propertyId: propertyId,
      contractId: contractId,
      notes: notes,
    );

    result.fold(
      (failure) => emit(CreateFinancePaymentError(failure.message)),
      (payment) => emit(const CreateFinancePaymentSuccess('تم إنشاء السند بنجاح')),
    );
  }
}
