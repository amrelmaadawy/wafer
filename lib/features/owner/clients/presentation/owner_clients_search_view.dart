import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/presentation/widgets/app_search.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../../core/presentation/widgets/custom_empty_widget.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../core/theme/app_spacing.dart';
import 'cubit/search/search_owner_clients_cubit.dart';
import 'cubit/search/search_owner_clients_state.dart';
import 'widgets/owner_client_card.dart';

class OwnerClientsSearchView extends StatelessWidget {
  const OwnerClientsSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: LocaleKeys.searchClientsHint.tr(),
        showBackButton: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: AppSearch(
              hintLocaleKey: LocaleKeys.searchClientsHint,
              autofocus: true,
              debounceDuration: const Duration(milliseconds: 500),
              onChanged: (query) {
                context.read<SearchOwnerClientsCubit>().search(query);
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<SearchOwnerClientsCubit, SearchOwnerClientsState>(
              builder: (context, state) {
                if (state is SearchOwnerClientsInitial) {
                  return const SizedBox.shrink();
                }

                if (state is SearchOwnerClientsLoading) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }

                if (state is SearchOwnerClientsError) {
                  return CustomErrorWidget(
                    message: state.message,
                    onRetry: () => context.read<SearchOwnerClientsCubit>().retry(),
                  );
                }

                if (state is SearchOwnerClientsLoaded) {
                  if (state.clients.isEmpty) {
                    return CustomEmptyWidget(
                      title: LocaleKeys.searchClientsNoResults.tr(),
                      icon: Icons.search_off_rounded,
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    itemCount: state.clients.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, index) {
                      return OwnerClientCard(client: state.clients[index]);
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
