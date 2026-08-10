import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/theme/app_colors.dart';
import '../cubit/list/owner_contracts_cubit.dart';

class OwnerLeasesView extends StatefulWidget {
  const OwnerLeasesView({super.key});

  @override
  State<OwnerLeasesView> createState() => _OwnerLeasesViewState();
}

class _OwnerLeasesViewState extends State<OwnerLeasesView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   context.read<OwnerContractsCubit>().getContracts();
    // });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<OwnerContractsCubit>().loadNextPage();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.construction_rounded,
                size: 80,
                color: AppColors.textSecondaryLight.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 24),
              Text(
                'feature_coming_soon'.tr(),
                style: const TextStyle(
                  color: AppColors.textSecondaryLight,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
