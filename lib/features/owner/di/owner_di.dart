import '../../../../core/di/service_locator.dart';
// Shell
import '../shell/presentation/cubit/owner_nav_cubit.dart';
// Dashboard
import '../dashboard/data/datasources/owner_dashboard_remote_data_source.dart';
import '../dashboard/data/repositories/owner_dashboard_repository_impl.dart';
import '../dashboard/domain/repositories/owner_dashboard_repository.dart';
import '../dashboard/domain/usecases/get_owner_dashboard_use_case.dart';
import '../dashboard/presentation/cubit/owner_dashboard_cubit.dart';
// Contracts
import '../contracts/data/datasources/owner_contracts_remote_data_source.dart';
import '../contracts/data/repositories/owner_contracts_repository_impl.dart';
import '../contracts/domain/repositories/owner_contracts_repository.dart';
import '../contracts/domain/usecases/get_owner_contracts_use_case.dart';
import '../contracts/domain/usecases/get_owner_contract_details_use_case.dart';
import '../contracts/domain/usecases/get_owner_contract_installments_use_case.dart';
import '../contracts/presentation/cubit/list/owner_contracts_cubit.dart';
import '../contracts/presentation/cubit/details/owner_contract_details_cubit.dart';
import '../contracts/presentation/cubit/installments/owner_contract_installments_cubit.dart';

void initOwnerModule() {
  _initShell();
  _initDashboard();
  _initContracts();
}

void _initShell() {
  if (!sl.isRegistered<OwnerNavCubit>()) {
    sl.registerFactory(() => OwnerNavCubit());
  }
}

void _initDashboard() {
  if (!sl.isRegistered<OwnerDashboardRemoteDataSource>()) {
    sl.registerLazySingleton<OwnerDashboardRemoteDataSource>(
      () => OwnerDashboardRemoteDataSourceImpl(sl()),
    );
  }
  if (!sl.isRegistered<OwnerDashboardRepository>()) {
    sl.registerLazySingleton<OwnerDashboardRepository>(
      () => OwnerDashboardRepositoryImpl(sl()),
    );
  }
  if (!sl.isRegistered<GetOwnerDashboardUseCase>()) {
    sl.registerLazySingleton(() => GetOwnerDashboardUseCase(sl()));
  }
  if (!sl.isRegistered<OwnerDashboardCubit>()) {
    sl.registerFactory(() => OwnerDashboardCubit(sl()));
  }
}

void _initContracts() {
  if (!sl.isRegistered<OwnerContractsRemoteDataSource>()) {
    sl.registerLazySingleton<OwnerContractsRemoteDataSource>(
      () => OwnerContractsRemoteDataSourceImpl(sl()),
    );
  }
  if (!sl.isRegistered<OwnerContractsRepository>()) {
    sl.registerLazySingleton<OwnerContractsRepository>(
      () => OwnerContractsRepositoryImpl(sl()),
    );
  }
  if (!sl.isRegistered<GetOwnerContractsUseCase>()) {
    sl.registerLazySingleton(() => GetOwnerContractsUseCase(sl()));
  }
  if (!sl.isRegistered<GetOwnerContractDetailsUseCase>()) {
    sl.registerLazySingleton(() => GetOwnerContractDetailsUseCase(sl()));
  }
  if (!sl.isRegistered<GetOwnerContractInstallmentsUseCase>()) {
    sl.registerLazySingleton(() => GetOwnerContractInstallmentsUseCase(sl()));
  }
  if (!sl.isRegistered<OwnerContractsCubit>()) {
    sl.registerFactory(() => OwnerContractsCubit(sl()));
  }
  if (!sl.isRegistered<OwnerContractDetailsCubit>()) {
    sl.registerFactory(() => OwnerContractDetailsCubit(sl()));
  }
  if (!sl.isRegistered<OwnerContractInstallmentsCubit>()) {
    sl.registerFactory(() => OwnerContractInstallmentsCubit(sl()));
  }
}
