import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../cubit/units/unit_create_cubit.dart';
import '../../cubit/units/unit_create_state.dart';

class UnitCreateBottomSheet extends StatefulWidget {
  final int propertyId;
  final VoidCallback onUnitCreated;

  const UnitCreateBottomSheet({
    super.key,
    required this.propertyId,
    required this.onUnitCreated,
  });

  @override
  State<UnitCreateBottomSheet> createState() => _UnitCreateBottomSheetState();
}

class _UnitCreateBottomSheetState extends State<UnitCreateBottomSheet> {
  final _unitNumberController = TextEditingController();
  final _rentPriceController = TextEditingController();
  final _floorController = TextEditingController();
  final _areaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UnitCreateCubit>().initDraftUnit(widget.propertyId);
    });
  }

  @override
  void dispose() {
    _unitNumberController.dispose();
    _rentPriceController.dispose();
    _floorController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        top: 20,
        left: 20,
        right: 20,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.topXxl,
      ),
      child: BlocConsumer<UnitCreateCubit, UnitCreateState>(
        listener: (context, state) {
          if (state.isPublished) {
            Navigator.pop(context);
            widget.onUnitCreated();
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: AppRadius.circularFull,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  LocaleKeys.propertyDetailsAddUnit.tr(),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildInput(_unitNumberController, 'رقم الوحدة *'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildInput(_floorController, 'الطابق'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildInput(_rentPriceController, 'سعر الإيجار *',
                          keyboardType: TextInputType.number),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildInput(_areaController, 'المساحة م²',
                          keyboardType: TextInputType.number),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state.isSaving
                        ? null
                        : () {
                            final number = _unitNumberController.text.trim();
                            final rent = num.tryParse(_rentPriceController.text);
                            if (number.isNotEmpty && rent != null) {
                              context.read<UnitCreateCubit>().saveAndPublish(
                                    propertyId: widget.propertyId,
                                    unitNumber: number,
                                    rentPrice: rent,
                                    floor: _floorController.text,
                                    area: num.tryParse(_areaController.text),
                                  );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.circularLg),
                    ),
                    child: state.isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('حفظ ونشر الوحدة'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInput(TextEditingController controller, String hint,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 12.5, color: AppColors.textSecondaryLight),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        border: OutlineInputBorder(
          borderRadius: AppRadius.circularLg,
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
      ),
    );
  }
}
