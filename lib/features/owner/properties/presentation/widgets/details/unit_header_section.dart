import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wafer/core/theme/app_colors.dart';
import 'package:wafer/core/theme/app_radius.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../../../../core/theme/state_color_utils.dart';
import '../../../domain/entities/unit_full_details_entity.dart';
import '../../cubit/delete_unit/unit_delete_cubit.dart';
import 'unit_delete_confirmation_sheet.dart';

class UnitHeaderSection extends StatefulWidget {
  final UnitFullDetailsEntity unit;
  final int propertyId;

  const UnitHeaderSection({super.key, required this.unit, required this.propertyId});

  @override
  State<UnitHeaderSection> createState() => _UnitHeaderSectionState();
}

class _UnitHeaderSectionState extends State<UnitHeaderSection> {
  int _currentIndex = 0;
  late PageController _pageController;
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    if (widget.unit.images.length > 1) {
      _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
        if (_pageController.hasClients) {
          int nextPage = _currentIndex + 1;
          if (nextPage >= widget.unit.images.length) {
            nextPage = 0;
          }
          _pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool hasImages = widget.unit.images.isNotEmpty;

    return SliverAppBar(
      expandedHeight: hasImages ? 280.0 : 220.0,
      pinned: true,
      backgroundColor: context.primaryColor,
      leadingWidth: 64,
      leading: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: IconButton(
            icon: Icon(
              context.locale.languageCode == 'ar'
                  ? Icons.arrow_forward_ios_rounded
                  : Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: Colors.white,
            ),
            onPressed: () => context.pop(),
            constraints: const BoxConstraints.tightFor(width: 40, height: 40),
            padding: EdgeInsets.zero,
          ),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: IconButton(
            icon: const Icon(Icons.edit_rounded, size: 18, color: Colors.white),
            constraints: const BoxConstraints.tightFor(width: 40, height: 40),
            padding: EdgeInsets.zero,
            onPressed: () {
              context.push(
                '/owner-unit-edit?propertyId=${widget.propertyId}&unitId=${widget.unit.id}',
              );
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.8),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: IconButton(
            icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.white),
            constraints: const BoxConstraints.tightFor(width: 40, height: 40),
            padding: EdgeInsets.zero,
            onPressed: () {
              UnitDeleteConfirmationSheet.show(
                context,
                widget.unit.id,
                context.read<UnitDeleteCubit>(),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
      ],
      flexibleSpace: FlexibleSpaceBar(background: _buildBackground(context)),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(20),
        child: Container(
          height: 20,
          decoration: const BoxDecoration(
            color: AppColors.surfaceSubtleLight,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackground(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. Background (Images or Fallback)
        if (widget.unit.images.isNotEmpty) ...[
          PageView.builder(
            controller: _pageController,
            itemCount: widget.unit.images.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                imageUrl: widget.unit.images[index],
                fit: BoxFit.cover,
                memCacheWidth: 600, // Helps with memory and decoding speed
                errorWidget: (context, url, error) => const Center(
                  child: Icon(Icons.broken_image_rounded, color: Colors.white54, size: 48),
                ),
                placeholder: (context, url) => _buildImageSkeleton(),
              );
            },
          ),
          IgnorePointer(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black54, Colors.transparent, Colors.black87],
                  stops: [0.0, 0.4, 1.0],
                ),
              ),
            ),
          ),
        ] else
          _buildFallbackBackground(context),

        // 2. Dots Indicator (Only if multiple images)
        if (widget.unit.images.length > 1)
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.unit.images.length,
                (index) => GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentIndex == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentIndex == index
                          ? context.primaryColor
                          : Colors.white.withValues(alpha: 0.5),
                      borderRadius: AppRadius.circularSm,
                    ),
                  ),
                ),
              ),
            ),
          ),

        // 3. Content Overlay (Title, Badges, etc.)
        _buildContentOverlay(context),
      ],
    );
  }

  Widget _buildImageSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        color: Colors.white,
      ),
    );
  }

  Widget _buildFallbackBackground(BuildContext context) {
    final primary = context.primaryColor;

    return Container(
      decoration: BoxDecoration(
        color: primary,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primary,
            Color.alphaBlend(Colors.black.withValues(alpha: 0.25), primary),
          ],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background decorative watermark icons
          Positioned(
            left: -30,
            bottom: -20,
            child: Icon(
              Icons.apartment_rounded,
              size: 180,
              color: Colors.white.withValues(alpha: 0.06),
            ),
          ),
          Positioned(
            right: 20,
            top: 20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.03),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentOverlay(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                // Title + Icon Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: AppRadius.circularXl,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.20),
                        ),
                      ),
                      child: const Icon(
                        Icons.meeting_room_rounded,
                        size: 28,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.unit.name ??
                                LocaleKeys.dashboard_unit_prefix.tr(
                                  args: [widget.unit.unitNumber],
                                ),
                            style: AppTextStyles.h1.copyWith(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: AppFonts.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _buildSubtitle(),
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Info Badges Wrap (Status, Code, Area, Floor, Furnished)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _buildStatusBadge(context),
                    if (widget.unit.code != null && widget.unit.code!.isNotEmpty)
                      _buildGlassChip(
                        icon: Icons.tag_rounded,
                        label: widget.unit.code!,
                      ),
                    if (widget.unit.area != null && widget.unit.area! > 0)
                      _buildGlassChip(
                        icon: Icons.square_foot_rounded,
                        label:
                            LocaleKeys.commonAreaM2.tr(args: [widget.unit.area!.toStringAsFixed(0)]),
                      ),
                    if (widget.unit.floor != null && widget.unit.floor!.isNotEmpty)
                      _buildGlassChip(
                        icon: Icons.layers_rounded,
                        label: LocaleKeys.unitDetailsFloorPrefix.tr(
                          args: [widget.unit.floor!],
                        ),
                      ),
                    if (widget.unit.isFurnished)
                      _buildGlassChip(
                        icon: Icons.chair_rounded,
                        label: LocaleKeys.unit_details_furnished.tr(),
                        color: Colors.amber.shade300,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _buildSubtitle() {
    final parts = <String>[];
    if (widget.unit.typeLabel != null || widget.unit.type != null) {
      parts.add(widget.unit.typeLabel ?? widget.unit.type!);
    }
    if (widget.unit.usageType != null) {
      switch (widget.unit.usageType!.toLowerCase()) {
        case 'residential':
          parts.add(LocaleKeys.unitDetailsUsageResidential.tr());
          break;
        case 'commercial':
          parts.add(LocaleKeys.unitDetailsUsageCommercial.tr());
          break;
        case 'administrative':
          parts.add(LocaleKeys.unitDetailsUsageAdministrative.tr());
          break;
        default:
          parts.add(widget.unit.usageType!);
      }
    }
    return parts.join(' • ');
  }

  Widget _buildGlassChip({
    required IconData icon,
    required String label,
    Color? color,
  }) {
    final chipColor = color ?? Colors.white;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: AppRadius.circularLg,
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: chipColor),
          const SizedBox(width: 5),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: chipColor,
              fontWeight: AppFonts.medium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    Color badgeColor = StateColorUtils.getStatusColor(widget.unit.status);
    String statusText = widget.unit.statusLabel?.isNotEmpty == true
        ? widget.unit.statusLabel!
        : (widget.unit.status.isNotEmpty ? widget.unit.status : LocaleKeys.dashboardVacant.tr());

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.circularLg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: badgeColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            statusText,
            style: AppTextStyles.labelSmall.copyWith(
              color: badgeColor,
              fontWeight: AppFonts.bold,
            ),
          ),
        ],
      ),
    );
  }
}


