import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wafer/core/error/failures.dart';
import 'package:wafer/features/owner/supervisors/domain/usecases/get_supervisors_use_case.dart';
import 'package:wafer/features/owner/supervisors/presentation/cubit/list/supervisors_list_cubit.dart';
import 'package:wafer/features/owner/supervisors/presentation/cubit/list/supervisors_list_state.dart';
import 'package:wafer/features/owner/supervisors/domain/entities/supervisors_list_response_entity.dart';
import 'package:wafer/features/owner/supervisors/domain/entities/supervisors_pagination_entity.dart';
import 'package:wafer/features/owner/supervisors/domain/entities/supervisor_entity.dart';

class MockGetSupervisorsUseCase extends Mock implements GetSupervisorsUseCase {}

void main() {
  late SupervisorsListCubit cubit;
  late MockGetSupervisorsUseCase mockGetSupervisorsUseCase;

  setUp(() {
    mockGetSupervisorsUseCase = MockGetSupervisorsUseCase();
    cubit = SupervisorsListCubit(getSupervisorsUseCase: mockGetSupervisorsUseCase);
  });

  final tPagination = SupervisorsPaginationEntity(
    currentPage: 1,
    lastPage: 2,
    perPage: 15,
    total: 30,
  );
  
  final tSupervisor1 = SupervisorEntity(id: 1, user: const SupervisorUserListEntity(id: 1), isActive: true);
  final tSupervisor2 = SupervisorEntity(id: 2, user: const SupervisorUserListEntity(id: 2), isActive: true);

  final tResponse = SupervisorsListResponseEntity(
    supervisors: [tSupervisor1],
    pagination: tPagination,
  );

  group('fetchSupervisors', () {
    blocTest<SupervisorsListCubit, SupervisorsListState>(
      'emits [loading, success] when data is gotten successfully',
      build: () {
        when(() => mockGetSupervisorsUseCase(any()))
            .thenAnswer((_) async => Right(tResponse));
        return cubit;
      },
      act: (cubit) => cubit.fetchSupervisors(),
      expect: () => [
        const SupervisorsListState(status: SupervisorsListStatus.loading),
        SupervisorsListState(
          status: SupervisorsListStatus.success,
          supervisors: [tSupervisor1],
          pagination: tPagination,
          hasReachedMax: false,
        ),
      ],
    );

    blocTest<SupervisorsListCubit, SupervisorsListState>(
      'emits [loading, failure] when usecase fails',
      build: () {
        when(() => mockGetSupervisorsUseCase(any()))
            .thenAnswer((_) async => const Left(ServerFailure('Error')));
        return cubit;
      },
      act: (cubit) => cubit.fetchSupervisors(),
      expect: () => [
        const SupervisorsListState(status: SupervisorsListStatus.loading),
        const SupervisorsListState(
          status: SupervisorsListStatus.failure,
          errorMessage: 'Error',
        ),
      ],
    );
  });

  group('addSupervisor', () {
    blocTest<SupervisorsListCubit, SupervisorsListState>(
      'should add supervisor at the top of the list and deduplicate if needed',
      build: () => cubit,
      seed: () => SupervisorsListState(
        status: SupervisorsListStatus.success,
        supervisors: [tSupervisor1],
        pagination: tPagination,
      ),
      act: (cubit) {
        cubit.addSupervisor(tSupervisor2);
      },
      expect: () => [
        SupervisorsListState(
          status: SupervisorsListStatus.success,
          supervisors: [tSupervisor2, tSupervisor1],
          pagination: tPagination,
        ),
      ],
    );
    
    blocTest<SupervisorsListCubit, SupervisorsListState>(
      'should avoid duplicates when adding',
      build: () => cubit,
      seed: () => SupervisorsListState(
        status: SupervisorsListStatus.success,
        supervisors: [tSupervisor1, tSupervisor2],
        pagination: tPagination,
      ),
      act: (cubit) {
        cubit.addSupervisor(tSupervisor1);
      },
      expect: () => <SupervisorsListState>[],
    );
  });
}
