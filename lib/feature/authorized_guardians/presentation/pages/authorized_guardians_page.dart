import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/common/custom_app_bar.dart';
import '../../data/authorized_guardians_dummy_data.dart';
import '../../data/models/authorized_guardian.dart';
import '../widgets/authorized_guardian_card.dart';
import '../widgets/authorized_guardians_empty_state.dart';
import '../widgets/authorized_guardians_filters.dart';
import '../widgets/authorized_guardians_summary.dart';

class AuthorizedGuardiansPage extends StatefulWidget {
  const AuthorizedGuardiansPage({super.key});

  @override
  State<AuthorizedGuardiansPage> createState() =>
      _AuthorizedGuardiansPageState();
}

class _AuthorizedGuardiansPageState extends State<AuthorizedGuardiansPage> {
  final TextEditingController _searchController = TextEditingController();

  String _query = '';
  String _gate = 'الكل';
  GuardianTrustStatus? _status;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<AuthorizedGuardian> get _filteredGuardians {
    return AuthorizedGuardiansDummyData.guardians
        .where(_matchesFilters)
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final guardians = _filteredGuardians;
    final verifiedCount = guardians
        .where((guardian) => guardian.status == GuardianTrustStatus.verified)
        .length;
    final reviewCount = guardians
        .where(
          (guardian) => guardian.status == GuardianTrustStatus.reviewNeeded,
        )
        .length;

    return Scaffold(
      appBar: const CustomAppBar(title: 'أولياء الأمور المعتمدون'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        children: [
          AuthorizedGuardiansSummary(
            totalCount: guardians.length,
            verifiedCount: verifiedCount,
            reviewCount: reviewCount,
          ),
          AppSpacing.verticalSpaceMd,
          AuthorizedGuardiansFilters(
            searchController: _searchController,
            query: _query,
            gate: _gate,
            status: _status,
            onSearchChanged: (value) => setState(() => _query = value),
            onGateChanged: (value) => setState(() => _gate = value),
            onStatusChanged: (value) => setState(() => _status = value),
            onReset: _resetFilters,
          ),
          AppSpacing.verticalSpaceLg,
          _ResultsHeader(count: guardians.length),
          AppSpacing.verticalSpaceMd,
          if (guardians.isEmpty)
            const AuthorizedGuardiansEmptyState()
          else
            for (final guardian in guardians)
              AuthorizedGuardianCard(guardian: guardian),
        ],
      ),
    );
  }

  bool _matchesFilters(AuthorizedGuardian guardian) {
    final query = _query.trim();
    final matchesSearch =
        query.isEmpty ||
        guardian.name.contains(query) ||
        guardian.phone.contains(query) ||
        guardian.nationalIdMasked.contains(query) ||
        guardian.allowedStudents.any((student) => student.contains(query));
    final matchesGate = _gate == 'الكل' || guardian.allowedGate == _gate;
    final matchesStatus = _status == null || guardian.status == _status;

    return matchesSearch && matchesGate && matchesStatus;
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _query = '';
      _gate = 'الكل';
      _status = null;
    });
  }
}

class _ResultsHeader extends StatelessWidget {
  const _ResultsHeader({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'قائمة المخولين',
            style: AppTypography.heading5.copyWith(
              color: AppColors.primaryDeep,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Text(
          '$count ولي أمر',
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.textSecondaryLight,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
