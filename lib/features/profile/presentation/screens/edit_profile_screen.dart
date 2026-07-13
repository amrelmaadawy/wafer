import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/profile_entity.dart';
import '../cubit/profile_cubit.dart';
import '../views/edit_profile_view.dart';

class EditProfileScreen extends StatelessWidget {
  final ProfileCubit cubit;
  final ProfileEntity profile;

  const EditProfileScreen({
    super.key,
    required this.cubit,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider<ProfileCubit>.value(
        value: cubit,
        child: EditProfileView(profile: profile),
      ),
    );
  }
}
