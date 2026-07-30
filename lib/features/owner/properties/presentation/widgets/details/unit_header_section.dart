import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../domain/entities/unit_full_details_entity.dart';

class UnitHeaderSection extends StatelessWidget {
  final UnitFullDetailsEntity unit;

  const UnitHeaderSection({super.key, required this.unit});

  @override
  Widget build(BuildContext context) {
    final bool hasImages = unit.images.isNotEmpty;

    return SliverAppBar(
      expandedHeight: hasImages ? 280.0 : 220.0,
      pinned: true,
      backgroundColor: context.primaryColor,
      flexibleSpace: FlexibleSpaceBar(background: _buildBackground(context)),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(20),
        child: Container(
          height: 20,
          decoration: const BoxDecoration(
            color: Color(0xFFF8FAFC),
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
    if (unit.images.isNotEmpty) {
      return Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            itemCount: unit.images.length,
            itemBuilder: (context, index) {
              return Image.network(
                unit.images[index],
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _buildFallbackHeader(context),
              );
            },
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black54, Colors.transparent, Colors.black87],
                stops: [0.0, 0.4, 1.0],
              ),
            ),
          ),
        ],
      );
    }
    return _buildFallbackHeader(context);
  }

  Widget _buildFallbackHeader(BuildContext context) {
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
          // Main content
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
                          borderRadius: BorderRadius.circular(16),
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
                              unit.name ??
                                  LocaleKeys.dashboard_unit_prefix.tr(
                                    args: [unit.unitNumber],
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
                      if (unit.code != null && unit.code!.isNotEmpty)
                        _buildGlassChip(
                          icon: Icons.tag_rounded,
                          label: unit.code!,
                        ),
                      if (unit.area != null && unit.area! > 0)
                        _buildGlassChip(
                          icon: Icons.square_foot_rounded,
                          label:
                              '${unit.area!.toStringAsFixed(0)} ${LocaleKeys.commonAreaM2.tr()}',
                        ),
                      if (unit.floor != null && unit.floor!.isNotEmpty)
                        _buildGlassChip(
                          icon: Icons.layers_rounded,
                          label: LocaleKeys.unitDetailsFloorPrefix.tr(
                            args: [unit.floor!],
                          ),
                        ),
                      if (unit.isFurnished)
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
      ),
    );
  }

  String _buildSubtitle() {
    final parts = <String>[];
    if (unit.typeLabel != null || unit.type != null) {
      parts.add(unit.typeLabel ?? unit.type!);
    }
    if (unit.usageType != null) {
      switch (unit.usageType!.toLowerCase()) {
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
          parts.add(unit.usageType!);
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
        borderRadius: BorderRadius.circular(12),
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
    Color badgeColor;
    String statusText;

    switch (unit.status.toLowerCase()) {
      case 'available':
      case 'vacant':
        badgeColor = const Color(0xFF10B981);
        statusText = LocaleKeys.unitDetailsStatusAvailable.tr();
        break;
      case 'rented':
      case 'occupied':
        badgeColor = const Color(0xFF3B82F6);
        statusText = LocaleKeys.unitDetailsStatusRented.tr();
        break;
      case 'reserved':
        badgeColor = const Color(0xFFF59E0B);
        statusText = LocaleKeys.unitDetailsStatusReserved.tr();
        break;
      case 'under_maintenance':
      case 'maintenance':
        badgeColor = const Color(0xFFEF4444);
        statusText = LocaleKeys.unitDetailsStatusMaintenance.tr();
        break;
      default:
        badgeColor = Colors.grey;
        statusText = unit.statusLabel ?? unit.status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
