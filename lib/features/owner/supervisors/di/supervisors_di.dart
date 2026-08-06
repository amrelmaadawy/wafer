import '../../../../../core/di/service_locator.dart';
import '../data/datasources/supervisors_remote_data_source.dart';
import '../data/repositories/supervisors_repository_impl.dart';
import '../domain/repositories/supervisors_repository.dart';
import '../domain/usecases/get_supervisor_form_data_use_case.dart';
import '../domain/usecases/get_supervisors_use_case.dart';
import '../domain/usecases/create_supervisor_use_case.dart';
import '../presentation/cubit/form_data/supervisor_form_data_cubit.dart';
import '../presentation/cubit/list/supervisors_list_cubit.dart';
import '../presentation/cubit/create/create_supervisor_cubit.dart';

void initSupervisors() {
  // Cubits
  sl.registerFactory(() => SupervisorFormDataCubit(sl()));
  sl.registerFactory(() => SupervisorsListCubit(getSupervisorsUseCase: sl()));
  sl.registerFactory(
    () => CreateSupervisorCubit(createSupervisorUseCase: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetSupervisorFormDataUseCase(sl()));
  sl.registerLazySingleton(() => GetSupervisorsUseCase(sl()));
  sl.registerLazySingleton(() => CreateSupervisorUseCase(sl()));

  // Repository
  sl.registerLazySingleton<SupervisorsRepository>(
    () => SupervisorsRepositoryImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton<SupervisorsRemoteDataSource>(
    () => SupervisorsRemoteDataSourceImpl(sl()),
  );
}
