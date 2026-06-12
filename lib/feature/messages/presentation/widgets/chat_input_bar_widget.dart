import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_durations.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class ChatInputBarWidget extends StatefulWidget {
  const ChatInputBarWidget({super.key});

  @override
  State<ChatInputBarWidget> createState() => _ChatInputBarWidgetState();
}

class _ChatInputBarWidgetState extends State<ChatInputBarWidget> {
  final TextEditingController _messageController = TextEditingController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _messageController.addListener(() {
      final isTyping = _messageController.text.trim().isNotEmpty;
      if (_isTyping != isTyping) {
        setState(() {
          _isTyping = isTyping;
        });
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),

      child: SafeArea(
        child: Row(
          children: [
            // Rightmost Add/Attach Button
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.indigo.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.add, color: Colors.indigo, size: 24),
                constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                padding: EdgeInsets.zero,
              ),
            ),
            AppSpacing.horizontalSpaceMd,

            // Center Text Field
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'اكتب الرسالة ..',
                  hintStyle: AppTypography.bodyMedium.copyWith(
                    color: Colors.grey[400],
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.radiusXXL),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md + 2,
                  ),
                ),
              ),
            ),
            AppSpacing.horizontalSpaceMd,

            // Leftmost Dynamic Button (Mic / Send)
            AnimatedContainer(
              duration: AppDurations.fast,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {
                  if (_isTyping) {
                    // Send message logic
                    _messageController.clear();
                  } else {
                    // Microphone logic
                  }
                },
                icon: AnimatedSwitcher(
                  duration: AppDurations.fast,
                  transitionBuilder: (child, animation) =>
                      ScaleTransition(scale: animation, child: child),
                  child: _isTyping
                      ? const Icon(
                          Icons.send_rounded,
                          key: ValueKey('send_icon'),
                          color: Colors.white,
                          size: 24,
                        )
                      : const Icon(
                          Icons.mic,
                          key: ValueKey('mic_icon'),
                          color: Colors.white,
                          size: 24,
                        ),
                ),
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
