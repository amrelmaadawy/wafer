import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/service_locator.dart';
import 'core/routing/app_router.dart';
import 'core/storage/cache_helper.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_theme_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize localization
  await EasyLocalization.ensureInitialized();

  // Initialize Dependency Injection
  await setupServiceLocator();

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

class RealEstateApp extends StatelessWidget {
  const RealEstateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppThemeCubit>.value(
      value: sl<AppThemeCubit>(),
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
          );
        },
      ),
    );
  }
}
