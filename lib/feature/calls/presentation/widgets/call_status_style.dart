import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/pickup_request.dart';

class CallStatusStyle {
  const CallStatusStyle._();

  static Color statusColor(PickupStatus status) {
    switch (status) {
      case PickupStatus.newRequest:
        return AppColors.info;
      case PickupStatus.preparing:
        return AppColors.warning;
      case PickupStatus.ready:
        return AppColors.success;
      case PickupStatus.delivered:
        return AppColors.primary;
      case PickupStatus.delayed:
        return AppColors.error;
    }
  }
}
