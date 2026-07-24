import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/localization/locale_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/color_utils.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key});

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().login(
            username: _usernameController.text.trim(),
            password: _passwordController.text,
            deviceName: 'iPhone/Android Device',
            deviceToken: 'fcm_token_placeholder',
            rememberMe: _rememberMe,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(controller: _usernameController, hint: LocaleKeys.authUsernameLabel.tr(), icon: Icons.person_outline_rounded, keyboardType: TextInputType.emailAddress, validator: (v) => (v == null || v.trim().isEmpty) ? LocaleKeys.authUsernameValidation.tr() : null),
              const SizedBox(height: 14),
              _buildPasswordField(context),
              const SizedBox(height: 14),
              _buildRememberMeRow(context),
              const SizedBox(height: 24),
              _buildSubmitButton(context, isLoading),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String hint, required IconData icon, TextInputType keyboardType = TextInputType.text, String? Function(String?)? validator}) => TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        decoration: _inputDeco(context, hint: hint, prefixIcon: icon),
      );

  Widget _buildPasswordField(BuildContext context) => TextFormField(
        controller: _passwordController,
        obscureText: _obscurePassword,
        validator: (v) {
          if (v == null || v.isEmpty) return LocaleKeys.authPasswordValidation.tr();
          if (v.length < 6) return LocaleKeys.authPasswordMinLength.tr();
          return null;
        },
        decoration: _inputDeco(context, hint: LocaleKeys.authPasswordLabel.tr(), prefixIcon: Icons.lock_outline_rounded, suffix: IconButton(icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20, color: const Color(0xFF94A3B8)), onPressed: () => setState(() => _obscurePassword = !_obscurePassword))),
      );

  InputDecoration _inputDeco(BuildContext context, {required String hint, required IconData prefixIcon, Widget? suffix}) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFB0B8CC), fontSize: 13.5),
        prefixIcon: Icon(prefixIcon, color: const Color(0xFF8A97B0), size: 20),
        suffixIcon: suffix,
        filled: true,
        fillColor: const Color(0xFFF7F8FC),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE4E9F2))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE4E9F2))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: context.primaryColor, width: 1.5)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.error)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.error, width: 1.5)),
      );

  Widget _buildRememberMeRow(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => setState(() => _rememberMe = !_rememberMe),
            child: Row(children: [
              SizedBox(height: 20, width: 20, child: Checkbox(value: _rememberMe, activeColor: context.primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)), side: const BorderSide(color: Color(0xFFCCD3E0)), onChanged: (val) => setState(() => _rememberMe = val ?? true))),
              const SizedBox(width: 8),
              Text(LocaleKeys.authRememberMe.tr(), style: const TextStyle(color: Color(0xFF4B5563), fontSize: 13, fontWeight: FontWeight.w500)),
            ]),
          ),
          TextButton(onPressed: () {}, style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 0), tapTargetSize: MaterialTapTargetSize.shrinkWrap), child: Text(LocaleKeys.authForgotPassword.tr(), style: TextStyle(color: context.primaryColor, fontSize: 13, fontWeight: FontWeight.w600))),
        ],
      );

  Widget _buildSubmitButton(BuildContext context, bool isLoading) => DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: isLoading ? null : LinearGradient(colors: [context.primaryColor, context.primaryLight], begin: Alignment.centerRight, end: Alignment.centerLeft),
          boxShadow: isLoading ? [] : [BoxShadow(color: context.primaryShadow, blurRadius: 16, offset: const Offset(0, 6))],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : _submit,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, disabledBackgroundColor: const Color(0xFFE4E9F2), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), minimumSize: const Size(double.infinity, 52)),
          child: isLoading ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation(Colors.white))) : Text(LocaleKeys.authLoginBtn.tr(), style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
        ),
      );
}
