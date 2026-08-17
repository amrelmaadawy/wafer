import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wafer/core/network/connectivity/network_info.dart';
import 'package:wafer/core/services/connectivity_service.dart';

class MockConnectivity extends Mock implements Connectivity {}
class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late MockConnectivity mockConnectivity;
  late MockNetworkInfo mockNetworkInfo;
  late StreamController<List<ConnectivityResult>> connectivityController;
  late ConnectivityServiceImpl connectivityService;

  setUp(() {
    mockConnectivity = MockConnectivity();
    mockNetworkInfo = MockNetworkInfo();
    connectivityController = StreamController<List<ConnectivityResult>>.broadcast();

    when(() => mockConnectivity.onConnectivityChanged)
        .thenAnswer((_) => connectivityController.stream);

    connectivityService = ConnectivityServiceImpl(
      mockConnectivity,
      mockNetworkInfo,
    );
  });

  tearDown(() {
    connectivityService.dispose();
    connectivityController.close();
  });

  test('isConnected returns false when connectivity results are none', () async {
    when(() => mockConnectivity.checkConnectivity())
        .thenAnswer((_) async => [ConnectivityResult.none]);

    final result = await connectivityService.isConnected;

    expect(result, isFalse);
    verifyNever(() => mockNetworkInfo.isConnected);
  });

  test('isConnected returns true when wifi is connected and network is reachable', () async {
    when(() => mockConnectivity.checkConnectivity())
        .thenAnswer((_) async => [ConnectivityResult.wifi]);
    when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);

    final result = await connectivityService.isConnected;

    expect(result, isTrue);
    verify(() => mockNetworkInfo.isConnected).called(1);
  });

  test('onConnectivityChanged emits correct online/offline status', () async {
    when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);

    final emitted = <bool>[];
    final sub = connectivityService.onConnectivityChanged.listen(emitted.add);

    connectivityController.add([ConnectivityResult.wifi]);
    await Future.delayed(const Duration(milliseconds: 10));

    connectivityController.add([ConnectivityResult.none]);
    await Future.delayed(const Duration(milliseconds: 10));

    expect(emitted, [true, false]);
    await sub.cancel();
  });
}
