import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_owner_revenue_report_use_case.dart';
import 'owner_revenue_state.dart';

class OwnerRevenueCubit extends Cubit<OwnerRevenueState> {
  final GetOwnerRevenueReportUseCase _getReportUseCase;

  OwnerRevenueCubit(this._getReportUseCase)
      : super(const OwnerRevenueInitial());

  Future<void> loadRevenueReport({bool forceRefresh = false}) async {
    if (state is! OwnerRevenueLoaded || forceRefresh) {
      emit(const OwnerRevenueLoading());
    }

    final result = await _getReportUseCase(
      GetOwnerRevenueReportParams(forceRefresh: forceRefresh),
    );

    result.fold(
      (failure) => emit(OwnerRevenueError(failure.message)),
      (entries) {
        if (entries.isEmpty) {
          emit(const OwnerRevenueEmpty());
        } else {
          final totalExpected =
              entries.fold(0.0, (sum, item) => sum + item.expected);
          final totalCollected =
              entries.fold(0.0, (sum, item) => sum + item.collected);
          final rate = totalExpected > 0 ? totalCollected / totalExpected : 0.0;

          emit(OwnerRevenueLoaded(
            entries: entries,
            totalExpected: totalExpected,
            totalCollected: totalCollected,
            collectionRate: rate,
          ));
        }
      },
    );
  }
}
