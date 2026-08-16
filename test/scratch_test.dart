import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wafer/core/network/interceptors/cache_interceptor_config.dart';
import 'package:wafer/core/storage/secure_storage_service.dart';
import 'package:wafer/core/di/service_locator.dart';

void main() {
  test('Hive Encryption persists across re-initialization', () async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
    
    sl.registerLazySingleton(() => SecureStorageService());
    await CacheInterceptorConfig.init(customPath: 'test_cache_dir');
    
    Hive.init('test_cache_dir');
    final box = await Hive.openBox('test_scratch_box');
    await box.put('test_key', 'test_value');
    
    expect(box.get('test_key'), equals('test_value'));
    
    await box.close();
    
    // Simulating app restart
    final box2 = await Hive.openBox('test_scratch_box');
    
    expect(box2.get('test_key'), equals('test_value'));
    await box2.close();
    
    await sl.reset();
  });
}
