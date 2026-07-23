import '../../../../core/di/service_locator.dart';
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
// Maintenance
import '../maintenance/data/datasources/owner_maintenance_remote_data_source.dart';
import '../maintenance/data/repositories/owner_maintenance_repository_impl.dart';
import '../maintenance/domain/repositories/owner_maintenance_repository.dart';
import '../maintenance/domain/usecases/get_owner_maintenance_use_case.dart';
import '../maintenance/domain/usecases/get_owner_maintenance_details_use_case.dart';
import '../maintenance/presentation/cubit/owner_maintenance_cubit.dart';
import '../maintenance/presentation/cubit/details/owner_maintenance_details_cubit.dart';
// Reports
import '../reports/data/datasources/owner_reports_remote_data_source.dart';
import '../reports/data/repositories/owner_reports_repository_impl.dart';
import '../reports/domain/repositories/owner_reports_repository.dart';
import '../reports/domain/usecases/get_owner_defaulters_report_use_case.dart';
import '../reports/domain/usecases/get_owner_occupancy_report_use_case.dart';
import '../reports/domain/usecases/get_owner_revenue_report_use_case.dart';
import '../reports/presentation/cubit/owner_defaulters_cubit.dart';
import '../reports/presentation/cubit/owner_occupancy_cubit.dart';
import '../reports/presentation/cubit/owner_revenue_cubit.dart';

// Properties
import '../properties/data/datasources/properties_remote_data_source.dart';
import '../properties/data/datasources/deeds_remote_data_source.dart';
import '../properties/data/repositories/properties_repository_impl.dart';
import '../properties/data/repositories/deeds_repository_impl.dart';
import '../properties/domain/repositories/properties_repository.dart';
import '../properties/domain/repositories/deeds_repository.dart';
import '../properties/domain/usecases/get_properties_list_use_case.dart';
import '../properties/domain/usecases/get_property_form_options_use_case.dart';
import '../properties/domain/usecases/get_property_details_use_case.dart';
import '../properties/domain/usecases/get_deeds_list_use_case.dart';
import '../properties/domain/usecases/create_deed_use_case.dart';
import '../properties/domain/usecases/create_draft_property_use_case.dart';
import '../properties/domain/usecases/auto_save_property_step_use_case.dart';
import '../properties/domain/usecases/get_property_form_data_use_case.dart';
import '../properties/domain/usecases/sync_owners_use_case.dart';
import '../properties/domain/usecases/upload_temp_file_use_case.dart';
import '../properties/domain/usecases/publish_property_use_case.dart';
import '../properties/presentation/cubit/list/properties_list_cubit.dart';
import '../properties/presentation/cubit/details/property_details_cubit.dart';
import '../properties/presentation/cubit/create/property_create_cubit.dart';

// Units
import '../properties/data/datasources/units_remote_data_source.dart';
import '../properties/data/repositories/units_repository_impl.dart';
import '../properties/domain/repositories/units_repository.dart';
import '../properties/domain/usecases/get_property_units_use_case.dart';
import '../properties/domain/usecases/create_draft_unit_use_case.dart';
import '../properties/domain/usecases/auto_save_unit_use_case.dart';
import '../properties/domain/usecases/publish_unit_use_case.dart';
import '../properties/presentation/cubit/units/units_list_cubit.dart';
import '../properties/presentation/cubit/units/unit_create_cubit.dart';

import '../properties/domain/usecases/clone_property_use_case.dart';
import '../properties/domain/usecases/make_representative_use_case.dart';
import '../properties/domain/usecases/remove_representative_use_case.dart';
import '../properties/domain/usecases/delete_property_use_case.dart';
import '../properties/domain/usecases/patch_property_use_case.dart';
import '../properties/presentation/cubit/edit/property_edit_cubit.dart';
import '../deeds/di/deeds_di.dart';

void initOwnerModule() {
  _initDashboard();
  _initProperties();
  _initUnits();
  _initContracts();
  _initMaintenance();
  _initReports();
  initDeeds();
}

void _initUnits() {
  if (!sl.isRegistered<UnitsRemoteDataSource>()) {
    sl.registerLazySingleton<UnitsRemoteDataSource>(
      () => UnitsRemoteDataSourceImpl(sl()),
    );
  }
  if (!sl.isRegistered<UnitsRepository>()) {
    sl.registerLazySingleton<UnitsRepository>(
      () => UnitsRepositoryImpl(sl()),
    );
  }
  if (!sl.isRegistered<GetPropertyUnitsUseCase>()) {
    sl.registerLazySingleton(() => GetPropertyUnitsUseCase(sl()));
  }
  if (!sl.isRegistered<CreateDraftUnitUseCase>()) {
    sl.registerLazySingleton(() => CreateDraftUnitUseCase(sl()));
  }
  if (!sl.isRegistered<AutoSaveUnitUseCase>()) {
    sl.registerLazySingleton(() => AutoSaveUnitUseCase(sl()));
  }
  if (!sl.isRegistered<PublishUnitUseCase>()) {
    sl.registerLazySingleton(() => PublishUnitUseCase(sl()));
  }
  if (!sl.isRegistered<UnitsListCubit>()) {
    sl.registerFactory(() => UnitsListCubit(sl()));
  }
  if (!sl.isRegistered<UnitCreateCubit>()) {
    sl.registerFactory(() => UnitCreateCubit(
          createDraftUnit: sl(),
          autoSaveUnit: sl(),
          publishUnit: sl(),
        ));
  }
}

void _initProperties() {
  if (!sl.isRegistered<PropertiesRemoteDataSource>()) {
    sl.registerLazySingleton<PropertiesRemoteDataSource>(
      () => PropertiesRemoteDataSourceImpl(sl()),
    );
  }
  if (!sl.isRegistered<DeedsRemoteDataSource>()) {
    sl.registerLazySingleton<DeedsRemoteDataSource>(
      () => DeedsRemoteDataSourceImpl(sl()),
    );
  }
  if (!sl.isRegistered<PropertiesRepository>()) {
    sl.registerLazySingleton<PropertiesRepository>(
      () => PropertiesRepositoryImpl(remoteDataSource: sl()),
    );
  }
  if (!sl.isRegistered<DeedsRepository>()) {
    sl.registerLazySingleton<DeedsRepository>(
      () => DeedsRepositoryImpl(sl()),
    );
  }
  if (!sl.isRegistered<GetPropertiesListUseCase>()) {
    sl.registerLazySingleton(() => GetPropertiesListUseCase(sl()));
  }
  if (!sl.isRegistered<GetPropertyFormOptionsUseCase>()) {
    sl.registerLazySingleton(() => GetPropertyFormOptionsUseCase(sl()));
  }
  if (!sl.isRegistered<GetPropertyFormDataUseCase>()) {
    sl.registerLazySingleton(() => GetPropertyFormDataUseCase(sl()));
  }
  if (!sl.isRegistered<GetPropertyDetailsUseCase>()) {
    sl.registerLazySingleton(() => GetPropertyDetailsUseCase(sl()));
  }
  if (!sl.isRegistered<GetDeedsListUseCase>()) {
    sl.registerLazySingleton(() => GetDeedsListUseCase(sl()));
  }
  if (!sl.isRegistered<CreateDeedUseCase>()) {
    sl.registerLazySingleton(() => CreateDeedUseCase(sl()));
  }
  if (!sl.isRegistered<CreateDraftPropertyUseCase>()) {
    sl.registerLazySingleton(() => CreateDraftPropertyUseCase(sl()));
  }
  if (!sl.isRegistered<AutoSavePropertyStepUseCase>()) {
    sl.registerLazySingleton(() => AutoSavePropertyStepUseCase(sl()));
  }
  if (!sl.isRegistered<SyncOwnersUseCase>()) {
    sl.registerLazySingleton(() => SyncOwnersUseCase(sl()));
  }
  if (!sl.isRegistered<UploadTempFileUseCase>()) {
    sl.registerLazySingleton(() => UploadTempFileUseCase(sl()));
  }
  if (!sl.isRegistered<PublishPropertyUseCase>()) {
    sl.registerLazySingleton(() => PublishPropertyUseCase(sl()));
  }
  if (!sl.isRegistered<PropertiesListCubit>()) {
    sl.registerFactory(() => PropertiesListCubit(sl()));
  }
  if (!sl.isRegistered<PropertyDetailsCubit>()) {
    sl.registerFactory(() => PropertyDetailsCubit(sl()));
  }
  if (!sl.isRegistered<PropertyCreateCubit>()) {
    sl.registerFactory(() => PropertyCreateCubit(
          createDraft: sl(),
          autoSave: sl(),
          getDeeds: sl(),
          createDeed: sl(),
          syncOwners: sl(),
          uploadFile: sl(),
          publish: sl(),
          getFormData: sl(),
        ));
  }
  if (!sl.isRegistered<ClonePropertyUseCase>()) {
    sl.registerLazySingleton(() => ClonePropertyUseCase(sl()));
  }
  if (!sl.isRegistered<MakeRepresentativeUseCase>()) {
    sl.registerLazySingleton(() => MakeRepresentativeUseCase(sl()));
  }
  if (!sl.isRegistered<RemoveRepresentativeUseCase>()) {
    sl.registerLazySingleton(() => RemoveRepresentativeUseCase(sl()));
  }
  if (!sl.isRegistered<DeletePropertyUseCase>()) {
    sl.registerLazySingleton(() => DeletePropertyUseCase(sl()));
  }
  if (!sl.isRegistered<PatchPropertyUseCase>()) {
    sl.registerLazySingleton(() => PatchPropertyUseCase(sl()));
  }
  if (!sl.isRegistered<PropertyEditCubit>()) {
    sl.registerFactory(() => PropertyEditCubit(sl()));
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

void _initMaintenance() {
  if (!sl.isRegistered<OwnerMaintenanceRemoteDataSource>()) {
    sl.registerLazySingleton<OwnerMaintenanceRemoteDataSource>(
      () => OwnerMaintenanceRemoteDataSourceImpl(sl()),
    );
  }
  if (!sl.isRegistered<OwnerMaintenanceRepository>()) {
    sl.registerLazySingleton<OwnerMaintenanceRepository>(
      () => OwnerMaintenanceRepositoryImpl(sl()),
    );
  }
  if (!sl.isRegistered<GetOwnerMaintenanceUseCase>()) {
    sl.registerLazySingleton(() => GetOwnerMaintenanceUseCase(sl()));
  }
  if (!sl.isRegistered<GetOwnerMaintenanceDetailsUseCase>()) {
    sl.registerLazySingleton(() => GetOwnerMaintenanceDetailsUseCase(sl()));
  }
  if (!sl.isRegistered<OwnerMaintenanceCubit>()) {
    sl.registerFactory(() => OwnerMaintenanceCubit(sl()));
  }
  if (!sl.isRegistered<OwnerMaintenanceDetailsCubit>()) {
    sl.registerFactory(() => OwnerMaintenanceDetailsCubit(sl()));
  }
}

void _initReports() {
  if (!sl.isRegistered<OwnerReportsRemoteDataSource>()) {
    sl.registerLazySingleton<OwnerReportsRemoteDataSource>(
      () => OwnerReportsRemoteDataSourceImpl(sl()),
    );
  }
  if (!sl.isRegistered<OwnerReportsRepository>()) {
    sl.registerLazySingleton<OwnerReportsRepository>(
      () => OwnerReportsRepositoryImpl(sl()),
    );
  }
  if (!sl.isRegistered<GetOwnerRevenueReportUseCase>()) {
    sl.registerLazySingleton(() => GetOwnerRevenueReportUseCase(sl()));
  }
  if (!sl.isRegistered<GetOwnerOccupancyReportUseCase>()) {
    sl.registerLazySingleton(() => GetOwnerOccupancyReportUseCase(sl()));
  }
  if (!sl.isRegistered<GetOwnerDefaultersReportUseCase>()) {
    sl.registerLazySingleton(() => GetOwnerDefaultersReportUseCase(sl()));
  }
  if (!sl.isRegistered<OwnerRevenueCubit>()) {
    sl.registerFactory(() => OwnerRevenueCubit(sl()));
  }
  if (!sl.isRegistered<OwnerOccupancyCubit>()) {
    sl.registerFactory(() => OwnerOccupancyCubit(sl()));
  }
  if (!sl.isRegistered<OwnerDefaultersCubit>()) {
    sl.registerFactory(() => OwnerDefaultersCubit(sl()));
  }
}
