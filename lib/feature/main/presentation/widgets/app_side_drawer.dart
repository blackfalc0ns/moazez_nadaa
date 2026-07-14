import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/permissions/app_permission.dart';
import '../../../../core/permissions/permission_repository.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/helper/on_genrated_routes.dart';
import '../../../../core/utils/navigation/custom_bottom_nav_bar.dart';
import '../../../../generated/app_localizations.dart';
import '../../../../core/constants/storage_keys.dart';
import '../../../auth/data/repositories/dismissal_auth_repo.dart';
import '../../../auth/data/mappers/dismissal_auth_mapper.dart';
import '../../../auth/data/models/dismissal_auth_session.dart';

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
    return FutureBuilder<DismissalAuthSession?>(
      future: _loadSession(),
      builder: (context, snapshot) => _buildDrawer(context, snapshot.data),
    );
  }

  Future<DismissalAuthSession?> _loadSession() async {
    if (!sl.isRegistered<SharedPreferences>()) return null;
    final prefs = sl<SharedPreferences>();
    final raw = prefs.getString(StorageKeys.userData);
    if (raw == null || raw.isEmpty) return null;
    try {
      final json = Map<String, dynamic>.from(jsonDecode(raw) as Map);
      return DismissalAuthMapper.sessionFromJson(json);
    } catch (_) {
      return null;
    }
  }

  Widget _buildDrawer(BuildContext context, DismissalAuthSession? session) {
    final l10n = AppLocalizations.of(context)!;
    final permissions = sl<PermissionRepository>();

    final canViewCalls = _hasTarget(DismissalNavigationTarget.calls);
    final canViewWaiting = _hasTarget(DismissalNavigationTarget.waiting);
    final canViewGates = _hasTarget(DismissalNavigationTarget.gates);
    final canViewHistory = permissions.has(AppPermission.viewHistory);

    final hasAcademics =
        canViewCalls || canViewWaiting || canViewGates || canViewHistory;

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.65,
      backgroundColor: const Color(
        0xFFF6F8FB,
      ), // Matching background light color
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          bottomLeft: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          // ═══════════ HEADER ═══════════
          _buildHeader(context, l10n, session),

          // ═══════════ SCROLLABLE CONTENT ═══════════
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Quick Actions ──
                  _sectionLabel(l10n.drawerDailyWork),
                  _quickActionsRow(context, l10n),
                  const SizedBox(height: 20),

                  // ── Daily Work (Academics category layout) ──
                  if (hasAcademics) _sectionLabel(l10n.drawerDailyWork),
                  _tile(
                    context,
                    Iconsax.direct_notification,
                    l10n.drawerCallsBoard,
                    onTap: () =>
                        _selectTab(context, DismissalNavigationTarget.calls),
                    visible: canViewCalls,
                  ),
                  _tile(
                    context,
                    Iconsax.profile_2user,
                    l10n.drawerWaiting,
                    onTap: () =>
                        _selectTab(context, DismissalNavigationTarget.waiting),
                    visible: canViewWaiting,
                  ),
                  _tile(
                    context,
                    Iconsax.location_tick,
                    l10n.drawerGates,
                    onTap: () =>
                        _selectTab(context, DismissalNavigationTarget.gates),
                    visible: canViewGates,
                  ),
                  _tile(
                    context,
                    Iconsax.receipt_search,
                    l10n.drawerCallsHistory,
                    onTap: () => _openRoute(context, Routes.callsHistory),
                    visible: canViewHistory,
                  ),
                  if (hasAcademics) ...[
                    const SizedBox(height: AppSpacing.sm),
                    _divider(),
                    const SizedBox(height: AppSpacing.sm),
                  ],

                  // ── Account & Settings ──
                  _sectionLabel(l10n.drawerAccountSafety),
                  _tile(
                    context,
                    Iconsax.user_octagon,
                    l10n.drawerProfile,
                    onTap: () => _openRoute(context, Routes.profile),
                    visible: permissions.has(AppPermission.viewProfile),
                  ),
                  _tile(
                    context,
                    Iconsax.setting_2,
                    l10n.drawerSettings,
                    onTap: () => _openRoute(context, Routes.settings),
                  ),
                  _tile(
                    context,
                    Icons.lock_outline_rounded,
                    _drawerText(
                      context,
                      'تغيير كلمة المرور',
                      'Change password',
                    ),
                    onTap: () => _openRoute(context, Routes.changePassword),
                  ),
                  _tile(
                    context,
                    Iconsax.lock_1,
                    l10n.drawerPrivacy,
                    onTap: () => Navigator.pop(context),
                  ),
                  _tile(
                    context,
                    Iconsax.document_text,
                    l10n.drawerTerms,
                    onTap: () => Navigator.pop(context),
                  ),
                  _tile(
                    context,
                    Icons.info_outline_rounded,
                    _drawerText(context, 'عن التطبيق', 'About App'),
                    onTap: () => Navigator.pop(context),
                  ),
                  _tile(
                    context,
                    Iconsax.message_question,
                    l10n.drawerHelp,
                    onTap: () => Navigator.pop(context),
                  ),
                  _tile(
                    context,
                    Icons.star_outline_rounded,
                    _drawerText(context, 'تقييم التطبيق', 'Rate app'),
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),

          // ═══════════ FOOTER ═══════════
          _buildFooter(context, l10n),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    AppLocalizations l10n,
    DismissalAuthSession? session,
  ) {
    final topPadding = MediaQuery.of(context).padding.top;
    final displayName = session?.displayName ?? '';
    final role = session?.userType ?? '';
    final hasSession = session != null;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, topPadding + 16, 20, 20),
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(
                AppAssets.logo,
                height: 28,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Profile Row
          if (hasSession)
            GestureDetector(
              onTap: () => _openRoute(context, Routes.profile),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.2),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.5),
                        width: 2,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: const Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          style: AppTypography.withWeight(
                            AppTypography.withColor(
                              AppTypography.bodyMedium.copyWith(fontSize: 16),
                              Colors.white,
                            ),
                            FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          role,
                          style: AppTypography.withColor(
                            AppTypography.labelSmall.copyWith(fontSize: 12),
                            Colors.white.withValues(alpha: 0.75),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _quickActionsRow(BuildContext context, AppLocalizations l10n) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (_hasTarget(DismissalNavigationTarget.calls))
          _quickChip(
            context,
            Iconsax.direct_notification,
            l10n.drawerCallsBoard,
            onTap: () => _selectTab(context, DismissalNavigationTarget.calls),
          ),
        if (_hasTarget(DismissalNavigationTarget.waiting))
          _quickChip(
            context,
            Iconsax.profile_2user,
            l10n.drawerWaiting,
            onTap: () => _selectTab(context, DismissalNavigationTarget.waiting),
          ),
        if (_hasTarget(DismissalNavigationTarget.gates))
          _quickChip(
            context,
            Iconsax.location_tick,
            l10n.drawerGates,
            onTap: () => _selectTab(context, DismissalNavigationTarget.gates),
          ),
      ],
    );
  }

  Widget _quickChip(
    BuildContext context,
    IconData icon,
    String label, {
    String? badge,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap();
          return;
        }
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.06),
          borderRadius: AppRadius.all(20),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: AppColors.primary),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTypography.withWeight(
                AppTypography.withColor(
                  AppTypography.labelSmall.copyWith(fontSize: 11),
                  AppColors.primary,
                ),
                FontWeight.w600,
              ),
            ),
            if (badge != null) ...[
              const SizedBox(width: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: AppRadius.all(8),
                ),
                child: Text(
                  badge,
                  style: AppTypography.withWeight(
                    AppTypography.withColor(
                      AppTypography.labelSmall.copyWith(fontSize: 9),
                      Colors.white,
                    ),
                    FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, right: 4, top: 4),
      child: Text(
        text,
        style: AppTypography.withWeight(
          AppTypography.withColor(
            AppTypography.labelSmall.copyWith(fontSize: 11),
            AppColors.textSecondaryLight.withValues(alpha: 0.7),
          ),
          FontWeight.bold,
        ),
      ),
    );
  }

  Widget _tile(
    BuildContext context,
    IconData icon,
    String label, {
    required VoidCallback onTap,
    Color? iconColor,
    bool visible = true,
  }) {
    if (!visible) return const SizedBox.shrink();
    final clr = iconColor ?? AppColors.textPrimaryLight;
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.all(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 4),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              child: Icon(icon, size: 18, color: clr.withValues(alpha: 0.75)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: AppTypography.withWeight(
                  AppTypography.withColor(
                    AppTypography.bodySmall.copyWith(fontSize: 13),
                    clr,
                  ),
                  FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 11,
              color: AppColors.textSecondaryLight.withValues(alpha: 0.35),
            ),
          ],
        ),
      ),
    );
  }

  String _drawerText(BuildContext context, String ar, String en) {
    return Localizations.localeOf(context).languageCode == 'ar' ? ar : en;
  }

  Widget _divider() {
    return Divider(
      height: 1,
      thickness: 0.5,
      color: AppColors.primary.withValues(alpha: 0.08),
    );
  }

  Widget _buildFooter(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        8,
        20,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(color: AppColors.primary.withValues(alpha: 0.08)),
        ),
      ),
      child: Column(
        children: [
          // Logout
          InkWell(
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
            borderRadius: AppRadius.all(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
              child: Row(
                children: [
                  const SizedBox(
                    width: 24,
                    child: Icon(
                      Icons.logout_rounded,
                      size: 18,
                      color: AppColors.error,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    l10n.drawerLogout,
                    style: AppTypography.withWeight(
                      AppTypography.withColor(
                        AppTypography.bodySmall.copyWith(fontSize: 13),
                        AppColors.error,
                      ),
                      FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Text(
                  _drawerText(context, 'عن التطبيق', 'About App'),
                  style: AppTypography.withColor(
                    AppTypography.labelSmall.copyWith(fontSize: 10),
                    AppColors.textSecondaryLight.withValues(alpha: 0.6),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  '•',
                  style: AppTypography.withColor(
                    AppTypography.labelSmall.copyWith(fontSize: 10),
                    AppColors.textSecondaryLight.withValues(alpha: 0.3),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Text(
                  l10n.drawerTerms,
                  style: AppTypography.withColor(
                    AppTypography.labelSmall.copyWith(fontSize: 10),
                    AppColors.textSecondaryLight.withValues(alpha: 0.6),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  '•',
                  style: AppTypography.withColor(
                    AppTypography.labelSmall.copyWith(fontSize: 10),
                    AppColors.textSecondaryLight.withValues(alpha: 0.3),
                  ),
                ),
              ),
              Text(
                'v1.0.0',
                style: AppTypography.withColor(
                  AppTypography.labelSmall.copyWith(fontSize: 10),
                  AppColors.textSecondaryLight.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
        ],
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
