import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/di/service_locator.dart';
import '../cubit/unit_details/unit_details_cubit.dart';
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
    return BlocProvider(
      create: (context) =>
          sl<UnitDetailsCubit>()..fetchUnitDetails(propertyId, unitId),
      child: const UnitDetailsView(),
    );
  }
}
