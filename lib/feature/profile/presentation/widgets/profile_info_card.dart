import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../generated/app_localizations.dart';
import '../../../dismissal/data/models/dismissal_models.dart';

class ProfileInfoCard extends StatelessWidget {
  const ProfileInfoCard({super.key, required this.profile});

  final DismissalProfileModel profile;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.all(AppRadius.radius5),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _ProfileMetric(
                icon: Iconsax.task_square,
                label: l10n.dismissalProfileAssignments,
                value: '${profile.assignmentsCount}',
              ),
              _ProfileMetric(
                icon: Iconsax.flash_1,
                label: l10n.dismissalProfileActiveAssignments,
                value: '${profile.activeAssignmentsCount}',
                color: AppColors.success,
              ),
              _ProfileMetric(
                icon: Iconsax.crown_1,
                label: l10n.dismissalProfileLeadAssignments,
                value: '${profile.leadAssignmentsCount}',
                color: AppColors.warning,
              ),
            ],
          ),
          const _Divider(),
          _InfoRow(
            icon: Iconsax.location_tick,
            title: l10n.dismissalProfileAssignedGates,
            value: profile.gates.isEmpty
                ? l10n.dismissalProfileNoGates
                : profile.gates.join(' - '),
          ),
          const _Divider(),
          _InfoRow(
            icon: profile.ready ? Iconsax.tick_circle : Iconsax.warning_2,
            title: l10n.dismissalProfileReadiness,
            value: profile.ready
                ? l10n.dismissalProfileReady
                : l10n.dismissalProfileNotReady,
            valueColor: profile.ready ? AppColors.success : AppColors.warning,
          ),
          const _Divider(),
          _AcademicScopes(
            scopes: profile.academicScopes,
            title: l10n.dismissalProfileAcademicScopes,
            emptyLabel: l10n.dismissalProfileNoAcademicScopes,
            leadLabel: l10n.dismissalProfileScopeLead,
          ),
        ],
      ),
    );
  }
}

class _ProfileMetric extends StatelessWidget {
  const _ProfileMetric({
    required this.icon,
    required this.label,
    required this.value,
    this.color = AppColors.primary,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 96,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.06),
          borderRadius: AppRadius.all(AppRadius.radius3),
          border: Border.all(color: color.withValues(alpha: 0.1)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 17, color: color),
            const SizedBox(height: 4),
            Text(
              value,
              style: AppTypography.bodyMedium.copyWith(
                color: color,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondaryLight,
                fontSize: 9,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AcademicScopes extends StatelessWidget {
  const _AcademicScopes({
    required this.scopes,
    required this.title,
    required this.emptyLabel,
    required this.leadLabel,
  });

  final List<DismissalAcademicScopeModel> scopes;
  final String title;
  final String emptyLabel;
  final String leadLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Iconsax.book_1, size: 18, color: AppColors.primary),
            AppSpacing.horizontalSpaceSm,
            Text(
              title,
              style: AppTypography.caption.copyWith(
                color: AppColors.textSecondaryLight,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        if (scopes.isEmpty)
          Text(
            emptyLabel,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondaryLight,
            ),
          )
        else
          for (final scope in scopes)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: AppSpacing.xs),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.05),
                borderRadius: AppRadius.all(AppRadius.radius3),
              ),
              child: _ScopeContent(
                scope: scope,
                emptyLabel: emptyLabel,
                leadLabel: leadLabel,
                l10n: l10n,
              ),
            ),
      ],
    );
  }
}

class _ScopeContent extends StatelessWidget {
  const _ScopeContent({
    required this.scope,
    required this.emptyLabel,
    required this.leadLabel,
    required this.l10n,
  });

  final DismissalAcademicScopeModel scope;
  final String emptyLabel;
  final String leadLabel;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final status = _assignmentStatus();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                scope.labels.isEmpty ? emptyLabel : scope.labels.join(' / '),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.caption.copyWith(
                  color: AppColors.primaryDeep,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            if (scope.isLead) ...[
              AppSpacing.horizontalSpaceXs,
              _ScopeBadge(label: leadLabel, color: AppColors.warning),
            ],
          ],
        ),
        AppSpacing.verticalSpaceXs,
        Row(
          children: [
            const Icon(Iconsax.calendar_1, size: 14, color: AppColors.primary),
            AppSpacing.horizontalSpaceXs,
            Expanded(
              child: Text(
                _periodLabel(context),
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondaryLight,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            _ScopeBadge(label: status.$1, color: status.$2),
          ],
        ),
      ],
    );
  }

  String _periodLabel(BuildContext context) {
    if (scope.startsAt == null && scope.endsAt == null) {
      return l10n.dismissalAssignmentPeriodUnavailable;
    }
    final material = MaterialLocalizations.of(context);
    final start = scope.startsAt == null
        ? l10n.dismissalUnknownValue
        : material.formatMediumDate(scope.startsAt!.toLocal());
    final end = scope.endsAt == null
        ? l10n.dismissalUnknownValue
        : material.formatMediumDate(scope.endsAt!.toLocal());
    return l10n.dismissalAssignmentPeriod(start, end);
  }

  (String, Color) _assignmentStatus() {
    final now = DateTime.now();
    if (scope.endsAt != null && now.isAfter(scope.endsAt!.toLocal())) {
      return (l10n.dismissalAssignmentEnded, AppColors.grey);
    }
    if (scope.startsAt != null && now.isBefore(scope.startsAt!.toLocal())) {
      return (l10n.dismissalAssignmentUpcoming, AppColors.info);
    }
    return (l10n.dismissalAssignmentActive, AppColors.success);
  }
}

class _ScopeBadge extends StatelessWidget {
  const _ScopeBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadius.all(AppRadius.radiusFull),
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final String title;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: AppRadius.all(AppRadius.radius3),
          ),
          child: Icon(icon, color: AppColors.primary, size: 18),
        ),
        AppSpacing.horizontalSpaceMd,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondaryLight,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                value,
                style: AppTypography.bodySmall.copyWith(
                  color: valueColor ?? AppColors.primaryDeep,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Divider(height: 1, color: AppColors.borderLight),
    );
  }
}
