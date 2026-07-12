import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../network/dio_factory.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Core
  sl.registerLazySingleton<Dio>(() => DioFactory.getDio());
  
  // Storage
  // sl.registerLazySingleton<SecureStorageService>(() => SecureStorageService());
  
  // Features (Each feature will have its own init method called here)
  // await initAuthModule();
}
