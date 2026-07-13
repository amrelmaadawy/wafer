import 'package:equatable/equatable.dart';
import '../../domain/entities/profile_entity.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final ProfileEntity profile;

  const ProfileLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProfileUpdating extends ProfileLoaded {
  const ProfileUpdating(super.profile);
}

class ProfileUpdateSuccess extends ProfileLoaded {
  final String message;

  const ProfileUpdateSuccess(super.profile, {required this.message});

  @override
  List<Object?> get props => [profile, message];
}

class ProfileUpdateError extends ProfileLoaded {
  final String errorMessage;

  const ProfileUpdateError(super.profile, {required this.errorMessage});

  @override
  List<Object?> get props => [profile, errorMessage];
}

