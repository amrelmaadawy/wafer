import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../domain/entities/property_owner_entity.dart';
import '../../cubit/create/property_create_cubit.dart';
import '../../cubit/create/property_create_state.dart';

class Step4OwnersView extends StatelessWidget {
  const Step4OwnersView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PropertyCreateCubit, PropertyCreateState>(
      builder: (context, state) {
        final cubit = context.read<PropertyCreateCubit>();
        final double totalPercentage = state.owners.fold(0.0, (sum, o) => sum + o.percentage.toDouble());
        final is100 = (totalPercentage - 100.0).abs() < 0.01;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.propertyWizardStep4Title.tr(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'أضف الملاك وقم بتوزيع الحصص لتصل إلى 100%',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 24),
              _buildAddOwnerSection(context, state, cubit),
              const SizedBox(height: 24),
              _buildProgressBar(context, totalPercentage, is100),
              const SizedBox(height: 24),
              if (state.owners.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'الملاك المضافين (${state.owners.length})',
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                    TextButton.icon(
                      onPressed: () => cubit.autoDistributePercentages(),
                      icon: const Icon(Icons.calculate_outlined, size: 18),
                      label: Text(LocaleKeys.propertyOwnersAutoDistribute.tr()),
                      style: TextButton.styleFrom(
                        foregroundColor: context.primaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...state.owners.map((owner) => _OwnerEntryCard(owner: owner, cubit: cubit)),
              ] else
                _buildEmptyState(context),
              
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddOwnerSection(BuildContext context, PropertyCreateState state, PropertyCreateCubit cubit) {
    // Just a placeholder mock add button since the real list needs to come from an API.
    // In actual implementation, we might need a bottom sheet to search/add owners.
    // For now, we simulate adding a new owner for the wizard.
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.circularXl,
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.propertyOwnersAddOwner.tr(),
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                final availableOwners = state.formData?.options.owners ?? [];
                
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (ctx) {
                    return _OwnerSelectionSheet(
                      availableOwners: availableOwners,
                      addedOwnerIds: state.owners.map((e) => e.id).toSet(),
                      onSelect: (owner) {
                        cubit.addOwner(PropertyOwnerEntity(
                          id: owner.id,
                          name: owner.name,
                          percentage: 0,
                          isRepresentative: false,
                        ));
                      },
                    );
                  },
                );
              },
              icon: Icon(Icons.person_add_alt_1_outlined, color: context.primaryColor, size: 20),
              label: Text(
                LocaleKeys.propertyOwnersAddOwner.tr(),
                style: TextStyle(color: context.primaryColor),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: context.primaryColor.withValues(alpha: 0.3)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: AppRadius.circularLg),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context, double totalPercentage, bool is100) {
    final progressColor = is100 ? AppColors.success : context.primaryColor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              LocaleKeys.propertyOwnersTotalPercentage.tr(),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            Text(
              '${totalPercentage.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: progressColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: AppRadius.circularFull,
          child: LinearProgressIndicator(
            value: (totalPercentage / 100).clamp(0.0, 1.0),
            backgroundColor: const Color(0xFFE2E8F0),
            color: progressColor,
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(Icons.people_outline, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 12),
          Text(
            LocaleKeys.propertyOwnersNoOwners.tr(),
            style: const TextStyle(color: AppColors.textSecondaryLight),
          ),
        ],
      ),
    );
  }

}

class _OwnerEntryCard extends StatefulWidget {
  final PropertyOwnerEntity owner;
  final PropertyCreateCubit cubit;

  const _OwnerEntryCard({required this.owner, required this.cubit});

  @override
  State<_OwnerEntryCard> createState() => _OwnerEntryCardState();
}

class _OwnerEntryCardState extends State<_OwnerEntryCard> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.owner.percentage.toStringAsFixed(
          widget.owner.percentage % 1 == 0 ? 0 : 1),
    );
  }

  @override
  void didUpdateWidget(_OwnerEntryCard oldWidget) {
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
                                )
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

class _OwnerSelectionSheet extends StatefulWidget {
  final List<dynamic> availableOwners;
  final Set<int> addedOwnerIds;
  final Function(dynamic) onSelect;

  const _OwnerSelectionSheet({
    required this.availableOwners,
    required this.addedOwnerIds,
    required this.onSelect,
  });

  @override
  State<_OwnerSelectionSheet> createState() => _OwnerSelectionSheetState();
}

class _OwnerSelectionSheetState extends State<_OwnerSelectionSheet> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.availableOwners.where((o) {
      final matchesSearch = o.name.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesSearch && !widget.addedOwnerIds.contains(o.id);
    }).toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFCBD5E1),
              borderRadius: AppRadius.circularFull,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  LocaleKeys.propertyOwnersSelectOwner.tr(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimaryLight,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'ابحث عن مالك...',
                prefixIcon: const Icon(Icons.search, color: AppColors.textSecondaryLight),
                filled: true,
                fillColor: AppColors.surfaceLight,
                border: OutlineInputBorder(
                  borderRadius: AppRadius.circularMd,
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text(
                      LocaleKeys.propertyOwnersNoAvailable.tr(),
                      style: const TextStyle(color: AppColors.textSecondaryLight),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final owner = filtered[index];
                      return InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          widget.onSelect(owner);
                        },
                        borderRadius: AppRadius.circularLg,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight,
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                            borderRadius: AppRadius.circularLg,
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: context.primarySubtle,
                                child: Text(
                                  owner.name.isNotEmpty ? owner.name[0] : '?',
                                  style: TextStyle(
                                    color: context.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  owner.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Icon(Icons.add_circle_outline, color: context.primaryColor),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
