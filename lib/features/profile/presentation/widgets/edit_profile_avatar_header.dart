import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/color_utils.dart';
import '../../../../core/utils/widgets/app_toast.dart';
import '../../domain/entities/profile_entity.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import 'avatar_picker_bottom_sheet.dart';

class EditProfileAvatarHeader extends StatelessWidget {
  final ProfileEntity profile;

  const EditProfileAvatarHeader({super.key, required this.profile});

  Future<void> _pickAndUploadImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 85);
    if (pickedFile != null && context.mounted) {
      context.read<ProfileCubit>().updateAvatar(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileAvatarUpdateSuccess) {
          AppToast.showSuccess(context, state.message);
        } else if (state is ProfileAvatarUpdateError) {
          AppToast.showError(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        final currentProfile = state is ProfileLoaded ? state.profile : profile;
        final isUpdating = state is ProfileAvatarUpdating;
        final initial = currentProfile.name.isNotEmpty ? currentProfile.name[0].toUpperCase() : 'U';

        return Column(
          children: [
            GestureDetector(
              onTap: isUpdating
                  ? null
                  : () => AvatarPickerBottomSheet.show(
                        context: context,
                        onPick: (source) => _pickAndUploadImage(context, source),
                      ),
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  _buildAvatarCircle(context, currentProfile, initial, isUpdating),
                  _buildEditBadge(context, isUpdating),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              currentProfile.email,
              style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAvatarCircle(BuildContext context, ProfileEntity currentProfile, String initial, bool isUpdating) {
    return Container(
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
          BoxShadow(color: context.primaryShadow.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 6)),
        ],
        border: Border.all(color: Colors.white, width: 3),
      ),
      alignment: Alignment.center,
      child: ClipOval(
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (currentProfile.avatar != null && currentProfile.avatar!.isNotEmpty)
              Image.network(
                currentProfile.avatar!,
                width: 86,
                height: 86,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stack) => _buildInitialText(initial),
              )
            else
              _buildInitialText(initial),
            if (isUpdating)
              Container(
                width: 86,
                height: 86,
                color: Colors.black.withValues(alpha: 0.45),
                alignment: Alignment.center,
                child: const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditBadge(BuildContext context, bool isUpdating) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: context.primaryColor,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Icon(isUpdating ? Icons.hourglass_top_rounded : Icons.camera_alt_rounded, color: Colors.white, size: 14),
    );
  }

  Widget _buildInitialText(String initial) {
    return Center(
      child: Text(
        initial,
        style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
      ),
    );
  }
}
