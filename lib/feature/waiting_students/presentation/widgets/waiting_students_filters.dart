import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/models/waiting_student.dart';
import '../../data/waiting_students_dummy_data.dart';

class WaitingStudentsFilters extends StatelessWidget {
  const WaitingStudentsFilters({
    super.key,
    required this.stage,
    required this.gate,
    required this.zone,
    required this.status,
    required this.onStageChanged,
    required this.onGateChanged,
    required this.onZoneChanged,
    required this.onStatusChanged,
    required this.onReset,
  });

  final String stage;
  final String gate;
  final String zone;
  final WaitingStudentStatus? status;
  final ValueChanged<String> onStageChanged;
  final ValueChanged<String> onGateChanged;
  final ValueChanged<String> onZoneChanged;
  final ValueChanged<WaitingStudentStatus?> onStatusChanged;
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
        children: [
          Row(
            children: [
              const Icon(Iconsax.filter_search, color: AppColors.primary),
              AppSpacing.horizontalSpaceSm,
              Expanded(
                child: Text(
                  'تصفية الطلاب المنتظرين',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.primaryDeep,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TextButton(onPressed: onReset, child: const Text('مسح')),
            ],
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
                  _StringDropdown(
                    width: itemWidth,
                    label: 'المرحلة',
                    value: stage,
                    values: WaitingStudentsDummyData.stages,
                    onChanged: onStageChanged,
                  ),
                  _StringDropdown(
                    width: itemWidth,
                    label: 'البوابة',
                    value: gate,
                    values: WaitingStudentsDummyData.gates,
                    onChanged: onGateChanged,
                  ),
                  _StringDropdown(
                    width: itemWidth,
                    label: 'منطقة الانتظار',
                    value: zone,
                    values: WaitingStudentsDummyData.zones,
                    onChanged: onZoneChanged,
                  ),
                  _StatusDropdown(
                    width: itemWidth,
                    value: status,
                    onChanged: onStatusChanged,
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

class _StringDropdown extends StatelessWidget {
  const _StringDropdown({
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
    return SizedBox(
      width: width,
      child: DropdownButtonFormField<String>(
        initialValue: value,
        isExpanded: true,
        icon: const Icon(Iconsax.arrow_down_1, size: 16),
        decoration: _dropdownDecoration(label),
        items: values
            .map(
              (item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item, overflow: TextOverflow.ellipsis),
              ),
            )
            .toList(growable: false),
        onChanged: (value) {
          if (value != null) onChanged(value);
        },
      ),
    );
  }
}

class _StatusDropdown extends StatelessWidget {
  const _StatusDropdown({
    required this.width,
    required this.value,
    required this.onChanged,
  });

  final double width;
  final WaitingStudentStatus? value;
  final ValueChanged<WaitingStudentStatus?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: DropdownButtonFormField<WaitingStudentStatus?>(
        initialValue: value,
        isExpanded: true,
        icon: const Icon(Iconsax.arrow_down_1, size: 16),
        decoration: _dropdownDecoration('الحالة'),
        items: const [
          DropdownMenuItem<WaitingStudentStatus?>(
            value: null,
            child: Text('الكل'),
          ),
          DropdownMenuItem<WaitingStudentStatus?>(
            value: WaitingStudentStatus.called,
            child: Text('تم الاستدعاء'),
          ),
          DropdownMenuItem<WaitingStudentStatus?>(
            value: WaitingStudentStatus.moving,
            child: Text('في الطريق'),
          ),
          DropdownMenuItem<WaitingStudentStatus?>(
            value: WaitingStudentStatus.atGate,
            child: Text('عند البوابة'),
          ),
          DropdownMenuItem<WaitingStudentStatus?>(
            value: WaitingStudentStatus.delayed,
            child: Text('متأخر'),
          ),
        ],
        onChanged: onChanged,
      ),
    );
  }
}

InputDecoration _dropdownDecoration(String label) {
  return InputDecoration(
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
  );
}
