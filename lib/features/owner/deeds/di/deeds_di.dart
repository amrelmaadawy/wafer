import '../data/datasources/deeds_remote_data_source.dart';
import '../data/repositories/deed_repository_impl.dart';
import '../domain/repositories/deed_repository.dart';
import '../domain/usecases/get_deeds_use_case.dart';
import '../presentation/cubit/list/deeds_list_cubit.dart';

import '../../../../core/di/service_locator.dart';

void initDeeds() {
  // Cubit
  sl.registerFactory(() => DeedsListCubit(sl()));

  // Use Cases
  sl.registerLazySingleton(() => GetDeedsUseCase(sl()));

  // Repository
  sl.registerLazySingleton<DeedRepository>(
    () => DeedRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<DeedsRemoteDataSource>(
    () => DeedsRemoteDataSourceImpl(sl()),
  );
}
