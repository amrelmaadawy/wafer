import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/presentation/widgets/app_responsive_content.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../cubit/list/owner_contracts_cubit.dart';
import '../cubit/list/owner_contracts_state.dart';
import '../../../../../core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../shell/presentation/widgets/owner_top_app_bar.dart';
import '../widgets/contracts_filter_bar.dart';
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
    return BlocBuilder<OwnerContractsCubit, OwnerContractsState>(
      builder: (context, state) {
        final totalCount = state is OwnerContractsLoaded
            ? state.meta.total
            : null;

        return Scaffold(
          appBar: OwnerTopAppBar(
            title: LocaleKeys.contractsTitle.tr(),
            subtitle: totalCount != null ? '${LocaleKeys.contractsTotalCount.tr()}: $totalCount' : null,
          ),
          body: SafeArea(
            child: Column(
              children: [
                const AppResponsiveContent(
                  child: Padding(
                    padding: EdgeInsets.only(top: AppSpacing.md),
                    child: ContractsFilterBar(),
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
            ),
          ),
        );
      },
    );
  }
}
