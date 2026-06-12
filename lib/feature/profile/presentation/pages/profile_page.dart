import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/common/custom_app_bar.dart';
import '../../data/profile_dummy_data.dart';
import '../widgets/profile_check_list_card.dart';
import '../widgets/profile_header_card.dart';
import '../widgets/profile_info_card.dart';
import '../widgets/profile_stats_grid.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    const profile = ProfileDummyData.profile;

    return Scaffold(
      appBar: const CustomAppBar(title: 'الملف الشخصي'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        children: [
          ProfileHeaderCard(profile: profile),
          AppSpacing.verticalSpaceMd,
          ProfileStatsGrid(stats: profile.todayStats),
          AppSpacing.verticalSpaceMd,
          ProfileInfoCard(profile: profile),
          AppSpacing.verticalSpaceMd,
          ProfileCheckListCard(
            title: 'الصلاحيات',
            icon: Iconsax.shield_tick,
            items: profile.permissions,
          ),
          AppSpacing.verticalSpaceMd,
          ProfileCheckListCard(
            title: 'ضوابط السلامة',
            icon: Iconsax.security_safe,
            items: profile.safetyChecks,
          ),
        ],
      ),
    );
  }
}
