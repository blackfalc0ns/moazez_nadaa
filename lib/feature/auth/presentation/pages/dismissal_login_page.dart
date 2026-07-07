import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/common/custom_button.dart';
import '../../../../core/utils/common/custom_text_field.dart';
import '../../../../core/utils/feedback/premium_snackbar.dart';
import '../../../../core/utils/helper/on_genrated_routes.dart';
import '../../../../generated/app_localizations.dart';
import '../cubits/dismissal_auth_cubit.dart';
import '../cubits/dismissal_auth_state.dart';

class DismissalLoginPage extends StatefulWidget {
  const DismissalLoginPage({super.key});

  @override
  State<DismissalLoginPage> createState() => _DismissalLoginPageState();
}

class _DismissalLoginPageState extends State<DismissalLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<DismissalAuthCubit>().login(
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (_) => sl<DismissalAuthCubit>(),
      child: BlocConsumer<DismissalAuthCubit, DismissalAuthState>(
        listener: (context, state) {
          if (state is DismissalAuthSuccess) {
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
          return Scaffold(
            body: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(AppAssets.onboarding_1, fit: BoxFit.cover),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.primaryDeep.withValues(alpha: 0.34),
                        AppColors.primaryDeep.withValues(alpha: 0.58),
                      ],
                    ),
                  ),
                ),
                SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: ClipRRect(
                        borderRadius: AppRadius.all(AppRadius.radius7),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 430),
                            padding: const EdgeInsets.all(AppSpacing.xl),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.88),
                              borderRadius: AppRadius.all(AppRadius.radius7),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.14),
                                  blurRadius: 30,
                                  offset: const Offset(0, 14),
                                ),
                              ],
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: SvgPicture.asset(
                                      AppAssets.logo,
                                      height: 54,
                                    ),
                                  ),
                                  AppSpacing.verticalSpaceLg,
                                  Text(
                                    l10n.authLoginTitle,
                                    style: AppTypography.heading3.copyWith(
                                      color: AppColors.primaryDeep,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  AppSpacing.verticalSpaceXs,
                                  Text(
                                    l10n.authLoginSubtitle,
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.textSecondaryLight,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  AppSpacing.verticalSpaceLg,
                                  CustomTextField(
                                    controller: _emailController,
                                    label: l10n.authEmailLabel,
                                    keyboardType: TextInputType.emailAddress,
                                    prefix: const Icon(Iconsax.sms),
                                    fillColor: Colors.white.withValues(
                                      alpha: 0.76,
                                    ),
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
                                    prefix: const Icon(Iconsax.lock_1),
                                    suffix: IconButton(
                                      onPressed: () => setState(
                                        () => _obscurePassword =
                                            !_obscurePassword,
                                      ),
                                      icon: Icon(
                                        _obscurePassword
                                            ? Iconsax.eye
                                            : Iconsax.eye_slash,
                                      ),
                                    ),
                                    fillColor: Colors.white.withValues(
                                      alpha: 0.76,
                                    ),
                                    validator: (value) =>
                                        (value ?? '').length < 6
                                        ? l10n.authPasswordInvalid
                                        : null,
                                  ),
                                  AppSpacing.verticalSpaceLg,
                                  CustomButton(
                                    width: double.infinity,
                                    text: l10n.authLoginButton,
                                    isLoading: isLoading,
                                    onPressed: () => _submit(context),
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
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
