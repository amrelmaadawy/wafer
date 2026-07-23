import '../data/datasources/deeds_remote_data_source.dart';
import '../data/repositories/deed_repository_impl.dart';
import '../domain/repositories/deed_repository.dart';
import '../domain/usecases/get_deeds_use_case.dart';
import '../presentation/cubit/list/deeds_list_cubit.dart';
import '../presentation/cubit/create/create_deed_cubit.dart';
import '../domain/usecases/create_deed_use_case.dart';

import '../presentation/cubit/details/deed_details_cubit.dart';
import '../domain/usecases/get_deed_details_use_case.dart';

import '../../../../core/di/service_locator.dart';

void initDeeds() {
  // Cubit
  sl.registerFactory(() => DeedsListCubit(sl()));
  sl.registerFactory(() => CreateDeedCubit(sl()));
  sl.registerFactory(() => DeedDetailsCubit(sl()));

  // Use Cases
  sl.registerLazySingleton(() => GetDeedsUseCase(sl()));
  sl.registerLazySingleton(() => AddNewDeedUseCase(sl()));
  sl.registerLazySingleton(() => GetDeedDetailsUseCase(sl()));

  // Repository
  sl.registerLazySingleton<DeedRepository>(
    () => DeedRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<DeedsRemoteDataSource>(
    () => DeedsRemoteDataSourceImpl(sl()),
  );
}
