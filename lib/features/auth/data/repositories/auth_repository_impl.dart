import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/localization/locale_keys.dart';
import '../../../../core/storage/cache_helper.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorageService _secureStorageService;
  final CacheHelper _cacheHelper;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required SecureStorageService secureStorageService,
    required CacheHelper cacheHelper,
  })  : _remoteDataSource = remoteDataSource,
        _secureStorageService = secureStorageService,
        _cacheHelper = cacheHelper;

  @override
  Future<Either<Failure, UserEntity>> login({
    required String username,
    required String password,
    required String deviceName,
    required String deviceToken,
  }) async {
    try {
      final userModel = await _remoteDataSource.login(
        username: username,
        password: password,
        deviceName: deviceName,
        deviceToken: deviceToken,
      );

      if (userModel.token != null && userModel.token!.isNotEmpty) {
        await _secureStorageService.saveToken(userModel.token!);
      }
      await _cacheHelper.saveAccountType(userModel.accountType);
      if (userModel.tenantId != null) {
        await _cacheHelper.saveTenantId(userModel.tenantId!);
      }

      return Right(userModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(LocaleKeys.errorsUnexpected.tr(args: [e.toString()])));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _secureStorageService.deleteToken();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(LocaleKeys.errorsLogoutFailed.tr()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> checkAuthStatus() async {
    try {
      final token = await _secureStorageService.getToken();
      final accountType = _cacheHelper.getAccountType();
      if (token != null && token.isNotEmpty) {
        return Right(UserEntity(
          id: '',
          name: '',
          email: '',
          token: token,
          accountType: accountType ?? 'unknown',
        ));
      }
      return Left(ServerFailure(LocaleKeys.errorsNotLoggedIn.tr()));
    } catch (e) {
      return Left(ServerFailure(LocaleKeys.errorsAuthDisconnected.tr()));
    }
  }
}
