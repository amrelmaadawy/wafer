import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/di/service_locator.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../cubit/units/unit_create_cubit.dart';
import '../../cubit/units/units_list_cubit.dart';
import '../../cubit/units/units_list_state.dart';
import '../units/unit_card.dart';
import '../units/unit_create_bottom_sheet.dart';

class PropertyUnitsTab extends StatefulWidget {
  final int propertyId;
  final int unitsCount;

  const PropertyUnitsTab({
    super.key,
    required this.propertyId,
    required this.unitsCount,
  });

  @override
  State<PropertyUnitsTab> createState() => _PropertyUnitsTabState();
}

class _PropertyUnitsTabState extends State<PropertyUnitsTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UnitsListCubit>().loadUnits(widget.propertyId);
    });
  }

  void _showAddUnitSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider(
        create: (_) => sl<UnitCreateCubit>(),
        child: UnitCreateBottomSheet(
          propertyId: widget.propertyId,
          onUnitCreated: () {
            context.read<UnitsListCubit>().loadUnits(widget.propertyId);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UnitsListCubit, UnitsListState>(
      builder: (context, state) {
        if (state is UnitsListLoading || state is UnitsListInitial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UnitsListEmpty) {
          return _buildEmptyState(context);
        } else if (state is UnitsListLoaded) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => _showAddUnitSheet(context),
              backgroundColor: context.primaryColor,
              icon: const Icon(Icons.add_rounded, color: Colors.white),
              label: Text(LocaleKeys.propertyDetailsAddUnit.tr(),
                  style: const TextStyle(color: Colors.white)),
            ),
            body: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 80),
              itemCount: state.units.length,
              itemBuilder: (context, index) {
                final unit = state.units[index];
                return UnitCard(
                  unit: unit,
                  onTap: () {},
                );
              },
            ),
          );
        } else if (state is UnitsListError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: context.primarySubtle,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.meeting_room_outlined,
                size: 48,
                color: context.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              LocaleKeys.propertyDetailsNoUnitsTitle.tr(),
              style: const TextStyle(
                color: AppColors.textPrimaryLight,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              LocaleKeys.propertyDetailsNoUnitsSubtitle.tr(),
              style: const TextStyle(
                color: AppColors.textSecondaryLight,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _showAddUnitSheet(context),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: Text(LocaleKeys.propertyDetailsAddUnit.tr()),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.circularFull,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
