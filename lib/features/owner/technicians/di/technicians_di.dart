import '../../../../core/di/service_locator.dart';
import '../data/datasources/technicians_remote_data_source.dart';
import '../data/repositories/technicians_repository_impl.dart';
import '../domain/repositories/technicians_repository.dart';
import '../domain/usecases/get_technician_form_data_use_case.dart';
import '../domain/usecases/get_technicians_list_use_case.dart';
import '../presentation/cubits/technician_form_data_cubit.dart';
import '../presentation/cubit/list/technicians_list_cubit.dart';
import '../domain/usecases/add_technician_use_case.dart';
import '../presentation/cubit/add/add_technician_cubit.dart';

void initTechnicians() {
  if (!sl.isRegistered<TechniciansRemoteDataSource>()) {
    sl.registerLazySingleton<TechniciansRemoteDataSource>(
      () => TechniciansRemoteDataSourceImpl(sl()),
    );
  }

  if (!sl.isRegistered<TechniciansRepository>()) {
    sl.registerLazySingleton<TechniciansRepository>(
      () => TechniciansRepositoryImpl(remoteDataSource: sl()),
    );
  }

  if (!sl.isRegistered<GetTechnicianFormDataUseCase>()) {
    sl.registerLazySingleton(() => GetTechnicianFormDataUseCase(sl()));
  }

  if (!sl.isRegistered<GetTechniciansListUseCase>()) {
    sl.registerLazySingleton(() => GetTechniciansListUseCase(sl()));
  }

  if (!sl.isRegistered<AddTechnicianUseCase>()) {
    sl.registerLazySingleton(() => AddTechnicianUseCase(sl()));
  }

  if (!sl.isRegistered<TechnicianFormDataCubit>()) {
    sl.registerFactory(() => TechnicianFormDataCubit(sl()));
  }

  if (!sl.isRegistered<TechniciansListCubit>()) {
    sl.registerFactory(
      () => TechniciansListCubit(getTechniciansListUseCase: sl()),
    );
  }

  if (!sl.isRegistered<AddTechnicianCubit>()) {
    sl.registerFactory(() => AddTechnicianCubit(sl()));
  }
}
