import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/usecases/usecase.dart';
import '../../../domain/usecases/get_owner_warehouse_summary_use_case.dart';
import 'owner_warehouse_summary_state.dart';

class OwnerWarehouseSummaryCubit extends Cubit<OwnerWarehouseSummaryState> {
  final GetOwnerWarehouseSummaryUseCase getWarehouseSummaryUseCase;

  OwnerWarehouseSummaryCubit({required this.getWarehouseSummaryUseCase})
    : super(OwnerWarehouseSummaryInitial());

  Future<void> fetchSummary() async {
    emit(OwnerWarehouseSummaryLoading());
    final result = await getWarehouseSummaryUseCase(NoParams());
    result.fold(
      (failure) => emit(OwnerWarehouseSummaryFailure(failure.message)),
      (summary) => emit(OwnerWarehouseSummarySuccess(summary)),
    );
  }
}
