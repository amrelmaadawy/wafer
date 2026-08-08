import '../../../../../core/localization/locale_keys.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:go_router/go_router.dart';
import '../../../../../core/presentation/widgets/custom_back_button.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../core/presentation/widgets/custom_empty_widget.dart';
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
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<FinanceAccountsCubit>().fetchAccounts();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      context.read<FinanceAccountsCubit>().fetchAccounts();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        context.read<FinanceAccountsCubit>().fetchAccounts(search: query, isRefresh: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        leadingWidth: 68,
        leading: const CustomBackButton(),
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textPrimaryLight,
                ),
                decoration: InputDecoration(
                  hintText: LocaleKeys.owner_finance_search_hint.tr(),
                  hintStyle: const TextStyle(
                    color: AppColors.textSecondaryLight,
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
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
                  context.read<FinanceAccountsCubit>().fetchAccounts(search: '', isRefresh: true);
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
              onRetry: () => context
                  .read<FinanceAccountsCubit>()
                  .fetchAccounts(isRefresh: true),
            );
          }

          if (state is FinanceAccountsEmpty) {
            return CustomEmptyWidget(
              title: LocaleKeys.owner_finance_no_data.tr(),
              subtitle: LocaleKeys.owner_finance_no_records_currently.tr(),
              icon: Icons.account_balance_wallet_outlined,
            );
          }

          if (state is FinanceAccountsSuccess) {
            final accounts = state.accounts;
            
            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<FinanceAccountsCubit>()
                    .fetchAccounts(isRefresh: true);
              },
              child: ListView.separated(
                controller: _scrollController,
                padding: const EdgeInsets.all(24),
                itemCount: accounts.length + (state.hasReachedMax ? 0 : 1),
                separatorBuilder: (_, _) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  if (index >= accounts.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  return FinanceAccountCard(
                    account: accounts[index],
                    onTap: () {
                      context.push(
                        Routes.ownerFinanceAccountDetails.replaceFirst(':id', accounts[index].id.toString()),
                      );
                    },
                    onEdit: () async {
                      final result = await context.push(
                        Routes.ownerFinanceAccountUpdate,
                        extra: accounts[index],
                      );
                      if (result == true && context.mounted) {
                        context.read<FinanceAccountsCubit>().fetchAccounts(isRefresh: true);
                      }
                    },
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await context.push(Routes.ownerFinanceAccountCreate);
          if (result == true && context.mounted) {
            context.read<FinanceAccountsCubit>().fetchAccounts(isRefresh: true);
          }
        },
        backgroundColor: context.primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
