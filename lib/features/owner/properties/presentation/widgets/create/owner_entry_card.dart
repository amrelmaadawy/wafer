import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../domain/entities/property_owner_entity.dart';
import '../../cubit/create/property_create_cubit.dart';

class OwnerEntryCard extends StatefulWidget {
  final PropertyOwnerEntity owner;
  final PropertyCreateCubit cubit;

  const OwnerEntryCard({
    super.key,
    required this.owner,
    required this.cubit,
  });

  @override
  State<OwnerEntryCard> createState() => _OwnerEntryCardState();
}

class _OwnerEntryCardState extends State<OwnerEntryCard> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.owner.percentage.toStringAsFixed(
          widget.owner.percentage % 1 == 0 ? 0 : 1),
    );
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _controller.text.length,
        );
      }
    });
  }

  @override
  void didUpdateWidget(OwnerEntryCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newVal = widget.owner.percentage.toStringAsFixed(
        widget.owner.percentage % 1 == 0 ? 0 : 1);
    if (_controller.text != newVal) {
      _controller.text = newVal;
      _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length));
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = context.primaryColor;
    final isRep = widget.owner.isRepresentative;
    final isDefaultOwner = widget.owner.id == widget.cubit.state.formData?.defaults.defaultOwnerId;

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
          borderRadius: BorderRadius.circular(14.5),
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
                            widget.owner.name.isNotEmpty
                                ? widget.owner.name[0]
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
                              widget.owner.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimaryLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => widget.cubit.setRepresentative(widget.owner.id),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isRep
                                    ? const Color(0xFFF59E0B).withValues(alpha: 0.15)
                                    : const Color(0xFFF1F5F9),
                                borderRadius: AppRadius.circularMd,
                                border: Border.all(
                                  color: isRep ? const Color(0xFFF59E0B).withValues(alpha: 0.3) : Colors.transparent,
                                ),
                              ),
                              child: Icon(
                                isRep ? Icons.star_rounded : Icons.star_outline_rounded,
                                color: isRep ? const Color(0xFFF59E0B) : AppColors.textSecondaryLight,
                                size: 20,
                              ),
                            ),
                          ),
                          if (!isDefaultOwner) const SizedBox(width: 10),
                          if (!isDefaultOwner)
                            GestureDetector(
                              onTap: () => widget.cubit.removeOwner(widget.owner.id),
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
                              value: widget.owner.percentage.toDouble().clamp(0.0, 100.0),
                              min: 0,
                              max: 100,
                              divisions: 200,
                              onChanged: (val) {
                                widget.cubit.updateOwnerPercentage(
                                  widget.owner.id,
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
                          focusNode: _focusNode,
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
                              widget.cubit.updateOwnerPercentage(widget.owner.id, parsed);
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
