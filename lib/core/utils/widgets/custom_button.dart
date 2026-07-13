import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_sizes.dart';
import '../../theme/color_utils.dart';

enum ButtonType { primary, secondary, text }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonType type;
  final bool isLoading;
  final bool isDisabled;
  final double? width;
  final Widget? icon;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.isDisabled = false,
    this.width = AppSizes.buttonWidthLarge,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: AppSizes.buttonHeight,
      child: _buildButton(context),
    );
  }

  Widget _buildButton(BuildContext context) {
    final bool disabled = isDisabled || isLoading;
    
    switch (type) {
      case ButtonType.primary:
        return ElevatedButton(
          onPressed: disabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: context.primaryColor,
            foregroundColor: Colors.white,
            shape: const RoundedRectangleBorder(borderRadius: AppRadius.circularMd),
            elevation: 0,
            disabledBackgroundColor: AppColors.borderLight,
          ),
          child: _buildChild(Colors.white),
        );
      case ButtonType.secondary:
        return OutlinedButton(
          onPressed: disabled ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: context.primaryColor,
            side: BorderSide(color: context.primaryColor),
            shape: const RoundedRectangleBorder(borderRadius: AppRadius.circularMd),
          ),
          child: _buildChild(context.primaryColor),
        );
      case ButtonType.text:
        return TextButton(
          onPressed: disabled ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: context.primaryColor,
          ),
          child: _buildChild(context.primaryColor),
        );
    }
  }

  Widget _buildChild(Color color) {
    if (isLoading) {
      return SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon!,
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      );
    }

    return Text(text, style: const TextStyle(fontWeight: FontWeight.bold));
  }
}
