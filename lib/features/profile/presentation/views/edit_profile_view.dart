import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/color_utils.dart';
import '../../domain/entities/profile_entity.dart';
import '../widgets/edit_profile_form_widget.dart';

class EditProfileView extends StatelessWidget {
  final ProfileEntity profile;

  const EditProfileView({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text(
          'تعديل البيانات الشخصية',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
            _buildAvatarHeader(context),
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

  Widget _buildAvatarHeader(BuildContext context) {
    final initial = profile.name.isNotEmpty ? profile.name[0].toUpperCase() : 'U';
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Container(
              width: 86,
              height: 86,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [context.primaryColor, context.primaryColor.withValues(alpha: 0.75)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: context.primaryShadow.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
                border: Border.all(color: Colors.white, width: 3),
              ),
              alignment: Alignment.center,
              child: ClipOval(
                child: (profile.avatar != null && profile.avatar!.isNotEmpty)
                    ? Image.network(
                        profile.avatar!,
                        width: 86,
                        height: 86,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => _buildInitialText(initial),
                      )
                    : _buildInitialText(initial),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: context.primaryColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(Icons.edit_rounded, color: Colors.white, size: 14),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          profile.email,
          style: const TextStyle(
            color: AppColors.textSecondaryLight,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildInitialText(String initial) {
    return Text(
      initial,
      style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
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
              'بيانات البريد ورقم الهوية مسجلة رسمياً ولا يمكن تعديلها مباشرة لضمان أمان وتوثيق الحساب.',
              style: TextStyle(color: const Color(0xFF475569), fontSize: 12, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
