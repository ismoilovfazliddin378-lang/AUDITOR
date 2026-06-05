import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../screens/practice_screen.dart';

class SubtitleBox extends StatelessWidget {
  final String spokenText;
  final PracticeState state;
  final Color levelColor;

  const SubtitleBox({
    super.key,
    required this.spokenText,
    required this.state,
    required this.levelColor,
  });

  @override
  Widget build(BuildContext context) {
    final isListening = state == PracticeState.listening;
    final hasText = spokenText.isNotEmpty;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 64),
      decoration: BoxDecoration(
        color: isListening
            ? AppColors.accent.withOpacity(0.08)
            : AppColors.surfaceVariant,
        border: Border.all(
          color: isListening
              ? AppColors.accent.withOpacity(0.4)
              : AppColors.cardBorder,
          width: isListening ? 1.5 : 1,
        ),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label row
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isListening ? AppColors.accent : AppColors.textHint,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                isListening ? 'Tinglayapman...' : 'Sizning gapingiz',
                style: TextStyle(
                  color: isListening ? AppColors.accent : AppColors.textHint,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (isListening) ...[
                const SizedBox(width: 8),
                _BlinkingDots(color: AppColors.accent),
              ],
            ],
          ),

          const SizedBox(height: 8),

          // Spoken text
          if (hasText)
            Text(
              spokenText,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            )
          else
            Text(
              isListening
                  ? 'Inglizcha gapiring...'
                  : 'Mikrofon tugmasini bosib gapiring',
              style: const TextStyle(
                color: AppColors.textHint,
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }
}

// ── Blinking dots animation ────────────────────────────────────────────────
class _BlinkingDots extends StatefulWidget {
  final Color color;
  const _BlinkingDots({required this.color});

  @override
  State<_BlinkingDots> createState() => _BlinkingDotsState();
}

class _BlinkingDotsState extends State<_BlinkingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600))
      ..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.3, end: 1.0).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _anim,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          3,
          (i) => Container(
            width: 5,
            height: 5,
            margin: const EdgeInsets.only(right: 3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.color,
            ),
          ),
        ),
      ),
    );
  }
}
