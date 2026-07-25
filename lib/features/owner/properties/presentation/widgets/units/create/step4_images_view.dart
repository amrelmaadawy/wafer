import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../cubit/units/unit_create_cubit.dart';
import '../../../cubit/units/unit_create_state.dart';

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
              const Text('صور الوحدة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('قم بإضافة صور للوحدة لزيادة فرص التأجير أو البيع', style: TextStyle(color: AppColors.textSecondaryLight)),
              const SizedBox(height: 24),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: state.images.length + 1,
                itemBuilder: (context, index) {
                  if (index == state.images.length) {
                    return _buildAddImageButton(context);
                  }
                  return _buildImageItem(context, state.images[index], index);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddImageButton(BuildContext context) {
    return InkWell(
      onTap: () async {
        final picker = ImagePicker();
        final pickedFiles = await picker.pickMultiImage();
        if (pickedFiles.isNotEmpty) {
          if (!context.mounted) return;
          for (var file in pickedFiles) {
            context.read<UnitCreateCubit>().addImage(File(file.path));
          }
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.05),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Icon(Icons.add_photo_alternate_outlined, color: AppColors.primary, size: 32),
        ),
      ),
    );
  }

  Widget _buildImageItem(BuildContext context, File image, int index) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: FileImage(image),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: InkWell(
            onTap: () => context.read<UnitCreateCubit>().removeImage(index),
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
