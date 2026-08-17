import '../../../../../core/offline/models/offline_queue_entry.dart';
import '../../../../../core/offline/services/offline_queue_handler.dart';
import '../../domain/usecases/create_owner_maintenance_use_case.dart';
import '../../domain/usecases/update_owner_maintenance_use_case.dart';
import 'owner_maintenance_remote_data_source.dart';

class MaintenanceCreateOfflineQueueHandler implements OfflineQueueHandler {
  final OwnerMaintenanceRemoteDataSource _remoteDataSource;

  MaintenanceCreateOfflineQueueHandler(this._remoteDataSource);

  @override
  String get featureKey => 'maintenance.create';

  @override
  Future<void> replay(OfflineQueueEntry entry) async {
    final params = CreateOwnerMaintenanceParams.fromJson(entry.payload);
    await _remoteDataSource.createMaintenanceRequest(params);
  }
}

class MaintenanceUpdateOfflineQueueHandler implements OfflineQueueHandler {
  final OwnerMaintenanceRemoteDataSource _remoteDataSource;

  MaintenanceUpdateOfflineQueueHandler(this._remoteDataSource);

  @override
  String get featureKey => 'maintenance.update';

  @override
  Future<void> replay(OfflineQueueEntry entry) async {
    final params = UpdateOwnerMaintenanceParams.fromJson(entry.payload);
    await _remoteDataSource.updateMaintenanceRequest(params);
  }
}
