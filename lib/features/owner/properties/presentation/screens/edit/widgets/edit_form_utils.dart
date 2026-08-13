import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/theme/app_radius.dart';
import '../../../../../../../core/theme/color_utils.dart';

class EditFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool isRequired;
  final TextInputType keyboardType;
  final int maxLines;
  final bool isNumber;
  final String? hint;
  final int? maxLength;
  final String? suffixText;

  const EditFormField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.isRequired = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.isNumber = false,
    this.hint,
    this.maxLength,
    this.suffixText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryLight,
                ),
              ),
            ),
            if (isRequired)
              const Text(' *', style: TextStyle(color: AppColors.error)),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          maxLength: maxLength,
          inputFormatters: isNumber
              ? [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  if (maxLength != null)
                    LengthLimitingTextInputFormatter(maxLength),
                ]
              : maxLength != null
              ? [LengthLimitingTextInputFormatter(maxLength)]
              : null,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            counterText: "",
            hintText: hint,
            hintStyle: const TextStyle(
              color: AppColors.textSecondaryLight,
              fontSize: 13,
              overflow: TextOverflow.visible,
            ),
            hintMaxLines: 2,
            suffixText: suffixText,
            suffixStyle: TextStyle(
              color: context.primaryColor,
              fontWeight: FontWeight.bold,
            ),
            prefixIcon: maxLines > 1
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 50.0),
                    child: Icon(icon, size: 20, color: context.primaryColor),
                  )
                : Icon(icon, size: 20, color: context.primaryColor),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: const OutlineInputBorder(
              borderRadius: AppRadius.circularLg,
              borderSide: BorderSide(color: AppColors.borderLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.circularLg,
              borderSide: BorderSide(color: context.primaryColor, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

class EditSectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const EditSectionHeader({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: context.primaryColor.withValues(alpha: 0.1),
            borderRadius: AppRadius.circularMd,
          ),
          child: Icon(icon, size: 18, color: context.primaryColor),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15.5,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(child: Divider(color: AppColors.borderLight, height: 1)),
      ],
    );
  }
}

