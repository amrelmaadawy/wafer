import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wafer/core/network/connectivity/network_info.dart';
import 'package:wafer/core/offline/models/offline_queue_entry.dart';
import 'package:wafer/core/offline/services/offline_queue_service.dart';
import 'package:wafer/features/owner/maintenance/data/datasources/owner_maintenance_remote_data_source.dart';
import 'package:wafer/features/owner/maintenance/data/models/maintenance_item_model.dart';
import 'package:wafer/features/owner/maintenance/data/repositories/owner_maintenance_repository_impl.dart';
import 'package:wafer/features/owner/maintenance/domain/usecases/create_owner_maintenance_use_case.dart';
import 'package:wafer/features/owner/maintenance/domain/usecases/update_owner_maintenance_use_case.dart';

class MockRemoteDataSource extends Mock implements OwnerMaintenanceRemoteDataSource {}
class MockNetworkInfo extends Mock implements NetworkInfo {}
class MockOfflineQueueService extends Mock implements OfflineQueueService {}
class FakeOfflineQueueEntry extends Fake implements OfflineQueueEntry {}
class FakeCreateOwnerMaintenanceParams extends Fake implements CreateOwnerMaintenanceParams {}
class FakeUpdateOwnerMaintenanceParams extends Fake implements UpdateOwnerMaintenanceParams {}

void main() {
  late MockRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late MockOfflineQueueService mockOfflineQueueService;
  late OwnerMaintenanceRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(FakeOfflineQueueEntry());
    registerFallbackValue(FakeCreateOwnerMaintenanceParams());
    registerFallbackValue(FakeUpdateOwnerMaintenanceParams());
  });

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    mockOfflineQueueService = MockOfflineQueueService();

    repository = OwnerMaintenanceRepositoryImpl(
      mockRemoteDataSource,
      mockNetworkInfo,
      mockOfflineQueueService,
    );
  });

  const createParams = CreateOwnerMaintenanceParams(
    propertyId: 1,
    clientName: 'Ahmed',
    clientPhone: '0501234567',
    description: 'Fix pipe',
    requestedDate: '2026-08-20',
    maintenanceTypes: ['plumbing'],
  );

  test('createMaintenanceRequest enqueues locally and returns Right(null) when offline', () async {
    when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    when(() => mockOfflineQueueService.enqueue(any())).thenAnswer((_) async {});

    final result = await repository.createMaintenanceRequest(createParams);

    expect(result.isRight(), isTrue);
    verify(() => mockOfflineQueueService.enqueue(any())).called(1);
    verifyNever(() => mockRemoteDataSource.createMaintenanceRequest(any()));
  });

  test('createMaintenanceRequest calls remoteDataSource when online', () async {
    when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    when(() => mockRemoteDataSource.createMaintenanceRequest(any()))
        .thenAnswer((_) async {});

    final result = await repository.createMaintenanceRequest(createParams);

    expect(result.isRight(), isTrue);
    verify(() => mockRemoteDataSource.createMaintenanceRequest(any())).called(1);
    verifyNever(() => mockOfflineQueueService.enqueue(any()));
  });

  const updateParams = UpdateOwnerMaintenanceParams(
    id: 10,
    description: 'Updated pipe fix',
    maintenanceTypes: ['plumbing'],
  );

  test('updateMaintenanceRequest enqueues locally and returns Right(entity) when offline', () async {
    when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    when(() => mockOfflineQueueService.enqueue(any())).thenAnswer((_) async {});

    final result = await repository.updateMaintenanceRequest(updateParams);

    expect(result.isRight(), isTrue);
    verify(() => mockOfflineQueueService.enqueue(any())).called(1);
    verifyNever(() => mockRemoteDataSource.updateMaintenanceRequest(any()));
  });

  test('updateMaintenanceRequest calls remoteDataSource when online', () async {
    when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    when(() => mockRemoteDataSource.updateMaintenanceRequest(any()))
        .thenAnswer((_) async => const MaintenanceItemModel(id: 10));

    final result = await repository.updateMaintenanceRequest(updateParams);

    expect(result.isRight(), isTrue);
    verify(() => mockRemoteDataSource.updateMaintenanceRequest(any())).called(1);
    verifyNever(() => mockOfflineQueueService.enqueue(any()));
  });
}
