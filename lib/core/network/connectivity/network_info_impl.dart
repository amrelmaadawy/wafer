import 'dart:io';
import 'network_info.dart';

/// Concrete implementation that performs a real DNS lookup against the
/// production host to confirm internet + server reachability.
class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    try {
      final result = await InternetAddress.lookup('codra.cloud')
          .timeout(const Duration(seconds: 5));
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    } on Exception {
      return false;
    }
  }
}
