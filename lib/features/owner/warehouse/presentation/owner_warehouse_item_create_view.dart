import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../../core/utils/widgets/app_toast.dart';
import '../../../../../core/utils/widgets/custom_button.dart';
import '../../../../../core/presentation/widgets/custom_dropdown_menu.dart';
import '../../../../../core/utils/widgets/custom_text_field.dart';
import '../domain/entities/create_warehouse_item_params.dart';
import 'cubit/create_item/owner_warehouse_item_create_cubit.dart';
import 'cubit/create_item/owner_warehouse_item_create_state.dart';

class OwnerWarehouseItemCreateView extends StatefulWidget {
  const OwnerWarehouseItemCreateView({super.key});

  @override
  State<OwnerWarehouseItemCreateView> createState() =>
      _OwnerWarehouseItemCreateViewState();
}

class _OwnerWarehouseItemCreateViewState
    extends State<OwnerWarehouseItemCreateView> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _skuController = TextEditingController();
  final _serialNumberController = TextEditingController();
  final _categoryController = TextEditingController();
  final _quantityController = TextEditingController();
  final _minQuantityController = TextEditingController();
  final _unitPriceController = TextEditingController();
  final _sellingPriceController = TextEditingController();
  final _discountValueController = TextEditingController();
  final _taxPercentageController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _discountType = 'none';
  bool _priceIncludesTax = false;
  bool _isActive = true;

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _serialNumberController.dispose();
    _categoryController.dispose();
    _quantityController.dispose();
    _minQuantityController.dispose();
    _unitPriceController.dispose();
    _sellingPriceController.dispose();
    _discountValueController.dispose();
    _taxPercentageController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final params = CreateWarehouseItemParams(
        name: _nameController.text.trim(),
        sku: _skuController.text.trim(),
        serialNumber: _serialNumberController.text.trim(),
        category: _categoryController.text.trim(),
        warehouseId: 1, // Defaulting to 1 as per current implementation context
        quantity: num.tryParse(_quantityController.text) ?? 0,
        minQuantity: num.tryParse(_minQuantityController.text) ?? 0,
        unitPrice: num.tryParse(_unitPriceController.text) ?? 0,
        sellingPrice: num.tryParse(_sellingPriceController.text) ?? 0,
        discountType: _discountType,
        discountValue: num.tryParse(_discountValueController.text) ?? 0,
        taxPercentage: num.tryParse(_taxPercentageController.text) ?? 0,
        priceIncludesTax: _priceIncludesTax,
        description: _descriptionController.text.trim(),
        isActive: _isActive,
      );

      context.read<OwnerWarehouseItemCreateCubit>().createItem(params);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'warehouse.create_item_title'.tr(),
        showBackButton: true,
      ),
      body:
          BlocConsumer<
            OwnerWarehouseItemCreateCubit,
            OwnerWarehouseItemCreateState
          >(
            listener: (context, state) {
              if (state is OwnerWarehouseItemCreateSuccess) {
                AppToast.showSuccess(
                  context,
                  'warehouse.create_item_success'.tr(),
                );
                context.pop(state.item);
              } else if (state is OwnerWarehouseItemCreateError) {
                AppToast.showError(context, state.message);
              }
            },
            builder: (context, state) {
              final isLoading = state is OwnerWarehouseItemCreateLoading;

              return Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    CustomTextField(
                      label: 'warehouse.item_name'.tr(),
                      hintText: 'warehouse.item_name_hint'.tr(),
                      controller: _nameController,
                      validator: (val) => val == null || val.isEmpty
                          ? 'warehouse.item_name_val'.tr()
                          : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            label: 'warehouse.item_sku'.tr(),
                            hintText: 'warehouse.item_sku_hint'.tr(),
                            controller: _skuController,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomTextField(
                            label: 'warehouse.item_serial_number'.tr(),
                            hintText: 'warehouse.item_serial_number_hint'.tr(),
                            controller: _serialNumberController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'warehouse.item_category'.tr(),
                      hintText: 'warehouse.item_category_hint'.tr(),
                      controller: _categoryController,
                      validator: (val) => val == null || val.isEmpty
                          ? 'warehouse.item_category_val'.tr()
                          : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            label: 'warehouse.item_quantity'.tr(),
                            hintText: 'warehouse.item_quantity_hint'.tr(),
                            controller: _quantityController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomTextField(
                            label: 'warehouse.item_min_quantity'.tr(),
                            hintText: 'warehouse.item_min_quantity_hint'.tr(),
                            controller: _minQuantityController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            label: 'warehouse.item_unit_price'.tr(),
                            hintText: 'warehouse.item_unit_price_hint'.tr(),
                            controller: _unitPriceController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomTextField(
                            label: 'warehouse.item_selling_price'.tr(),
                            hintText: 'warehouse.item_selling_price_hint'.tr(),
                            controller: _sellingPriceController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'warehouse.item_discount_type'.tr(),
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              CustomDropdownMenu<String>(
                                hint: 'warehouse.item_discount_type'.tr(),
                                value: _discountType,
                                items: const ['none', 'percentage', 'fixed'],
                                itemLabelBuilder: (val) {
                                  if (val == 'percentage') {
                                    return 'warehouse.discount_percentage'.tr();
                                  } else if (val == 'fixed') {
                                    return 'warehouse.discount_fixed'.tr();
                                  }
                                  return 'warehouse.discount_none'.tr();
                                },
                                onSelected: (val) {
                                  setState(() {
                                    _discountType = val;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomTextField(
                            label: 'warehouse.item_discount_value'.tr(),
                            hintText: 'warehouse.item_discount_value_hint'.tr(),
                            controller: _discountValueController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'warehouse.item_tax_percentage'.tr(),
                      hintText: 'warehouse.item_tax_percentage_hint'.tr(),
                      controller: _taxPercentageController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: Text('warehouse.item_price_includes_tax'.tr()),
                      value: _priceIncludesTax,
                      onChanged: (val) =>
                          setState(() => _priceIncludesTax = val),
                      contentPadding: EdgeInsets.zero,
                    ),
                    SwitchListTile(
                      title: Text('warehouse.item_is_active'.tr()),
                      value: _isActive,
                      onChanged: (val) => setState(() => _isActive = val),
                      contentPadding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'warehouse.item_description'.tr(),
                      hintText: 'warehouse.item_description_hint'.tr(),
                      controller: _descriptionController,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      text: 'warehouse.create_item_btn'.tr(),
                      onPressed: isLoading ? () {} : _submit,
                      isLoading: isLoading,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            },
          ),
    );
  }
}
