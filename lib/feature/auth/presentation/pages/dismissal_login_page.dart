import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/widgets/logo_shimmer_loader.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/common/custom_button.dart';
import '../../../../core/utils/common/custom_text_field.dart';
import '../../../../core/utils/feedback/premium_snackbar.dart';
import '../../../../core/utils/helper/on_genrated_routes.dart';
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
          return AuthGlassShell(
            backgroundImagePath: AppAssets.onboarding_1,
            title: l10n.authLoginTitle,
            subtitle: l10n.authLoginSubtitle,
            centerContent: true,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Form(
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
                          child: FaIcon(FontAwesomeIcons.envelope, size: 18),
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
                        validator: (value) =>
                            (value ?? '').length < 6
                                ? l10n.authPasswordInvalid
                                : null,
                      ),
                      AppSpacing.verticalSpaceLg,
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          text: l10n.authLoginButton,
                          isLoading: false, // We use the center shimmer now
                          onPressed: isLoading ? null : () => _submit(context),
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
                if (isLoading)
                  const Center(
                    child: LogoShimmerLoader(size: 120),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
