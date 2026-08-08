import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/di/service_locator.dart';
import '../cubit/unit_details/unit_details_cubit.dart';
import '../cubit/delete_unit/unit_delete_cubit.dart';
import '../views/unit_details_view.dart';

class UnitDetailsScreen extends StatelessWidget {
  final int propertyId;
  final int unitId;

  const UnitDetailsScreen({
    super.key,
    required this.propertyId,
    required this.unitId,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              sl<UnitDetailsCubit>()..fetchUnitDetails(propertyId, unitId),
        ),
        BlocProvider(
          create: (context) => sl<UnitDeleteCubit>(),
        ),
      ],
      child: const UnitDetailsView(),
    );
  }
}
