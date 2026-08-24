import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/localization/locale_keys.dart';
import '../../../../core/utils/widgets/app_toast.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../views/login_view.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: context.locale.languageCode == 'ar'
          ? ui.TextDirection.rtl
          : ui.TextDirection.ltr,
      child: Scaffold(
        body: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              AppToast.showError(context, state.message);
            } else if (state is Authenticated) {
              // Navigation is handled by GoRouter redirect via updateAuthState() in main.dart.
              // Show success toast only.
              AppToast.showSuccess(context, LocaleKeys.authLoginSuccess.tr());
            }
            // No manual context.go() calls here — the router guard handles all routing.
          },
          child: const LoginView(),
        ),
      ),
    );
  }
}
