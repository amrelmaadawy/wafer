
import '../data/data_sources/legal_cases_remote_data_source.dart';
import '../data/repositories_impl/legal_cases_repository_impl.dart';
import '../domain/repositories/legal_cases_repository.dart';
import '../domain/usecases/get_legal_case_form_data_use_case.dart';
import '../domain/usecases/get_legal_cases_list_use_case.dart';
import '../domain/usecases/get_legal_case_details_use_case.dart';
import '../domain/usecases/create_legal_case_use_case.dart';
import '../presentation/cubits/form_data/legal_case_form_data_cubit.dart';
import '../presentation/cubits/list/legal_cases_list_cubit.dart';
import '../presentation/cubits/details/legal_case_details_cubit.dart';
import '../presentation/cubits/create/legal_case_create_cubit.dart';

// Import service_locator.dart to use the same 'sl' instance
import '../../../../../core/di/service_locator.dart';

void initLegalCases() {
  // Data Sources
  if (!sl.isRegistered<LegalCasesRemoteDataSource>()) {
    sl.registerLazySingleton<LegalCasesRemoteDataSource>(
      () => LegalCasesRemoteDataSourceImpl(dio: sl()),
    );
  }

  // Repositories
  if (!sl.isRegistered<LegalCasesRepository>()) {
    sl.registerLazySingleton<LegalCasesRepository>(
      () => LegalCasesRepositoryImpl(
        remoteDataSource: sl(),
      ),
    );
  }

  // UseCases
  if (!sl.isRegistered<GetLegalCaseFormDataUseCase>()) {
    sl.registerLazySingleton(
      () => GetLegalCaseFormDataUseCase(sl()),
    );
  }

    if (!sl.isRegistered<GetLegalCasesListUseCase>()) {
      sl.registerLazySingleton(
        () => GetLegalCasesListUseCase(sl()),
      );
    }

    if (!sl.isRegistered<GetLegalCaseDetailsUseCase>()) {
      sl.registerLazySingleton(
        () => GetLegalCaseDetailsUseCase(sl()),
      );
    }

    if (!sl.isRegistered<CreateLegalCaseUseCase>()) {
      sl.registerLazySingleton(
        () => CreateLegalCaseUseCase(sl()),
      );
    }

    // Cubits
  if (!sl.isRegistered<LegalCaseFormDataCubit>()) {
    sl.registerFactory(
      () => LegalCaseFormDataCubit(getFormDataUseCase: sl()),
    );
  }

  if (!sl.isRegistered<LegalCasesListCubit>()) {
    sl.registerFactory(
      () => LegalCasesListCubit(getLegalCasesListUseCase: sl()),
    );
  }

  if (!sl.isRegistered<LegalCaseDetailsCubit>()) {
    sl.registerFactory(
      () => LegalCaseDetailsCubit(sl()),
    );
  }

  if (!sl.isRegistered<LegalCaseCreateCubit>()) {
    sl.registerFactory(
      () => LegalCaseCreateCubit(sl()),
    );
  }
}
