import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/locale_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/color_utils.dart';
import '../cubit/notifications_cubit.dart';
import '../cubit/notifications_state.dart';

class NotificationCategoryChips extends StatelessWidget {
  const NotificationCategoryChips({super.key});

  static const List<(String, String)> _filters = [
    ('all', LocaleKeys.notificationsAll),
    ('unread', LocaleKeys.notificationsUnread),
    ('financial', LocaleKeys.notificationCategoryFinancial),
    ('contracts', LocaleKeys.notificationCategoryContracts),
    ('maintenance', LocaleKeys.notificationCategoryMaintenance),
    ('tasks', LocaleKeys.notificationCategoryTasks),
    ('legal', LocaleKeys.notificationCategoryLegal),
    ('system', LocaleKeys.notificationCategorySystem),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      margin: const EdgeInsets.only(top: 8, bottom: 4),
      child: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          String current = 'all';
          if (state is NotificationsLoaded) current = state.activeFilter;
          if (state is NotificationsEmpty) current = state.activeFilter;

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: _filters.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final (key, labelKey) = _filters[index];
              final isSelected = current == key;
              return _buildChip(
                context: context,
                label: labelKey.tr(),
                isSelected: isSelected,
                onTap: () =>
                    context.read<NotificationsCubit>().changeFilter(key),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildChip({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final primary = context.primaryColor;
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? primary : AppColors.dividerSubtleLight,
            borderRadius: AppRadius.circularXxl,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? Colors.white : AppColors.textSecondaryLight,
            ),
          ),
        ),
      ),
    );
  }
}
