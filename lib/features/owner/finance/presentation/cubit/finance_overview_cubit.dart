import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_finance_overview_usecase.dart';
import 'finance_overview_state.dart';

class FinanceOverviewCubit extends Cubit<FinanceOverviewState> {
  final GetFinanceOverviewUseCase getFinanceOverviewUseCase;

  FinanceOverviewCubit({required this.getFinanceOverviewUseCase})
    : super(FinanceOverviewInitial());

  Future<void> fetchFinanceOverview({bool isRefresh = false}) async {
    if (!isRefresh) {
      emit(FinanceOverviewLoading());
    }

    final result = await getFinanceOverviewUseCase(const NoParams());

    result.fold(
      (failure) => emit(FinanceOverviewError(message: failure.message)),
      (overview) => emit(FinanceOverviewLoaded(overview: overview)),
    );
  }
}
