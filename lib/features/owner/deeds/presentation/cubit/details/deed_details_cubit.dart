import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_deed_details_use_case.dart';
import 'deed_details_state.dart';

class DeedDetailsCubit extends Cubit<DeedDetailsState> {
  final GetDeedDetailsUseCase _getDeedDetailsUseCase;

  DeedDetailsCubit(this._getDeedDetailsUseCase)
      : super(const DeedDetailsInitial());

  Future<void> fetchDeedDetails(int deedId) async {
    emit(const DeedDetailsLoading());
    final result = await _getDeedDetailsUseCase(deedId);
    result.fold(
      (failure) => emit(DeedDetailsError(failure.message)),
      (deed) => emit(DeedDetailsLoaded(deed)),
    );
  }
}
