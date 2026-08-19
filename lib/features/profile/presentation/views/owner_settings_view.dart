import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/localization/locale_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../owner/shell/presentation/widgets/owner_top_app_bar.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../domain/entities/profile_entity.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../widgets/profile_actions_card.dart';
import '../widgets/profile_skeleton_widget.dart';
import '../../../../core/theme/color_utils.dart';

class OwnerSettingsView extends StatelessWidget {
  const OwnerSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: OwnerTopAppBar(
        title: LocaleKeys.drawerNavSettings.tr(),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading || state is ProfileInitial) {
            return const ProfileSkeletonWidget();
          } else if (state is ProfileLoaded) {
            return _buildContent(context, state.profile);
          } else if (state is ProfileError) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: () =>
                  context.read<ProfileCubit>().fetchProfile(forceRefresh: true),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, ProfileEntity profile) {
    return RefreshIndicator(
      color: context.primaryColor,
      onRefresh: () =>
          context.read<ProfileCubit>().fetchProfile(forceRefresh: true),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          ProfileActionsCard(profile: profile),
        ],
      ),
    );
  }
}
