import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../../../features/auth/presentation/cubit/auth_state.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/localization/locale_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../widgets/change_password_form_widget.dart';
import '../widgets/change_password_header_card.dart';

class ChangePasswordView extends StatelessWidget {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        final isForced = authState is Authenticated && authState.user.requiresPasswordChange;

        return Scaffold(
          backgroundColor: AppColors.backgroundLight,
          appBar: CustomAppBar(
            title: LocaleKeys.changePasswordTitle.tr(),
            showBackButton: !isForced,
            actions: isForced
                ? [
                    IconButton(
                      icon: const Icon(Icons.logout, color: AppColors.error),
                      onPressed: () => context.read<AuthCubit>().logout(),
                    ),
                  ]
                : null,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              children: [
                const ChangePasswordHeaderCard(),
                const SizedBox(height: 24),
                ChangePasswordFormWidget(isForced: isForced),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }
}
