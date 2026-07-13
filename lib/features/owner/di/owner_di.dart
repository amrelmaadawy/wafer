import '../../../../core/di/service_locator.dart';
import '../presentation/cubit/owner_nav_cubit.dart';

void initOwnerModule() {
  if (!sl.isRegistered<OwnerNavCubit>()) {
    sl.registerFactory(() => OwnerNavCubit());
  }
}
