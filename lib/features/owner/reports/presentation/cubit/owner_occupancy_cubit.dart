import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_owner_occupancy_report_use_case.dart';
import 'owner_occupancy_state.dart';

class OwnerOccupancyCubit extends Cubit<OwnerOccupancyState> {
  final GetOwnerOccupancyReportUseCase _getOwnerOccupancyReportUseCase;

  OwnerOccupancyCubit(this._getOwnerOccupancyReportUseCase)
      : super(const OwnerOccupancyInitial());

  Future<void> loadOccupancyReport({bool forceRefresh = false}) async {
    if (state is! OwnerOccupancyLoaded) {
      emit(const OwnerOccupancyLoading());
    }

    final result = await _getOwnerOccupancyReportUseCase(
      forceRefresh: forceRefresh,
    );

    result.fold(
      (failure) => emit(OwnerOccupancyError(failure.message)),
      (properties) {
        if (properties.isEmpty) {
          emit(const OwnerOccupancyEmpty());
        } else {
          int totalUnits = 0;
          int totalRented = 0;
          int totalVacant = 0;

          for (final prop in properties) {
            totalUnits += prop.totalUnits;
            totalRented += prop.rentedUnits;
            totalVacant += prop.vacantUnits;
          }

          final overallRate = totalUnits > 0
              ? (totalRented / totalUnits * 100).clamp(0.0, 100.0)
              : 0.0;

          emit(OwnerOccupancyLoaded(
            properties: properties,
            overallRate: overallRate,
            totalUnits: totalUnits,
            totalRented: totalRented,
            totalVacant: totalVacant,
          ));
        }
      },
    );
  }
}
