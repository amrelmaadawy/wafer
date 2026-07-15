import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_owner_defaulters_report_use_case.dart';
import 'owner_defaulters_state.dart';

class OwnerDefaultersCubit extends Cubit<OwnerDefaultersState> {
  final GetOwnerDefaultersReportUseCase _getOwnerDefaultersReportUseCase;

  OwnerDefaultersCubit(this._getOwnerDefaultersReportUseCase)
      : super(const OwnerDefaultersInitial());

  Future<void> loadDefaultersReport({bool forceRefresh = false}) async {
    if (state is! OwnerDefaultersLoaded) {
      emit(const OwnerDefaultersLoading());
    }

    final result = await _getOwnerDefaultersReportUseCase(
      forceRefresh: forceRefresh,
    );

    result.fold(
      (failure) => emit(OwnerDefaultersError(failure.message)),
      (defaulters) {
        if (defaulters.isEmpty) {
          emit(const OwnerDefaultersEmpty());
        } else {
          double totalOverdue = 0.0;
          for (final d in defaulters) {
            totalOverdue += d.overdueAmount;
          }
          emit(OwnerDefaultersLoaded(
            defaulters: defaulters,
            totalOverdueAmount: totalOverdue,
            totalDefaultersCount: defaulters.length,
          ));
        }
      },
    );
  }
}
