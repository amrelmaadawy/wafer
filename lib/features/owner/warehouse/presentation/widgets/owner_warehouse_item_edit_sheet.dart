import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/di/service_locator.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/theme_context.dart';
import '../../../../../../core/utils/translations/locale_keys.g.dart';
import '../../../../../../core/utils/widgets/app_toast.dart';
import '../../../../../../core/utils/widgets/custom_button.dart';
import '../../../../../../core/utils/widgets/custom_text_field.dart';
import '../../domain/entities/warehouse_item_details_entity.dart';
import '../cubit/update/owner_warehouse_item_update_cubit.dart';
import '../cubit/update/owner_warehouse_item_update_state.dart';

class OwnerWarehouseItemEditSheet extends StatefulWidget {
  final WarehouseItemDetailsEntity item;
  final VoidCallback onSuccess;

  const OwnerWarehouseItemEditSheet({
    super.key,
    required this.item,
    required this.onSuccess,
  });

  static Future<void> show(
    BuildContext context, {
    required WarehouseItemDetailsEntity item,
    required VoidCallback onSuccess,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.appBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => BlocProvider(
        create: (context) => sl<OwnerWarehouseItemUpdateCubit>(),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: OwnerWarehouseItemEditSheet(
            item: item,
            onSuccess: onSuccess,
          ),
        ),
      ),
    );
  }

  @override
  State<OwnerWarehouseItemEditSheet> createState() =>
      _OwnerWarehouseItemEditSheetState();
}

class _OwnerWarehouseItemEditSheetState
    extends State<OwnerWarehouseItemEditSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _minQtyController;
  late TextEditingController _sellingPriceController;
  late TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    _minQtyController =
        TextEditingController(text: widget.item.quantityMinLimit.toString());
    _sellingPriceController =
        TextEditingController(text: widget.item.pricing.sellingPrice.toString());
    _descController = TextEditingController(text: widget.item.description ?? '');
  }

  @override
  void dispose() {
    _minQtyController.dispose();
    _sellingPriceController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<OwnerWarehouseItemUpdateCubit>().updateItem(
            id: widget.item.id,
            minQuantity: num.tryParse(_minQtyController.text),
            sellingPrice: num.tryParse(_sellingPriceController.text),
            description: _descController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OwnerWarehouseItemUpdateCubit,
        OwnerWarehouseItemUpdateState>(
      listener: (context, state) {
        if (state is OwnerWarehouseItemUpdateSuccess) {
          AppToast.showSuccess(context, LocaleKeys.warehouse_edit_item_success.tr());
          widget.onSuccess();
          context.pop();
        } else if (state is OwnerWarehouseItemUpdateError) {
          AppToast.showError(context, state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is OwnerWarehouseItemUpdateLoading;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LocaleKeys.warehouse_edit_item_title.tr(),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
                CustomTextField(
                  label: LocaleKeys.warehouse_item_min_quantity.tr(),
                  controller: _minQtyController,
                  keyboardType: TextInputType.number,
                  readOnly: isLoading,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return LocaleKeys.warehouse_item_name_val.tr(); // Reusing a general validation if needed, or better, no strict validation
                    }
                    if (num.tryParse(value) == null) {
                      return 'Invalid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                CustomTextField(
                  label: LocaleKeys.warehouse_item_selling_price.tr(),
                  controller: _sellingPriceController,
                  keyboardType: TextInputType.number,
                  readOnly: isLoading,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return LocaleKeys.warehouse_item_name_val.tr();
                    }
                    if (num.tryParse(value) == null) {
                      return 'Invalid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                CustomTextField(
                  label: LocaleKeys.warehouse_item_description.tr(),
                  controller: _descController,
                  maxLines: 3,
                  readOnly: isLoading,
                ),
                const SizedBox(height: AppSpacing.xl),
                CustomButton(
                  text: LocaleKeys.warehouse_edit_item_btn.tr(),
                  onPressed: isLoading ? () {} : _submit,
                  isLoading: isLoading,
                  isDisabled: isLoading,
                ),
                const SizedBox(height: AppSpacing.md),
              ],
            ),
          ),
        );
      },
    );
  }
}
