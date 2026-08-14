import 'dart:async';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/service_locator.dart';
import 'core/network/interceptors/cache_interceptor_config.dart';
import 'core/network/connectivity/auth_event_bus.dart';
import 'core/presentation/widgets/no_internet_banner.dart';
import 'core/routing/app_router.dart';
import 'core/routing/routes.dart';
import 'core/storage/cache_helper.dart';
import 'core/storage/secure_storage_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_theme_cubit.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/cubit/auth_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize localization
  await EasyLocalization.ensureInitialized();

  // Initialize Dependency Injection
  await setupServiceLocator();

  // Initialize API Cache Store
  await CacheInterceptorConfig.init();

  // Load saved primary color and apply it before first frame
  final savedColor = sl<CacheHelper>().getPrimaryColor();
  sl<AppThemeCubit>().loadFromPrefs(savedColor);

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/translations',
      startLocale: const Locale('ar'),
      fallbackLocale: const Locale('ar'),
      child: const RealEstateApp(),
    ),
  );
}

class RealEstateApp extends StatefulWidget {
  const RealEstateApp({super.key});

  @override
  State<RealEstateApp> createState() => _RealEstateAppState();
}

class _RealEstateAppState extends State<RealEstateApp> {
  StreamSubscription<AuthEvent>? _authSubscription;

  @override
  void initState() {
    super.initState();
    _listenToAuthEvents();
  }

  void _listenToAuthEvents() {
    _authSubscription = AuthEventBus.stream.listen((event) async {
      if (event == AuthEvent.unauthorized) {
        // Clear stored credentials
        await sl<SecureStorageService>().clearAll();
        await sl<CacheHelper>().clearAll();
        await CacheInterceptorConfig.clearCache();

        // Navigate to login screen
        if (mounted) {
          AppRouter.router.go(Routes.login);
        }
      }
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppThemeCubit>.value(value: sl<AppThemeCubit>()),
        BlocProvider<AuthCubit>(create: (_) => sl<AuthCubit>()..checkAuthStatus()),
      ],
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          // Keep the router guard in sync with the global auth state
          updateAuthState(state);
        },
        child: BlocBuilder<AppThemeCubit, ThemeData>(
          builder: (context, theme) {
            return MaterialApp.router(
              title: 'Wafer Real Estate ERP',
              debugShowCheckedModeBanner: false,
              theme: theme,
              darkTheme: AppTheme.buildDark(theme.colorScheme.primary),
              themeMode: ThemeMode.light,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              routerConfig: AppRouter.router,
              builder: (context, child) {
                return NoInternetBanner(child: child!);
              },
            );
          },
        ),
      ),
    );
  }
}
