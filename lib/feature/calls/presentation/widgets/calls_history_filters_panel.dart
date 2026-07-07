import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/calls_history_dummy_data.dart';
import '../../data/models/calls_history_record.dart';
import '../../data/models/pickup_request.dart';

class CallsHistoryFiltersPanel extends StatelessWidget {
  const CallsHistoryFiltersPanel({
    super.key,
    required this.selectedDate,
    required this.stageFilter,
    required this.gradeFilter,
    required this.sectionFilter,
    required this.gateFilter,
    required this.statusFilter,
    required this.onDateChanged,
    required this.onStageChanged,
    required this.onGradeChanged,
    required this.onSectionChanged,
    required this.onGateChanged,
    required this.onStatusChanged,
    required this.onReset,
  });

  final DateTime? selectedDate;
  final String stageFilter;
  final String gradeFilter;
  final String sectionFilter;
  final String gateFilter;
  final PickupStatus? statusFilter;
  final ValueChanged<DateTime?> onDateChanged;
  final ValueChanged<String> onStageChanged;
  final ValueChanged<String> onGradeChanged;
  final ValueChanged<String> onSectionChanged;
  final ValueChanged<String> onGateChanged;
  final ValueChanged<PickupStatus?> onStatusChanged;
  final VoidCallback onReset;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Iconsax.filter_search, color: AppColors.primary),
              AppSpacing.horizontalSpaceSm,
              Expanded(
                child: Text(
                  'تصفية السجل',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.primaryDeep,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              TextButton(
                onPressed: onReset,
                child: Text('مسح', style: AppTypography.bodyMedium),
              ),
            ],
          ),
          AppSpacing.verticalSpaceSm,
          _DateFilterField(
            selectedDate: selectedDate,
            onDateChanged: onDateChanged,
          ),
          AppSpacing.verticalSpaceSm,
          LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = constraints.maxWidth >= 340
                  ? (constraints.maxWidth - AppSpacing.sm) / 2
                  : constraints.maxWidth;

              return Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  _FilterDropdown<PickupStatus?>(
                    width: itemWidth,
                    label: 'الحالة',
                    value: statusFilter,
                    options: const [
                      _FilterOption(value: null, label: 'الكل'),
                      _FilterOption(
                        value: PickupStatus.delivered,
                        label: 'تم التسليم',
                      ),
                      _FilterOption(
                        value: PickupStatus.delayed,
                        label: 'متأخر',
                      ),
                      _FilterOption(value: PickupStatus.ready, label: 'جاهز'),
                    ],
                    onChanged: onStatusChanged,
                  ),
                  _StringFilterDropdown(
                    width: itemWidth,
                    label: 'المرحلة',
                    value: stageFilter,
                    values: CallsHistoryDummyData.stages,
                    onChanged: onStageChanged,
                  ),
                  _StringFilterDropdown(
                    width: itemWidth,
                    label: 'الصف',
                    value: gradeFilter,
                    values: CallsHistoryDummyData.grades,
                    onChanged: onGradeChanged,
                  ),
                  _StringFilterDropdown(
                    width: itemWidth,
                    label: 'الفصل',
                    value: sectionFilter,
                    values: CallsHistoryDummyData.sections,
                    onChanged: onSectionChanged,
                  ),
                  _StringFilterDropdown(
                    width: itemWidth,
                    label: 'البوابة',
                    value: gateFilter,
                    values: CallsHistoryDummyData.gates,
                    onChanged: onGateChanged,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DateFilterField extends StatelessWidget {
  const _DateFilterField({
    required this.selectedDate,
    required this.onDateChanged,
  });

  final DateTime? selectedDate;
  final ValueChanged<DateTime?> onDateChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _pickDate(context),
      borderRadius: AppRadius.all(AppRadius.radius5),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: AppRadius.all(AppRadius.radius5),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: AppRadius.all(AppRadius.radius3),
              ),
              child: const Icon(
                Iconsax.calendar_1,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            AppSpacing.horizontalSpaceMd,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'تاريخ النداء',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondaryLight,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  AppSpacing.verticalSpaceXxs,
                  Text(
                    selectedDate == null
                        ? 'كل التواريخ'
                        : formatHistoryDate(selectedDate!),
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.primaryDeep,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            if (selectedDate != null)
              IconButton(
                onPressed: () => onDateChanged(null),
                icon: const Icon(Iconsax.close_circle, size: 20),
                color: AppColors.hintDark,
                tooltip: 'كل التواريخ',
              )
            else
              const Icon(
                Iconsax.arrow_down_1,
                color: AppColors.hintDark,
                size: 18,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? CallsHistoryDummyData.today,
      firstDate: DateTime(2026),
      lastDate: CallsHistoryDummyData.today,
      helpText: 'اختر تاريخ النداءات',
      cancelText: 'إلغاء',
      confirmText: 'تطبيق',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.primary,
              onPrimary: AppColors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      onDateChanged(
        DateTime(pickedDate.year, pickedDate.month, pickedDate.day),
      );
    }
  }
}

class _StringFilterDropdown extends StatelessWidget {
  const _StringFilterDropdown({
    required this.width,
    required this.label,
    required this.value,
    required this.values,
    required this.onChanged,
  });

  final double width;
  final String label;
  final String value;
  final List<String> values;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return _FilterDropdown<String>(
      width: width,
      label: label,
      value: value,
      options: values
          .map((item) => _FilterOption<String>(value: item, label: item))
          .toList(growable: false),
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    );
  }
}

class _FilterDropdown<T> extends StatelessWidget {
  const _FilterDropdown({
    required this.width,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final double width;
  final String label;
  final T? value;
  final List<_FilterOption<T>> options;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: DropdownButtonFormField<T?>(
        initialValue: value,
        isExpanded: true,
        icon: const Icon(Iconsax.arrow_down_1, size: 16),
        decoration: InputDecoration(
          labelStyle: AppTypography.caption.copyWith(
            color: AppColors.textSecondaryLight,
            fontWeight: FontWeight.w700,
          ),
          labelText: label,
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
          enabledBorder: OutlineInputBorder(
            borderRadius: AppRadius.all(AppRadius.radius5),
            borderSide: const BorderSide(color: AppColors.borderLight),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppRadius.all(AppRadius.radius5),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
          ),
        ),
        items: options
            .map(
              (option) => DropdownMenuItem<T?>(
                value: option.value,
                child: Text(
                  option.label,
                  style: AppTypography.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
            .toList(growable: false),
        onChanged: onChanged,
      ),
    );
  }
}

class _FilterOption<T> {
  const _FilterOption({required this.value, required this.label});

  final T? value;
  final String label;
}
