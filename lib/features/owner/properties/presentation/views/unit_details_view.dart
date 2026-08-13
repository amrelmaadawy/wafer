import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wafer/core/localization/locale_keys.dart';
import 'package:wafer/core/theme/app_colors.dart';
import 'package:wafer/core/theme/app_radius.dart';
import '../../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../cubit/unit_details/unit_details_cubit.dart';
import '../cubit/unit_details/unit_details_state.dart';
import '../widgets/details/unit_header_section.dart';
import '../widgets/details/unit_basic_info_card.dart';
import '../widgets/details/unit_prices_section.dart';
import '../widgets/details/unit_specs_grid.dart';
import '../widgets/details/unit_dimensions_card.dart';
import '../widgets/details/unit_meters_section.dart';
import '../widgets/details/unit_amenities_section.dart';
import '../widgets/details/unit_media_section.dart';
import '../widgets/details/unit_maintenance_section.dart';
import '../widgets/details/unit_details_skeleton.dart';

class UnitDetailsView extends StatelessWidget {
  const UnitDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceSubtleLight,
      body: BlocBuilder<UnitDetailsCubit, UnitDetailsState>(
        buildWhen: (previous, current) {
          if (previous is! UnitDetailsLoaded || current is! UnitDetailsLoaded) return true;
          return previous.unit != current.unit;
        },
        builder: (context, state) {
          if (state is UnitDetailsLoading || state is UnitDetailsInitial) {
            return const UnitDetailsSkeleton();
          }
          if (state is UnitDetailsError) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: () => context.read<UnitDetailsCubit>().retryFetch(),
            );
          }
          if (state is UnitDetailsLoaded) {
            final unit = state.unit;
            final propertyId = state.propertyId;

            final hasMeters =
                unit.meters.electricity != null ||
                unit.meters.water != null ||
                unit.meters.gas != null;

            return CustomScrollView(
              slivers: [
                UnitHeaderSection(unit: unit, propertyId: propertyId),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // â”€â”€ Basic info (code, type, usage, floor, desc) â”€â”€
                      UnitBasicInfoCard(unit: unit),

                      // â”€â”€ Active contract banner â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                      if (unit.currentContract != null) ...[
                        const SizedBox(height: 20),
                        _ContractBanner(contract: unit.currentContract),
                      ],

                      // â”€â”€ Prices â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                      const SizedBox(height: 28),
                      UnitPricesSection(unit: unit),

                      // â”€â”€ Specs â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                      const SizedBox(height: 28),
                      UnitSpecsGrid(unit: unit),

                      // â”€â”€ Dimensions â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                      const SizedBox(height: 28),
                      UnitDimensionsCard(unit: unit),

                      // â”€â”€ Meters â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                      if (hasMeters) ...[
                        const SizedBox(height: 28),
                        UnitMetersSection(unit: unit),
                      ],

                      // â”€â”€ Amenities â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                      if (unit.amenities.isNotEmpty) ...[
                        const SizedBox(height: 28),
                        UnitAmenitiesSection(unit: unit),
                      ],
                      
                      // â”€â”€ Media â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                      if (unit.videos.isNotEmpty || unit.attachments.isNotEmpty) ...[
                        const SizedBox(height: 28),
                        UnitMediaSection(unit: unit),
                      ],

                      // â”€â”€ Maintenance Requests â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                      if (unit.maintenanceRequests.isNotEmpty) ...[
                        const SizedBox(height: 28),
                        UnitMaintenanceSection(unit: unit),
                      ],
                    ]),
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// â”€â”€ Active Contract Banner â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _ContractBanner extends StatelessWidget {
  final dynamic contract;
  const _ContractBanner({required this.contract});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> c = contract as Map<String, dynamic>;
    final tenantName = c['tenant']?['name'] as String? ?? '-';
    final startDate = c['start_date'] as String? ?? '';
    final endDate = c['end_date'] as String? ?? '';
    final statusLabel =
        c['status_label'] as String? ?? c['status'] as String? ?? '';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.primaryColor,
            context.primaryColor.withValues(alpha: 0.80),
          ],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ),
        borderRadius: AppRadius.circularXxl,
        boxShadow: [
          BoxShadow(
            color: context.primaryShadow.withValues(alpha: 0.30),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.description_outlined,
                color: Colors.white70,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                LocaleKeys.owner_active_contracts_sub.tr(),
                style: AppTextStyles.labelMedium.copyWith(
                  color: Colors.white70,
                ),
              ),
              const Spacer(),
              if (statusLabel.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.20),
                    borderRadius: AppRadius.circularXxl,
                  ),
                  child: Text(
                    statusLabel,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            tenantName,
            style: AppTextStyles.h4.copyWith(color: Colors.white),
          ),
          if (startDate.isNotEmpty && endDate.isNotEmpty) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.white60,
                  size: 13,
                ),
                const SizedBox(width: 6),
                Text(
                  '$startDate  â†’  $endDate',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: Colors.white70,
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


