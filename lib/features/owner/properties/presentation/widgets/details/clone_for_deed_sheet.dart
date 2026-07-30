import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../../../../core/routing/routes.dart';
import '../../cubit/clone_for_deed/clone_for_deed_cubit.dart';
import '../../cubit/clone_for_deed/clone_for_deed_state.dart';

class CloneForDeedSheet extends StatefulWidget {
  final int propertyId;

  const CloneForDeedSheet({super.key, required this.propertyId});

  @override
  State<CloneForDeedSheet> createState() => _CloneForDeedSheetState();
}

class _CloneForDeedSheetState extends State<CloneForDeedSheet> {
  bool _copyData = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CloneForDeedCubit, CloneForDeedState>(
      listener: (context, state) {
        if (state is CloneForDeedSuccess) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(LocaleKeys.propertyDetailsCloneForDeedSuccess.tr()),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.circularMd),
            ),
          );
          // Navigate to the new property details
          context.pushReplacement(
            '${Routes.ownerPropertyDetails}?id=${state.newPropertyId}',
          );
        } else if (state is CloneForDeedError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.circularMd),
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is CloneForDeedLoading;

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 48,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: context.primaryColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.content_copy_rounded,
                        color: context.primaryColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocaleKeys.propertyDetailsCloneForDeedTitle.tr(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimaryLight,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            LocaleKeys.propertyDetailsCloneForDeedDesc.tr(),
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondaryLight,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                _buildOptionCard(
                  context,
                  title: LocaleKeys.propertyDetailsCloneForDeedCopyAll.tr(),
                  subtitle: LocaleKeys.propertyDetailsCloneForDeedCopyAllDesc
                      .tr(),
                  icon: Icons.file_copy_rounded,
                  isSelected: _copyData,
                  onTap: isLoading
                      ? null
                      : () => setState(() => _copyData = true),
                ),
                const SizedBox(height: 12),
                _buildOptionCard(
                  context,
                  title: LocaleKeys.propertyDetailsCloneForDeedEmpty.tr(),
                  subtitle: LocaleKeys.propertyDetailsCloneForDeedEmptyDesc
                      .tr(),
                  icon: Icons.note_add_rounded,
                  isSelected: !_copyData,
                  onTap: isLoading
                      ? null
                      : () => setState(() => _copyData = false),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            context.read<CloneForDeedCubit>().cloneForDeed(
                              widget.propertyId,
                              _copyData,
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.circularLg,
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            LocaleKeys.propertyDetailsCloneForDeedConfirm.tr(),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback? onTap,
  }) {
    final color = isSelected ? context.primaryColor : const Color(0xFF94A3B8);
    final bgColor = isSelected
        ? context.primaryColor.withValues(alpha: 0.05)
        : Colors.transparent;
    final borderColor = isSelected
        ? context.primaryColor
        : const Color(0xFFE2E8F0);

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.circularLg,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: AppRadius.circularLg,
          border: Border.all(color: borderColor, width: isSelected ? 1.5 : 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? context.primaryColor.withValues(alpha: 0.1)
                    : const Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? context.primaryColor
                          : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: context.primaryColor,
                size: 24,
              )
            else
              const Icon(
                Icons.circle_outlined,
                color: Color(0xFFCBD5E1),
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
