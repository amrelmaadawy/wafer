import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../domain/entities/option_value_label_entity.dart';

class PropertyTypeSelectorWidget extends StatelessWidget {
  final List<OptionValueLabelEntity> propertyTypes;
  final String? selectedType;
  final Function(String) onSelect;
  final String? errorText;

  const PropertyTypeSelectorWidget({
    super.key,
    required this.propertyTypes,
    required this.selectedType,
    required this.onSelect,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.5,
          ),
          itemCount: propertyTypes.length,
          itemBuilder: (context, index) {
            final type = propertyTypes[index];
            final isSelected = selectedType == type.value;
            
            IconData typeIcon;
            switch (type.value) {
              case 'residential': typeIcon = Icons.home_rounded; break;
              case 'commercial': typeIcon = Icons.storefront_rounded; break;
              case 'land': typeIcon = Icons.landscape_rounded; break;
              case 'administrative': typeIcon = Icons.business_rounded; break;
              default: typeIcon = Icons.domain_rounded;
            }

            return InkWell(
              onTap: () => onSelect(type.value),
              borderRadius: AppRadius.circularMd,
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? context.primaryColor.withValues(alpha: 0.05) : Colors.white,
                  borderRadius: AppRadius.circularMd,
                  border: Border.all(
                    color: isSelected ? context.primaryColor : const Color(0xFFE2E8F0),
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Icon(
                      typeIcon,
                      color: isSelected ? context.primaryColor : AppColors.textSecondaryLight,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        type.label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                          color: isSelected ? context.primaryColor : AppColors.textPrimaryLight,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8, right: 12),
            child: Text(
              errorText!,
              style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
      ],
    );
  }
}
