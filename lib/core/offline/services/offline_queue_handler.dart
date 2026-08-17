import '../models/offline_queue_entry.dart';

abstract class OfflineQueueHandler {
  String get featureKey;
  Future<void> replay(OfflineQueueEntry entry);
}
