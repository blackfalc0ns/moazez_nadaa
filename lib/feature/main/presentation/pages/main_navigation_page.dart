import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/permissions/app_permission.dart';
import '../../../../core/permissions/permission_repository.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/navigation/custom_bottom_nav_bar.dart';
import '../../../../generated/app_localizations.dart';
import '../../../calls/presentation/pages/calls_dashboard_page.dart';
import '../../../gates_duties/presentation/pages/gates_duties_page.dart';
import '../../../waiting_students/presentation/pages/waiting_students_page.dart';
import '../widgets/app_side_drawer.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final permissions = sl<PermissionRepository>();
    final destinations = <_Destination>[
      if (permissions.has(AppPermission.viewRequests))
        _Destination(
          navItem: DismissalBottomNavItem(
            target: DismissalNavigationTarget.calls,
            label: l10n.calls,
            icon: Iconsax.direct_notification,
          ),
          page: const CallsDashboardPage(),
        ),
      if (permissions.has(AppPermission.viewRequests))
        _Destination(
          navItem: DismissalBottomNavItem(
            target: DismissalNavigationTarget.waiting,
            label: l10n.navWaiting,
            icon: Iconsax.profile_2user,
          ),
          page: const WaitingStudentsPage(),
        ),
      if (permissions.has(AppPermission.viewGates))
        _Destination(
          navItem: DismissalBottomNavItem(
            target: DismissalNavigationTarget.gates,
            label: l10n.navGates,
            icon: Iconsax.location_tick,
          ),
          page: const GatesDutiesPage(),
        ),
    ];

    if (destinations.isEmpty) {
      return Scaffold(
        body: _PermissionEmptyState(l10n: l10n),
      );
    }

    final safeIndex = _selectedIndex.clamp(0, destinations.length - 1);
    if (safeIndex != _selectedIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _selectedIndex = safeIndex);
      });
    }

    return Scaffold(
      extendBody: true,
      drawer: AppSideDrawer(
        selectedTarget: destinations[safeIndex].navItem.target,
        availableTargets: destinations
            .map((item) => item.navItem.target)
            .toList(growable: false),
        onTabSelected: (target) {
          final index = destinations.indexWhere(
            (item) => item.navItem.target == target,
          );
          if (index >= 0) setState(() => _selectedIndex = index);
        },
      ),
      body: IndexedStack(
        index: safeIndex,
        children: destinations.map((item) => item.page).toList(growable: false),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: safeIndex,
        items: destinations.map((item) => item.navItem).toList(growable: false),
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}

class _Destination {
  const _Destination({required this.navItem, required this.page});

  final DismissalBottomNavItem navItem;
  final Widget page;
}

class _PermissionEmptyState extends StatelessWidget {
  const _PermissionEmptyState({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Iconsax.shield_cross,
                  color: AppColors.primary,
                  size: 34,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                l10n.permissionDeniedTitle,
                style: AppTypography.labelLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.permissionDeniedDescription,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondaryLight,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
