import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final UserEntity user;
  final bool isAutoLogin;

  const Authenticated(this.user, {this.isAutoLogin = false});

  @override
  List<Object> get props => [user, isAutoLogin];
}

class Unauthenticated extends AuthState {}

/// Emitted when session check fails due to network/server error,
/// not because the session has expired. Allows showing a Retry option.
class AuthSessionError extends AuthState {
  final String message;
  const AuthSessionError(this.message);

  @override
  List<Object> get props => [message];
}

class AuthSessionExpired extends AuthState {
  final String? message;
  const AuthSessionExpired([this.message]);

  @override
  List<Object> get props => message != null ? [message!] : [];
}

class AuthForbidden extends AuthState {
  final String? message;
  const AuthForbidden([this.message]);

  @override
  List<Object> get props => message != null ? [message!] : [];
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}
