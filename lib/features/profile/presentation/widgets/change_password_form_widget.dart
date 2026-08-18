import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/localization/locale_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/color_utils.dart';
import '../../../../core/utils/widgets/app_toast.dart';
import '../cubit/change_password_cubit.dart';
import '../cubit/change_password_state.dart';
import '../../../../features/auth/presentation/cubit/auth_cubit.dart';

class ChangePasswordFormWidget extends StatefulWidget {
  final bool isForced;
  const ChangePasswordFormWidget({super.key, this.isForced = false});

  @override
  State<ChangePasswordFormWidget> createState() =>
      _ChangePasswordFormWidgetState();
}

class _ChangePasswordFormWidgetState extends State<ChangePasswordFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus();
      context.read<ChangePasswordCubit>().changePassword(
        currentPassword: _currentController.text.trim(),
        newPassword: _newController.text.trim(),
        newPasswordConfirmation: _confirmController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
      listener: (context, state) {
        if (state is ChangePasswordSuccess) {
          AppToast.showSuccess(
            context,
            LocaleKeys.profile_change_password_success.tr(),
          );
          if (widget.isForced) {
            context.read<AuthCubit>().confirmPasswordChanged();
          } else {
            context.read<AuthCubit>().confirmPasswordChanged();
            Navigator.pop(context);
          }
        } else if (state is ChangePasswordError) {
          AppToast.showError(context, state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is ChangePasswordLoading;
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildPasswordField(
                controller: _currentController,
                label: LocaleKeys.profile_change_password_current.tr(),
                obscure: _obscureCurrent,
                onToggle: () =>
                    setState(() => _obscureCurrent = !_obscureCurrent),
                validator: (val) => val == null || val.trim().isEmpty
                    ? LocaleKeys.profile_change_password_val_required.tr()
                    : null,
              ),
              const SizedBox(height: 16),
              _buildPasswordField(
                controller: _newController,
                label: LocaleKeys.profile_change_password_new.tr(),
                obscure: _obscureNew,
                onToggle: () => setState(() => _obscureNew = !_obscureNew),
                onChanged: (_) => setState(() {}),
                validator: _validateNewPassword,
              ),
              const SizedBox(height: 16),
              _buildPasswordField(
                controller: _confirmController,
                label: LocaleKeys.profile_change_password_confirm.tr(),
                obscure: _obscureConfirm,
                onToggle: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
                onChanged: (_) => setState(() {}),
                validator: _validateConfirmPassword,
              ),
              const SizedBox(height: 20),
              _buildCriteriaSection(),
              const SizedBox(height: 32),
              _buildSubmitButton(isLoading),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback onToggle,
    ValueChanged<String>? onChanged,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      onChanged: onChanged,
      validator: validator,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14.5),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          Icons.lock_outline_rounded,
          color: context.primaryColor,
          size: 22,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: AppColors.textSecondaryLight,
            size: 20,
          ),
          onPressed: onToggle,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: AppRadius.circularXl,
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.circularXl,
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.circularXl,
          borderSide: BorderSide(color: context.primaryColor, width: 2),
        ),
      ),
    );
  }

  String? _validateNewPassword(String? val) {
    if (val == null || val.trim().isEmpty) {
      return LocaleKeys.profile_change_password_val_required.tr();
    }
    if (val.trim().length < 8) {
      return LocaleKeys.profile_change_password_req_min.tr();
    }
    if (val.trim() == _currentController.text.trim() &&
        _currentController.text.isNotEmpty) {
      return LocaleKeys.profile_change_password_val_diff.tr();
    }
    return null;
  }

  String? _validateConfirmPassword(String? val) {
    if (val == null || val.trim().isEmpty) {
      return LocaleKeys.profile_change_password_val_required.tr();
    }
    if (val.trim() != _newController.text.trim()) {
      return LocaleKeys.profile_change_password_val_mismatch.tr();
    }
    return null;
  }

  Widget _buildCriteriaSection() {
    final newPass = _newController.text.trim();
    final confirmPass = _confirmController.text.trim();
    final hasMin = newPass.length >= 8;
    final hasNum = newPass.contains(RegExp(r'[0-9]'));
    final isMatch = newPass.isNotEmpty && newPass == confirmPass;

    return Column(
      children: [
        _buildPill(LocaleKeys.profile_change_password_req_min.tr(), hasMin),
        const SizedBox(height: 8),
        _buildPill(LocaleKeys.profile_change_password_req_num.tr(), hasNum),
        const SizedBox(height: 8),
        _buildPill(LocaleKeys.profile_change_password_req_match.tr(), isMatch),
      ],
    );
  }

  Widget _buildPill(String text, bool met) {
    final color = met ? AppColors.success : AppColors.textSecondaryLight;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: met
            ? AppColors.success.withValues(alpha: 0.08)
            : AppColors.surfaceLight,
        borderRadius: AppRadius.circularLg,
        border: Border.all(
          color: met
              ? AppColors.success.withValues(alpha: 0.3)
              : AppColors.borderLight,
        ),
      ),
      child: Row(
        children: [
          Icon(
            met
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            size: 18,
            color: color,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: met ? FontWeight.bold : FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(bool isLoading) {
    return ElevatedButton(
      onPressed: isLoading ? null : _submit,
      style: ElevatedButton.styleFrom(
        backgroundColor: context.primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.circularXl),
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
              LocaleKeys.profile_change_password_btn.tr(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
    );
  }
}
