import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../../../core/localization/locale_keys.dart';
import '../../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../../core/theme/app_radius.dart';
import '../../../../../../../../core/theme/color_utils.dart';
import '../../../../../../../../core/utils/widgets/app_toast.dart';
import '../../../../../domain/entities/form_owner_entity.dart';
import '../../../../cubit/owners/sync_owners_cubit.dart';
import '../../../../cubit/owners/sync_owners_state.dart';

class AddOwnerDropdown extends StatelessWidget {
  final SyncOwnersState state;
  final SyncOwnersCubit cubit;
  const AddOwnerDropdown({super.key, required this.state, required this.cubit});

  @override
  Widget build(BuildContext context) {
    final available = state.availableOwners
        .where((o) => !state.assignedOwners.any((a) => a.owner.id == o.id))
        .toList();
    final primary = context.primaryColor;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.circularXl,
        border: Border.all(color: primary.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<FormOwnerEntity>(
            isExpanded: true,
            hint: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.person_add_alt_1_rounded,
                        color: primary, size: 18),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    available.isEmpty
                        ? LocaleKeys.propertyOwnersNoAvailable.tr()
                        : LocaleKeys.propertyOwnersAddOwner.tr(),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimaryLight,
                    ),
                  ),
                ],
              ),
            ),
            icon: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(Icons.expand_more_rounded, color: primary),
            ),
            borderRadius: AppRadius.circularXl,
            items: available.map((owner) {
              return DropdownMenuItem<FormOwnerEntity>(
                value: owner,
                child: Text(
                  owner.name,
                  style: const TextStyle(
                    fontSize: 15, 
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryLight
                  ),
                ),
              );
            }).toList(),
            onChanged: available.isEmpty
                ? null
                : (owner) {
                    if (owner == null) return;
                    final added = cubit.addOwner(owner);
                    if (!added) {
                      AppToast.showInfo(
                          context, LocaleKeys.propertyOwnersAlreadyAdded.tr());
                    }
                  },
          ),
        ),
      ),
    );
  }
}

class AutoDistributeButton extends StatelessWidget {
  final SyncOwnersCubit cubit;
  const AutoDistributeButton({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    final primary = context.primaryColor;
    return GestureDetector(
      onTap: cubit.autoDistribute,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primary.withValues(alpha: 0.1), primary.withValues(alpha: 0.02)],
          ),
          borderRadius: AppRadius.circularLg,
          border: Border.all(color: primary.withValues(alpha: 0.15)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.auto_fix_high_rounded, size: 18, color: primary),
            const SizedBox(width: 10),
            Text(
              LocaleKeys.propertyOwnersAutoDistribute.tr(),
              style: TextStyle(
                color: primary,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyOwners extends StatelessWidget {
  const EmptyOwners({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Icon(Icons.people_outline_rounded,
                  size: 56, color: const Color(0xFFCBD5E1)),
            ),
            const SizedBox(height: 20),
            Text(
              LocaleKeys.propertyOwnersNoOwners.tr(),
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SaveButton extends StatelessWidget {
  final SyncOwnersState state;
  final SyncOwnersCubit cubit;
  final int propertyId;

  const SaveButton({
    super.key,
    required this.state,
    required this.cubit,
    required this.propertyId,
  });

  @override
  Widget build(BuildContext context) {
    final canSave = state.isValid && state.assignedOwners.isNotEmpty;
    final primary = context.primaryColor;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: AppRadius.circularXl,
            gradient: canSave && !state.isSyncing
                ? LinearGradient(
                    colors: [primary, primary.withValues(alpha: 0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: canSave && !state.isSyncing ? null : const Color(0xFFE2E8F0),
            boxShadow: canSave && !state.isSyncing
                ? [
                    BoxShadow(
                      color: primary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    )
                  ]
                : [],
          ),
          child: ElevatedButton(
            onPressed: (canSave && !state.isSyncing)
                ? () async {
                    if (!state.isValid) {
                      AppToast.showError(
                          context, LocaleKeys.propertyOwnersValidationError.tr());
                      return;
                    }
                    await cubit.syncOwners(propertyId);
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.circularXl),
            ),
            child: state.isSyncing
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                        strokeWidth: 3, color: Colors.white),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle_rounded, size: 20, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        LocaleKeys.propertyOwnersSaveBtn.tr(),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 0.5),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
