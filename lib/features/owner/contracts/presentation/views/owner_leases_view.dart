import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/presentation/widgets/app_responsive_content.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../cubit/list/owner_contracts_cubit.dart';
import '../cubit/list/owner_contracts_state.dart';
import '../widgets/contracts_page_header.dart';
import '../widgets/contracts_state_content.dart';

class OwnerLeasesView extends StatefulWidget {
  const OwnerLeasesView({super.key});

  @override
  State<OwnerLeasesView> createState() => _OwnerLeasesViewState();
}

class _OwnerLeasesViewState extends State<OwnerLeasesView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadNextPage);
  }

  void _loadNextPage() {
    if (_scrollController.position.extentAfter < 240) {
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
      body: SafeArea(
        child: BlocBuilder<OwnerContractsCubit, OwnerContractsState>(
          builder: (context, state) {
            final totalCount = state is OwnerContractsLoaded
                ? state.meta.total
                : null;
            return Column(
              children: [
                AppResponsiveContent(
                  child: Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.md),
                    child: ContractsPageHeader(totalCount: totalCount),
                  ),
                ),
                Expanded(
                  child: AppResponsiveContent(
                    padding: EdgeInsets.zero,
                    child: SizedBox.expand(
                      child: ContractsStateContent(
                        state: state,
                        scrollController: _scrollController,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
