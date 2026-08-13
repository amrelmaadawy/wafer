import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../../core/presentation/widgets/custom_dropdown_menu.dart';
import '../../../../../core/utils/widgets/app_toast.dart';
import '../../../../../core/utils/widgets/custom_button.dart';
import '../../../../../core/utils/widgets/custom_text_field.dart';
import '../../../../../core/di/service_locator.dart';
import '../../domain/entities/option_value_label_entity.dart';
import '../cubit/edit_unit/unit_edit_cubit.dart';
import '../cubit/edit_unit/unit_edit_state.dart';
import '../widgets/units/edit/unit_edit_shimmer.dart';

class UnitEditScreen extends StatelessWidget {
  final int propertyId;
  final int unitId;

  const UnitEditScreen({
    super.key,
    required this.propertyId,
    required this.unitId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<UnitEditCubit>()..loadData(propertyId, unitId),
      child: _UnitEditScreenContent(unitId: unitId),
    );
  }
}

class _UnitEditScreenContent extends StatefulWidget {
  final int unitId;
  const _UnitEditScreenContent({required this.unitId});

  @override
  State<_UnitEditScreenContent> createState() => _UnitEditScreenContentState();
}

class _UnitEditScreenContentState extends State<_UnitEditScreenContent> {
  final _formKey = GlobalKey<FormState>();

  // Basic
  late TextEditingController _nameController;
  late TextEditingController _unitNumberController;
  late TextEditingController _descriptionController;

  // Dimensions
  late TextEditingController _floorNumberController;
  late TextEditingController _areaController;
  late TextEditingController _roomsController;
  late TextEditingController _bathroomsController;

  // Pricing
  late TextEditingController _rentPriceController;

  // Dropdowns
  String? _selectedUnitType;
  String? _selectedUnitStatus;
  String? _selectedPurpose;
  String? _selectedUsageType;
  String? _selectedFloorType;
  String? _selectedFinishingType;

  // Bools
  bool _isFurnished = false;
  final bool _isCompleted = false;
  bool _isInitialized = false;

  // Media
  final List<File> _newImages = [];
  final List<File> _newVideos = [];
  final List<File> _newFiles = [];
  
  // To keep track of existing media strings
  List<String> _existingImages = [];
  List<String> _existingVideos = [];
  List<String> _existingFiles = [];

  // Assuming for now we just delete by index or we need IDs? 
  // We'll pass some integers, though properly it requires IDs.
  final List<int> _deleteImages = [];
  final List<int> _deleteVideos = [];
  final List<int> _deleteFiles = [];


  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _unitNumberController = TextEditingController();
    _descriptionController = TextEditingController();
    _floorNumberController = TextEditingController();
    _areaController = TextEditingController();
    _roomsController = TextEditingController();
    _bathroomsController = TextEditingController();
    _rentPriceController = TextEditingController();
  }

  void _populateData(UnitEditState state) {
    final unit = state.initialUnit;
    if (unit != null && !_isInitialized) {
      _nameController.text = unit.name ?? '';
      _unitNumberController.text = unit.unitNumber;
      _descriptionController.text = unit.description ?? '';
      _floorNumberController.text = unit.floor ?? '0';
      _areaController.text = unit.area?.toString() ?? '';
      _roomsController.text = unit.roomsCount.toString();
      _bathroomsController.text = unit.bathroomsCount.toString();
      _rentPriceController.text = unit.rentPrice.toString();

      _selectedUnitType = unit.type;
      _selectedUnitStatus = unit.status;
      _selectedUsageType = unit.usageType;
      
      String? p = unit.purpose?.toLowerCase();
      if (p == 'rent') p = 'for_rent';
      if (p == 'sale') p = 'for_sale';
      _selectedPurpose = p;
      
      _selectedFloorType = unit.floorType?.toLowerCase();
      _selectedFinishingType = unit.finishingType?.toLowerCase();
      _isFurnished = unit.isFurnished;
      
      _existingImages = List.from(unit.images);
      _existingVideos = List.from(unit.videos);
      _existingFiles = List.from(unit.attachments);
      
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _unitNumberController.dispose();
    _descriptionController.dispose();
    _floorNumberController.dispose();
    _areaController.dispose();
    _roomsController.dispose();
    _bathroomsController.dispose();
    _rentPriceController.dispose();
    super.dispose();
  }

  void _onSave(BuildContext context) {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_selectedUnitType == null ||
        _selectedUnitStatus == null ||
        _selectedPurpose == null) {
      AppToast.showError(context, 'errorOccurred'.tr());
      return;
    }

    String p = _selectedPurpose!;
    if (p == 'for_rent') p = 'rent';
    if (p == 'for_sale') p = 'sale';

    context.read<UnitEditCubit>().submit(
      unitId: widget.unitId,
      name: _nameController.text,
      unitNumber: _unitNumberController.text,
      unitType: _selectedUnitType!,
      unitStatus: _selectedUnitStatus!,
      purpose: p,
      usageType: _selectedUsageType,
      finishingType: _selectedFinishingType,
      isFurnished: _isFurnished,
      description: _descriptionController.text,
      isCompleted: _isCompleted,
      floorType: _selectedFloorType,
      floorNumber: int.tryParse(_floorNumberController.text),
      area: double.tryParse(_areaController.text) ?? 0.0,
      roomsCount: int.tryParse(_roomsController.text),
      bathroomsCount: int.tryParse(_bathroomsController.text),
      annualRentMonthly: double.tryParse(_rentPriceController.text),
      images: _newImages,
      videos: _newVideos,
      files: _newFiles,
      deleteImages: _deleteImages,
      deleteVideos: _deleteVideos,
      deleteFiles: _deleteFiles,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UnitEditCubit, UnitEditState>(
      listenWhen: (prev, current) =>
          prev.submitError != current.submitError ||
          (prev.isSubmitting && !current.isSubmitting),
      listener: (context, state) {
        if (state.submitError != null) {
          AppToast.showError(context, state.submitError!.message);
        } else if (!state.isSubmitting && state.error == null) {
          AppToast.showSuccess(
              context, LocaleKeys.unitEditSuccess.tr());
          context.pop(true);
        }
      },
      builder: (context, state) {
        if (state.isLoading) {
          return Scaffold(
            appBar: CustomAppBar(
              title: LocaleKeys.unitsEditUnit.tr(),
              onBackPressed: () => context.pop(),
            ),
            body: const UnitEditShimmer(),
          );
        }

        if (state.error != null) {
          return Scaffold(
            appBar: CustomAppBar(
              title: LocaleKeys.unitsEditUnit.tr(),
              onBackPressed: () => context.pop(),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.error!.message),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: 'retry'.tr(),
                    onPressed: () {
                      context.read<UnitEditCubit>().loadData(
                            state.initialUnit?.propertyId ?? 0,
                            widget.unitId,
                          );
                    },
                  ),
                ],
              ),
            ),
          );
        }

        _populateData(state);

        return Scaffold(
          appBar: CustomAppBar(
            title: LocaleKeys.unitsEditUnit.tr(),
            onBackPressed: () => context.pop(),
          ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBasicInfoSection(state),
                  const SizedBox(height: 24),
                  _buildDimensionsSection(),
                  const SizedBox(height: 24),
                  _buildFinancialsSection(),
                  const SizedBox(height: 32),
                  _buildMediaSection(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          bottomNavigationBar: _buildBottomBar(context, state),
        );
      },
    );
  }

  Widget _buildBasicInfoSection(UnitEditState state) {
    final opts = state.formData?.options;
    
    String getLabel(List<OptionValueLabelEntity>? options, String val) {
      if (options == null) return val;
      try {
        return options.firstWhere((e) => e.value == val).label;
      } catch (_) {
        return val;
      }
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          controller: _nameController,
          label: LocaleKeys.unitsUnitNameLabel.tr(),
          validator: (v) => v!.isEmpty ? 'required_field'.tr() : null,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _unitNumberController,
          label: LocaleKeys.unitsUnitNumberLabel.tr(),
          validator: (v) => v!.isEmpty ? 'required_field'.tr() : null,
        ),
        const SizedBox(height: 16),
        CustomDropdownMenu<String>(
          value: _selectedUnitType,
          hint: LocaleKeys.unitsUnitTypeLabel.tr(),
          items: opts?.unitTypes.map((e) => e.value).toList() ?? [],
          itemLabelBuilder: (val) => getLabel(opts?.unitTypes, val),
          onSelected: (v) => setState(() => _selectedUnitType = v),
        ),
        const SizedBox(height: 16),
        CustomDropdownMenu<String>(
          value: _selectedUnitStatus,
          hint: 'unitsStatusLabel'.tr(),
          items: opts?.unitStatuses.map((e) => e.value).toList() ?? [],
          itemLabelBuilder: (val) => getLabel(opts?.unitStatuses, val),
          onSelected: (v) => setState(() => _selectedUnitStatus = v),
        ),
        const SizedBox(height: 16),
        CustomDropdownMenu<String>(
          value: _selectedPurpose,
          hint: LocaleKeys.unitsPurposeLabel.tr(),
          items: const ['for_rent', 'for_sale'],
          itemLabelBuilder: (val) {
            if (val == 'for_rent') return LocaleKeys.unitsPurposeRent.tr();
            if (val == 'for_sale') return LocaleKeys.unitsPurposeSale.tr();
            return val;
          },
          onSelected: (v) => setState(() => _selectedPurpose = v),
        ),
        const SizedBox(height: 16),
        CustomDropdownMenu<String>(
          value: _selectedUsageType,
          hint: LocaleKeys.unitsUsageTypeLabel.tr(),
          items: opts?.usageTypes.map((e) => e.value).toList() ?? [],
          itemLabelBuilder: (val) => getLabel(opts?.usageTypes, val),
          onSelected: (v) => setState(() => _selectedUsageType = v),
        ),
        const SizedBox(height: 16),
        CustomDropdownMenu<String>(
          value: _selectedFloorType,
          hint: LocaleKeys.unitsFloorTypeLabel.tr(),
          items: const ['ground', 'typical', 'roof', 'basement'],
          itemLabelBuilder: (val) {
            switch (val) {
              case 'ground':
                return LocaleKeys.unitsFloorTypeGround.tr();
              case 'typical':
                return LocaleKeys.unitsFloorTypeTypical.tr();
              case 'roof':
                return LocaleKeys.unitsFloorTypeRoof.tr();
              case 'basement':
                return LocaleKeys.unitsFloorTypeBasement.tr();
              default:
                return val;
            }
          },
          onSelected: (v) => setState(() => _selectedFloorType = v),
        ),
        const SizedBox(height: 16),
        CustomDropdownMenu<String>(
          value: _selectedFinishingType,
          hint: LocaleKeys.unitsFinishingTypeLabel.tr(),
          items: const ['finished', 'semi_finished'],
          itemLabelBuilder: (val) => val,
          onSelected: (v) => setState(() => _selectedFinishingType = v),
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          title: Text(LocaleKeys.unitsIsFurnishedLabel.tr()),
          value: _isFurnished,
          onChanged: (v) => setState(() => _isFurnished = v),
          activeThumbColor: context.primaryColor,
        ),
      ],
    );
  }

  Widget _buildDimensionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: _floorNumberController,
                label: LocaleKeys.unitsFloorNumberLabel.tr(),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomTextField(
                controller: _areaController,
                label: LocaleKeys.unitsAreaLabel.tr(),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'required_field'.tr() : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: _roomsController,
                label: LocaleKeys.unitsRoomsCountLabel.tr(),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomTextField(
                controller: _bathroomsController,
                label: LocaleKeys.unitsBathroomsCountLabel.tr(),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFinancialsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          controller: _rentPriceController,
          label: LocaleKeys.unitsAnnualRentMonthlyLabel.tr(),
          keyboardType: TextInputType.number,
          validator: (v) => v!.isEmpty ? 'required_field'.tr() : null,
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context, UnitEditState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: CustomButton(
          text: 'common_save'.tr(),
          isLoading: state.isSubmitting,
          onPressed: () => _onSave(context),
        ),
      ),
    );
  }

  Widget _buildMediaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMediaCategory(
          title: LocaleKeys.unitsImagesTitle.tr(),
          subtitle: LocaleKeys.unitsImagesSubtitle.tr(),
          existing: _existingImages,
          newItems: _newImages,
          onAdd: () async {
            final picker = ImagePicker();
            final pickedFiles = await picker.pickMultiImage();
            if (pickedFiles.isNotEmpty) {
              setState(() {
                _newImages.addAll(pickedFiles.map((f) => File(f.path)));
              });
            }
          },
          onRemoveExisting: (index) {
            setState(() {
              _deleteImages.add(index); // assuming API takes index or it ignores it
              _existingImages.removeAt(index);
            });
          },
          onRemoveNew: (index) {
            setState(() {
              _newImages.removeAt(index);
            });
          },
          icon: Icons.add_photo_alternate_outlined,
          isImage: true,
        ),
        const SizedBox(height: 32),
        _buildMediaCategory(
          title: LocaleKeys.unitsVideosTitle.tr(),
          subtitle: LocaleKeys.unitsVideosSubtitle.tr(),
          existing: _existingVideos,
          newItems: _newVideos,
          onAdd: () async {
            final picker = ImagePicker();
            final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
            if (pickedFile != null) {
              setState(() {
                _newVideos.add(File(pickedFile.path));
              });
            }
          },
          onRemoveExisting: (index) {
            setState(() {
              _deleteVideos.add(index);
              _existingVideos.removeAt(index);
            });
          },
          onRemoveNew: (index) {
            setState(() {
              _newVideos.removeAt(index);
            });
          },
          icon: Icons.video_call_outlined,
          isImage: false,
        ),
        const SizedBox(height: 32),
        _buildMediaCategory(
          title: LocaleKeys.unitsFilesTitle.tr(),
          subtitle: LocaleKeys.unitsFilesSubtitle.tr(),
          existing: _existingFiles,
          newItems: _newFiles,
          onAdd: () async {
            final result = await FilePicker.pickFiles(allowMultiple: true);
            if (result != null) {
              setState(() {
                _newFiles.addAll(result.paths.where((p) => p != null).map((p) => File(p!)));
              });
            }
          },
          onRemoveExisting: (index) {
            setState(() {
              _deleteFiles.add(index);
              _existingFiles.removeAt(index);
            });
          },
          onRemoveNew: (index) {
            setState(() {
              _newFiles.removeAt(index);
            });
          },
          icon: Icons.attach_file_rounded,
          isImage: false,
        ),
      ],
    );
  }

  Widget _buildMediaCategory({
    required String title,
    required String subtitle,
    required List<String> existing,
    required List<File> newItems,
    required VoidCallback onAdd,
    required void Function(int) onRemoveExisting,
    required void Function(int) onRemoveNew,
    required IconData icon,
    required bool isImage,
  }) {
    final totalCount = existing.length + newItems.length;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(subtitle, style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 13)),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: totalCount + 1,
          itemBuilder: (context, index) {
            if (index == totalCount) {
              return InkWell(
                onTap: onAdd,
                borderRadius: AppRadius.circularMd,
                child: Container(
                  decoration: BoxDecoration(
                    color: context.primaryColor.withValues(alpha: 0.05),
                    border: Border.all(
                      color: context.primaryColor.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                    borderRadius: AppRadius.circularLg,
                  ),
                  child: Center(
                    child: Icon(icon, color: context.primaryColor, size: 32),
                  ),
                ),
              );
            }
            
            if (index < existing.length) {
              return _buildMediaItem(
                url: existing[index], 
                onRemove: () => onRemoveExisting(index), 
                isImage: isImage
              );
            } else {
              final newIndex = index - existing.length;
              return _buildMediaItem(
                file: newItems[newIndex], 
                onRemove: () => onRemoveNew(newIndex), 
                isImage: isImage
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildMediaItem({String? url, File? file, required VoidCallback onRemove, required bool isImage}) {
    ImageProvider? imageProvider;
    if (isImage) {
      if (file != null) {
        imageProvider = FileImage(file);
      } else if (url != null) {
        imageProvider = NetworkImage(url);
      }
    }

    String fileName = '';
    if (!isImage) {
      if (file != null) {
        fileName = file.path.split('/').last;
      } else if (url != null) {
        fileName = url.split('/').last;
      }
    }

    final isVideo = fileName.endsWith('.mp4') || fileName.endsWith('.mov') || (url?.contains('.mp4') ?? false);

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.1),
            borderRadius: AppRadius.circularMd,
            image: imageProvider != null ? DecorationImage(image: imageProvider, fit: BoxFit.cover) : null,
          ),
          child: !isImage
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isVideo ? Icons.video_file_outlined : Icons.insert_drive_file_outlined,
                      size: 28,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        fileName,
                        style: const TextStyle(fontSize: 10),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                )
              : null,
        ),
        Positioned(
          top: 4,
          right: 4,
          child: InkWell(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 16, color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }
}
