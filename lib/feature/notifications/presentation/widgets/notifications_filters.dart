import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/models/app_notification.dart';

class NotificationsFilters extends StatelessWidget {
  const NotificationsFilters({
    super.key,
    required this.type,
    required this.showUnreadOnly,
    required this.onTypeChanged,
    required this.onUnreadChanged,
  });

  final AppNotificationType? type;
  final bool showUnreadOnly;
  final ValueChanged<AppNotificationType?> onTypeChanged;
  final ValueChanged<bool> onUnreadChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.allMd,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.all(AppRadius.radius5),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Iconsax.filter_search, color: AppColors.primary),
              AppSpacing.horizontalSpaceSm,
              Expanded(
                child: Text(
                  'تصفية التنبيهات',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.primaryDeep,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Switch.adaptive(
                value: showUnreadOnly,
                activeThumbColor: AppColors.primary,
                onChanged: onUnreadChanged,
              ),
              Text(
                'غير مقروء',
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondaryLight,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          AppSpacing.verticalSpaceSm,
          DropdownButtonFormField<AppNotificationType?>(
            initialValue: type,
            isExpanded: true,
            icon: const Icon(Iconsax.arrow_down_1, size: 16),
            decoration: InputDecoration(
              labelText: 'نوع التنبيه',
              filled: true,
              fillColor: AppColors.backgroundLight,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              border: OutlineInputBorder(
                borderRadius: AppRadius.all(AppRadius.radius5),
                borderSide: BorderSide.none,
              ),
            ),
            items: const [
              DropdownMenuItem<AppNotificationType?>(
                value: null,
                child: Text('الكل'),
              ),
              DropdownMenuItem<AppNotificationType?>(
                value: AppNotificationType.urgentCall,
                child: Text('نداء عاجل'),
              ),
              DropdownMenuItem<AppNotificationType?>(
                value: AppNotificationType.delayedPickup,
                child: Text('تأخير'),
              ),
              DropdownMenuItem<AppNotificationType?>(
                value: AppNotificationType.delivered,
                child: Text('تسليم'),
              ),
              DropdownMenuItem<AppNotificationType?>(
                value: AppNotificationType.gate,
                child: Text('بوابة'),
              ),
              DropdownMenuItem<AppNotificationType?>(
                value: AppNotificationType.system,
                child: Text('نظام'),
              ),
            ],
            onChanged: onTypeChanged,
          ),
        ],
      ),
    );
  }
}
