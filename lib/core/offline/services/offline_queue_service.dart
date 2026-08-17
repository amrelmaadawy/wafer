import 'dart:async';
import 'dart:convert';
import 'package:hive_ce/hive_ce.dart';
import '../../services/connectivity_service.dart';
import '../../storage/secure_storage_service.dart';
import '../models/offline_queue_entry.dart';
import 'offline_queue_handler.dart';

abstract class OfflineQueueService {
  void registerHandler(OfflineQueueHandler handler);
  Future<void> enqueue(OfflineQueueEntry entry);
  Future<List<OfflineQueueEntry>> getPendingEntries();
  Future<void> syncAll();
  Future<void> clear();
  Stream<int> get pendingCountStream;
  void dispose();
}

class OfflineQueueServiceImpl implements OfflineQueueService {
  final ConnectivityService _connectivityService;
  final SecureStorageService _secureStorageService;

  static const String boxName = 'codra_queue_v1';
  final Map<String, OfflineQueueHandler> _handlers = {};
  final StreamController<int> _countController =
      StreamController<int>.broadcast();
  StreamSubscription<bool>? _connectivitySubscription;
  bool _isSyncing = false;

  OfflineQueueServiceImpl(
    this._connectivityService,
    this._secureStorageService,
  ) {
    _init();
  }

  Future<Box> _getBox() async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box(boxName);
    }
    String? base64Key = await _secureStorageService.getHiveKey();
    List<int> encryptionKey;
    if (base64Key == null) {
      encryptionKey = Hive.generateSecureKey();
      await _secureStorageService.saveHiveKey(base64Encode(encryptionKey));
    } else {
      encryptionKey = base64Decode(base64Key);
    }

    return await Hive.openBox(
      boxName,
      encryptionCipher: HiveAesCipher(encryptionKey),
    );
  }

  void _init() {
    _connectivitySubscription = _connectivityService.onConnectivityChanged
        .listen((isOnline) {
      if (isOnline) {
        syncAll();
      }
    });
  }

  @override
  void registerHandler(OfflineQueueHandler handler) {
    _handlers[handler.featureKey] = handler;
  }

  @override
  Future<void> enqueue(OfflineQueueEntry entry) async {
    final box = await _getBox();
    await box.put(entry.id, entry.toMap());
    _notifyCount(box);
  }

  @override
  Future<List<OfflineQueueEntry>> getPendingEntries() async {
    final box = await _getBox();
    return box.values
        .map((e) => OfflineQueueEntry.fromMap(e as Map))
        .toList();
  }

  @override
  Future<void> syncAll() async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      final isConnected = await _connectivityService.isConnected;
      if (!isConnected) {
        _isSyncing = false;
        return;
      }

      final box = await _getBox();
      final entries = box.values
          .map((e) => OfflineQueueEntry.fromMap(e as Map))
          .toList();

      for (final entry in entries) {
        final handler = _handlers[entry.featureKey];
        if (handler != null) {
          try {
            await handler.replay(entry);
            await box.delete(entry.id);
          } catch (e) {
            final updated = entry.copyWith(
              retryCount: entry.retryCount + 1,
              status: 'failed',
            );
            await box.put(entry.id, updated.toMap());
          }
        }
      }
      _notifyCount(box);
    } finally {
      _isSyncing = false;
    }
  }

  @override
  Future<void> clear() async {
    final box = await _getBox();
    await box.clear();
    _notifyCount(box);
  }

  void _notifyCount(Box box) {
    if (!_countController.isClosed) {
      _countController.add(box.length);
    }
  }

  @override
  Stream<int> get pendingCountStream => _countController.stream;

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    _countController.close();
  }
}
