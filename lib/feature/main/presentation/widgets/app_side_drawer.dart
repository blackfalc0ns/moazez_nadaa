import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/permissions/app_permission.dart';
import '../../../../core/permissions/permission_repository.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/helper/on_genrated_routes.dart';
import '../../../../core/utils/navigation/custom_bottom_nav_bar.dart';
import '../../../../generated/app_localizations.dart';
import '../../../auth/data/repositories/dismissal_auth_repo.dart';

class AppSideDrawer extends StatelessWidget {
  const AppSideDrawer({
    super.key,
    required this.selectedTarget,
    required this.availableTargets,
    required this.onTabSelected,
  });

  final DismissalNavigationTarget selectedTarget;
  final List<DismissalNavigationTarget> availableTargets;
  final ValueChanged<DismissalNavigationTarget> onTabSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final permissions = sl<PermissionRepository>();
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Drawer(
      width: screenWidth > 420 ? 304 : screenWidth * 0.76,
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.94),
            border: BorderDirectional(
              end: BorderSide(
                color: Colors.white.withValues(alpha: 0.55),
                width: 1.2,
              ),
            ),
            boxShadow: AppShadows.xl,
          ),
          child: Column(
            children: [
              _DrawerHeader(l10n: l10n),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.sm,
                  ),
                  children: [
                    _SectionLabel(l10n.drawerDailyWork),
                    if (_hasTarget(DismissalNavigationTarget.calls))
                      _DrawerItem(
                        icon: Iconsax.direct_notification,
                        title: l10n.drawerCallsBoard,
                        subtitle: l10n.drawerCallsBoardSubtitle,
                        selected:
                            selectedTarget == DismissalNavigationTarget.calls,
                        onTap: () => _selectTab(
                          context,
                          DismissalNavigationTarget.calls,
                        ),
                      ),
                    if (_hasTarget(DismissalNavigationTarget.waiting))
                      _DrawerItem(
                        icon: Iconsax.profile_2user,
                        title: l10n.drawerWaiting,
                        subtitle: l10n.drawerWaitingSubtitle,
                        selected:
                            selectedTarget == DismissalNavigationTarget.waiting,
                        onTap: () => _selectTab(
                          context,
                          DismissalNavigationTarget.waiting,
                        ),
                      ),
                    if (_hasTarget(DismissalNavigationTarget.gates))
                      _DrawerItem(
                        icon: Iconsax.location_tick,
                        title: l10n.drawerGates,
                        subtitle: l10n.drawerGatesSubtitle,
                        selected:
                            selectedTarget == DismissalNavigationTarget.gates,
                        onTap: () => _selectTab(
                          context,
                          DismissalNavigationTarget.gates,
                        ),
                      ),
                    if (permissions.has(AppPermission.viewHistory))
                      _DrawerItem(
                        icon: Iconsax.receipt_search,
                        title: l10n.drawerCallsHistory,
                        subtitle: l10n.drawerCallsHistorySubtitle,
                        onTap: () => _openRoute(context, Routes.callsHistory),
                      ),
                    const _SectionDivider(),
                    _SectionLabel(l10n.drawerAccountSafety),
                    if (permissions.has(AppPermission.viewProfile))
                      _DrawerItem(
                        icon: Iconsax.user_octagon,
                        title: l10n.drawerProfile,
                        subtitle: l10n.drawerProfileSubtitle,
                        onTap: () => _openRoute(context, Routes.profile),
                      ),
                    if (permissions.has(AppPermission.viewNotifications))
                      _DrawerItem(
                        icon: Iconsax.notification_status,
                        title: l10n.drawerNotifications,
                        subtitle: l10n.drawerNotificationsSubtitle,
                        onTap: () => _openRoute(context, Routes.notifications),
                      ),
                    _DrawerItem(
                      icon: Iconsax.setting_2,
                      title: l10n.drawerSettings,
                      subtitle: l10n.drawerSettingsSubtitle,
                      onTap: () => _openRoute(context, Routes.settings),
                    ),
                    const _SectionDivider(),
                    _SectionLabel(l10n.drawerSupportLegal),
                    _DrawerItem(
                      icon: Iconsax.message_question,
                      title: l10n.drawerHelp,
                      subtitle: l10n.drawerHelpSubtitle,
                      onTap: () => Navigator.pop(context),
                    ),
                    _DrawerItem(
                      icon: Iconsax.document_text,
                      title: l10n.drawerTerms,
                      subtitle: l10n.drawerTermsSubtitle,
                      onTap: () => Navigator.pop(context),
                    ),
                    _DrawerItem(
                      icon: Iconsax.lock_1,
                      title: l10n.drawerPrivacy,
                      subtitle: l10n.drawerPrivacySubtitle,
                      onTap: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              _DrawerFooter(l10n: l10n),
            ],
          ),
        ),
      ),
    );
  }

  bool _hasTarget(DismissalNavigationTarget target) {
    return availableTargets.contains(target);
  }

  void _selectTab(BuildContext context, DismissalNavigationTarget target) {
    Navigator.pop(context);
    onTabSelected(target);
  }

  void _openRoute(BuildContext context, String routeName) {
    Navigator.pop(context);
    Navigator.pushNamed(context, routeName);
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.paddingOf(context).top + 18,
        20,
        20,
      ),
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadiusDirectional.only(
          bottomEnd: Radius.circular(28),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: SvgPicture.asset(
              AppAssets.logo,
              height: 34,
              alignment: AlignmentDirectional.centerStart,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.14),
            ),
            icon: const Icon(Icons.close_rounded, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8, 10, 8, 8),
      child: Text(
        text,
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.textSecondaryLight,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 28,
      color: AppColors.primary.withValues(alpha: 0.08),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.selected = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.primaryDeep;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Material(
        color: selected
            ? AppColors.primary.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: AppRadius.all(AppRadius.radius5),
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.all(AppRadius.radius5),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: 10,
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(
                      alpha: selected ? 0.14 : 0.07,
                    ),
                    borderRadius: AppRadius.all(AppRadius.radius3),
                  ),
                  child: Icon(icon, color: color, size: 19),
                ),
                AppSpacing.horizontalSpaceSm,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTypography.bodyMedium.copyWith(
                          color: color,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textSecondaryLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DrawerFooter extends StatelessWidget {
  const _DrawerFooter({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Material(
          color: AppColors.error.withValues(alpha: 0.08),
          borderRadius: AppRadius.all(AppRadius.radius3),
          child: InkWell(
            onTap: () async {
              Navigator.pop(context);
              await sl<DismissalAuthRepo>().logout();
              if (!context.mounted) return;
              Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.login,
                (route) => false,
              );
            },
            borderRadius: AppRadius.all(AppRadius.radius3),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Row(
                children: [
                  const Icon(
                    Iconsax.logout_1,
                    color: AppColors.error,
                    size: 21,
                  ),
                  AppSpacing.horizontalSpaceMd,
                  Text(
                    l10n.drawerLogout,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
