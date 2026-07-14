import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_unread_notifications_count_use_case.dart';
import 'unread_count_state.dart';

class UnreadCountCubit extends Cubit<UnreadCountState> {
  final GetUnreadNotificationsCountUseCase _getUnreadCountUseCase;

  UnreadCountCubit(this._getUnreadCountUseCase) : super(const UnreadCountInitial());

  int _currentCount = 0;
  int get currentCount => _currentCount;

  Future<void> getUnreadCount() async {
    if (state is! UnreadCountLoaded) {
      emit(const UnreadCountLoading());
    }

    final result = await _getUnreadCountUseCase(const NoParams());

    result.fold(
      (failure) {
        // If we already have a loaded state or fallback, keep it silent or emit error
        if (state is! UnreadCountLoaded) {
          emit(UnreadCountError(failure.message));
        }
      },
      (count) {
        _currentCount = count;
        emit(UnreadCountLoaded(count));
      },
    );
  }

  void updateCount(int newCount) {
    if (_currentCount == newCount && state is UnreadCountLoaded) return;
    _currentCount = newCount;
    emit(UnreadCountLoaded(newCount));
  }

  void resetCount() {
    _currentCount = 0;
    emit(const UnreadCountLoaded(0));
  }
}
