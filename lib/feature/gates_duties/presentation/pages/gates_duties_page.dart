import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/common/custom_app_bar.dart';
import '../../data/gates_duties_dummy_data.dart';
import '../widgets/duty_shift_card.dart';
import '../widgets/gate_duty_card.dart';
import '../widgets/gate_operations_notes.dart';
import '../widgets/gates_overview_strip.dart';

class GatesDutiesPage extends StatefulWidget {
  const GatesDutiesPage({super.key});

  @override
  State<GatesDutiesPage> createState() => _GatesDutiesPageState();
}

class _GatesDutiesPageState extends State<GatesDutiesPage> {
  int _selectedView = 0;

  @override
  Widget build(BuildContext context) {
    final gates = GatesDutiesDummyData.gates;

    return Scaffold(
      appBar: const CustomAppBar(title: 'البوابات والمناوبات'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        children: [
          GatesOverviewStrip(gates: gates),
          AppSpacing.verticalSpaceMd,
          _ViewSwitch(
            selectedIndex: _selectedView,
            onChanged: (index) => setState(() => _selectedView = index),
          ),
          AppSpacing.verticalSpaceMd,
          if (_selectedView == 0) ...[
            const _SectionHeader(
              title: 'حالة البوابات الآن',
              subtitle: 'متابعة الضغط والمشرفين ونطاق كل بوابة',
            ),
            AppSpacing.verticalSpaceSm,
            for (final gate in gates) GateDutyCard(gate: gate),
            AppSpacing.verticalSpaceMd,
            const GateOperationsNotes(),
          ] else ...[
            const _SectionHeader(
              title: 'مناوبات اليوم',
              subtitle: 'المسؤوليات الحالية والقادمة لكل بوابة',
            ),
            AppSpacing.verticalSpaceSm,
            for (final gate in gates)
              DutyShiftCard(gateName: gate.name, shift: gate.currentShift),
            AppSpacing.verticalSpaceMd,
            const _SectionHeader(
              title: 'المناوبات القادمة',
              subtitle: 'تحضير الانتقال وتسليم المسؤوليات',
            ),
            AppSpacing.verticalSpaceSm,
            for (final gate in gates)
              DutyShiftCard(
                gateName: gate.name,
                shift: gate.nextShift,
                compact: true,
              ),
          ],
        ],
      ),
    );
  }
}

class _ViewSwitch extends StatelessWidget {
  const _ViewSwitch({required this.selectedIndex, required this.onChanged});

  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    const labels = ['البوابات', 'المناوبات'];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.all(AppRadius.radius5),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          for (int index = 0; index < labels.length; index++)
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: selectedIndex == index
                        ? AppColors.primary
                        : Colors.transparent,
                    borderRadius: AppRadius.all(AppRadius.radius4),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    labels[index],
                    style: AppTypography.labelMedium.copyWith(
                      color: selectedIndex == index
                          ? AppColors.white
                          : AppColors.textSecondaryLight,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.heading5.copyWith(
            color: AppColors.primaryDeep,
            fontWeight: FontWeight.w900,
          ),
        ),
        AppSpacing.verticalSpaceXxs,
        Text(
          subtitle,
          style: AppTypography.caption.copyWith(
            color: AppColors.textSecondaryLight,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
