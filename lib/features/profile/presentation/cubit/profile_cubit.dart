import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_profile_use_case.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase _getProfileUseCase;

  ProfileCubit(this._getProfileUseCase) : super(const ProfileInitial());

  Future<void> fetchProfile({bool forceRefresh = false}) async {
    if (!forceRefresh && state is! ProfileLoaded) {
      emit(const ProfileLoading());
    }

    final result = await _getProfileUseCase(forceRefresh: forceRefresh);
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (profile) => emit(ProfileLoaded(profile)),
    );
  }
}
