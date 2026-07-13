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
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.8), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 30,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildDockItem(
              context: context,
              index: 0,
              label: 'الرئيسية',
              activeIcon: Icons.dashboard_rounded,
              inactiveIcon: Icons.dashboard_outlined,
            ),
            _buildDockItem(
              context: context,
              index: 1,
              label: 'العقارات',
              activeIcon: Icons.apartment_rounded,
              inactiveIcon: Icons.apartment_outlined,
            ),
            _buildDockItem(
              context: context,
              index: 2,
              label: 'العقود',
              activeIcon: Icons.description_rounded,
              inactiveIcon: Icons.description_outlined,
            ),
            _buildDockItem(
              context: context,
              index: 3,
              label: 'المالية',
              activeIcon: Icons.account_balance_wallet_rounded,
              inactiveIcon: Icons.account_balance_wallet_outlined,
            ),
            _buildDockItem(
              context: context,
              index: 4,
              label: 'المزيد',
              activeIcon: Icons.more_horiz_rounded,
              inactiveIcon: Icons.more_horiz_outlined,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDockItem({
    required BuildContext context,
    required int index,
    required String label,
    required IconData activeIcon,
    required IconData inactiveIcon,
  }) {
    final isSelected = currentIndex == index;

    return InkWell(
      onTap: () => onTabChanged(index),
      borderRadius: BorderRadius.circular(22),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 14 : 10,
          vertical: isSelected ? 8 : 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : inactiveIcon,
              color: isSelected ? Colors.white : AppColors.textSecondaryLight.withValues(alpha: 0.7),
              size: 22,
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
