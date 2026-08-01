import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../maintenance/domain/entities/maintenance_item_entity.dart';
import '../../../maintenance/domain/usecases/get_owner_maintenance_use_case.dart';
import '../../domain/usecases/get_owner_dashboard_use_case.dart';
import 'owner_dashboard_state.dart';

class OwnerDashboardCubit extends Cubit<OwnerDashboardState> {
  final GetOwnerDashboardUseCase _getDashboardUseCase;
  final GetOwnerMaintenanceUseCase _getMaintenanceUseCase;

  OwnerDashboardCubit(this._getDashboardUseCase, this._getMaintenanceUseCase)
    : super(const OwnerDashboardInitial());

  Future<void> loadDashboardStats({bool forceRefresh = false}) async {
    if (state is! OwnerDashboardLoaded) {
      emit(const OwnerDashboardLoading());
    }
    final result = await _getDashboardUseCase(forceRefresh: forceRefresh);
    await result.fold(
      (failure) async => emit(OwnerDashboardError(failure.message)),
      (data) async {
        List<MaintenanceItemEntity> recentItems = [];
        final maintResult = await _getMaintenanceUseCase(
          GetOwnerMaintenanceParams(page: 1, forceRefresh: forceRefresh),
        );
        maintResult.fold(
          (_) {},
          (maintData) {
            recentItems = maintData.items.take(5).toList();
          },
        );
        emit(
          OwnerDashboardLoaded(
            data,
            recentMaintenanceItems: recentItems,
          ),
        );
      },
    );
  }
}
