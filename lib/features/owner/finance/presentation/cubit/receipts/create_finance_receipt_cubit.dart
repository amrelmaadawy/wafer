import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/error/failures.dart';
import '../../../domain/usecases/create_finance_receipt_use_case.dart';
import 'create_finance_receipt_state.dart';

class CreateFinanceReceiptCubit extends Cubit<CreateFinanceReceiptState> {
  final CreateFinanceReceiptUseCase createFinanceReceiptUseCase;

  CreateFinanceReceiptCubit(this.createFinanceReceiptUseCase)
      : super(CreateFinanceReceiptInitial());

  Future<void> createReceipt({
    required int ownerId,
    required num amount,
    required String receiptDate,
    required int debitAccountId,
    required int creditAccountId,
    int? propertyId,
    int? contractId,
    int? businessSegmentId,
    String? notes,
  }) async {
    emit(CreateFinanceReceiptLoading());

    final params = CreateFinanceReceiptParams(
      ownerId: ownerId,
      amount: amount,
      receiptDate: receiptDate,
      debitAccountId: debitAccountId,
      creditAccountId: creditAccountId,
      propertyId: propertyId,
      contractId: contractId,
      businessSegmentId: businessSegmentId,
      notes: notes,
    );

    final result = await createFinanceReceiptUseCase(params);

    result.fold(
      (failure) {
        String message = 'Unexpected Error';
        if (failure is ServerFailure) {
          message = failure.message;
        } else if (failure is NetworkFailure) {
          message = failure.message;
        }
        emit(CreateFinanceReceiptError(message));
      },
      (receipt) {
        emit(const CreateFinanceReceiptSuccess());
      },
    );
  }
}
