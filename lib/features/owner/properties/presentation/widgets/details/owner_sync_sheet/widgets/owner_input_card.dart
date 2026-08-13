import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../../../core/localization/locale_keys.dart';
import '../../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../../core/theme/app_radius.dart';
import '../../../../../../../../core/theme/color_utils.dart';

import '../../../../cubit/owners/sync_owners_cubit.dart';
import '../../../../cubit/owners/sync_owners_state.dart';

class OwnerEntryCard extends StatefulWidget {
  final DraftOwnerEntry entry;
  final SyncOwnersCubit cubit;

  const OwnerEntryCard({super.key, required this.entry, required this.cubit});

  @override
  State<OwnerEntryCard> createState() => _OwnerEntryCardState();
}

class _OwnerEntryCardState extends State<OwnerEntryCard> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.entry.percentage.toStringAsFixed(
        widget.entry.percentage % 1 == 0 ? 0 : 1,
      ),
    );
  }

  @override
  void didUpdateWidget(OwnerEntryCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newVal = widget.entry.percentage.toStringAsFixed(
      widget.entry.percentage % 1 == 0 ? 0 : 1,
    );
    if (_controller.text != newVal) {
      _controller.text = newVal;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
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
              : AppColors.dividerSubtleLight,
          width: isRep ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isRep
                ? primary.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.02),
            blurRadius: isRep ? 16 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(14.5)),
        child: Stack(
          children: [
            if (isRep)
              Positioned.directional(
                textDirection: Directionality.of(context),
                start: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
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
                      const Icon(
                        Icons.star_rounded,
                        size: 14,
                        color: Colors.white,
                      ),
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
                  if (isRep) const SizedBox(height: 12),
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
                              primary.withValues(alpha: 0.5),
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
                                : 'Ù…',
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
                                  Icon(
                                    Icons.phone_rounded,
                                    size: 12,
                                    color: AppColors.textSecondaryLight,
                                  ),
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
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => widget.cubit.setRepresentative(
                              widget.entry.owner.id,
                            ),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isRep
                                    ? const Color(
                                        0xFFF59E0B,
                                      ).withValues(alpha: 0.15)
                                    : AppColors.dividerSubtleLight,
                                borderRadius: AppRadius.circularMd,
                                border: Border.all(
                                  color: isRep
                                      ? const Color(
                                          0xFFF59E0B,
                                        ).withValues(alpha: 0.3)
                                      : Colors.transparent,
                                ),
                              ),
                              child: Icon(
                                isRep
                                    ? Icons.star_rounded
                                    : Icons.star_outline_rounded,
                                color: isRep
                                    ? AppColors.warning
                                    : AppColors.textSecondaryLight,
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () =>
                                widget.cubit.removeOwner(widget.entry.owner.id),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFFEF4444,
                                ).withValues(alpha: 0.1),
                                borderRadius: AppRadius.circularMd,
                                border: Border.all(
                                  color: const Color(
                                    0xFFEF4444,
                                  ).withValues(alpha: 0.2),
                                ),
                              ),
                              child: const Icon(
                                Icons.delete_outline_rounded,
                                color: AppColors.error,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 6,
                              activeTrackColor: primary,
                              inactiveTrackColor: AppColors.borderLight,
                              thumbColor: Colors.white,
                              overlayColor: primary.withValues(alpha: 0.2),
                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 10,
                                elevation: 4,
                                pressedElevation: 8,
                              ),
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
                          border: Border.all(
                            color: primary.withValues(alpha: 0.1),
                          ),
                        ),
                        child: TextFormField(
                          controller: _controller,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          textAlign: TextAlign.center,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*'),
                            ),
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
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 12,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                          onChanged: (val) {
                            final parsed = double.tryParse(val);
                            if (parsed != null) {
                              widget.cubit.updatePercentage(
                                widget.entry.owner.id,
                                parsed,
                              );
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
      ),
    );
  }
}

