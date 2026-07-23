import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
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
import '../../../../core/widgets/logo_shimmer_loader.dart';
import '../../../../generated/app_localizations.dart';
import '../cubits/dismissal_auth_cubit.dart';
import '../cubits/dismissal_auth_state.dart';
import '../widgets/auth_glass_shell.dart';

class DismissalLoginPage extends StatefulWidget {
  const DismissalLoginPage({super.key});

  @override
  State<DismissalLoginPage> createState() => _DismissalLoginPageState();
}

class _DismissalLoginPageState extends State<DismissalLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;
  bool _didShowRouteSnackbar = false;

  @override
  void initState() {
    super.initState();
    _loadRememberedCredentials();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didShowRouteSnackbar) return;

    final arguments = ModalRoute.of(context)?.settings.arguments;
    final data = arguments is Map
        ? Map<String, dynamic>.from(arguments)
        : const <String, dynamic>{};
    if (data['showLogoutSuccess'] == true) {
      _didShowRouteSnackbar = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        PremiumSnackbar.success(
          context,
          message: AppLocalizations.of(context)!.auth_logout_success,
        );
      });
    }
  }

  void _submit(BuildContext context) {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<DismissalAuthCubit>().login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  Future<void> _loadRememberedCredentials() async {
    final prefs = sl<SharedPreferences>();
    final secureStorage = sl<FlutterSecureStorage>();
    final shouldRemember = prefs.getBool(StorageKeys.rememberLogin) ?? false;
    if (!shouldRemember) {
      if (mounted) setState(() => _rememberMe = false);
      return;
    }

    final email = prefs.getString(StorageKeys.rememberedEmail) ?? '';
    final password =
        await secureStorage.read(key: StorageKeys.rememberedPassword) ?? '';
    if (!mounted) return;
    setState(() {
      _rememberMe = true;
      _emailController.text = email;
      _passwordController.text = password;
    });
  }

  Future<void> _syncRememberedCredentials() async {
    final prefs = sl<SharedPreferences>();
    final secureStorage = sl<FlutterSecureStorage>();
    if (_rememberMe) {
      await prefs.setBool(StorageKeys.rememberLogin, true);
      await prefs.setString(
        StorageKeys.rememberedEmail,
        _emailController.text.trim(),
      );
      await secureStorage.write(
        key: StorageKeys.rememberedPassword,
        value: _passwordController.text,
      );
      return;
    }

    await prefs.setBool(StorageKeys.rememberLogin, false);
    await prefs.remove(StorageKeys.rememberedEmail);
    await secureStorage.delete(key: StorageKeys.rememberedPassword);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (_) => sl<DismissalAuthCubit>(),
      child: BlocConsumer<DismissalAuthCubit, DismissalAuthState>(
        listener: (context, state) async {
          if (state is DismissalAuthSuccess) {
            await _syncRememberedCredentials();
            if (!context.mounted) return;
            PremiumSnackbar.success(context, message: l10n.auth_login_success);
            await Future<void>.delayed(const Duration(milliseconds: 650));
            if (!context.mounted) return;
            if (state.session.mustChangePassword) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.changePassword,
                (route) => false,
                arguments: const {'mandatory': true},
              );
              return;
            }
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
          return AuthGlassShell(
            backgroundImagePath: AppAssets.onboarding_1,
            title: l10n.authLoginTitle,
            subtitle: l10n.authLoginSubtitle,
            centerContent: true,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AbsorbPointer(
                  absorbing: isLoading,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 180),
                    opacity: isLoading ? 0.38 : 1,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            controller: _emailController,
                            label: l10n.authEmailLabel,
                            keyboardType: TextInputType.emailAddress,
                            prefix: const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: FaIcon(
                                FontAwesomeIcons.envelope,
                                size: 18,
                              ),
                            ),
                            fillColor: Colors.white.withValues(alpha: 0.2),
                            enabled: !isLoading,
                            validator: (value) {
                              final input = (value ?? '').trim();
                              if (input.isEmpty) {
                                return l10n.fieldRequired;
                              }
                              if (!input.contains('@')) {
                                return l10n.authEmailInvalid;
                              }
                              return null;
                            },
                          ),
                          AppSpacing.verticalSpaceMd,
                          CustomTextField(
                            controller: _passwordController,
                            label: l10n.authPasswordLabel,
                            obscureText: _obscurePassword,
                            prefix: const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: FaIcon(FontAwesomeIcons.lock, size: 18),
                            ),
                            fillColor: Colors.white.withValues(alpha: 0.2),
                            enabled: !isLoading,
                            suffix: IconButton(
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                            validator: (value) => (value ?? '').length < 6
                                ? l10n.authPasswordInvalid
                                : null,
                          ),
                          AppSpacing.verticalSpaceSm,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: isLoading
                                    ? null
                                    : () {
                                        setState(
                                          () => _rememberMe = !_rememberMe,
                                        );
                                      },
                                child: Icon(
                                  _rememberMe
                                      ? Icons.check_circle
                                      : Icons.circle_outlined,
                                  color: AppColors.primary,
                                  size: 24,
                                ),
                              ),
                              AppSpacing.horizontalSpaceXs,
                              Text(
                                l10n.auth_remember_me,
                                style: AppTypography.labelLarge.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          AppSpacing.verticalSpaceMd,
                          SizedBox(
                            width: double.infinity,
                            child: CustomButton(
                              text: l10n.authLoginButton,
                              isLoading: false,
                              height: 45,
                              onPressed: isLoading
                                  ? null
                                  : () => _submit(context),
                            ),
                          ),
                          AppSpacing.verticalSpaceMd,
                          Row(
                            children: [
                              const Icon(
                                Iconsax.shield_tick,
                                size: 16,
                                color: AppColors.primary,
                              ),
                              AppSpacing.horizontalSpaceXs,
                              Expanded(
                                child: Text(
                                  l10n.authStaffOnlyHint,
                                  style: AppTypography.caption.copyWith(
                                    color: AppColors.primaryDeep,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (isLoading) const _LoginLoadingOverlay(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _LoginLoadingOverlay extends StatelessWidget {
  const _LoginLoadingOverlay();

  @override
  Widget build(BuildContext context) {
    return const Center(child: LogoShimmerLoader(size: 92));
  }
}
