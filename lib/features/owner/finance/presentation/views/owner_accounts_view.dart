import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/presentation/widgets/custom_back_button.dart';
import '../../../../../core/presentation/widgets/custom_empty_widget.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../core/presentation/widgets/list/paginated_list_view.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../domain/entities/finance_account_entity.dart';
import '../cubit/accounts/finance_accounts_cubit.dart';
import '../cubit/accounts/finance_accounts_state.dart';
import '../widgets/finance_account_card.dart';
import '../widgets/finance_accounts_skeleton.dart';

class OwnerAccountsView extends StatefulWidget {
  const OwnerAccountsView({super.key});

  @override
  State<OwnerAccountsView> createState() => _OwnerAccountsViewState();
}

class _OwnerAccountsViewState extends State<OwnerAccountsView> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    context.read<FinanceAccountsCubit>().fetchAccounts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        final cubit = context.read<FinanceAccountsCubit>();
        cubit.fetchAccounts(
          query: cubit.currentQuery.copyWith(search: query),
          isRefresh: true,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<FinanceAccountsCubit>();

    return Scaffold(
      backgroundColor: context.appBackgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        leadingWidth: 68,
        leading: const CustomBackButton(),
        backgroundColor: context.appBackgroundColor,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: context.appOnSurfaceColor,
                ),
                decoration: InputDecoration(
                  hintText: LocaleKeys.owner_finance_search_hint.tr(),
                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                    color: context.appSecondaryTextColor,
                  ),
                  border: InputBorder.none,
                ),
                onChanged: _onSearchChanged,
              )
            : Text(LocaleKeys.owner_finance_financial_accounts.tr()),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  cubit.fetchAccounts(
                    query: cubit.currentQuery.copyWith(search: ''),
                    isRefresh: true,
                  );
                }
              });
            },
          ),
        ],
      ),
      body: BlocBuilder<FinanceAccountsCubit, FinanceAccountsState>(
        builder: (context, state) {
          if (state is FinanceAccountsInitial ||
              (state is FinanceAccountsLoading && _searchController.text.isEmpty)) {
            return const FinanceAccountsSkeleton();
          }

          if (state is FinanceAccountsError) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: () => cubit.fetchAccounts(isRefresh: true),
            );
          }

          final accounts = state is FinanceAccountsSuccess
              ? state.accounts
              : <FinanceAccountEntity>[];
          final hasReachedMax =
              state is FinanceAccountsSuccess ? state.hasReachedMax : true;

          return PaginatedListView<FinanceAccountEntity>(
            items: accounts,
            hasReachedMax: hasReachedMax,
            useStaggeredAnimation: true,
            onRefresh: () => cubit.fetchAccounts(isRefresh: true),
            onLoadMore: () => cubit.fetchAccounts(),
            padding: const EdgeInsets.all(AppSpacing.lg),
            emptyWidget: CustomEmptyWidget(
              title: LocaleKeys.owner_finance_no_data.tr(),
              subtitle: LocaleKeys.owner_finance_no_records_currently.tr(),
              icon: Icons.account_balance_wallet_outlined,
            ),
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index, account) {
              return FinanceAccountCard(
                account: account,
                onTap: () => context.push(
                  Routes.ownerFinanceAccountDetails.replaceFirst(
                    ':id',
                    account.id.toString(),
                  ),
                ),
                onEdit: () async {
                  final result = await context.push(
                    Routes.ownerFinanceAccountUpdate,
                    extra: account,
                  );
                  if (result == true && context.mounted) {
                    cubit.fetchAccounts(isRefresh: true);
                  }
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await context.push(Routes.ownerFinanceAccountCreate);
          if (result == true && context.mounted) {
            cubit.fetchAccounts(isRefresh: true);
          }
        },
        backgroundColor: context.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
