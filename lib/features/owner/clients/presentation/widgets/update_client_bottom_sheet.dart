import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../../../../core/theme/theme_context.dart';
import '../../../../../../core/presentation/widgets/app_loading_overlay.dart';
import '../../../../../../core/presentation/widgets/custom_dropdown_menu.dart';
import '../../../../../../core/utils/widgets/custom_text_field.dart';
import '../../../../../../core/utils/widgets/app_toast.dart';
import '../../../../../../core/di/service_locator.dart' as di;
import '../../domain/entities/client_entity.dart';
import '../cubit/update/update_owner_client_cubit.dart';
import '../cubit/update/update_owner_client_state.dart';

class UpdateClientBottomSheet extends StatefulWidget {
  final ClientEntity client;
  final VoidCallback onUpdateSuccess;

  const UpdateClientBottomSheet({
    super.key,
    required this.client,
    required this.onUpdateSuccess,
  });

  static Future<void> show(BuildContext context, ClientEntity client, VoidCallback onUpdateSuccess) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider(
        create: (_) => di.sl<UpdateOwnerClientCubit>(),
        child: UpdateClientBottomSheet(
          client: client,
          onUpdateSuccess: onUpdateSuccess,
        ),
      ),
    );
  }

  @override
  State<UpdateClientBottomSheet> createState() => _UpdateClientBottomSheetState();
}

class _UpdateClientBottomSheetState extends State<UpdateClientBottomSheet> {
  late final TextEditingController _phoneController;
  late String _selectedStatus;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: widget.client.phone);
    _selectedStatus = widget.client.status;
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.primaryColor;
    final maxSheetHeight = MediaQuery.of(context).size.height * 0.88;

    return BlocConsumer<UpdateOwnerClientCubit, UpdateOwnerClientState>(
      listener: (context, state) {
        if (state.status == UpdateOwnerClientStatus.success) {
          AppToast.showSuccess(context, 'تم تحديث بيانات العميل بنجاح');
          widget.onUpdateSuccess();
          Navigator.of(context).pop();
        } else if (state.status == UpdateOwnerClientStatus.failure) {
          AppToast.showError(context, state.errorMessage ?? LocaleKeys.commonError.tr());
        }
      },
      builder: (context, state) {
        final isLoading = state.status == UpdateOwnerClientStatus.loading;

        return AppLoadingOverlay(
          isLoading: isLoading,
          child: Container(
            constraints: BoxConstraints(maxHeight: maxSheetHeight),
            decoration: BoxDecoration(
              color: context.appSurfaceColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: context.appBorderColor,
                      borderRadius: AppRadius.circularFull,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.md,
                      AppSpacing.lg,
                      AppSpacing.sm,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.1),
                            borderRadius: AppRadius.circularMd,
                          ),
                          child: Icon(
                            Icons.edit_rounded,
                            size: 18,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'تعديل بيانات العميل',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: context.appOnSurfaceColor,
                            ),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              if (!isLoading) {
                                Navigator.of(context).pop();
                              }
                            },
                            borderRadius: AppRadius.circularFull,
                            child: Container(
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                color: context.appBackgroundColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: context.appBorderColor.withValues(alpha: 0.6),
                                ),
                              ),
                              child: Icon(
                                Icons.close_rounded,
                                size: 18,
                                color: context.appSecondaryTextColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1, color: context.appBorderColor),
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.md,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            controller: _phoneController,
                            label: LocaleKeys.clientsRenterPhone.tr(),
                            hintText: '05xxxxxxxx',
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            LocaleKeys.clientStatus.tr(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          CustomDropdownMenu<String>(
                            value: _selectedStatus,
                            items: const ['active', 'inactive'],
                            hint: LocaleKeys.clientStatus.tr(),
                            itemLabelBuilder: (val) => val == 'active' ? 'نشط' : 'غير نشط',
                            onSelected: (val) {
                              setState(() {
                                _selectedStatus = val;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(height: 1, color: context.appBorderColor),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.sm,
                      AppSpacing.lg,
                      AppSpacing.md,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: isLoading
                            ? null
                            : () {
                                context.read<UpdateOwnerClientCubit>().updateClient(
                                      clientId: widget.client.id,
                                      phone: _phoneController.text.trim(),
                                      status: _selectedStatus,
                                    );
                                // The keyboard needs to be closed
                                FocusScope.of(context).unfocus();
                              },
                        icon: isLoading
                            ? const SizedBox.shrink()
                            : const Icon(Icons.save_rounded, size: 18, color: Colors.white),
                        label: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : Text(
                                LocaleKeys.save.tr(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.circularXl,
                          ),
                        ),
                      ),
                    ),
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
