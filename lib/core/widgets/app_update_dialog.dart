import 'package:flutter/material.dart';
import 'package:ndaaa_chat/core/di/injection_container.dart';
import 'package:ndaaa_chat/core/services/app_update/app_update_service.dart';
import 'package:ndaaa_chat/core/utils/feedback/premium_snackbar.dart';
import 'package:ndaaa_chat/generated/app_localizations.dart';

class AppUpdateDialog {
  const AppUpdateDialog._();

  static Future<bool> show(
    BuildContext context, {
    required AppUpdateInfo update,
  }) async {
    final result = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'app-update',
      barrierColor: Colors.black.withValues(alpha: 0.62),
      transitionDuration: const Duration(milliseconds: 320),
      pageBuilder: (_, _, _) => _UpdateDialogBody(update: update),
      transitionBuilder: (_, animation, _, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
          reverseCurve: Curves.easeInCubic,
        );
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(scale: curved, child: child),
        );
      },
    );
    return result ?? false;
  }
}

class _UpdateDialogBody extends StatefulWidget {
  const _UpdateDialogBody({required this.update});

  final AppUpdateInfo update;

  @override
  State<_UpdateDialogBody> createState() => _UpdateDialogBodyState();
}

class _UpdateDialogBodyState extends State<_UpdateDialogBody> {
  bool _openingStore = false;

  Future<void> _openStore() async {
    if (_openingStore) return;
    setState(() => _openingStore = true);
    final opened = await sl<AppUpdateService>().openStore(widget.update);
    if (!mounted) return;
    setState(() => _openingStore = false);
    if (!opened) {
      PremiumSnackbar.error(
        context,
        message: AppLocalizations.of(context)!.app_update_store_error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final update = widget.update;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final languageCode = Localizations.localeOf(context).languageCode;
    final releaseNotes = update.releaseNotesFor(languageCode);
    final accent = update.isRequired ? Colors.orange : colorScheme.secondary;

    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.sizeOf(context).width.clamp(0, 410).toDouble(),
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.14),
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.2),
                    blurRadius: 35,
                    offset: const Offset(0, 18),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          accent.withValues(alpha: 0.22),
                          accent.withValues(alpha: 0.07),
                        ],
                      ),
                      border: Border.all(color: accent.withValues(alpha: 0.28)),
                    ),
                    child: Icon(
                      update.isRequired
                          ? Icons.lock_reset_rounded
                          : Icons.rocket_launch_rounded,
                      size: 36,
                      color: accent,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    update.isRequired
                        ? l10n.app_update_required_title
                        : l10n.app_update_available_title,
                    textAlign: TextAlign.center,
                    style: textTheme.titleLarge?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    update.isRequired
                        ? l10n.app_update_required_description
                        : l10n.app_update_available_description,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      l10n.app_update_current_version(update.currentVersion),
                      style: textTheme.labelMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (releaseNotes.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        releaseNotes,
                        textAlign: TextAlign.start,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton.icon(
                      onPressed: _openingStore ? null : _openStore,
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: _openingStore
                          ? const SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.system_update_alt_rounded),
                      label: Text(
                        l10n.app_update_now,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                  if (!update.isRequired) ...[
                    const SizedBox(height: 6),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(
                        l10n.app_update_later,
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
