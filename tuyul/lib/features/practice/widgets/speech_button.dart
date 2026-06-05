import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../screens/practice_screen.dart';

class SpeechButton extends StatelessWidget {
  final PracticeState state;
  final Animation<double> pulseAnim;
  final Color levelColor;
  final bool speechAvailable;
  final VoidCallback onStart;
  final VoidCallback onStop;

  const SpeechButton({
    super.key,
    required this.state,
    required this.pulseAnim,
    required this.levelColor,
    required this.speechAvailable,
    required this.onStart,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    final isListening = state == PracticeState.listening;
    final isChecking = state == PracticeState.checking;
    final isDone =
        state == PracticeState.correct || state == PracticeState.wrong;

    if (isDone) {
      return const SizedBox(width: 80, height: 80);
    }

    return GestureDetector(
      onTap: !speechAvailable
          ? null
          : isListening
              ? onStop
              : !isChecking
                  ? onStart
                  : null,
      child: AnimatedBuilder(
        animation: pulseAnim,
        builder: (context, child) {
          final scale = isListening ? pulseAnim.value : 1.0;
          return Transform.scale(
            scale: scale,
            child: child,
          );
        },
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isListening
                ? AppColors.accent
                : isChecking
                    ? AppColors.warning
                    : speechAvailable
                        ? levelColor
                        : AppColors.textHint,
            boxShadow: isListening
                ? [
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 4,
                    )
                  ]
                : [
                    BoxShadow(
                      color: levelColor.withOpacity(0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    )
                  ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isListening
                    ? Icons.stop
                    : isChecking
                        ? Icons.hourglass_top
                        : Icons.mic,
                color: Colors.white,
                size: 28,
              ),
              const SizedBox(height: 2),
              Text(
                isListening
                    ? 'To\'xtat'
                    : isChecking
                        ? 'Tekshir...'
                        : 'Gapir',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
