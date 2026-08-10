import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/theme/color_utils.dart';
import '../../../../../../../core/theme/app_radius.dart';
import '../../../cubit/units/unit_create_cubit.dart';
import '../../../cubit/units/unit_create_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../../../../core/localization/locale_keys.dart';

class Step4ImagesView extends StatelessWidget {
  const Step4ImagesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UnitCreateCubit, UnitCreateState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection(
                context,
                title: LocaleKeys.unitsImagesTitle.tr(),
                subtitle: LocaleKeys.unitsImagesSubtitle.tr(),
                items: state.images,
                onAdd: () async {
                  final picker = ImagePicker();
                  final pickedFiles = await picker.pickMultiImage();
                  if (pickedFiles.isNotEmpty) {
                    if (!context.mounted) return;
                    for (var file in pickedFiles) {
                      context.read<UnitCreateCubit>().addImage(File(file.path));
                    }
                  }
                },
                onRemove: (index) => context.read<UnitCreateCubit>().removeImage(index),
                icon: Icons.add_photo_alternate_outlined,
                isImage: true,
              ),
              const SizedBox(height: 32),
              
              _buildSection(
                context,
                title: LocaleKeys.unitsVideosCount.tr(),
                subtitle: '',
                items: state.videos,
                onAdd: () async {
                  final picker = ImagePicker();
                  final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    if (!context.mounted) return;
                    context.read<UnitCreateCubit>().addVideo(File(pickedFile.path));
                  }
                },
                onRemove: (index) => context.read<UnitCreateCubit>().removeVideo(index),
                icon: Icons.video_call_outlined,
                isImage: false,
              ),
              const SizedBox(height: 32),
              
              _buildSection(
                context,
                title: LocaleKeys.unitsFilesCount.tr(),
                subtitle: '',
                items: state.files,
                onAdd: () async {
                  final result = await FilePicker.pickFiles(allowMultiple: true);
                  if (result != null) {
                    if (!context.mounted) return;
                    for (var file in result.paths) {
                      if (file != null) {
                        context.read<UnitCreateCubit>().addFile(File(file));
                      }
                    }
                  }
                },
                onRemove: (index) => context.read<UnitCreateCubit>().removeFile(index),
                icon: Icons.attach_file_rounded,
                isImage: false,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String subtitle,
    required List<File> items,
    required VoidCallback onAdd,
    required void Function(int) onRemove,
    required IconData icon,
    required bool isImage,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        if (subtitle.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 13)),
        ],
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: items.length + 1,
          itemBuilder: (context, index) {
            if (index == items.length) {
              return InkWell(
                onTap: onAdd,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  decoration: BoxDecoration(
                    color: context.primaryColor.withValues(alpha: 0.05),
                    border: Border.all(
                      color: context.primaryColor.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                    borderRadius: AppRadius.circularLg,
                  ),
                  child: Center(
                    child: Icon(icon, color: context.primaryColor, size: 32),
                  ),
                ),
              );
            }
            return _buildMediaItem(items[index], () => onRemove(index), isImage);
          },
        ),
      ],
    );
  }

  Widget _buildMediaItem(File file, VoidCallback onRemove, bool isImage) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            image: isImage ? DecorationImage(image: FileImage(file), fit: BoxFit.cover) : null,
          ),
          child: !isImage
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      file.path.endsWith('.mp4') || file.path.endsWith('.mov')
                          ? Icons.video_file_outlined
                          : Icons.insert_drive_file_outlined,
                      size: 28,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        file.path.split('/').last,
                        style: const TextStyle(fontSize: 10),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                )
              : null,
        ),
        Positioned(
          top: 4,
          right: 4,
          child: InkWell(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 16, color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }
}
