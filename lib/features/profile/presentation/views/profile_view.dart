import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/localization/locale_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/color_utils.dart';
import '../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../domain/entities/profile_entity.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../widgets/profile_actions_card.dart';
import '../widgets/profile_header_card.dart';
import '../widgets/profile_info_card.dart';
import '../widgets/profile_skeleton_widget.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: CustomAppBar(
        title: LocaleKeys.profileTitle.tr(),
        showBackButton: false,
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading || state is ProfileInitial) {
            return _buildSkeleton();
          } else if (state is ProfileLoaded) {
            return _buildContent(context, state.profile);
          } else if (state is ProfileError) {
            return _buildError(context, state.message);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, ProfileEntity profile) {
    return RefreshIndicator(
      color: context.primaryColor,
      onRefresh: () => context.read<ProfileCubit>().fetchProfile(forceRefresh: true),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 120),
        children: [
          ProfileHeaderCard(profile: profile),
          const SizedBox(height: 16),
          ProfileInfoCard(profile: profile),
          const SizedBox(height: 16),
          ProfileActionsCard(profile: profile),
        ],
      ),
    );
  }

  Widget _buildSkeleton() {
    return const ProfileSkeletonWidget();
  }

  Widget _buildError(BuildContext context, String message) {
    return CustomErrorWidget(
      message: message,
      onRetry: () => context.read<ProfileCubit>().fetchProfile(forceRefresh: true),
    );
  }
}
