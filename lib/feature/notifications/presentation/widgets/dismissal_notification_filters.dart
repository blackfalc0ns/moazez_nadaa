import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../generated/app_localizations.dart';

class DismissalNotificationFilters extends StatelessWidget {
  const DismissalNotificationFilters({
    super.key,
    required this.selectedStatus,
    required this.selectedType,
    required this.onStatusChanged,
    required this.onTypeChanged,
  });

  final String selectedStatus;
  final String selectedType;
  final ValueChanged<String> onStatusChanged;
  final ValueChanged<String> onTypeChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: AppRadius.all(18),
      ),
      child: Column(
        children: [
          _FilterRow(
            selected: selectedStatus,
            values: [
              ('all', l10n.dismissalAll),
              ('unread', l10n.dismissalUnread),
              ('read', l10n.dismissalMarkRead),
            ],
            onChanged: onStatusChanged,
          ),
          const SizedBox(height: 6),
          _FilterRow(
            selected: selectedType,
            values: [
              ('all', l10n.dismissalAll),
              ('request_created', l10n.dismissalStatusRequested),
              ('request_called', l10n.dismissalStatusCalled),
              ('request_ready', l10n.dismissalStatusReady),
              ('request_handed_over', l10n.dismissalStatusHandedOver),
              ('request_cancelled', l10n.dismissalStatusCancelled),
              ('request_expired', l10n.dismissalStatusExpired),
            ],
            onChanged: onTypeChanged,
          ),
        ],
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({
    required this.selected,
    required this.values,
    required this.onChanged,
  });

  final String selected;
  final List<(String, String)> values;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: values
            .map(
              (value) => Padding(
                padding: const EdgeInsetsDirectional.only(end: 6),
                child: ChoiceChip(
                  selected: selected == value.$1,
                  showCheckmark: false,
                  label: Text(value.$2),
                  labelStyle: AppTypography.withWeight(
                    AppTypography.withColor(
                      AppTypography.labelSmall.copyWith(fontSize: 9),
                      selected == value.$1
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                    FontWeight.w800,
                  ),
                  selectedColor: AppColors.primary.withValues(alpha: 0.1),
                  backgroundColor: AppColors.background,
                  side: BorderSide(
                    color: selected == value.$1
                        ? AppColors.primary.withValues(alpha: 0.3)
                        : Colors.transparent,
                  ),
                  onSelected: (_) => onChanged(value.$1),
                ),
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}
