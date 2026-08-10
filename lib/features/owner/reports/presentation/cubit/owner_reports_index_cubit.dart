import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_owner_reports_index_usecase.dart';
import 'owner_reports_index_state.dart';

class OwnerReportsIndexCubit extends Cubit<OwnerReportsIndexState> {
  final GetOwnerReportsIndexUseCase _getReportsIndexUseCase;

  OwnerReportsIndexCubit({
    required GetOwnerReportsIndexUseCase getReportsIndexUseCase,
  })  : _getReportsIndexUseCase = getReportsIndexUseCase,
        super(OwnerReportsIndexInitial());

  Future<void> fetchReportsIndex() async {
    if (isClosed) return;
    emit(OwnerReportsIndexLoading());

    final result = await _getReportsIndexUseCase(NoParams());

    if (isClosed) return;
    result.fold(
      (failure) => emit(OwnerReportsIndexError(message: failure.message)),
      (indexData) => emit(OwnerReportsIndexLoaded(indexData: indexData)),
    );
  }
}
