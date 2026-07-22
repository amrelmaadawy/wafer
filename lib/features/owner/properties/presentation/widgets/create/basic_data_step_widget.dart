import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../cubit/create/property_create_cubit.dart';
import '../../cubit/create/property_create_state.dart';

class BasicDataStepWidget extends StatefulWidget {
  const BasicDataStepWidget({super.key});

  @override
  State<BasicDataStepWidget> createState() => _BasicDataStepWidgetState();
}

class _BasicDataStepWidgetState extends State<BasicDataStepWidget> {
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _areaController;
  late TextEditingController _descriptionController;
  late TextEditingController _deedNumController;

  @override
  void initState() {
    super.initState();
    final state = context.read<PropertyCreateCubit>().state;
    _nameController = TextEditingController(text: state.propertyName);
    _addressController = TextEditingController(text: state.address);
    _areaController = TextEditingController(text: state.area != null ? state.area.toString() : '');
    _descriptionController = TextEditingController(text: state.notes ?? state.description);
    _deedNumController = TextEditingController(text: state.deedNumber ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _areaController.dispose();
    _descriptionController.dispose();
    _deedNumController.dispose();
    super.dispose();
  }

  void _onChanged() {
    context.read<PropertyCreateCubit>().updateBasicData(
          name: _nameController.text,
          address: _addressController.text,
          area: num.tryParse(_areaController.text),
          deedNumber: _deedNumController.text,
          notes: _descriptionController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PropertyCreateCubit, PropertyCreateState>(
      builder: (context, state) {
        final cubit = context.read<PropertyCreateCubit>();
        final options = state.formData?.options;
        final usageTypes = options?.usageTypes ?? [];
        final docTypes = options?.documentTypes ?? [];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.propertyCreateStep2Title.tr(),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _nameController,
                label: LocaleKeys.propertyCreatePropertyName.tr(),
                hint: 'مثال: برج الأمل العقاري',
                icon: Icons.apartment_rounded,
                isRequired: true,
              ),
              const SizedBox(height: 16),
              if (usageTypes.isNotEmpty) ...[
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'نوع الاستخدام',
                    border: OutlineInputBorder(borderRadius: AppRadius.circularLg),
                  ),
                  items: usageTypes.map((u) => DropdownMenuItem(value: u.value, child: Text(u.label))).toList(),
                  onChanged: (val) {
                    if (val != null) cubit.selectUsageType(val);
                  },
                ),
                const SizedBox(height: 16),
              ],
              if (docTypes.isNotEmpty) ...[
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'نوع المستند',
                    border: OutlineInputBorder(borderRadius: AppRadius.circularLg),
                  ),
                  items: docTypes.map((d) => DropdownMenuItem(value: d.value, child: Text(d.label))).toList(),
                  onChanged: (val) {
                    if (val != null) cubit.updateBasicData(documentType: val);
                  },
                ),
                const SizedBox(height: 16),
              ],
              _buildTextField(
                controller: _addressController,
                label: LocaleKeys.propertyCreateAddress.tr(),
                hint: 'المدينة، الحي، الشارع',
                icon: Icons.location_on_outlined,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _areaController,
                      label: LocaleKeys.propertyCreateArea.tr(),
                      hint: 'المساحة (م²)',
                      icon: Icons.square_foot_outlined,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _deedNumController,
                      label: 'رقم الصك/المستند',
                      hint: '123456',
                      icon: Icons.receipt_long_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _descriptionController,
                label: LocaleKeys.propertyCreateDescription.tr(),
                hint: 'ملاحظات وتفاصيل إضافية...',
                icon: Icons.notes_rounded,
                maxLines: 3,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isRequired = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            if (isRequired) const Text(' *', style: TextStyle(color: AppColors.error)),
          ],
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          onChanged: (_) => _onChanged(),
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 20, color: AppColors.textSecondaryLight),
            filled: true,
            fillColor: AppColors.surfaceLight,
            border: OutlineInputBorder(borderRadius: AppRadius.circularLg),
          ),
        ),
      ],
    );
  }
}
