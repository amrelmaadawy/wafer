import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../../../../core/utils/widgets/app_toast.dart';
import '../../../../../../core/utils/widgets/app_shimmer.dart';
import '../../../domain/entities/form_owner_entity.dart';
import '../../cubit/owners/sync_owners_cubit.dart';
import '../../cubit/owners/sync_owners_state.dart';

class OwnerSyncSheet extends StatelessWidget {
  final int propertyId;
  final VoidCallback onSuccess;

  const OwnerSyncSheet({
    super.key,
    required this.propertyId,
    required this.onSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SyncOwnersCubit, SyncOwnersState>(
      listener: (context, state) {
        if (state.isSuccess) {
          Navigator.of(context).pop();
          onSuccess();
          AppToast.showSuccess(context, LocaleKeys.propertyOwnersSuccessMsg.tr());
        }
        if (state.errorMessage != null) {
          AppToast.showError(context, state.errorMessage!);
        }
      },
      builder: (context, state) {
        return _SheetBody(propertyId: propertyId, state: state);
      },
    );
  }
}

class _SheetBody extends StatelessWidget {
  final int propertyId;
  final SyncOwnersState state;

  const _SheetBody({required this.propertyId, required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SyncOwnersCubit>();
    final primary = context.primaryColor;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC), // Softer background
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Premium Header with Gradient Background
          Container(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, const Color(0xFFF8FAFC)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Drag Handle
                Center(
                  child: Container(
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: AppRadius.circularFull,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [primary.withValues(alpha: 0.2), primary.withValues(alpha: 0.05)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: AppRadius.circularLg,
                        border: Border.all(color: primary.withValues(alpha: 0.1)),
                      ),
                      child: Icon(Icons.people_alt_rounded, color: primary, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocaleKeys.propertyOwnersSheetTitle.tr(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimaryLight,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "قم بتوزيع الحصص وتحديد الممثل القانوني",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded, size: 20, color: AppColors.textPrimaryLight),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Total Percentage Bar integrated into header
                _PercentageBar(state: state),
              ],
            ),
          ),
          // Scrollable content
          Flexible(
            child: state.isLoading
                ? _buildShimmerLoading()
                : ListView(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      // Owner Selector
                      _AddOwnerDropdown(state: state, cubit: cubit),
                      const SizedBox(height: 20),
                      // Auto-distribute button
                      if (state.assignedOwners.isNotEmpty)
                        _AutoDistributeButton(cubit: cubit),
                      const SizedBox(height: 16),
                      // Assigned Owners List
                      if (state.assignedOwners.isEmpty)
                        _EmptyOwners()
                      else
                        ...state.assignedOwners.map(
                          (e) => _OwnerEntryCard(entry: e, cubit: cubit),
                        ),
                      const SizedBox(height: 100),
                    ],
                  ),
          ),
          // Save Button
          _SaveButton(state: state, cubit: cubit, propertyId: propertyId),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      itemCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppRadius.circularXl,
            border: Border.all(color: const Color(0xFFF1F5F9)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AppShimmer.circle(size: 48),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppShimmer.box(height: 16, width: 140),
                        const SizedBox(height: 10),
                        AppShimmer.box(height: 12, width: 90),
                      ],
                    ),
                  ),
                  AppShimmer.box(height: 32, width: 32, borderRadius: AppRadius.circularMd),
                  const SizedBox(width: 10),
                  AppShimmer.box(height: 32, width: 32, borderRadius: AppRadius.circularMd),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: AppShimmer.box(height: 12, borderRadius: AppRadius.circularFull)),
                  const SizedBox(width: 20),
                  AppShimmer.box(height: 44, width: 80, borderRadius: AppRadius.circularLg),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PercentageBar extends StatelessWidget {
  final SyncOwnersState state;
  const _PercentageBar({required this.state});

  @override
  Widget build(BuildContext context) {
    final total = state.totalPercentage;
    final isValid = state.isValid;
    final primary = context.primaryColor;
    
    final barColor = isValid
        ? const Color(0xFF10B981) // Vibrant Emerald
        : total > 100
            ? const Color(0xFFEF4444) // Vibrant Red
            : total >= 50
                ? const Color(0xFFF59E0B) // Vibrant Amber
                : primary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.circularXl,
        border: Border.all(color: const Color(0xFFE2E8F0).withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: barColor.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.propertyOwnersTotalPercentage.tr(),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondaryLight,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: barColor.withValues(alpha: 0.1),
                  borderRadius: AppRadius.circularFull,
                ),
                child: Text(
                  '${total.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: barColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Stack(
            children: [
              Container(
                height: 10,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: AppRadius.circularFull,
                  boxShadow: const [
                    BoxShadow(color: Color(0xFFE2E8F0), blurRadius: 2),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutCubic,
                height: 10,
                width: MediaQuery.of(context).size.width * ((total / 100).clamp(0.0, 1.0)) * 0.8, // Approximation for animation width
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [barColor.withValues(alpha: 0.7), barColor],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: AppRadius.circularFull,
                  boxShadow: [
                    BoxShadow(
                      color: barColor.withValues(alpha: 0.4),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (!isValid && state.assignedOwners.isNotEmpty) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.info_outline_rounded, size: 14, color: barColor),
                const SizedBox(width: 6),
                Text(
                  LocaleKeys.propertyOwnersValidationError.tr(),
                  style: TextStyle(
                    fontSize: 12,
                    color: barColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _AddOwnerDropdown extends StatelessWidget {
  final SyncOwnersState state;
  final SyncOwnersCubit cubit;
  const _AddOwnerDropdown({required this.state, required this.cubit});

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

class _AutoDistributeButton extends StatelessWidget {
  final SyncOwnersCubit cubit;
  const _AutoDistributeButton({required this.cubit});

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

class _EmptyOwners extends StatelessWidget {
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

class _OwnerEntryCard extends StatefulWidget {
  final DraftOwnerEntry entry;
  final SyncOwnersCubit cubit;

  const _OwnerEntryCard({required this.entry, required this.cubit});

  @override
  State<_OwnerEntryCard> createState() => _OwnerEntryCardState();
}

class _OwnerEntryCardState extends State<_OwnerEntryCard> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.entry.percentage.toStringAsFixed(
          widget.entry.percentage % 1 == 0 ? 0 : 1),
    );
  }

  @override
  void didUpdateWidget(_OwnerEntryCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newVal = widget.entry.percentage.toStringAsFixed(
        widget.entry.percentage % 1 == 0 ? 0 : 1);
    if (_controller.text != newVal) {
      _controller.text = newVal;
      _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = context.primaryColor;
    final isRep = widget.entry.isRepresentative;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.circularXl,
        border: Border.all(
          color: isRep
              ? primary.withValues(alpha: 0.5)
              : const Color(0xFFF1F5F9),
          width: isRep ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isRep ? primary.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.02),
            blurRadius: isRep ? 16 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.5), // AppRadius.circularXl (16) - Border Width (1.5)
        ),
        child: Stack(
          children: [
            if (isRep)
              Positioned.directional(
                textDirection: Directionality.of(context),
                start: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primary, primary.withValues(alpha: 0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadiusDirectional.only(
                      bottomEnd: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star_rounded, size: 14, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(
                        LocaleKeys.propertyOwnersRepresentative.tr(),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isRep) const SizedBox(height: 12), // Spacing for the top badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            primary.withValues(alpha: 0.8),
                            primary.withValues(alpha: 0.5)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: primary.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          widget.entry.owner.name.isNotEmpty
                              ? widget.entry.owner.name[0]
                              : 'م',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.entry.owner.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimaryLight,
                            ),
                          ),
                          const SizedBox(height: 4),
                          if (widget.entry.owner.phone != null)
                            Row(
                              children: [
                                Icon(Icons.phone_rounded, size: 12, color: AppColors.textSecondaryLight),
                                const SizedBox(width: 4),
                                Text(
                                  widget.entry.owner.phone!,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textSecondaryLight,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    // Action Buttons (Star & Remove)
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => widget.cubit.setRepresentative(widget.entry.owner.id),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isRep
                                  ? const Color(0xFFF59E0B).withValues(alpha: 0.15) // Soft Gold
                                  : const Color(0xFFF1F5F9),
                              borderRadius: AppRadius.circularMd,
                              border: Border.all(
                                color: isRep ? const Color(0xFFF59E0B).withValues(alpha: 0.3) : Colors.transparent,
                              )
                            ),
                            child: Icon(
                              isRep ? Icons.star_rounded : Icons.star_outline_rounded,
                              color: isRep ? const Color(0xFFF59E0B) : AppColors.textSecondaryLight,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () => widget.cubit.removeOwner(widget.entry.owner.id),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                              borderRadius: AppRadius.circularMd,
                              border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.2)),
                            ),
                            child: const Icon(
                              Icons.delete_outline_rounded,
                              color: Color(0xFFEF4444),
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Premium Slider and Input
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 6,
                            activeTrackColor: primary,
                            inactiveTrackColor: const Color(0xFFE2E8F0),
                            thumbColor: Colors.white,
                            overlayColor: primary.withValues(alpha: 0.2),
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 10,
                                elevation: 4,
                                pressedElevation: 8),
                            trackShape: const RoundedRectSliderTrackShape(),
                          ),
                          child: Slider(
                            value: widget.entry.percentage.clamp(0.0, 100.0),
                            min: 0,
                            max: 100,
                            divisions: 200,
                            onChanged: (val) {
                              widget.cubit.updatePercentage(
                                widget.entry.owner.id,
                                double.parse(val.toStringAsFixed(1)),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      width: 80,
                      decoration: BoxDecoration(
                        color: primary.withValues(alpha: 0.05),
                        borderRadius: AppRadius.circularLg,
                        border: Border.all(color: primary.withValues(alpha: 0.1)),
                      ),
                      child: TextFormField(
                        controller: _controller,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                        ],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: primary,
                        ),
                        decoration: InputDecoration(
                          suffixText: '%',
                          suffixStyle: TextStyle(
                            color: primary.withValues(alpha: 0.7),
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        onChanged: (val) {
                          final parsed = double.tryParse(val);
                          if (parsed != null) {
                            widget.cubit.updatePercentage(widget.entry.owner.id, parsed);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}

class _SaveButton extends StatelessWidget {
  final SyncOwnersState state;
  final SyncOwnersCubit cubit;
  final int propertyId;

  const _SaveButton({
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
