import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/models/gate_duty.dart';

class GatesOverviewStrip extends StatelessWidget {
  const GatesOverviewStrip({super.key, required this.gates});

  final List<GateDuty> gates;

  @override
  Widget build(BuildContext context) {
    final openCount = gates
        .where((gate) => gate.status == GateOperationalStatus.open)
        .length;
    final busyCount = gates
        .where((gate) => gate.status == GateOperationalStatus.busy)
        .length;
    final activeRequests = gates.fold<int>(
      0,
      (sum, gate) => sum + gate.activeRequests,
    );

    return Row(
      children: [
        _OverviewTile(
          icon: Iconsax.location_tick,
          label: 'مفتوحة',
          value: '$openCount',
          color: AppColors.success,
        ),
        AppSpacing.horizontalSpaceSm,
        _OverviewTile(
          icon: Iconsax.flash_1,
          label: 'ضغط',
          value: '$busyCount',
          color: AppColors.warning,
        ),
        AppSpacing.horizontalSpaceSm,
        _OverviewTile(
          icon: Iconsax.direct_notification,
          label: 'طلبات',
          value: '$activeRequests',
          color: AppColors.primary,
        ),
      ],
    );
  }
}

class _OverviewTile extends StatelessWidget {
  const _OverviewTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: AppRadius.all(AppRadius.radius5),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            AppSpacing.horizontalSpaceSm,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: AppTypography.heading5.copyWith(
                      color: AppColors.primaryDeep,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondaryLight,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
