import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/localization/locale_keys.dart';
import '../../../../core/theme/color_utils.dart';

class AvatarPickerBottomSheet {
  AvatarPickerBottomSheet._();

  static void show({
    required BuildContext context,
    required Future<void> Function(ImageSource source) onPick,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                LocaleKeys.profileAvatarChangeTitle.tr(),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: bottomSheetContext.primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.camera_alt_rounded, color: bottomSheetContext.primaryColor),
                ),
                title: Text(LocaleKeys.profileAvatarCamera.tr(), style: const TextStyle(fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  onPick(ImageSource.camera);
                },
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: bottomSheetContext.primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.photo_library_rounded, color: bottomSheetContext.primaryColor),
                ),
                title: Text(LocaleKeys.profileAvatarGallery.tr(), style: const TextStyle(fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  onPick(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
