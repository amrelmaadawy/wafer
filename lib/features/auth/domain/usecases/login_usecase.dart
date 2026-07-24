import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase implements UseCase<UserEntity, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(LoginParams params) {
    return repository.login(
      username: params.username,
      password: params.password,
      deviceName: params.deviceName,
      deviceToken: params.deviceToken,
      rememberMe: params.rememberMe,
    );
  }
}

class LoginParams extends Equatable {
  final String username;
  final String password;
  final String deviceName;
  final String deviceToken;
  final bool rememberMe;

  const LoginParams({
    required this.username,
    required this.password,
    required this.deviceName,
    required this.deviceToken,
    required this.rememberMe,
  });

  @override
  List<Object> get props => [username, password, deviceName, deviceToken, rememberMe];
}
