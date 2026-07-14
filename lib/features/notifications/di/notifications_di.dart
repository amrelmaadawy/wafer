import 'package:get_it/get_it.dart';
import '../data/datasources/notifications_remote_data_source.dart';
import '../data/repositories/notifications_repository_impl.dart';
import '../domain/repositories/notifications_repository.dart';
import '../domain/usecases/get_notifications_use_case.dart';
import '../domain/usecases/get_unread_notifications_count_use_case.dart';
import '../presentation/cubit/notifications_cubit.dart';
import '../presentation/cubit/unread_count_cubit.dart';

final GetIt sl = GetIt.instance;

void initNotificationsModule() {
  // Cubit
  sl.registerFactory(() => NotificationsCubit(sl(), sl()));
  sl.registerLazySingleton(() => UnreadCountCubit(sl()));

  // Use cases
  sl.registerLazySingleton(() => GetNotificationsUseCase(sl()));
  sl.registerLazySingleton(() => GetUnreadNotificationsCountUseCase(sl()));

  // Repository
  sl.registerLazySingleton<NotificationsRepository>(
    () => NotificationsRepositoryImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton<NotificationsRemoteDataSource>(
    () => NotificationsRemoteDataSourceImpl(sl()),
  );
}
