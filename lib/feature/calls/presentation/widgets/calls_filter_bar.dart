// import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';

// import '../../../../core/theme/app_colors.dart';
// import '../../../../core/theme/app_radius.dart';
// import '../../../../core/theme/app_spacing.dart';
// import '../../../../core/theme/app_typography.dart';
// import '../../data/models/pickup_request.dart';
// import 'call_status_style.dart';

// class CallsFilterBar extends StatelessWidget {
//   const CallsFilterBar({
//     super.key,
//     required this.searchController,
//     required this.selectedStage,
//     required this.selectedStatus,
//     required this.stages,
//     required this.onStageChanged,
//     required this.onStatusChanged,
//     required this.onSearchChanged,
//   });

//   final TextEditingController searchController;
//   final String selectedStage;
//   final PickupStatus? selectedStatus;
//   final List<String> stages;
//   final ValueChanged<String> onStageChanged;
//   final ValueChanged<PickupStatus?> onStatusChanged;
//   final ValueChanged<String> onSearchChanged;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         TextField(
//           controller: searchController,
//           onChanged: onSearchChanged,
//           textInputAction: TextInputAction.search,
//           decoration: InputDecoration(
//             hintText: 'ابحث باسم الطالب، ولي الأمر، أو كود التسليم',
//             prefixIcon: const Icon(Iconsax.search_normal),
//             suffixIcon: searchController.text.isEmpty
//                 ? null
//                 : IconButton(
//                     onPressed: () {
//                       searchController.clear();
//                       onSearchChanged('');
//                     },
//                     icon: const Icon(Icons.close_rounded),
//                   ),
//           ),
//         ),
//         AppSpacing.verticalSpaceMd,
//         _HorizontalChips(
//           children: [
//             for (final stage in stages)
//               _FilterChip(
//                 label: stage,
//                 selected: selectedStage == stage,
//                 onTap: () => onStageChanged(stage),
//               ),
//           ],
//         ),
//         AppSpacing.verticalSpaceMd,
//         _HorizontalChips(
//           children: [
//             _FilterChip(
//               label: 'كل الحالات',
//               selected: selectedStatus == null,
//               onTap: () => onStatusChanged(null),
//             ),
//             for (final status in PickupStatus.values)
//               _FilterChip(
//                 label: status.label,
//                 selected: selectedStatus == status,
//                 color: CallStatusStyle.statusColor(status),
//                 onTap: () => onStatusChanged(status),
//               ),
//           ],
//         ),
//       ],
//     );
//   }
// }

// class _HorizontalChips extends StatelessWidget {
//   const _HorizontalChips({required this.children});

//   final List<Widget> children;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 38,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         itemBuilder: (context, index) => children[index],
//         separatorBuilder: (context, index) => AppSpacing.horizontalSpaceSm,
//         itemCount: children.length,
//       ),
//     );
//   }
// }

// class _FilterChip extends StatelessWidget {
//   const _FilterChip({
//     required this.label,
//     required this.selected,
//     required this.onTap,
//     this.color,
//   });

//   final String label;
//   final bool selected;
//   final VoidCallback onTap;
//   final Color? color;

//   @override
//   Widget build(BuildContext context) {
//     final activeColor = color ?? AppColors.primary;

//     return InkWell(
//       onTap: onTap,
//       borderRadius: AppRadius.all(AppRadius.radiusFull),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 180),
//         padding: const EdgeInsets.symmetric(
//           horizontal: AppSpacing.md,
//           vertical: AppSpacing.sm,
//         ),
//         decoration: BoxDecoration(
//           color: selected
//               ? activeColor.withValues(alpha: 0.12)
//               : AppColors.surfaceLight,
//           borderRadius: AppRadius.all(AppRadius.radiusFull),
//           border: Border.all(
//             color: selected ? activeColor : AppColors.borderLight,
//           ),
//         ),
//         child: Text(
//           label,
//           style: AppTypography.labelMedium.copyWith(
//             color: selected ? activeColor : AppColors.textSecondaryLight,
//             fontWeight: FontWeight.w800,
//           ),
//         ),
//       ),
//     );
//   }
// }
