import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wafer/core/localization/locale_keys.dart';
import 'package:wafer/core/theme/theme_context.dart';
import '../../../../../core/di/service_locator.dart';
import '../cubit/search_cubit.dart';
import '../cubit/search_state.dart';
import '../widgets/search_input_field.dart';
import '../widgets/search_result_group.dart';
import '../widgets/search_empty_widget.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SearchCubit>(),
      child: const _SearchScreenView(),
    );
  }
}

class _SearchScreenView extends StatelessWidget {
  const _SearchScreenView();

  @override
  Widget build(BuildContext context) {
    final searchCubit = context.read<SearchCubit>();
    
    return Scaffold(
      backgroundColor: context.appBackgroundColor,
      appBar: AppBar(
        backgroundColor: context.appSurfaceColor,
        elevation: 0,
        leading: const BackButton(),
        title: SearchInputField(
          onChanged: (query) => searchCubit.onQueryChanged(query),
          onClear: () => searchCubit.clearSearch(),
        ),
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          if (state is SearchInitial) {
            return Center(
              child: Text(
                LocaleKeys.search_min_chars.tr(),
                style: TextStyle(color: context.appSecondaryTextColor),
              ),
            );
          }

          if (state is SearchLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SearchError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (state is SearchEmpty) {
            return SearchEmptyWidget(query: state.query);
          }

          if (state is SearchLoaded) {
            final results = state.results;
            return ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                SearchResultGroup(
                  title: LocaleKeys.propertiesGroup.tr(),
                  items: results.properties,
                ),
                SearchResultGroup(
                  title: LocaleKeys.contractsGroup.tr(),
                  items: results.contracts,
                ),
                SearchResultGroup(
                  title: LocaleKeys.invoicesGroup.tr(),
                  items: results.payments,
                ),
                SearchResultGroup(
                  title: LocaleKeys.receiptsGroup.tr(),
                  items: results.receipts,
                ),
                SearchResultGroup(
                  title: LocaleKeys.maintenanceGroup.tr(),
                  items: results.maintenance,
                ),
                SearchResultGroup(
                  title: 'Tasks', // TODO: Add to locale_keys
                  items: results.tasks,
                ),
                SearchResultGroup(
                  title: 'Legal Cases', // TODO: Add to locale_keys
                  items: results.legalCases,
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
