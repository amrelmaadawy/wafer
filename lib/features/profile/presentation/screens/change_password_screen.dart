import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/di/service_locator.dart';
import '../cubit/change_password_cubit.dart';
import '../views/change_password_view.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: context.locale.languageCode == 'ar' ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: BlocProvider<ChangePasswordCubit>(
        create: (context) => sl<ChangePasswordCubit>(),
        child: const ChangePasswordView(),
      ),
    );
  }
}
