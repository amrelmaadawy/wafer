import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_owner_dashboard_use_case.dart';
import 'owner_dashboard_state.dart';

class OwnerDashboardCubit extends Cubit<OwnerDashboardState> {
  final GetOwnerDashboardUseCase _getDashboardUseCase;

  OwnerDashboardCubit(this._getDashboardUseCase) : super(const OwnerDashboardInitial());

  Future<void> loadDashboardStats({bool forceRefresh = false}) async {
    if (state is! OwnerDashboardLoaded) {
      emit(const OwnerDashboardLoading());
    }
    final result = await _getDashboardUseCase(forceRefresh: forceRefresh);
    result.fold(
      (failure) => emit(OwnerDashboardError(failure.message)),
      (data) => emit(OwnerDashboardLoaded(data)),
    );
  }
}
