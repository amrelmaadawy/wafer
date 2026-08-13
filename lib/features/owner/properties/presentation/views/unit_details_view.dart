import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/presentation/widgets/app_responsive_content.dart';
import '../../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../cubit/unit_details/unit_details_cubit.dart';
import '../cubit/unit_details/unit_details_state.dart';
import '../widgets/details/unit_details_content.dart';
import '../widgets/details/unit_details_skeleton.dart';
import '../widgets/details/unit_header_section.dart';

class UnitDetailsView extends StatelessWidget {
  const UnitDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

          return CustomScrollView(
            slivers: [
              UnitHeaderSection(unit: state.unit, propertyId: state.propertyId),
              SliverToBoxAdapter(
                child: AppResponsiveContent(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 40),
                    child: UnitDetailsContent(unit: state.unit),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
