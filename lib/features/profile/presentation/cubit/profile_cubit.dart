import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_profile_use_case.dart';
import '../../domain/usecases/update_profile_use_case.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;

  ProfileCubit(this._getProfileUseCase, this._updateProfileUseCase) : super(const ProfileInitial());

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

  Future<void> updateProfile({
    required String name,
    required String phone,
    required String gender,
  }) async {
    if (state is! ProfileLoaded) return;
    final currentProfile = (state as ProfileLoaded).profile;
    emit(ProfileUpdating(currentProfile));

    final result = await _updateProfileUseCase(
      name: name,
      phone: phone,
      gender: gender,
    );

    result.fold(
      (failure) => emit(ProfileUpdateError(currentProfile, errorMessage: failure.message)),
      (updatedProfile) => emit(ProfileUpdateSuccess(updatedProfile, message: 'تم تحديث البيانات بنجاح')),
    );
  }
}
