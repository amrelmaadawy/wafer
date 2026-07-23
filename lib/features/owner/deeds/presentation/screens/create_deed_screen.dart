import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';

import '../../../../../../core/di/service_locator.dart';
import '../../../../../../core/utils/widgets/app_toast.dart';
import '../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../../../../core/presentation/widgets/custom_dropdown_menu.dart';
import '../../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../domain/usecases/create_deed_use_case.dart';
import '../cubit/create/create_deed_cubit.dart';
import '../cubit/create/create_deed_state.dart';
import '../../../../../../core/utils/widgets/app_shimmer.dart';

class CreateDeedScreen extends StatelessWidget {
  const CreateDeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CreateDeedCubit>(),
      child: const _CreateDeedView(),
    );
  }
}

class _CreateDeedView extends StatefulWidget {
  const _CreateDeedView();

  @override
  State<_CreateDeedView> createState() => _CreateDeedViewState();
}

class _CreateDeedViewState extends State<_CreateDeedView> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _docNumberController = TextEditingController();
  final _docDateController = TextEditingController();
  final _areaController = TextEditingController();
  final _cityController = TextEditingController();
  final _districtController = TextEditingController();
  final _regionController = TextEditingController();
  final _streetController = TextEditingController();
  final _buildingController = TextEditingController();
  final _postalController = TextEditingController();
  final _notesController = TextEditingController();

  int? _selectedBranchId;
  String _selectedDocType = 'electronic';
  File? _attachment;
  bool _isPickerActive = false;
  String? _branchError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CreateDeedCubit>().fetchOptions();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _docNumberController.dispose();
    _docDateController.dispose();
    _areaController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _regionController.dispose();
    _streetController.dispose();
    _buildingController.dispose();
    _postalController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (_isPickerActive) return;
    _isPickerActive = true;
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null && mounted) {
        setState(() {
          _attachment = File(pickedFile.path);
        });
      }
    } finally {
      if (mounted) {
        _isPickerActive = false;
      }
    }
  }

  Future<void> _showProfessionalDatePicker() async {
    DateTime? tempDate = DateTime.tryParse(_docDateController.text) ?? DateTime.now();

    final date = await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 48,
                      height: 5,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          LocaleKeys.deeds_document_date.tr(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimaryLight,
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceLight,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: const Icon(Icons.close_rounded, size: 20, color: AppColors.textSecondaryLight),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: this.context.primaryColor,
                            onPrimary: Colors.white,
                            onSurface: AppColors.textPrimaryLight,
                          ),
                          textTheme: Theme.of(context).textTheme.copyWith(
                                bodyMedium: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                              ),
                        ),
                        child: CalendarDatePicker(
                          initialDate: tempDate ?? DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                          onDateChanged: (DateTime newDate) {
                            setState(() {
                              tempDate = newDate;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(tempDate),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: this.context.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          LocaleKeys.deeds_save.tr(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (date != null) {
      _docDateController.text = DateFormat('yyyy-MM-dd').format(date);
    }
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedBranchId == null) {
        setState(() {
          _branchError = LocaleKeys.deeds_required_field.tr();
        });
        return;
      } else {
        setState(() {
          _branchError = null;
        });
      }

      final params = AddNewDeedParams(
        name: _nameController.text.trim(),
        branchId: _selectedBranchId!,
        documentType: _selectedDocType,
        documentNumber: _docNumberController.text.trim(),
        documentDate: _docDateController.text.trim(),
        area: num.tryParse(_areaController.text.trim()) ?? 0,
        city: _cityController.text.trim(),
        district: _districtController.text.trim(),
        region: _regionController.text.trim(),
        streetName: _streetController.text.trim(),
        buildingNumber: _buildingController.text.trim(),
        postalCode: _postalController.text.trim(),
        notes: _notesController.text.trim(),
        documentAttachment: _attachment,
      );

      context.read<CreateDeedCubit>().submitDeed(params);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateDeedCubit, CreateDeedState>(
      listener: (context, state) {
        if (state is CreateDeedSuccess) {
          AppToast.showSuccess(
            context,
            LocaleKeys.deeds_success_create_deed.tr(),
          );
          Navigator.of(context).pop(true);
        } else if (state is CreateDeedError) {
          AppToast.showError(
            context,
            state.message,
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: CustomAppBar(
          title: LocaleKeys.deeds_create_deed.tr(),
          subtitle: LocaleKeys.deeds_create_subtitle.tr(),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _buildSectionTitle(LocaleKeys.deeds_basic_info.tr()),
              _buildCard([
                _buildTextField(
                  label: LocaleKeys.deeds_deed_name.tr(),
                  controller: _nameController,
                  isRequired: true,
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildBranchDropdown()),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        label: LocaleKeys.deeds_area.tr(),
                        controller: _areaController,
                        isRequired: true,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: LocaleKeys.deeds_notes.tr(),
                  controller: _notesController,
                  maxLines: 3,
                ),
              ]),
              const SizedBox(height: 24),
              _buildSectionTitle(LocaleKeys.deeds_document_info.tr()),
              _buildCard([
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildTextField(
                        label: LocaleKeys.deeds_document_number.tr(),
                        controller: _docNumberController,
                        isRequired: true,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        label: LocaleKeys.deeds_document_date.tr(),
                        controller: _docDateController,
                        isRequired: true,
                        hintText: 'YYYY-MM-DD',
                        readOnly: true,
                        suffixIcon: const Icon(Icons.calendar_today_rounded, color: AppColors.textSecondaryLight, size: 20),
                        onTap: _showProfessionalDatePicker,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildDocTypeDropdown(),
                const SizedBox(height: 16),
                _buildAttachmentPicker(),
              ]),
              const SizedBox(height: 24),
              _buildSectionTitle(LocaleKeys.deeds_location_info.tr()),
              _buildCard([
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildTextField(label: LocaleKeys.deeds_region.tr(), controller: _regionController)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildTextField(label: LocaleKeys.deeds_city.tr(), controller: _cityController)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildTextField(label: LocaleKeys.deeds_district.tr(), controller: _districtController)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildTextField(label: LocaleKeys.deeds_street_name.tr(), controller: _streetController)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(label: LocaleKeys.deeds_building_number.tr(), controller: _buildingController),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        label: LocaleKeys.deeds_postal_code.tr(),
                        controller: _postalController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      ),
                    ),
                  ],
                ),
              ]),
              const SizedBox(height: 32),
              _buildSubmitButton(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimaryLight,
        ),
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.circularXl,
        border: Border.all(color: const Color(0xFFE2E8F0)),
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
        children: children,
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool isRequired = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? hintText,
    bool readOnly = false,
    VoidCallback? onTap,
    Widget? suffixIcon,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondaryLight),
            ),
            if (isRequired)
              const Text(' *', style: TextStyle(color: Colors.red, fontSize: 13)),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onTap,
          inputFormatters: inputFormatters,
          validator: isRequired
              ? (value) => (value == null || value.trim().isEmpty) ? LocaleKeys.deeds_required_field.tr() : null
              : null,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: hintText ?? label,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: AppColors.backgroundLight,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: AppRadius.circularLg,
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.circularLg,
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.circularLg,
              borderSide: BorderSide(color: context.primaryColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: AppRadius.circularLg,
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBranchDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              LocaleKeys.deeds_branch.tr(),
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondaryLight),
            ),
            const Text(' *', style: TextStyle(color: Colors.red, fontSize: 13)),
          ],
        ),
        const SizedBox(height: 8),
        BlocBuilder<CreateDeedCubit, CreateDeedState>(
          buildWhen: (previous, current) =>
              current is CreateDeedInitial ||
              current is CreateDeedLoading ||
              current is FormOptionsLoaded ||
              current is CreateDeedError,
          builder: (context, state) {
            final branches = context.read<CreateDeedCubit>().branches;
            final isLoading = state is CreateDeedInitial || (state is CreateDeedLoading && branches.isEmpty);

            if (isLoading) {
              return AppShimmer.box(
                width: double.infinity,
                height: 54,
                borderRadius: AppRadius.circularLg,
              );
            }
            return CustomDropdownMenu<int>(
              height: 54,
              value: _selectedBranchId,
              hint: LocaleKeys.deeds_branch.tr(),
              items: branches.map((b) => b.id).toList(),
              itemLabelBuilder: (id) => branches.firstWhere((b) => b.id == id).name,
              errorText: _branchError,
              onSelected: (value) {
                setState(() {
                  _selectedBranchId = value;
                  _branchError = null;
                });
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildDocTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              LocaleKeys.deeds_document_type.tr(),
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondaryLight),
            ),
            const Text(' *', style: TextStyle(color: Colors.red, fontSize: 13)),
          ],
        ),
        const SizedBox(height: 8),
        CustomDropdownMenu<String>(
          height: 54,
          value: _selectedDocType,
          hint: LocaleKeys.deeds_document_type.tr(),
          items: const ['electronic', 'manual'],
          itemLabelBuilder: (val) => val == 'electronic' 
              ? LocaleKeys.deeds_electronic_deed.tr() 
              : LocaleKeys.deeds_manual_deed.tr(),
          onSelected: (value) {
            setState(() {
              _selectedDocType = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildAttachmentPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.deeds_attachment.tr(),
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondaryLight),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _pickImage,
          borderRadius: AppRadius.circularLg,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: context.primaryColor.withValues(alpha: 0.05),
              borderRadius: AppRadius.circularLg,
              border: Border.all(
                color: context.primaryColor.withValues(alpha: 0.3),
                style: BorderStyle.solid,
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  _attachment == null ? Icons.upload_file_rounded : Icons.check_circle_rounded,
                  color: context.primaryColor,
                  size: 32,
                ),
                const SizedBox(height: 12),
                Text(
                  _attachment == null
                      ? LocaleKeys.deeds_upload_attachment.tr()
                      : _attachment!.path.split('/').last,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: context.primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<CreateDeedCubit, CreateDeedState>(
      builder: (context, state) {
        final isLoading = state is CreateDeedLoading;
        return SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: isLoading ? null : _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: context.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.circularXl,
              ),
              elevation: 4,
              shadowColor: context.primaryShadow,
            ),
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Text(
                    LocaleKeys.deeds_save.tr(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
