import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wafer/core/network/interceptors/cache_interceptor_config.dart';
import 'package:wafer/core/storage/secure_storage_service.dart';
import 'package:wafer/core/di/service_locator.dart';

void main() {
  test('Hive Encryption persists across re-initialization', () async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    
    sl.registerLazySingleton(() => SecureStorageService());
    Hive.init('codra_cache_test_dir');
    
    await CacheInterceptorConfig.init();
    
    final box = Hive.box('codra_cache_v1');
    await box.put('test_key', 'test_value');
    
    expect(box.get('test_key'), equals('test_value'));
    
    await box.close();
    
    // Simulating app restart
    await CacheInterceptorConfig.init();
    final box2 = Hive.box('codra_cache_v1');
    
    expect(box2.get('test_key'), equals('test_value'));
    print('Value retrieved from Hive after reopen: ${box2.get('test_key')}');
    
    await sl.reset();
  });
}
