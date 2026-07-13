import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/utils/widgets/custom_snackbar.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../views/login_view.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthCubit>(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthError) {
                CustomSnackbar.showError(context, state.message);
              } else if (state is Authenticated) {
                CustomSnackbar.showSuccess(context, 'تم تسجيل الدخول بنجاح');
                if (state.user.requiresPasswordChange) {
                  // TODO: Navigate to ChangePasswordScreen when built
                  CustomSnackbar.showInfo(context, 'يرجى تغيير كلمة المرور أولاً');
                } else {
                  context.go(Routes.home);
                }
              }
            },
            builder: (context, state) {
              return const LoginView();
            },
          ),
        ),
      ),
    );
  }
}
