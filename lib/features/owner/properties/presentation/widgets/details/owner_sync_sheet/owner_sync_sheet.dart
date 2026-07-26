import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../../core/localization/locale_keys.dart';

import '../../../../../../../core/theme/app_radius.dart';

import '../../../../../../../core/utils/widgets/app_toast.dart';
import '../../../../../../../core/utils/widgets/app_shimmer.dart';
import '../../../cubit/owners/sync_owners_cubit.dart';
import '../../../cubit/owners/sync_owners_state.dart';

import 'widgets/sync_sheet_header.dart';
import 'widgets/sync_sheet_action_buttons.dart';
import 'widgets/owner_input_card.dart';

class OwnerSyncSheet extends StatelessWidget {
  final int propertyId;
  final VoidCallback onSuccess;

  const OwnerSyncSheet({
    super.key,
    required this.propertyId,
    required this.onSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SyncOwnersCubit, SyncOwnersState>(
      listener: (context, state) {
        if (state.isSuccess) {
          Navigator.of(context).pop();
          onSuccess();
          AppToast.showSuccess(context, LocaleKeys.propertyOwnersSuccessMsg.tr());
        }
        if (state.errorMessage != null) {
          AppToast.showError(context, state.errorMessage!);
        }
      },
      builder: (context, state) {
        return _SheetBody(propertyId: propertyId, state: state);
      },
    );
  }
}

class _SheetBody extends StatelessWidget {
  final int propertyId;
  final SyncOwnersState state;

  const _SheetBody({required this.propertyId, required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SyncOwnersCubit>();

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SyncSheetHeader(state: state),
          Flexible(
            child: state.isLoading
                ? _buildShimmerLoading()
                : ListView(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      AddOwnerDropdown(state: state, cubit: cubit),
                      const SizedBox(height: 20),
                      if (state.assignedOwners.isNotEmpty)
                        AutoDistributeButton(cubit: cubit),
                      const SizedBox(height: 16),
                      if (state.assignedOwners.isEmpty)
                        const EmptyOwners()
                      else
                        ...state.assignedOwners.map(
                          (e) => OwnerEntryCard(entry: e, cubit: cubit),
                        ),
                      const SizedBox(height: 100),
                    ],
                  ),
          ),
          SaveButton(state: state, cubit: cubit, propertyId: propertyId),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      itemCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppRadius.circularXl,
            border: Border.all(color: const Color(0xFFF1F5F9)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AppShimmer.circle(size: 48),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppShimmer.box(height: 16, width: 140),
                        const SizedBox(height: 10),
                        AppShimmer.box(height: 12, width: 90),
                      ],
                    ),
                  ),
                  AppShimmer.box(height: 32, width: 32, borderRadius: AppRadius.circularMd),
                  const SizedBox(width: 10),
                  AppShimmer.box(height: 32, width: 32, borderRadius: AppRadius.circularMd),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: AppShimmer.box(height: 12, borderRadius: AppRadius.circularFull)),
                  const SizedBox(width: 20),
                  AppShimmer.box(height: 44, width: 80, borderRadius: AppRadius.circularLg),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
