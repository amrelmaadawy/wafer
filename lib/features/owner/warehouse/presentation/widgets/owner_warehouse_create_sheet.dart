import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/utils/translations/locale_keys.g.dart';
import '../../../../../core/utils/widgets/app_toast.dart';
import '../../../../../core/utils/widgets/custom_button.dart';
import '../../../../../core/utils/widgets/custom_text_field.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../../../../core/theme/color_utils.dart';
import '../cubit/create_warehouse/owner_warehouse_create_cubit.dart';
import '../cubit/create_warehouse/owner_warehouse_create_state.dart';

class OwnerWarehouseCreateSheet extends StatefulWidget {
  final VoidCallback onSuccess;

  const OwnerWarehouseCreateSheet({
    super.key,
    required this.onSuccess,
  });

  static Future<void> show(BuildContext context, {required VoidCallback onSuccess}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.appSurfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (context) => BlocProvider(
        create: (context) => sl<OwnerWarehouseCreateCubit>(),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: OwnerWarehouseCreateSheet(
            onSuccess: onSuccess,
          ),
        ),
      ),
    );
  }

  @override
  State<OwnerWarehouseCreateSheet> createState() =>
      _OwnerWarehouseCreateSheetState();
}

class _OwnerWarehouseCreateSheetState extends State<OwnerWarehouseCreateSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _notesController = TextEditingController();
  bool _isActive = true;

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<OwnerWarehouseCreateCubit>().createWarehouse(
            name: _nameController.text,
            code: _codeController.text,
            notes: _notesController.text,
            isActive: _isActive,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OwnerWarehouseCreateCubit, OwnerWarehouseCreateState>(
      listener: (context, state) {
        if (state is OwnerWarehouseCreateSuccess) {
          AppToast.showSuccess(
            context,
            LocaleKeys.warehouse_create_success.tr(),
          );
          widget.onSuccess();
          context.pop();
        } else if (state is OwnerWarehouseCreateError) {
          AppToast.showError(context, state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is OwnerWarehouseCreateLoading;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LocaleKeys.warehouse_create_title.tr(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => context.pop(),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

                // Name
                CustomTextField(
                  controller: _nameController,
                  label: LocaleKeys.warehouse_name_label.tr(),
                  hintText: LocaleKeys.warehouse_name_hint.tr(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return LocaleKeys.warehouse_name_empty.tr();
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),

                // Code
                CustomTextField(
                  controller: _codeController,
                  label: LocaleKeys.warehouse_code_label.tr(),
                  hintText: LocaleKeys.warehouse_code_hint.tr(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return LocaleKeys.warehouse_code_empty.tr();
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),

                // Notes
                CustomTextField(
                  controller: _notesController,
                  label: LocaleKeys.warehouse_notes_label.tr(),
                  hintText: LocaleKeys.warehouse_notes_hint.tr(),
                  maxLines: 3,
                ),
                const SizedBox(height: AppSpacing.md),

                // Is Active
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    LocaleKeys.warehouse_is_active_label.tr(),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  activeThumbColor: context.primaryColor,
                  value: _isActive,
                  onChanged: (value) {
                    setState(() {
                      _isActive = value;
                    });
                  },
                ),
                const SizedBox(height: AppSpacing.xl),

                // Submit
                CustomButton(
                  onPressed: _submit,
                  isLoading: isLoading,
                  text: LocaleKeys.warehouse_create_button.tr(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
