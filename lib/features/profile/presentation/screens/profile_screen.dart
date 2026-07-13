import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/service_locator.dart';
import '../cubit/profile_cubit.dart';
import '../views/profile_view.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    try {
      context.read<ProfileCubit>();
      return const Directionality(
        textDirection: TextDirection.rtl,
        child: ProfileView(),
      );
    } catch (_) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: BlocProvider<ProfileCubit>(
          create: (_) => sl<ProfileCubit>()..fetchProfile(),
          child: const ProfileView(),
        ),
      );
    }
  }
}
