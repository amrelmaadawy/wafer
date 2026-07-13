import '../../../../core/di/service_locator.dart';
import '../data/datasources/owner_remote_data_source.dart';
import '../data/repositories/owner_repository_impl.dart';
import '../domain/repositories/owner_repository.dart';
import '../domain/usecases/get_owner_dashboard_use_case.dart';
import '../presentation/cubit/owner_dashboard_cubit.dart';
import '../presentation/cubit/owner_nav_cubit.dart';

void initOwnerModule() {
  // Data Sources
  if (!sl.isRegistered<OwnerRemoteDataSource>()) {
    sl.registerLazySingleton<OwnerRemoteDataSource>(() => OwnerRemoteDataSourceImpl(sl()));
  }

  // Repositories
  if (!sl.isRegistered<OwnerRepository>()) {
    sl.registerLazySingleton<OwnerRepository>(() => OwnerRepositoryImpl(sl()));
  }

  // Use Cases
  if (!sl.isRegistered<GetOwnerDashboardUseCase>()) {
    sl.registerLazySingleton(() => GetOwnerDashboardUseCase(sl()));
  }

  // Cubits
  if (!sl.isRegistered<OwnerNavCubit>()) {
    sl.registerFactory(() => OwnerNavCubit());
  }
  if (!sl.isRegistered<OwnerDashboardCubit>()) {
    sl.registerFactory(() => OwnerDashboardCubit(sl()));
  }
}
