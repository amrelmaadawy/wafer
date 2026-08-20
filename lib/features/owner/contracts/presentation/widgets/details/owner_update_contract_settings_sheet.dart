import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/utils/widgets/custom_button.dart';
import '../../../../../../core/utils/widgets/custom_text_field.dart';
import '../../../../../../core/utils/widgets/app_toast.dart';
import '../../../../../../core/di/service_locator.dart' as di;
import '../../../domain/entities/contract_details_entity.dart';
import '../../cubit/details/owner_contract_details_cubit.dart';
import '../../cubit/update/owner_update_contract_cubit.dart';
import '../../cubit/update/owner_update_contract_state.dart';

class OwnerUpdateContractSettingsSheet extends StatefulWidget {
  final ContractDetailsEntity contract;

  const OwnerUpdateContractSettingsSheet({
    super.key,
    required this.contract,
  });

  static Future<void> show(BuildContext context, ContractDetailsEntity contract) {
    final detailsCubit = context.read<OwnerContractDetailsCubit>();
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: detailsCubit),
          BlocProvider(create: (_) => di.sl<OwnerUpdateContractCubit>()),
        ],
        child: OwnerUpdateContractSettingsSheet(contract: contract),
      ),
    );
  }

  @override
  State<OwnerUpdateContractSettingsSheet> createState() =>
      _OwnerUpdateContractSettingsSheetState();
}

class _OwnerUpdateContractSettingsSheetState
    extends State<OwnerUpdateContractSettingsSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _renewalNoticeController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _renewalNoticeController = TextEditingController(
      text: widget.contract.renewalNoticeDays.toString(),
    );
    _notesController = TextEditingController(text: widget.contract.notes ?? '');
  }

  @override
  void dispose() {
    _renewalNoticeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    
    final renewalDays = int.tryParse(_renewalNoticeController.text.trim());
    final notes = _notesController.text.trim();

    context.read<OwnerUpdateContractCubit>().updateContract(
      id: widget.contract.id,
      renewalNoticeDays: renewalDays,
      notes: notes.isEmpty ? null : notes,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    return BlocConsumer<OwnerUpdateContractCubit, OwnerUpdateContractState>(
      listener: (context, state) {
        if (state is OwnerUpdateContractSuccess) {
          AppToast.showSuccess(
            context,
            LocaleKeys.contractSettingsUpdatedSuccessfully.tr(),
          );
          // Refresh details
          context.read<OwnerContractDetailsCubit>().getContractDetails(
            widget.contract.id,
          );
          Navigator.pop(context);
        } else if (state is OwnerUpdateContractError) {
          if (state.validationErrors == null) {
            AppToast.showError(context, state.message);
          }
        }
      },
      builder: (context, state) {
        final validationErrors = state is OwnerUpdateContractError
            ? state.validationErrors
            : null;

        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: bottomPadding + 24,
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    LocaleKeys.contractUpdateSettingsTitle.tr(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimaryLight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  CustomTextField(
                    controller: _renewalNoticeController,
                    label: LocaleKeys.contractsRenewalNoticeDays.tr(),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    errorText: validationErrors?['renewal_notice_days']?.toString(),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return LocaleKeys.maintenanceRequiredField.tr();
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  CustomTextField(
                    controller: _notesController,
                    label: LocaleKeys.contractNotes.tr(),
                    maxLines: 4,
                    errorText: validationErrors?['notes']?.toString(),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  CustomButton(
                    text: LocaleKeys.saveChanges.tr(),
                    onPressed: state is OwnerUpdateContractLoading ? () {} : _submit,
                    isLoading: state is OwnerUpdateContractLoading,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
