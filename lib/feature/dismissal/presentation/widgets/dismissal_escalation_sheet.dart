import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/common/custom_button.dart';
import '../../../../generated/app_localizations.dart';
import '../../data/models/dismissal_models.dart';

class DismissalEscalationInput {
  const DismissalEscalationInput({required this.reason, this.note});

  final DismissalEscalationReason reason;
  final String? note;
}

class DismissalEscalationSheet extends StatefulWidget {
  const DismissalEscalationSheet({required this.studentName, super.key});

  final String studentName;

  static Future<DismissalEscalationInput?> show(
    BuildContext context, {
    required String studentName,
  }) {
    return showModalBottomSheet<DismissalEscalationInput>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DismissalEscalationSheet(studentName: studentName),
    );
  }

  @override
  State<DismissalEscalationSheet> createState() =>
      _DismissalEscalationSheetState();
}

class _DismissalEscalationSheetState extends State<DismissalEscalationSheet> {
  final _noteController = TextEditingController();
  DismissalEscalationReason _reason = DismissalEscalationReason.parentWaiting;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _submit() {
    final note = _noteController.text.trim();
    Navigator.of(context).pop(
      DismissalEscalationInput(
        reason: _reason,
        note: note.isEmpty ? null : note,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        bottomInset + AppSpacing.lg,
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: AppSpacing.allLg,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.borderLight,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
                AppSpacing.verticalSpaceLg,
                Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: .1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Iconsax.warning_2,
                        color: AppColors.error,
                        size: 24,
                      ),
                    ),
                    AppSpacing.horizontalSpaceMd,
                    Expanded(
                      child: Text(
                        l10n.dismissalEscalationTitle,
                        style: AppTypography.heading5.copyWith(
                          color: AppColors.textPrimaryLight,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
                AppSpacing.verticalSpaceSm,
                Text(
                  l10n.dismissalEscalationBody(widget.studentName),
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondaryLight,
                    height: 1.55,
                  ),
                ),
                AppSpacing.verticalSpaceLg,
                Text(
                  l10n.dismissalEscalationReasonLabel,
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.textPrimaryLight,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                AppSpacing.verticalSpaceSm,
                DropdownButtonFormField<DismissalEscalationReason>(
                  initialValue: _reason,
                  isExpanded: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Iconsax.category_2),
                    filled: true,
                    fillColor: AppColors.surfaceLight,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: AppColors.borderLight),
                    ),
                  ),
                  items: DismissalEscalationReason.values
                      .map(
                        (reason) => DropdownMenuItem(
                          value: reason,
                          child: Text(_reasonLabel(reason, l10n)),
                        ),
                      )
                      .toList(growable: false),
                  onChanged: (reason) {
                    if (reason != null) setState(() => _reason = reason);
                  },
                ),
                AppSpacing.verticalSpaceLg,
                Text(
                  l10n.dismissalOptionalNote,
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.textPrimaryLight,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                AppSpacing.verticalSpaceSm,
                TextField(
                  controller: _noteController,
                  maxLength: 500,
                  minLines: 3,
                  maxLines: 5,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    hintText: l10n.dismissalEscalationNoteHint,
                    alignLabelWithHint: true,
                    filled: true,
                    fillColor: AppColors.surfaceLight,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: AppColors.borderLight),
                    ),
                  ),
                ),
                AppSpacing.verticalSpaceMd,
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        height: 50,
                        isOutlined: true,
                        backgroundColor: AppColors.primary,
                        text: l10n.dismissalEscalationCancel,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    AppSpacing.horizontalSpaceSm,
                    Expanded(
                      flex: 2,
                      child: CustomButton(
                        height: 50,
                        onPressed: _submit,
                        text: l10n.dismissalEscalationConfirm,
                        backgroundColor: AppColors.error,
                        suffix: const Icon(
                          Iconsax.warning_2,
                          size: 19,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _reasonLabel(DismissalEscalationReason reason, AppLocalizations l10n) {
    return switch (reason) {
      DismissalEscalationReason.studentNotArrived =>
        l10n.dismissalEscalationReasonStudentNotArrived,
      DismissalEscalationReason.gateCongestion =>
        l10n.dismissalEscalationReasonGateCongestion,
      DismissalEscalationReason.parentWaiting =>
        l10n.dismissalEscalationReasonParentWaiting,
      DismissalEscalationReason.safetyConcern =>
        l10n.dismissalEscalationReasonSafetyConcern,
      DismissalEscalationReason.manualFollowUp =>
        l10n.dismissalEscalationReasonManualFollowUp,
      DismissalEscalationReason.other => l10n.dismissalEscalationReasonOther,
    };
  }
}
