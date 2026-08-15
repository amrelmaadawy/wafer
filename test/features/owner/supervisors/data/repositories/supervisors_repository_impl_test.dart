import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wafer/core/error/exceptions.dart';
import 'package:wafer/core/error/failures.dart';
import 'package:wafer/features/owner/supervisors/data/datasources/supervisors_remote_data_source.dart';
import 'package:wafer/features/owner/supervisors/data/repositories/supervisors_repository_impl.dart';
import 'package:wafer/features/owner/supervisors/domain/entities/create_maintenance_supervisor_params.dart';
import 'package:wafer/features/owner/supervisors/domain/entities/scope_value_id.dart';
import 'package:wafer/features/owner/supervisors/data/models/supervisor_model.dart';
import 'package:wafer/features/owner/supervisors/data/models/supervisors_pagination_model.dart';
import 'package:wafer/features/owner/supervisors/data/models/supervisors_list_response_model.dart';

class MockSupervisorsRemoteDataSource extends Mock implements SupervisorsRemoteDataSource {}
class FakeCreateMaintenanceSupervisorParams extends Fake implements CreateMaintenanceSupervisorParams {}

void main() {
  late SupervisorsRepositoryImpl repository;
  late MockSupervisorsRemoteDataSource mockRemoteDataSource;

  setUpAll(() {
    registerFallbackValue(FakeCreateMaintenanceSupervisorParams());
  });

  setUp(() {
    mockRemoteDataSource = MockSupervisorsRemoteDataSource();
    repository = SupervisorsRepositoryImpl(mockRemoteDataSource);
  });

  group('createSupervisor', () {
    final tParams = CreateMaintenanceSupervisorParams(
      userId: 1,
      scopeType: 'property',
      scopeValues: [ScopeValueId.from(10)],
      isActive: true,
    );
    final tSupervisorModel = SupervisorModel(
      id: 1,
      user: SupervisorUserListModel(id: 1),
      isActive: true,
      scope: null,
    );

    test('should return remote data when the call is successful', () async {
      when(() => mockRemoteDataSource.createSupervisor(any()))
          .thenAnswer((_) async => tSupervisorModel);

      final result = await repository.createSupervisor(tParams);

      verify(() => mockRemoteDataSource.createSupervisor(tParams));
      expect(result, equals(Right(tSupervisorModel)));
    });

    test('should return ServerFailure when the call is unsuccessful', () async {
      when(() => mockRemoteDataSource.createSupervisor(any()))
          .thenThrow(ServerException('Error'));

      final result = await repository.createSupervisor(tParams);

      verify(() => mockRemoteDataSource.createSupervisor(tParams));
      expect(result, equals(Left(ServerFailure('Error'))));
    });
  });

  group('getSupervisors', () {
    final tResponse = SupervisorsListResponseModel(
      supervisors: const [],
      pagination: SupervisorsPaginationModel(currentPage: 1, lastPage: 1, perPage: 15, total: 0),
    );
    final tPage = 1;

    test('should return data when successful', () async {
      when(() => mockRemoteDataSource.getSupervisors(any()))
          .thenAnswer((_) async => tResponse);

      final result = await repository.getSupervisors(tPage);

      verify(() => mockRemoteDataSource.getSupervisors(tPage));
      expect(result, equals(Right(tResponse)));
    });
  });
}
