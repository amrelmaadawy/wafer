import '../../../../core/di/service_locator.dart';
import '../data/datasources/owner_contracts_remote_data_source.dart';
import '../data/datasources/owner_remote_data_source.dart';
import '../data/repositories/owner_contracts_repository_impl.dart';
import '../data/repositories/owner_repository_impl.dart';
import '../domain/repositories/owner_contracts_repository.dart';
import '../domain/repositories/owner_repository.dart';
import '../domain/usecases/get_owner_contract_details_use_case.dart';
import '../domain/usecases/get_owner_contracts_use_case.dart';
import '../domain/usecases/get_owner_dashboard_use_case.dart';
import '../presentation/cubit/owner_contract_details_cubit.dart';
import '../presentation/cubit/owner_contracts_cubit.dart';
import '../presentation/cubit/owner_dashboard_cubit.dart';
import '../presentation/cubit/owner_nav_cubit.dart';

void initOwnerModule() {
  // Data Sources
  if (!sl.isRegistered<OwnerRemoteDataSource>()) {
    sl.registerLazySingleton<OwnerRemoteDataSource>(() => OwnerRemoteDataSourceImpl(sl()));
  }
  if (!sl.isRegistered<OwnerContractsRemoteDataSource>()) {
    sl.registerLazySingleton<OwnerContractsRemoteDataSource>(() => OwnerContractsRemoteDataSourceImpl(sl()));
  }

  // Repositories
  if (!sl.isRegistered<OwnerRepository>()) {
    sl.registerLazySingleton<OwnerRepository>(() => OwnerRepositoryImpl(sl()));
  }
  if (!sl.isRegistered<OwnerContractsRepository>()) {
    sl.registerLazySingleton<OwnerContractsRepository>(() => OwnerContractsRepositoryImpl(sl()));
  }

  // Use Cases
  if (!sl.isRegistered<GetOwnerDashboardUseCase>()) {
    sl.registerLazySingleton(() => GetOwnerDashboardUseCase(sl()));
  }
  if (!sl.isRegistered<GetOwnerContractsUseCase>()) {
    sl.registerLazySingleton(() => GetOwnerContractsUseCase(sl()));
  }
  if (!sl.isRegistered<GetOwnerContractDetailsUseCase>()) {
    sl.registerLazySingleton(() => GetOwnerContractDetailsUseCase(sl()));
  }

  // Cubits
  if (!sl.isRegistered<OwnerNavCubit>()) {
    sl.registerFactory(() => OwnerNavCubit());
  }
  if (!sl.isRegistered<OwnerDashboardCubit>()) {
    sl.registerFactory(() => OwnerDashboardCubit(sl()));
  }
  if (!sl.isRegistered<OwnerContractsCubit>()) {
    sl.registerFactory(() => OwnerContractsCubit(sl()));
  }
  if (!sl.isRegistered<OwnerContractDetailsCubit>()) {
    sl.registerFactory(() => OwnerContractDetailsCubit(sl()));
  }
}
