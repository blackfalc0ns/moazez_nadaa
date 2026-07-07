import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/permissions/app_permission.dart';
import '../../../../core/permissions/permission_repository.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/common/custom_app_bar.dart';
import '../../../../core/utils/feedback/premium_snackbar.dart';
import '../../../../core/widgets/logo_shimmer_loader.dart';
import '../../../../generated/app_localizations.dart';
import '../../../dismissal/presentation/cubits/dismissal_cubit.dart';
import '../../../dismissal/presentation/cubits/dismissal_state.dart';
import '../widgets/profile_check_list_card.dart';
import '../widgets/profile_header_card.dart';
import '../widgets/profile_info_card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final DismissalCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<DismissalCubit>()..loadProfile();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<DismissalCubit, DismissalState>(
        listenWhen: (previous, current) => previous.failure != current.failure,
        listener: (context, state) {
          if (state.failure != null) {
            PremiumSnackbar.error(
              context,
              message: state.failure!.getLocalizedMessage(context),
            );
          }
        },
        builder: (context, state) {
          final profile = state.profile;
          return Scaffold(
            appBar: CustomAppBar(title: l10n.dismissalProfileTitle),
            body: profile == null
                ? const Center(child: LogoShimmerLoader(size: 112))
                : RefreshIndicator(
                    onRefresh: () =>
                        context.read<DismissalCubit>().loadProfile(),
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        AppSpacing.md,
                        AppSpacing.lg,
                        AppSpacing.xl,
                      ),
                      children: [
                        ProfileHeaderCard(profile: profile),
                        AppSpacing.verticalSpaceMd,
                        ProfileInfoCard(profile: profile),
                        AppSpacing.verticalSpaceMd,
                        ProfileCheckListCard(
                          title: l10n.dismissalProfilePermissions,
                          icon: Iconsax.shield_tick,
                          items: _permissionLabels(l10n),
                        ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }

  List<String> _permissionLabels(AppLocalizations l10n) {
    final granted = sl<PermissionRepository>().grantedPermissions();
    return granted.map((permission) {
      switch (permission) {
        case AppPermission.viewProfile:
          return l10n.permissionProfileView;
        case AppPermission.viewGates:
          return l10n.permissionGatesView;
        case AppPermission.viewRequests:
          return l10n.permissionRequestsView;
        case AppPermission.manageRequests:
          return l10n.permissionRequestsManage;
        case AppPermission.deliverRequests:
          return l10n.permissionRequestsDeliver;
        case AppPermission.escalateRequests:
          return l10n.permissionRequestsEscalate;
        case AppPermission.viewHistory:
          return l10n.permissionHistoryView;
        case AppPermission.viewNotifications:
          return l10n.permissionNotificationsView;
        case AppPermission.manageNotifications:
          return l10n.permissionNotificationsManage;
        case AppPermission.manageDeviceTokens:
          return l10n.permissionDeviceTokensManage;
      }
    }).toList(growable: false);
  }
}
