import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/presentation/widgets/custom_back_button.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../generated/locale_keys.dart';
import '../../domain/entities/finance_account_entity.dart';
import '../cubit/accounts/finance_account_details_cubit.dart';
import '../cubit/accounts/finance_account_details_state.dart';

class OwnerAccountDetailsView extends StatefulWidget {
  final int accountId;

  const OwnerAccountDetailsView({super.key, required this.accountId});

  @override
  State<OwnerAccountDetailsView> createState() => _OwnerAccountDetailsViewState();
}

class _OwnerAccountDetailsViewState extends State<OwnerAccountDetailsView> {
  @override
  void initState() {
    super.initState();
    context.read<FinanceAccountDetailsCubit>().fetchAccountDetails(widget.accountId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        leadingWidth: 68,
        leading: const CustomBackButton(),
        title: const Text('تفاصيل الحساب'), // No need to translate unless requested
        actions: [
          BlocBuilder<FinanceAccountDetailsCubit, FinanceAccountDetailsState>(
            builder: (context, state) {
              if (state is FinanceAccountDetailsSuccess) {
                return IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () async {
                    final result = await context.push(
                      Routes.ownerFinanceAccountUpdate,
                      extra: state.account,
                    );
                    if (result == true && context.mounted) {
                      context
                          .read<FinanceAccountDetailsCubit>()
                          .fetchAccountDetails(widget.accountId);
                    }
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<FinanceAccountDetailsCubit, FinanceAccountDetailsState>(
        builder: (context, state) {
          if (state is FinanceAccountDetailsLoading || state is FinanceAccountDetailsInitial) {
            return const Center(child: CircularProgressIndicator()); // Can be a skeleton later
          }

          if (state is FinanceAccountDetailsError) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: () => context
                  .read<FinanceAccountDetailsCubit>()
                  .fetchAccountDetails(widget.accountId),
            );
          }

          if (state is FinanceAccountDetailsSuccess) {
            return _buildDetails(context, state.account);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildDetails(BuildContext context, FinanceAccountEntity account) {
    final name = context.locale.languageCode == 'ar' ? account.nameAr : account.nameEn;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // Main Info Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: AppRadius.circularXl,
            border: Border.all(color: AppColors.borderLight),
            boxShadow: [
              BoxShadow(
                color: AppColors.textPrimaryLight.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundLight,
                      borderRadius: AppRadius.circularMd,
                    ),
                    child: Text(
                      account.code,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontFamily: AppFonts.fontFamilyEn,
                            color: AppColors.textSecondaryLight,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                  _buildStatusBadge(context, account.isActive),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildTypeTag(context, account.type),
                  const SizedBox(width: 8),
                  if (account.isPostable) _buildPostableTag(context),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        
        // Other Details
        if (account.descriptionAr != null && account.descriptionAr!.isNotEmpty) ...[
          Text(
            LocaleKeys.owner_finance_account_desc.tr(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: AppRadius.circularXl,
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Text(
              account.descriptionAr!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondaryLight,
                    height: 1.6,
                  ),
            ),
          ),
        ],
        const SizedBox(height: 16),
        _buildInfoRow(
          context,
          title: LocaleKeys.owner_finance_account_name_ar.tr(),
          value: account.nameAr,
        ),
        const SizedBox(height: 16),
        _buildInfoRow(
          context,
          title: LocaleKeys.owner_finance_account_name_en.tr(),
          value: account.nameEn,
        ),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, {required String title, required String value}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.circularMd,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondaryLight,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, bool isActive) {
    final color = isActive ? AppColors.success : AppColors.error;
    final text = isActive
        ? LocaleKeys.profile_active.tr()
        : LocaleKeys.profile_inactive.tr();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppRadius.circularXl,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeTag(BuildContext context, String type) {
    Color color;
    switch (type.toLowerCase()) {
      case 'asset':
      case 'أصول':
        color = AppColors.success;
        break;
      case 'liability':
      case 'خصوم':
      case 'خصم / دائن':
        color = AppColors.error;
        break;
      case 'expense':
      case 'مصروفات':
        color = AppColors.warning;
        break;
      case 'revenue':
      case 'إيرادات':
        color = AppColors.info;
        break;
      case 'equity':
      case 'حقوق ملكية':
        color = Colors.purple;
        break;
      default:
        color = AppColors.textSecondaryLight;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppRadius.circularLg,
      ),
      child: Text(
        type,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Widget _buildPostableTag(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.1),
        borderRadius: AppRadius.circularLg,
      ),
      child: Text(
        LocaleKeys.owner_finance_postable.tr(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.info,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
