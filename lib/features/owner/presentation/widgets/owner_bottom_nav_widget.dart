import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class OwnerBottomNavWidget extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabChanged;

  const OwnerBottomNavWidget({
    super.key,
    required this.currentIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        border: Border(
          top: BorderSide(color: AppColors.borderLight.withValues(alpha: 0.6), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context: context,
                index: 0,
                label: 'الرئيسية',
                activeIcon: Icons.dashboard_rounded,
                inactiveIcon: Icons.dashboard_outlined,
              ),
              _buildNavItem(
                context: context,
                index: 1,
                label: 'العقارات',
                activeIcon: Icons.apartment_rounded,
                inactiveIcon: Icons.apartment_outlined,
              ),
              _buildNavItem(
                context: context,
                index: 2,
                label: 'العقود',
                activeIcon: Icons.description_rounded,
                inactiveIcon: Icons.description_outlined,
              ),
              _buildNavItem(
                context: context,
                index: 3,
                label: 'المالية',
                activeIcon: Icons.account_balance_wallet_rounded,
                inactiveIcon: Icons.account_balance_wallet_outlined,
              ),
              _buildNavItem(
                context: context,
                index: 4,
                label: 'المزيد',
                activeIcon: Icons.more_horiz_rounded,
                inactiveIcon: Icons.more_horiz_outlined,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required String label,
    required IconData activeIcon,
    required IconData inactiveIcon,
  }) {
    final isSelected = currentIndex == index;

    return InkWell(
      onTap: () => onTabChanged(index),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : inactiveIcon,
              color: isSelected ? AppColors.primary : AppColors.textSecondaryLight.withValues(alpha: 0.75),
              size: 22,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isSelected ? AppColors.primary : AppColors.textSecondaryLight.withValues(alpha: 0.75),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
