import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_owner_maintenance_details_use_case.dart';
import 'owner_maintenance_details_state.dart';

class OwnerMaintenanceDetailsCubit
    extends Cubit<OwnerMaintenanceDetailsState> {
  final GetOwnerMaintenanceDetailsUseCase _getDetailsUseCase;

  OwnerMaintenanceDetailsCubit(this._getDetailsUseCase)
      : super(const OwnerMaintenanceDetailsInitial());

  Future<void> getMaintenanceDetails(int id) async {
    emit(const OwnerMaintenanceDetailsLoading());
    final result = await _getDetailsUseCase(id);
    result.fold(
      (failure) => emit(OwnerMaintenanceDetailsError(failure.message)),
      (item) => emit(OwnerMaintenanceDetailsLoaded(item)),
    );
  }
}
