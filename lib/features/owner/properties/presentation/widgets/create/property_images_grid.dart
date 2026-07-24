import 'dart:io';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../domain/entities/temp_property_image_entity.dart';

class PropertyImagesGrid extends StatefulWidget {
  final List<TempPropertyImageEntity> images;
  final Function(String) onAddImage;
  final Function(String) onRemoveImage;
  final VoidCallback? onRetryUpload;

  const PropertyImagesGrid({
    super.key,
    required this.images,
    required this.onAddImage,
    required this.onRemoveImage,
    this.onRetryUpload,
  });

  @override
  State<PropertyImagesGrid> createState() => _PropertyImagesGridState();
}

class _PropertyImagesGridState extends State<PropertyImagesGrid> {
  bool _isPickerActive = false;

  Future<void> _pickImage() async {
    if (_isPickerActive) return;
    
    setState(() {
      _isPickerActive = true;
    });
    
    try {
      final picker = ImagePicker();
      final xfile = await picker.pickImage(source: ImageSource.gallery);
      if (xfile != null) {
        widget.onAddImage(xfile.path);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPickerActive = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return _buildEmptyState(context);
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.images.length + 1,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        if (index == widget.images.length) {
          return _buildAddButton(context);
        }
        return _buildImageCard(context, widget.images[index]);
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 32),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: AppRadius.circularXl,
          border: Border.all(color: const Color(0xFFE2E8F0), style: BorderStyle.solid),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add_a_photo_outlined, size: 32, color: context.primaryColor),
            ),
            const SizedBox(height: 16),
            Text(
              LocaleKeys.propertyImagesNoImages.tr(),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              LocaleKeys.propertyImagesNoImagesSub.tr(),
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        decoration: BoxDecoration(
          color: context.primaryColor.withValues(alpha: 0.05),
          borderRadius: AppRadius.circularLg,
          border: Border.all(color: context.primaryColor.withValues(alpha: 0.3)),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add_rounded, color: context.primaryColor, size: 28),
              const SizedBox(height: 4),
              Text(
                LocaleKeys.propertyImagesAddPhoto.tr(),
                style: TextStyle(
                  color: context.primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageCard(BuildContext context, TempPropertyImageEntity image) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: AppRadius.circularLg,
            image: DecorationImage(
              image: FileImage(File(image.localPath)),
              fit: BoxFit.cover,
            ),
          ),
        ),
        if (image.isUploading)
          Container(
            decoration: BoxDecoration(
              borderRadius: AppRadius.circularLg,
              color: Colors.black.withValues(alpha: 0.5),
            ),
            child: const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              ),
            ),
          ),
        if (image.uploadFailed)
          Container(
            decoration: BoxDecoration(
              borderRadius: AppRadius.circularLg,
              color: AppColors.error.withValues(alpha: 0.8),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.white, size: 24),
                  const SizedBox(height: 4),
                  Text(
                    LocaleKeys.propertyImagesUploadFailed.tr(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
        if (!image.isUploading)
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => widget.onRemoveImage(image.tempPath ?? image.localPath),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 14, color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }
}
