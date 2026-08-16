import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:wafer/features/owner/dashboard/presentation/cubit/owner_dashboard_cubit.dart';
import 'package:wafer/features/owner/dashboard/presentation/cubit/owner_dashboard_state.dart';
import 'package:wafer/features/owner/dashboard/domain/usecases/get_owner_dashboard_use_case.dart';
import 'package:wafer/features/owner/dashboard/domain/entities/owner_dashboard_entity.dart';
import 'package:wafer/features/owner/maintenance/domain/usecases/get_owner_maintenance_use_case.dart';
import 'package:wafer/features/owner/maintenance/domain/entities/maintenance_response_entity.dart';
import 'package:wafer/features/owner/maintenance/domain/entities/maintenance_pagination_meta_entity.dart';
import 'package:wafer/core/error/failures.dart';

class MockGetOwnerDashboardUseCase extends Mock
    implements GetOwnerDashboardUseCase {}

class MockGetOwnerMaintenanceUseCase extends Mock
    implements GetOwnerMaintenanceUseCase {}

void main() {
  late OwnerDashboardCubit cubit;
  late MockGetOwnerDashboardUseCase mockDashboardUseCase;
  late MockGetOwnerMaintenanceUseCase mockMaintenanceUseCase;

  setUpAll(() {
    registerFallbackValue(const GetOwnerMaintenanceParams(page: 1));
  });

  setUp(() {
    mockDashboardUseCase = MockGetOwnerDashboardUseCase();
    mockMaintenanceUseCase = MockGetOwnerMaintenanceUseCase();
    cubit = OwnerDashboardCubit(mockDashboardUseCase, mockMaintenanceUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  final tDashboardData1 = OwnerDashboardEntity(
    totalProperties: 10,
    totalUnits: 20,
    rentedUnits: 15,
    vacantUnits: 5,
    activeContracts: 15,
    totalRevenue: 50000,
    collectedAmount: 40000,
    pendingAmount: 10000,
    overdueInstallmentsCount: 2,
    expiringContracts: 1,
    pendingMaintenance: 3,
    occupancyRate: 75.0,
    recentReceipts: const [],
    installmentStats: null,
    latestOverdueInstallments: const [],
    maintenanceBreakdown: null,
  );

  final tDashboardData2 = OwnerDashboardEntity(
    totalProperties: 10,
    totalUnits: 20,
    rentedUnits: 16,
    vacantUnits: 4,
    activeContracts: 16,
    totalRevenue: 55000,
    collectedAmount: 45000,
    pendingAmount: 10000,
    overdueInstallmentsCount: 1,
    expiringContracts: 1,
    pendingMaintenance: 2,
    occupancyRate: 80.0,
    recentReceipts: const [],
    installmentStats: null,
    latestOverdueInstallments: const [],
    maintenanceBreakdown: null,
  );

  final tMaintenanceData = MaintenanceResponseEntity(
    items: const [],
    meta: MaintenancePaginationMetaEntity(
      currentPage: 1,
      lastPage: 1,
      perPage: 15,
      total: 0,
    ),
  );

  group('OwnerDashboardCubit SWR', () {
    blocTest<OwnerDashboardCubit, OwnerDashboardState>(
      'emits Loading then Loaded(cache) then Loaded(network) on successful background fetch',
      build: () {
        when(
          () => mockDashboardUseCase(
            forceRefresh: false,
            cancelToken: any(named: 'cancelToken'),
          ),
        ).thenAnswer((_) async => Right(tDashboardData1));

        when(
          () => mockDashboardUseCase(
            forceRefresh: true,
            cancelToken: any(named: 'cancelToken'),
          ),
        ).thenAnswer((_) async => Right(tDashboardData2));

        when(
          () => mockMaintenanceUseCase(any()),
        ).thenAnswer((_) async => Right(tMaintenanceData));

        return cubit;
      },
      act: (cubit) => cubit.loadDashboardStats(),
      expect: () => [
        const OwnerDashboardLoading(),
        OwnerDashboardLoaded(tDashboardData1, recentMaintenanceItems: const []),
        OwnerDashboardLoaded(tDashboardData2, recentMaintenanceItems: const []),
      ],
    );

    blocTest<OwnerDashboardCubit, OwnerDashboardState>(
      'emits Loading then Loaded(cache) and ignores background fetch failure (keeps cache)',
      build: () {
        when(
          () => mockDashboardUseCase(
            forceRefresh: false,
            cancelToken: any(named: 'cancelToken'),
          ),
        ).thenAnswer((_) async => Right(tDashboardData1));

        when(
          () => mockDashboardUseCase(
            forceRefresh: true,
            cancelToken: any(named: 'cancelToken'),
          ),
        ).thenAnswer((_) async => const Left(ServerFailure('Network Error')));

        when(
          () => mockMaintenanceUseCase(any()),
        ).thenAnswer((_) async => Right(tMaintenanceData));

        return cubit;
      },
      act: (cubit) => cubit.loadDashboardStats(),
      expect: () => [
        const OwnerDashboardLoading(),
        OwnerDashboardLoaded(tDashboardData1, recentMaintenanceItems: const []),
      ],
    );
  });
}
