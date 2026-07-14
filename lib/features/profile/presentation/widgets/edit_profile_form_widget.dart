import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/localization/locale_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/color_utils.dart';
import '../../../../core/utils/widgets/app_toast.dart';
import '../../domain/entities/profile_entity.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import 'edit_profile_inputs.dart';

class EditProfileFormWidget extends StatefulWidget {
  final ProfileEntity profile;

  const EditProfileFormWidget({super.key, required this.profile});

  @override
  State<EditProfileFormWidget> createState() => _EditProfileFormWidgetState();
}

class _EditProfileFormWidgetState extends State<EditProfileFormWidget> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late String _gender;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _phoneController = TextEditingController(text: widget.profile.phone);
    _gender = widget.profile.gender.isNotEmpty ? widget.profile.gender : 'male';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus();
      context.read<ProfileCubit>().updateProfile(
            name: _nameController.text.trim(),
            phone: _phoneController.text.trim(),
            gender: _gender,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileUpdateSuccess) {
          AppToast.showSuccess(context, LocaleKeys.profileUpdateSuccess.tr());
          Navigator.pop(context);
        } else if (state is ProfileUpdateError) {
          AppToast.showError(context, state.errorMessage);
        } else if (state is ProfileError) {
          AppToast.showError(context, state.message);
        }
      },
      builder: (context, state) {
        final isUpdating = state is ProfileUpdating;

        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProfileTextField(
                controller: _nameController,
                label: LocaleKeys.profileFullNameLabel.tr(),
                icon: Icons.person_outline_rounded,
                validator: (val) => val == null || val.trim().isEmpty ? LocaleKeys.profileFullNameValidation.tr() : null,
              ),
              const SizedBox(height: 18),
              ProfileTextField(
                controller: _phoneController,
                label: LocaleKeys.profilePhoneLabel.tr(),
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (val) => val == null || val.trim().length < 9 ? LocaleKeys.profilePhoneValidation.tr() : null,
              ),
              const SizedBox(height: 20),
              Text(LocaleKeys.profileGenderLabel.tr(), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimaryLight)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ProfileGenderCard(
                      value: 'male',
                      currentGender: _gender,
                      label: LocaleKeys.profileGenderMale.tr(),
                      icon: Icons.male_rounded,
                      onSelect: (val) => setState(() => _gender = val),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: ProfileGenderCard(
                      value: 'female',
                      currentGender: _gender,
                      label: LocaleKeys.profileGenderFemale.tr(),
                      icon: Icons.female_rounded,
                      onSelect: (val) => setState(() => _gender = val),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 36),
              _buildSubmitButton(context, isUpdating),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSubmitButton(BuildContext context, bool isUpdating) {
    return ElevatedButton(
      onPressed: isUpdating ? null : _submit,
      style: ElevatedButton.styleFrom(
        backgroundColor: context.primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.circularXl),
        elevation: 4,
        shadowColor: context.primaryShadow,
      ),
      child: isUpdating
          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
          : Text(LocaleKeys.profileSaveChanges.tr(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }
}
