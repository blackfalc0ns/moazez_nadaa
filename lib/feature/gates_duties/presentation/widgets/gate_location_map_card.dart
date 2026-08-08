import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/feedback/premium_snackbar.dart';
import '../../../../generated/app_localizations.dart';
import '../../../dismissal/data/models/dismissal_models.dart';

class GateLocationMapCard extends StatelessWidget {
  const GateLocationMapCard({super.key, required this.gate});

  final DismissalGateModel gate;

  @override
  Widget build(BuildContext context) {
    if (!gate.hasValidLocation) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context)!;
    final position = LatLng(gate.latitude!, gate.longitude!);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.045),
        borderRadius: AppRadius.all(AppRadius.radius4),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 142,
            width: double.infinity,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(target: position, zoom: 16),
              markers: {
                Marker(
                  markerId: MarkerId(gate.id),
                  position: position,
                  infoWindow: InfoWindow(title: gate.name),
                ),
              },
              liteModeEnabled: true,
              mapToolbarEnabled: false,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              compassEnabled: false,
              rotateGesturesEnabled: false,
              scrollGesturesEnabled: false,
              tiltGesturesEnabled: false,
              zoomGesturesEnabled: false,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: AppRadius.all(AppRadius.radius3),
                  ),
                  child: const Icon(
                    Iconsax.location,
                    size: 17,
                    color: AppColors.primary,
                  ),
                ),
                AppSpacing.horizontalSpaceSm,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.dismissalGateLocationTitle,
                        style: AppTypography.caption.copyWith(
                          color: AppColors.primaryDeep,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        l10n.dismissalGateCoordinates(
                          gate.latitude!.toStringAsFixed(6),
                          gate.longitude!.toStringAsFixed(6),
                        ),
                        textDirection: TextDirection.ltr,
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textSecondaryLight,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _openLocation(context),
                  icon: const Icon(Iconsax.export_3, size: 15),
                  label: Text(l10n.dismissalOpenInMaps),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    textStyle: AppTypography.caption.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openLocation(BuildContext context) async {
    final uri = Uri.https('www.google.com', '/maps/search/', {
      'api': '1',
      'query': '${gate.latitude},${gate.longitude}',
    });
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && context.mounted) {
      PremiumSnackbar.error(
        context,
        message: AppLocalizations.of(context)!.dismissalMapOpenError,
      );
    }
  }
}
