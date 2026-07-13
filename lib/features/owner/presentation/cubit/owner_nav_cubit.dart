import 'package:flutter_bloc/flutter_bloc.dart';
import 'owner_nav_state.dart';

class OwnerNavCubit extends Cubit<OwnerNavState> {
  OwnerNavCubit() : super(const OwnerNavState());

  void changeTab(int index) {
    if (index != state.currentIndex) {
      emit(state.copyWith(currentIndex: index));
    }
  }
}
