import 'package:get_it/get_it.dart';
import '../data/datasources/profile_remote_data_source.dart';
import '../data/repositories/profile_repository_impl.dart';
import '../domain/repositories/profile_repository.dart';
import '../domain/usecases/get_profile_use_case.dart';
import '../domain/usecases/update_profile_use_case.dart';
import '../domain/usecases/change_password_use_case.dart';
import '../domain/usecases/update_avatar_use_case.dart';
import '../presentation/cubit/change_password_cubit.dart';
import '../presentation/cubit/profile_cubit.dart';

final sl = GetIt.instance;

void initProfileModule() {
  if (!sl.isRegistered<ProfileRemoteDataSource>()) {
    sl.registerLazySingleton<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(sl()),
    );
  }

  if (!sl.isRegistered<ProfileRepository>()) {
    sl.registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(sl(), sl()),
    );
  }

  if (!sl.isRegistered<GetProfileUseCase>()) {
    sl.registerLazySingleton<GetProfileUseCase>(
      () => GetProfileUseCase(sl()),
    );
  }

  if (!sl.isRegistered<UpdateProfileUseCase>()) {
    sl.registerLazySingleton<UpdateProfileUseCase>(
      () => UpdateProfileUseCase(sl()),
    );
  }

  if (!sl.isRegistered<ChangePasswordUseCase>()) {
    sl.registerLazySingleton<ChangePasswordUseCase>(
      () => ChangePasswordUseCase(sl()),
    );
  }

  if (!sl.isRegistered<UpdateAvatarUseCase>()) {
    sl.registerLazySingleton<UpdateAvatarUseCase>(
      () => UpdateAvatarUseCase(sl()),
    );
  }

  sl.registerFactory<ProfileCubit>(() => ProfileCubit(sl(), sl(), sl()));
  sl.registerFactory<ChangePasswordCubit>(() => ChangePasswordCubit(changePasswordUseCase: sl()));
}
