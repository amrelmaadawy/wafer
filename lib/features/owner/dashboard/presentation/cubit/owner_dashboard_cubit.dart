import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../maintenance/domain/entities/maintenance_item_entity.dart';
import '../../../maintenance/domain/usecases/get_owner_maintenance_use_case.dart';
import '../../domain/usecases/get_owner_dashboard_use_case.dart';
import 'owner_dashboard_state.dart';

class OwnerDashboardCubit extends Cubit<OwnerDashboardState> {
  final GetOwnerDashboardUseCase _getDashboardUseCase;
  final GetOwnerMaintenanceUseCase _getMaintenanceUseCase;
  CancelToken? _cancelToken;

  OwnerDashboardCubit(this._getDashboardUseCase, this._getMaintenanceUseCase)
    : super(const OwnerDashboardInitial());

  Future<void> loadDashboardStats({
    bool forceRefresh = false,
    bool showLoadingState = true,
  }) async {
    if (showLoadingState && state is! OwnerDashboardLoaded) {
      emit(const OwnerDashboardLoading());
    }

    _cancelToken?.cancel();
    _cancelToken = CancelToken();

    final result = await _getDashboardUseCase(
      forceRefresh: forceRefresh,
      cancelToken: _cancelToken,
    );
    await result.fold(
      (failure) async => emit(OwnerDashboardError(failure.message)),
      (data) async {
        List<MaintenanceItemEntity> recentItems = [];
        final maintResult = await _getMaintenanceUseCase(
          GetOwnerMaintenanceParams(page: 1, forceRefresh: forceRefresh),
        );
        maintResult.fold((_) {}, (maintData) {
          recentItems = maintData.items.take(5).toList();
        });
        emit(
          OwnerDashboardLoaded(
            data,
            recentMaintenanceItems: recentItems,
          ),
        );

        // Stale-while-revalidate: if not forced, refresh in background
        if (!forceRefresh && !isClosed) {
          _revalidateBackground();
        }
      },
    );
  }

  Future<void> _revalidateBackground() async {
    final result = await _getDashboardUseCase(
      forceRefresh: true,
      cancelToken: _cancelToken,
    );
    result.fold(
      (_) {},
      (data) async {
        if (isClosed) return;
        List<MaintenanceItemEntity> recentItems = [];
        final maintResult = await _getMaintenanceUseCase(
          const GetOwnerMaintenanceParams(page: 1, forceRefresh: true),
        );
        maintResult.fold((_) {}, (maintData) {
          recentItems = maintData.items.take(5).toList();
        });
        if (!isClosed) {
          emit(
            OwnerDashboardLoaded(
              data,
              recentMaintenanceItems: recentItems,
            ),
          );
        }
      },
    );
  }

  @override
  Future<void> close() {
    _cancelToken?.cancel();
    return super.close();
  }
}
