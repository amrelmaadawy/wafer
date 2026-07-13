import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/localization/locale_keys.dart';
import '../../domain/usecases/get_profile_use_case.dart';
import '../../domain/usecases/update_profile_use_case.dart';
import '../../domain/usecases/update_avatar_use_case.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final UpdateAvatarUseCase _updateAvatarUseCase;

  ProfileCubit(
    this._getProfileUseCase,
    this._updateProfileUseCase,
    this._updateAvatarUseCase,
  ) : super(const ProfileInitial());

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
      (updatedProfile) => emit(ProfileUpdateSuccess(updatedProfile, message: LocaleKeys.profileUpdateSuccess.tr())),
    );
  }

  Future<void> updateAvatar(String imagePath) async {
    if (state is! ProfileLoaded) return;
    final currentProfile = (state as ProfileLoaded).profile;
    emit(ProfileAvatarUpdating(currentProfile));

    final result = await _updateAvatarUseCase(imagePath: imagePath);

    result.fold(
      (failure) => emit(ProfileAvatarUpdateError(currentProfile, errorMessage: failure.message)),
      (updatedProfile) => emit(ProfileAvatarUpdateSuccess(updatedProfile, message: LocaleKeys.profileAvatarSuccess.tr())),
    );
  }
}
