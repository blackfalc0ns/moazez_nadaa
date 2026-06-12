import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class GateOperationsNotes extends StatelessWidget {
  const GateOperationsNotes({super.key});

  @override
  Widget build(BuildContext context) {
    const notes = [
      'لا يتم تسليم أي طالب قبل مطابقة كود الاستلام وهوية المستلم.',
      'أي طلب يتجاوز 15 دقيقة ينتقل للتصعيد ويظهر لمشرف البوابة.',
      'طلبات الحضانة والتمهيدي تظل داخل منطقة آمنة حتى وصول ولي الأمر.',
      'في حالة إغلاق بوابة يتم تحويل الطلبات تلقائيا للبوابة المحددة.',
    ];

    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: AppRadius.all(AppRadius.radius5),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Iconsax.shield_tick,
                color: AppColors.primary,
                size: 20,
              ),
              AppSpacing.horizontalSpaceSm,
              Text(
                'قواعد تشغيل سريعة',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.primaryDeep,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          AppSpacing.verticalSpaceSm,
          for (final note in notes)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 3),
                    child: Icon(
                      Iconsax.tick_circle,
                      color: AppColors.primary,
                      size: 14,
                    ),
                  ),
                  AppSpacing.horizontalSpaceXs,
                  Expanded(
                    child: Text(
                      note,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.primaryDeep,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
