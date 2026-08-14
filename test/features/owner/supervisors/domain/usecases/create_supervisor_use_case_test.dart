import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wafer/core/error/failures.dart';
import 'package:wafer/features/owner/supervisors/domain/repositories/supervisors_repository.dart';
import 'package:wafer/features/owner/supervisors/domain/usecases/create_supervisor_use_case.dart';
import 'package:wafer/features/owner/supervisors/domain/entities/create_maintenance_supervisor_params.dart';
import 'package:wafer/features/owner/supervisors/domain/entities/supervisor_entity.dart';
import 'package:wafer/features/owner/supervisors/domain/entities/scope_value_id.dart';

class MockSupervisorsRepository extends Mock implements SupervisorsRepository {}
class FakeCreateMaintenanceSupervisorParams extends Fake implements CreateMaintenanceSupervisorParams {}

void main() {
  late CreateSupervisorUseCase usecase;
  late MockSupervisorsRepository mockSupervisorsRepository;

  setUpAll(() {
    registerFallbackValue(FakeCreateMaintenanceSupervisorParams());
  });

  setUp(() {
    mockSupervisorsRepository = MockSupervisorsRepository();
    usecase = CreateSupervisorUseCase(mockSupervisorsRepository);
  });

  final tParams = CreateMaintenanceSupervisorParams(
    userId: 1,
    scopeType: 'property',
    scopeValues: [ScopeValueId.from(10)],
    isActive: true,
  );
  
  final tSupervisor = SupervisorEntity(
    id: 1,
    user: const SupervisorUserListEntity(id: 1),
    isActive: true,
  );

  test('should forward call to repository and return data', () async {
    when(() => mockSupervisorsRepository.createSupervisor(any()))
        .thenAnswer((_) async => Right(tSupervisor));

    final result = await usecase(tParams);

    expect(result, Right(tSupervisor));
    verify(() => mockSupervisorsRepository.createSupervisor(tParams));
    verifyNoMoreInteractions(mockSupervisorsRepository);
  });

  test('should return ServerFailure when repository fails', () async {
    when(() => mockSupervisorsRepository.createSupervisor(any()))
        .thenAnswer((_) async => const Left(ServerFailure('Error')));

    final result = await usecase(tParams);

    expect(result, const Left(ServerFailure('Error')));
    verify(() => mockSupervisorsRepository.createSupervisor(tParams));
  });
}
