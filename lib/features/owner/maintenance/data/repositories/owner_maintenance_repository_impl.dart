import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/maintenance_item_entity.dart';
import '../../domain/entities/maintenance_response_entity.dart';
import '../../domain/repositories/owner_maintenance_repository.dart';
import '../../domain/usecases/create_owner_maintenance_use_case.dart';
import '../../domain/usecases/update_owner_maintenance_use_case.dart';
import '../../domain/usecases/approve_owner_maintenance_use_case.dart';
import '../../domain/usecases/reject_owner_maintenance_use_case.dart';
import '../../domain/usecases/assign_owner_maintenance_use_case.dart';
import '../../domain/usecases/complete_owner_maintenance_task_use_case.dart';
import '../../domain/usecases/execute_owner_maintenance_use_case.dart';
import '../../domain/usecases/verify_close_owner_maintenance_use_case.dart';
import '../../domain/usecases/forward_owner_maintenance_use_case.dart';
import '../../../../../core/network/connectivity/network_info.dart';
import '../../../../../core/offline/models/offline_queue_entry.dart';
import '../../../../../core/offline/services/offline_queue_service.dart';
import '../../domain/entities/execute_owner_maintenance_response_entity.dart';
import '../../domain/entities/maintenance_form_data_entity.dart';
import '../datasources/owner_maintenance_remote_data_source.dart';

class OwnerMaintenanceRepositoryImpl implements OwnerMaintenanceRepository {
  final OwnerMaintenanceRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;
  final OfflineQueueService _offlineQueueService;

  OwnerMaintenanceRepositoryImpl(
    this._remoteDataSource,
    this._networkInfo,
    this._offlineQueueService,
  );

  @override
  Future<Either<Failure, MaintenanceFormDataEntity>> getFormData() async {
    try {
      final result = await _remoteDataSource.getFormData();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MaintenanceResponseEntity>> getMaintenanceRequests({
    required int page,
    String? status,
    bool forceRefresh = false,
  }) async {
    try {
      final result = await _remoteDataSource.getMaintenanceRequests(
        page: page,
        status: status,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MaintenanceItemEntity>> getMaintenanceDetails(
    int id,
  ) async {
    try {
      final result = await _remoteDataSource.getMaintenanceDetails(id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createMaintenanceRequest(
    CreateOwnerMaintenanceParams params,
  ) async {
    try {
      final isOnline = await _networkInfo.isConnected;
      if (!isOnline) {
        final entry = OfflineQueueEntry(
          id: 'maint_create_${DateTime.now().millisecondsSinceEpoch}',
          featureKey: 'maintenance.create',
          payload: params.toJson(),
          createdAt: DateTime.now(),
        );
        await _offlineQueueService.enqueue(entry);
        return const Right(null);
      }
      await _remoteDataSource.createMaintenanceRequest(params);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        final entry = OfflineQueueEntry(
          id: 'maint_create_${DateTime.now().millisecondsSinceEpoch}',
          featureKey: 'maintenance.create',
          payload: params.toJson(),
          createdAt: DateTime.now(),
        );
        await _offlineQueueService.enqueue(entry);
        return const Right(null);
      }
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MaintenanceItemEntity>> updateMaintenanceRequest(
    UpdateOwnerMaintenanceParams params,
  ) async {
    try {
      final isOnline = await _networkInfo.isConnected;
      if (!isOnline) {
        final entry = OfflineQueueEntry(
          id: 'maint_update_${params.id}_${DateTime.now().millisecondsSinceEpoch}',
          featureKey: 'maintenance.update',
          payload: params.toJson(),
          createdAt: DateTime.now(),
        );
        await _offlineQueueService.enqueue(entry);
        return Right(
          MaintenanceItemEntity(
            id: params.id,
            description: params.description,
          ),
        );
      }
      final result = await _remoteDataSource.updateMaintenanceRequest(params);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        final entry = OfflineQueueEntry(
          id: 'maint_update_${params.id}_${DateTime.now().millisecondsSinceEpoch}',
          featureKey: 'maintenance.update',
          payload: params.toJson(),
          createdAt: DateTime.now(),
        );
        await _offlineQueueService.enqueue(entry);
        return Right(
          MaintenanceItemEntity(
            id: params.id,
            description: params.description,
          ),
        );
      }
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> approveMaintenanceRequest(
    ApproveOwnerMaintenanceParams params,
  ) async {
    try {
      await _remoteDataSource.approveMaintenanceRequest(params);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMaintenanceRequest(int id) async {
    try {
      await _remoteDataSource.deleteMaintenanceRequest(id);
      return const Right(null);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioException(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> rejectMaintenanceRequest(
    RejectOwnerMaintenanceParams params,
  ) async {
    try {
      await _remoteDataSource.rejectMaintenanceRequest(params);
      return const Right(null);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioException(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> assignMaintenanceRequest(
    AssignOwnerMaintenanceParams params,
  ) async {
    try {
      await _remoteDataSource.assignMaintenanceRequest(params);
      return const Right(null);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioException(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MaintenanceItemEntity>> startMaintenanceRequest(
    int id,
  ) async {
    try {
      final result = await _remoteDataSource.startMaintenanceRequest(id);
      return Right(result);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioException(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MaintenanceItemEntity>> completeMaintenanceTask(
    CompleteOwnerMaintenanceTaskParams params,
  ) async {
    try {
      final result = await _remoteDataSource.completeMaintenanceTask(params);
      return Right(result);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioException(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ExecuteOwnerMaintenanceResponseEntity>>
  executeMaintenanceRequest(ExecuteOwnerMaintenanceParams params) async {
    try {
      final result = await _remoteDataSource.executeMaintenanceRequest(params);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MaintenanceItemEntity>> verifyCloseMaintenanceRequest(
    VerifyCloseOwnerMaintenanceParams params,
  ) async {
    try {
      final result = await _remoteDataSource.verifyCloseMaintenanceRequest(
        params,
      );
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> forwardMaintenanceRequest(
    ForwardOwnerMaintenanceParams params,
  ) async {
    try {
      await _remoteDataSource.forwardMaintenanceRequest(params);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
