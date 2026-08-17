import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import '../network/dio_factory.dart';
import '../network/interceptors/auth_interceptor.dart';
import '../network/interceptors/error_interceptor.dart';
import '../network/interceptors/locale_interceptor.dart';
import '../network/connectivity/network_info.dart';
import '../network/connectivity/network_info_impl.dart';
import '../offline/services/offline_queue_service.dart';
import '../services/connectivity_service.dart';
import '../storage/cache_helper.dart';
import '../storage/secure_storage_service.dart';
import '../theme/app_theme_cubit.dart';
import '../../features/auth/di/auth_di.dart';
import '../../features/notifications/di/notifications_di.dart';
import '../../features/owner/di/owner_di.dart';
import '../../features/profile/di/profile_di.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<Connectivity>(() => Connectivity());

  // Storage
  sl.registerLazySingleton<SecureStorageService>(() => SecureStorageService());
  sl.registerLazySingleton<CacheHelper>(() => CacheHelper(sl()));

  // Theme
  sl.registerLazySingleton<AppThemeCubit>(() => AppThemeCubit());

  // Connectivity
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  sl.registerLazySingleton<ConnectivityService>(
    () => ConnectivityServiceImpl(sl(), sl()),
  );

  // Offline Queue
  sl.registerLazySingleton<OfflineQueueService>(
    () => OfflineQueueServiceImpl(sl(), sl()),
  );

  // Network Interceptors
  sl.registerLazySingleton<AuthInterceptor>(() => AuthInterceptor(sl()));
  sl.registerLazySingleton<LocaleInterceptor>(() => LocaleInterceptor(sl()));
  sl.registerLazySingleton<ErrorInterceptor>(() => ErrorInterceptor());

  // Network
  sl.registerLazySingleton<Dio>(
    () => DioFactory.getDio(
      authInterceptor: sl(),
      localeInterceptor: sl(),
      errorInterceptor: sl(),
      networkInfo: sl(),
    ),
  );

  // Features
  await initAuthModule();
  initOwnerModule();
  initProfileModule();
  initNotificationsModule();
}
