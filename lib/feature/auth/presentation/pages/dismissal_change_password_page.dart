import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/storage_keys.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/common/custom_button.dart';
import '../../../../core/utils/common/custom_text_field.dart';
import '../../../../core/utils/feedback/premium_snackbar.dart';
import '../../../../core/utils/helper/on_genrated_routes.dart';
import '../../../../core/validators/password_validator.dart';
import '../../../../core/widgets/logo_shimmer_loader.dart';
import '../../../../generated/app_localizations.dart';
import '../cubits/dismissal_auth_cubit.dart';
import '../cubits/dismissal_auth_state.dart';
import '../widgets/auth_glass_shell.dart';

class DismissalChangePasswordPage extends StatefulWidget {
  const DismissalChangePasswordPage({super.key, this.mandatory = false});

  final bool mandatory;

  @override
  State<DismissalChangePasswordPage> createState() =>
      _DismissalChangePasswordPageState();
}

class _DismissalChangePasswordPageState
    extends State<DismissalChangePasswordPage> {
  static const _rules = PasswordValidationRules(
    checkCommonPatterns: false,
    checkSequentialChars: false,
    checkRepeatedChars: false,
    checkKeyboardPatterns: false,
  );

  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final currentPassword = _currentPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (newPassword != confirmPassword) {
      PremiumSnackbar.error(
        context,
        message: AppLocalizations.of(context)!.auth_change_password_mismatch,
      );
      return;
    }

    if (currentPassword == newPassword) {
      PremiumSnackbar.error(
        context,
        message: AppLocalizations.of(context)!.auth_change_password_same_as_old,
      );
      return;
    }

    context.read<DismissalAuthCubit>().changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (_) => sl<DismissalAuthCubit>(),
      child: BlocConsumer<DismissalAuthCubit, DismissalAuthState>(
        listener: (context, state) async {
          if (state is DismissalAuthPasswordChanged) {
            await _syncRememberedPasswordAfterChange();
            if (!context.mounted) return;
            PremiumSnackbar.success(
              context,
              message: l10n.auth_change_password_success,
            );
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.root,
              (route) => false,
            );
          } else if (state is DismissalAuthFailure) {
            PremiumSnackbar.error(
              context,
              message: state.failure.getLocalizedMessage(context),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is DismissalAuthLoading;

          return PopScope(
            canPop: !widget.mandatory && !isLoading,
            child: AuthGlassShell(
              backgroundImagePath: AppAssets.onboarding_2,
              centerContent: true,
              showBackButton: !widget.mandatory,
              title: l10n.auth_change_password_title,
              subtitle: widget.mandatory
                  ? l10n.auth_change_password_mandatory_subtitle
                  : l10n.auth_change_password_optional_subtitle,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _PasswordField(
                          controller: _currentPasswordController,
                          label: l10n.auth_change_password_current,
                          obscureText: _obscureCurrentPassword,
                          enabled: !isLoading,
                          onToggle: () => setState(
                            () => _obscureCurrentPassword =
                                !_obscureCurrentPassword,
                          ),
                          validator: (value) => (value ?? '').trim().isEmpty
                              ? l10n.fieldRequired
                              : null,
                        ),
                        AppSpacing.verticalSpaceMd,
                        _PasswordField(
                          controller: _newPasswordController,
                          label: l10n.auth_change_password_new,
                          obscureText: _obscureNewPassword,
                          enabled: !isLoading,
                          onToggle: () => setState(
                            () => _obscureNewPassword = !_obscureNewPassword,
                          ),
                          validator: (value) =>
                              PasswordValidator.validateWithRules(
                                value,
                                _rules,
                              ).isValid
                              ? null
                              : l10n.auth_change_password_rules,
                        ),

                        AppSpacing.verticalSpaceMd,
                        _PasswordField(
                          controller: _confirmPasswordController,
                          label: l10n.auth_change_password_confirm,
                          obscureText: _obscureConfirmPassword,
                          enabled: !isLoading,
                          onToggle: () => setState(
                            () => _obscureConfirmPassword =
                                !_obscureConfirmPassword,
                          ),
                          validator: (value) => (value ?? '').trim().isEmpty
                              ? l10n.fieldRequired
                              : null,
                        ),
                        AppSpacing.verticalSpaceLg,
                        Text(
                          l10n.auth_change_password_hint,
                          style: AppTypography.caption.copyWith(
                            color: AppColors.primaryDeep.withValues(
                              alpha: 0.75,
                            ),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        AppSpacing.verticalSpaceLg,
                        SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            text: l10n.auth_change_password_save,
                            isLoading: false,
                            onPressed: isLoading
                                ? null
                                : () => _submit(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isLoading) const LogoShimmerLoader(size: 120),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _syncRememberedPasswordAfterChange() async {
    final prefs = sl<SharedPreferences>();
    final shouldRemember = prefs.getBool(StorageKeys.rememberLogin) ?? false;
    if (!shouldRemember) return;

    await sl<FlutterSecureStorage>().write(
      key: StorageKeys.rememberedPassword,
      value: _newPasswordController.text,
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.controller,
    required this.label,
    required this.obscureText,
    required this.enabled,
    required this.onToggle,
    required this.validator,
  });

  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final bool enabled;
  final VoidCallback onToggle;
  final String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      label: label,
      fillColor: Colors.white.withValues(alpha: 0.2),
      obscureText: obscureText,
      enabled: enabled,
      prefix: const Padding(
        padding: EdgeInsets.all(12),
        child: FaIcon(FontAwesomeIcons.lock, size: 18),
      ),
      suffix: IconButton(
        onPressed: enabled ? onToggle : null,
        icon: Icon(
          obscureText
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
        ),
      ),
      validator: validator,
    );
  }
}
