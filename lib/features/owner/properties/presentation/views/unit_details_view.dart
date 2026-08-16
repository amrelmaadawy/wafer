import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../cubit/unit_details/unit_details_cubit.dart';
import '../cubit/unit_details/unit_details_state.dart';
import '../widgets/details/unit_details_skeleton.dart';
import '../widgets/details/unit_details_sliver_app_bar.dart';
import '../widgets/unit_details/unit_overview_tab.dart';
import '../widgets/unit_details/unit_tenant_tab.dart';
import '../widgets/unit_details/unit_contract_tab.dart';
import '../widgets/unit_details/unit_payments_tab.dart';
import '../widgets/unit_details/unit_maintenance_tab.dart';
import '../widgets/unit_details/unit_documents_tab.dart';
import '../widgets/unit_details/unit_activity_tab.dart';

class UnitDetailsView extends StatefulWidget {
  const UnitDetailsView({super.key});

  @override
  State<UnitDetailsView> createState() => _UnitDetailsViewState();
}

class _UnitDetailsViewState extends State<UnitDetailsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: BlocBuilder<UnitDetailsCubit, UnitDetailsState>(
        buildWhen: (previous, current) {
          if (previous is! UnitDetailsLoaded || current is! UnitDetailsLoaded) {
            return true;
          }
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
          if (state is! UnitDetailsLoaded) return const SizedBox.shrink();

          final unit = state.unit;
          final propertyId = state.propertyId;

          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                UnitDetailsSliverAppBar(
                  unit: unit,
                  propertyId: propertyId,
                  tabController: _tabController,
                ),
              ];
            },
            body: Container(
              color: AppColors.backgroundLight,
              child: TabBarView(
                controller: _tabController,
                children: [
                  UnitOverviewTab(unit: unit),
                  UnitTenantTab(unit: unit),
                  UnitContractTab(unit: unit),
                  UnitPaymentsTab(unitId: unit.id),
                  UnitMaintenanceTab(
                    maintenanceRequests: unit.maintenanceRequests,
                  ),
                  UnitDocumentsTab(unit: unit),
                  const UnitActivityTab(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
