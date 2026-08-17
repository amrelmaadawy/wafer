import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../network/connectivity/network_info.dart';

abstract class ConnectivityService {
  Stream<bool> get onConnectivityChanged;
  Future<bool> get isConnected;
  void dispose();
}

class ConnectivityServiceImpl implements ConnectivityService {
  final Connectivity _connectivity;
  final NetworkInfo _networkInfo;

  final StreamController<bool> _controller =
      StreamController<bool>.broadcast();
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool? _lastKnownStatus;

  ConnectivityServiceImpl(this._connectivity, this._networkInfo) {
    _init();
  }

  void _init() {
    _subscription = _connectivity.onConnectivityChanged.listen(
      _handleConnectivityResult,
    );
  }

  Future<void> _handleConnectivityResult(List<ConnectivityResult> results) async {
    final hasConnection = results.isNotEmpty &&
        !results.every((r) => r == ConnectivityResult.none);

    bool isOnline = false;
    if (hasConnection) {
      isOnline = await _networkInfo.isConnected;
    }

    if (_lastKnownStatus != isOnline) {
      _lastKnownStatus = isOnline;
      if (!_controller.isClosed) {
        _controller.add(isOnline);
      }
    }
  }

  @override
  Stream<bool> get onConnectivityChanged => _controller.stream;

  @override
  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();
    final hasConnection = results.isNotEmpty &&
        !results.every((r) => r == ConnectivityResult.none);
    if (!hasConnection) {
      _lastKnownStatus = false;
      return false;
    }
    final online = await _networkInfo.isConnected;
    _lastKnownStatus = online;
    return online;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _controller.close();
  }
}
