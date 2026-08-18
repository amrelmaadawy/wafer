import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class SortRadioIndicator extends StatelessWidget {
  final bool isSelected;
  final Color primaryColor;

  const SortRadioIndicator({
    super.key,
    required this.isSelected,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? primaryColor : AppColors.borderLight,
          width: 2,
        ),
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
            )
          : null,
    );
  }
}
