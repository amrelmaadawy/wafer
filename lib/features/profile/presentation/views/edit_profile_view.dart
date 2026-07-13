import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/localization/locale_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/color_utils.dart';
import '../../domain/entities/profile_entity.dart';
import '../widgets/edit_profile_avatar_header.dart';
import '../widgets/edit_profile_form_widget.dart';

class EditProfileView extends StatelessWidget {
  final ProfileEntity profile;

  const EditProfileView({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          LocaleKeys.profileEditScreenTitle.tr(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimaryLight),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.borderLight),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            EditProfileAvatarHeader(profile: profile),
            const SizedBox(height: 20),
            _buildReadOnlyBanner(context),
            const SizedBox(height: 24),
            EditProfileFormWidget(profile: profile),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Icon(Icons.shield_outlined, color: context.primaryColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              LocaleKeys.profileReadonlyBanner.tr(),
              style: const TextStyle(color: Color(0xFF475569), fontSize: 12, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
