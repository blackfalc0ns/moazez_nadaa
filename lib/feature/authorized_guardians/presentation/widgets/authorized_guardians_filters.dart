import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/authorized_guardians_dummy_data.dart';
import '../../data/models/authorized_guardian.dart';

class AuthorizedGuardiansFilters extends StatelessWidget {
  const AuthorizedGuardiansFilters({
    super.key,
    required this.searchController,
    required this.query,
    required this.gate,
    required this.status,
    required this.onSearchChanged,
    required this.onGateChanged,
    required this.onStatusChanged,
    required this.onReset,
  });

  final TextEditingController searchController;
  final String query;
  final String gate;
  final GuardianTrustStatus? status;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onGateChanged;
  final ValueChanged<GuardianTrustStatus?> onStatusChanged;
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
              const Icon(Iconsax.search_status, color: AppColors.primary),
              AppSpacing.horizontalSpaceSm,
              Expanded(
                child: Text(
                  'البحث والتحقق',
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
          TextField(
            controller: searchController,
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: 'اسم ولي الأمر، الطالب، الهاتف أو رقم الهوية',
              prefixIcon: const Icon(Iconsax.search_normal),
              filled: true,
              fillColor: AppColors.backgroundLight,
              border: OutlineInputBorder(
                borderRadius: AppRadius.all(AppRadius.radius5),
                borderSide: BorderSide.none,
              ),
            ),
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
                  _GateDropdown(
                    width: itemWidth,
                    value: gate,
                    onChanged: onGateChanged,
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

class _GateDropdown extends StatelessWidget {
  const _GateDropdown({
    required this.width,
    required this.value,
    required this.onChanged,
  });

  final double width;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: DropdownButtonFormField<String>(
        initialValue: value,
        isExpanded: true,
        icon: const Icon(Iconsax.arrow_down_1, size: 16),
        decoration: _dropdownDecoration('البوابة'),
        items: AuthorizedGuardiansDummyData.gates
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
  final GuardianTrustStatus? value;
  final ValueChanged<GuardianTrustStatus?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: DropdownButtonFormField<GuardianTrustStatus?>(
        initialValue: value,
        isExpanded: true,
        icon: const Icon(Iconsax.arrow_down_1, size: 16),
        decoration: _dropdownDecoration('الحالة'),
        items: const [
          DropdownMenuItem<GuardianTrustStatus?>(
            value: null,
            child: Text('الكل'),
          ),
          DropdownMenuItem<GuardianTrustStatus?>(
            value: GuardianTrustStatus.verified,
            child: Text('معتمد'),
          ),
          DropdownMenuItem<GuardianTrustStatus?>(
            value: GuardianTrustStatus.temporary,
            child: Text('تصريح مؤقت'),
          ),
          DropdownMenuItem<GuardianTrustStatus?>(
            value: GuardianTrustStatus.reviewNeeded,
            child: Text('يحتاج مراجعة'),
          ),
          DropdownMenuItem<GuardianTrustStatus?>(
            value: GuardianTrustStatus.suspended,
            child: Text('موقوف'),
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
