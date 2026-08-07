import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../core/routing/app_router.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/color_utils.dart';
import '../cubit/transfers/transfers_cubit.dart';
import '../widgets/finance_transfer_card.dart';
import '../widgets/finance_payments_skeleton.dart'; // Using generic list skeleton for now

class OwnerTransfersView extends StatefulWidget {
  const OwnerTransfersView({super.key});

  @override
  State<OwnerTransfersView> createState() => _OwnerTransfersViewState();
}

class _OwnerTransfersViewState extends State<OwnerTransfersView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<TransfersCubit>().fetchTransfers(forceRefresh: true);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<TransfersCubit>().fetchTransfers();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await context.read<TransfersCubit>().fetchTransfers(forceRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: CustomAppBar(
        title: LocaleKeys.owner_finance_internal_transfers.tr(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(Routes.ownerFinanceCreateTransfer).then((value) {
            if (value == true) {
              _onRefresh();
            }
          });
        },
        backgroundColor: context.primaryColor,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: context.primaryColor,
        child: BlocBuilder<TransfersCubit, TransfersState>(
          builder: (context, state) {
            if (state is TransfersLoading) {
              return const FinancePaymentsSkeleton();
            }

            if (state is TransfersError && state.transfers.isEmpty) {
              return CustomErrorWidget(
                message: state.message,
                onRetry: () => _onRefresh(),
              );
            }

            if (state is TransfersEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.swap_horiz_rounded,
                      size: 80,
                      color: AppColors.textSecondaryLight.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      LocaleKeys.reports_empty_state.tr(), // Reusing empty state
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              );
            }

            List<dynamic> transfers = [];
            bool hasReachedMax = true;

            if (state is TransfersLoaded) {
              transfers = state.transfers;
              hasReachedMax = state.hasReachedMax;
            } else if (state is TransfersLoadingMore) {
              transfers = state.transfers;
              hasReachedMax = state.hasReachedMax;
            } else if (state is TransfersError) {
              transfers = state.transfers;
            }

            return ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.all(16).copyWith(bottom: 80),
              itemCount: transfers.length + (hasReachedMax ? 0 : 1),
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                if (index >= transfers.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final transfer = transfers[index];
                return FinanceTransferCard(
                  transfer: transfer,
                  onTap: () {
                    // Navigate to details if needed
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
