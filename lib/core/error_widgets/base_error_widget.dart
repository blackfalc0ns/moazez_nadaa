import 'package:ndaaa_chat/core/theme/app_colors.dart';
import 'package:ndaaa_chat/core/utils/common/custom_button.dart';
import 'package:flutter/material.dart';

import '../../generated/app_localizations.dart';

class BaseErrorWidget extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback? onRetry;
  final VoidCallback? onSecondaryAction;
  final String? secondaryActionText;
  final Color? primaryColor;

  const BaseErrorWidget({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.onRetry,
    this.onSecondaryAction,
    this.secondaryActionText,
    this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: (primaryColor ?? colorScheme.error).withValues(
                    alpha: 0.1,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 64,
                  color: primaryColor ?? colorScheme.error,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                title.isEmpty ? 'Error' : title,
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDeep,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                description,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimaryLight.withValues(alpha: 0.8),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              if (onRetry != null) ...[
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    onPressed: onRetry,
                    text: getRetryButtonText(context),
                  ),
                ),
              ],
              if (onSecondaryAction != null && secondaryActionText != null) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    onPressed: onSecondaryAction,
                    text: secondaryActionText!,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String getRetryButtonText(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n != null && l10n.retry.isNotEmpty) {
      return l10n.retry;
    }
    return 'إعادة المحاولة'; // Fallback to Arabic 'Retry'
  }
}
