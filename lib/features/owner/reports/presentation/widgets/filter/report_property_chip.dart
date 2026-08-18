import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/color_utils.dart';

class ReportPropertyItem {
  final int id;
  final String displayName;
  final String? code;

  const ReportPropertyItem({
    required this.id,
    required this.displayName,
    this.code,
  });
}

class ReportPropertyChip extends StatelessWidget {
  final int? selectedPropertyId;
  final List<ReportPropertyItem> properties;
  final ValueChanged<int?> onPropertySelected;

  const ReportPropertyChip({
    super.key,
    required this.selectedPropertyId,
    required this.properties,
    required this.onPropertySelected,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasProperty = selectedPropertyId != null;
    final selectedProp = properties
        .cast<ReportPropertyItem?>()
        .firstWhere((p) => p?.id == selectedPropertyId, orElse: () => null);
    final String label =
        selectedProp?.displayName ?? LocaleKeys.reportsFilterProperty.tr();

    return ActionChip(
      onPressed: () => _showSheet(context),
      backgroundColor: hasProperty ? context.primaryColor : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.circularLg,
        side: BorderSide(
          color: hasProperty ? context.primaryColor : AppColors.borderLight,
        ),
      ),
      label: Text(
        label,
        style: TextStyle(
          color: hasProperty ? Colors.white : AppColors.textPrimaryLight,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
      avatar: Icon(
        Icons.apartment_rounded,
        size: 16,
        color: hasProperty ? Colors.white : AppColors.textSecondaryLight,
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
                LocaleKeys.reportsFilterProperty.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: properties.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return ListTile(
                        title: Text(
                          LocaleKeys.reportsAllProperties.tr(),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        trailing: selectedPropertyId == null
                            ? Icon(Icons.check_circle, color: context.primaryColor)
                            : null,
                        onTap: () {
                          onPropertySelected(null);
                          Navigator.pop(context);
                        },
                      );
                    }
                    final prop = properties[index - 1];
                    return ListTile(
                      title: Text(prop.displayName),
                      subtitle: prop.code != null
                          ? Text(prop.code!, style: const TextStyle(fontSize: 12))
                          : null,
                      trailing: selectedPropertyId == prop.id
                          ? Icon(Icons.check_circle, color: context.primaryColor)
                          : null,
                      onTap: () {
                        onPropertySelected(prop.id);
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
