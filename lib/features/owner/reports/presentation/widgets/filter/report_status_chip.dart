import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/color_utils.dart';

class ReportStatusItem {
  final String value;
  final String label;

  const ReportStatusItem({
    required this.value,
    required this.label,
  });
}

class ReportStatusChip extends StatelessWidget {
  final String? selectedStatus;
  final List<ReportStatusItem> statuses;
  final ValueChanged<String?> onStatusSelected;

  const ReportStatusChip({
    super.key,
    required this.selectedStatus,
    required this.statuses,
    required this.onStatusSelected,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasStatus = selectedStatus != null && selectedStatus != 'ALL';
    final selectedItem = statuses
        .cast<ReportStatusItem?>()
        .firstWhere((s) => s?.value == selectedStatus, orElse: () => null);
    final String label =
        selectedItem?.label ?? LocaleKeys.reportsFilterStatus.tr();

    return ActionChip(
      onPressed: () => _showSheet(context),
      backgroundColor: hasStatus ? context.primaryColor : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.circularLg,
        side: BorderSide(
          color: hasStatus ? context.primaryColor : AppColors.borderLight,
        ),
      ),
      label: Text(
        label,
        style: TextStyle(
          color: hasStatus ? Colors.white : AppColors.textPrimaryLight,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
      avatar: Icon(
        Icons.filter_list_rounded,
        size: 16,
        color: hasStatus ? Colors.white : AppColors.textSecondaryLight,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  void _showSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.borderLight,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                LocaleKeys.reportsFilterStatus.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: statuses.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return ListTile(
                        title: Text(
                          LocaleKeys.reportsAllStatuses.tr(),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        trailing: selectedStatus == null || selectedStatus == 'ALL'
                            ? Icon(Icons.check_circle, color: context.primaryColor)
                            : null,
                        onTap: () {
                          onStatusSelected(null);
                          Navigator.pop(context);
                        },
                      );
                    }
                    final item = statuses[index - 1];
                    return ListTile(
                      title: Text(item.label),
                      trailing: selectedStatus == item.value
                          ? Icon(Icons.check_circle, color: context.primaryColor)
                          : null,
                      onTap: () {
                        onStatusSelected(item.value);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
