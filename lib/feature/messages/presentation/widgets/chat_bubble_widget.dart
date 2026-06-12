import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/models/chat_message_model.dart';

class ChatBubbleWidget extends StatelessWidget {
  final ChatMessageModel message;
  final String? peerAvatarUrl;

  const ChatBubbleWidget({
    super.key,
    required this.message,
    this.peerAvatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    // isMe means I am the sender. In Arabic (RTL):
    // - Me -> Bubble on Left (end)
    // - Other -> Bubble on Right (start)
    final bool isMe = message.sender == MessageSender.me;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // If NOT me, show avatar on the right edge
          if (!isMe) ...[
            if (message.isFirstInGroup)
              CircleAvatar(
                radius: 16,
                backgroundImage: peerAvatarUrl != null
                    ? AssetImage(peerAvatarUrl!)
                    : null,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: peerAvatarUrl == null
                    ? const Icon(
                        Icons.person,
                        color: AppColors.primary,
                        size: 18,
                      )
                    : null,
              )
            else
              AppSpacing.horizontalSpaceXxl,
            AppSpacing.horizontalSpaceSm,
          ],

          Flexible(
            child: Padding(
              // Allow some spacing so bubbles don't stretch fully to the other side
              padding: EdgeInsets.only(
                right: isMe ? 40.0 : 0.0,
                left: isMe ? 0.0 : 40.0,
              ),
              child: Column(
                crossAxisAlignment: isMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  // Bubble container
                  Container(
                    padding: message.type == MessageType.audio
                        ? EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg - 2,
                            vertical: AppSpacing.sm + 2,
                          )
                        : EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg + 2,
                            vertical: AppSpacing.md,
                          ),
                    decoration: BoxDecoration(
                      border: isMe
                          ? null
                          : Border.all(color: AppColors.lightGrey),
                      color: isMe ? AppColors.primary : AppColors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(AppRadius.radiusL),
                        topRight: Radius.circular(AppRadius.radiusL),
                        bottomRight: isMe
                            ? Radius.circular(AppRadius.radiusL)
                            : Radius.circular(AppRadius.radius4),
                        bottomLeft: isMe
                            ? Radius.circular(AppRadius.radius4)
                            : Radius.circular(AppRadius.radiusL),
                      ),
                    ),
                    child: message.type == MessageType.text
                        ? Text(
                            message.text,
                            style: AppTypography.bodyMedium.copyWith(
                              color: isMe ? Colors.white : AppColors.black,
                            ),
                          )
                        : _buildAudioPlayer(isMe),
                  ),

                  // Footer (Time and Status)
                  Padding(
                    padding: EdgeInsets.only(top: AppSpacing.xs, left: AppSpacing.xs, right: AppSpacing.xs),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          message.time,
                          style: AppTypography.labelSmall.copyWith(
                            color: Colors.grey[400],
                          ),
                        ),
                        if (isMe) ...[
                          const SizedBox(width: 4),
                          Icon(
                            message.isRead ? Icons.done_all : Icons.check,
                            size: 15,
                            color: message.isRead
                                ? AppColors.primary
                                : Colors.grey[400],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioPlayer(bool isMe) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      textDirection:
          TextDirection.ltr, // Keep LTR layout for audio: Play -> Wave -> Time
      children: [
        // Play button
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.play_arrow_rounded,
            color: isMe ? AppColors.primary : AppColors.black,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        // Waves
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(12, (index) {
              final heights = [
                10.0,
                15.0,
                8.0,
                20.0,
                25.0,
                12.0,
                18.0,
                22.0,
                14.0,
                10.0,
                24.0,
                16.0,
              ];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2.0),
                width: 3,
                height: heights[index % heights.length],
                decoration: BoxDecoration(
                  color: isMe
                      ? Colors.white.withValues(alpha: 0.8)
                      : Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            }),
          ),
        ),
        const SizedBox(width: 12),
        // Duration
        Text(
          message.text,
          style: AppTypography.labelMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: isMe ? Colors.white : AppColors.black,
          ),
        ),
      ],
    );
  }
}
