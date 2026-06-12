import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/helper/on_genrated_routes.dart';

class AppSideDrawer extends StatelessWidget {
  const AppSideDrawer({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Drawer(
      width: screenWidth > 420 ? 292 : screenWidth * 0.65,
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.92),
            border: BorderDirectional(
              end: BorderSide(
                color: Colors.white.withValues(alpha: 0.45),
                width: 1.2,
              ),
            ),
            boxShadow: AppShadows.xl,
          ),
          child: ListView(
            padding: EdgeInsets.only(
              top: MediaQuery.paddingOf(context).top + AppSpacing.md,
              bottom: AppSpacing.lg,
            ),
            children: [
              _DrawerSection(
                title: 'العمل اليومي',
                children: [
                  _DrawerItem(
                    icon: Iconsax.direct_notification,
                    title: 'لوحة النداء',
                    subtitle: 'طلبات الاستلام النشطة',
                    selected: selectedIndex == 0,
                    onTap: () => _selectTab(context, 0),
                  ),
                  _DrawerItem(
                    icon: Iconsax.message_text,
                    title: 'الشات',
                    subtitle: 'رسائل المدرسة وأولياء الأمور',
                    selected: selectedIndex == 1,
                    onTap: () => _selectTab(context, 1),
                  ),
                  _DrawerItem(
                    icon: Iconsax.receipt_search,
                    title: 'سجل النداءات',
                    subtitle: 'الطلبات المكتملة والمتأخرة',
                    onTap: () => _openRoute(context, Routes.callsHistory),
                  ),
                  _DrawerItem(
                    icon: Iconsax.location_tick,
                    title: 'البوابات والمناوبات',
                    subtitle: 'نقاط التسليم والمشرفين',
                    onTap: () => _openRoute(context, Routes.gatesDuties),
                  ),
                  _DrawerItem(
                    icon: Iconsax.profile_2user,
                    title: 'الطلاب المنتظرون',
                    subtitle: 'لم يتم تسليمهم بعد',
                    badge: '3',
                    onTap: () => _openRoute(context, Routes.waitingStudents),
                  ),
                ],
              ),
              _DrawerSection(
                title: 'الحساب والسلامة',
                children: [
                  _DrawerItem(
                    icon: Iconsax.user_octagon,
                    title: 'الملف الشخصي',
                    subtitle: 'بيانات المشرف والصلاحيات',
                    onTap: () => _openRoute(context, Routes.profile),
                  ),
                  // _DrawerItem(
                  //   icon: Iconsax.shield_tick,
                  //   title: 'أولياء الأمور المعتمدون',
                  //   subtitle: 'تحقق من هوية المستلم',
                  //   onTap: () =>
                  //       _openRoute(context, Routes.authorizedGuardians),
                  // ),
                  _DrawerItem(
                    icon: Iconsax.notification_status,
                    title: 'التنبيهات',
                    subtitle: 'طلبات عاجلة وتأخيرات',
                    badge: '5',
                    onTap: () => _openRoute(context, Routes.notifications),
                  ),
                  _DrawerItem(
                    icon: Iconsax.setting_2,
                    title: 'الإعدادات',
                    subtitle: 'الصوت واللغة والإشعارات',
                    onTap: () => _openRoute(context, Routes.settings),
                  ),
                ],
              ),
              _DrawerSection(
                title: 'الدعم والقوانين',
                children: [
                  _DrawerItem(
                    icon: Iconsax.message_question,
                    title: 'المساعدة والدعم',
                    subtitle: 'تواصل مع دعم معزز',
                    onTap: () => _close(context),
                  ),
                  _DrawerItem(
                    icon: Iconsax.document_text,
                    title: 'الشروط والأحكام',
                    subtitle: 'قواعد استخدام التطبيق',
                    onTap: () => _close(context),
                  ),
                  _DrawerItem(
                    icon: Iconsax.lock_1,
                    title: 'سياسة الخصوصية',
                    subtitle: 'حماية بيانات الطلاب',
                    onTap: () => _close(context),
                  ),
                ],
              ),
              const _DrawerFooter(),
            ],
          ),
        ),
      ),
    );
  }

  void _selectTab(BuildContext context, int index) {
    Navigator.of(context).pop();
    onTabSelected(index);
  }

  void _close(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _openRoute(BuildContext context, String routeName) {
    Navigator.of(context).pop();
    Navigator.of(context).pushNamed(routeName);
  }
}

class _DrawerSection extends StatelessWidget {
  const _DrawerSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(
              start: AppSpacing.sm,
              bottom: AppSpacing.xxs,
            ),
            child: Text(
              title,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.textSecondaryLight,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          ...children,
        ],
      ),
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
    this.badge,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool selected;
  final String? badge;

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
              vertical: AppSpacing.xs,
            ),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.primary.withValues(alpha: 0.14)
                        : AppColors.primary.withValues(alpha: 0.07),
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodyMedium.copyWith(
                          color: color,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 1),
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
                if (badge != null) ...[
                  AppSpacing.horizontalSpaceSm,
                  Container(
                    height: 21,
                    alignment: Alignment.center,
                    constraints: const BoxConstraints(minWidth: 21),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: AppRadius.all(AppRadius.radiusFull),
                    ),
                    child: Text(
                      badge!,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DrawerFooter extends StatelessWidget {
  const _DrawerFooter();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.sm,
        AppSpacing.xs,
        AppSpacing.sm,
        AppSpacing.md,
      ),
      child: Material(
        color: AppColors.error.withValues(alpha: 0.08),
        borderRadius: AppRadius.all(AppRadius.radius3),
        child: InkWell(
          onTap: () => Navigator.of(context).pop(),
          borderRadius: AppRadius.all(AppRadius.radius5),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                const Icon(Iconsax.logout_1, color: AppColors.error, size: 21),
                AppSpacing.horizontalSpaceMd,
                Text(
                  'تسجيل الخروج',
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
    );
  }
}
