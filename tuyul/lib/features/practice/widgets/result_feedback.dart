import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../screens/practice_screen.dart';

class ResultFeedback extends StatelessWidget {
  final PracticeState state;
  final double accuracy;
  final String spokenText;
  final String correctText;
  final Color levelColor;
  final VoidCallback onNext;
  final VoidCallback onRetry;

  const ResultFeedback({
    super.key,
    required this.state,
    required this.accuracy,
    required this.spokenText,
    required this.correctText,
    required this.levelColor,
    required this.onNext,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final isCorrect = state == PracticeState.correct;
    final color = isCorrect ? AppColors.success : AppColors.error;
    final pct = (accuracy * 100).toInt();

    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 400),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          border: Border.all(color: color.withOpacity(0.35)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: color.withOpacity(0.12),
              child: Row(
                children: [
                  Icon(
                    isCorrect ? Icons.check_circle : Icons.cancel,
                    color: color,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isCorrect ? 'Ajoyib! To\'g\'ri!' : 'Qayta urinib ko\'ring',
                    style: TextStyle(
                      color: color,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  // Accuracy badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    color: color.withOpacity(0.2),
                    child: Text(
                      '$pct%',
                      style: TextStyle(
                        color: color,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Spoken
                  _ResultRow(
                    label: 'Siz aytdingiz:',
                    text: spokenText.isEmpty ? '(hech narsa eshitilmadi)' : spokenText,
                    color: isCorrect ? AppColors.success : AppColors.error,
                    icon: Icons.record_voice_over,
                  ),

                  if (!isCorrect) ...[
                    const SizedBox(height: 10),
                    // Correct answer
                    _ResultRow(
                      label: 'To\'g\'ri javob:',
                      text: correctText,
                      color: AppColors.secondary,
                      icon: Icons.check,
                    ),

                    const SizedBox(height: 12),
                    // Word comparison
                    _WordComparison(
                      spoken: spokenText,
                      correct: correctText,
                    ),
                  ],

                  const SizedBox(height: 14),

                  // Action buttons
                  Row(
                    children: [
                      if (!isCorrect) ...[
                        Expanded(
                          child: _ActionBtn(
                            label: 'Qayta urinish',
                            icon: Icons.refresh,
                            color: AppColors.warning,
                            onTap: onRetry,
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                      Expanded(
                        child: _ActionBtn(
                          label: 'Keyingisi',
                          icon: Icons.arrow_forward,
                          color: levelColor,
                          onTap: onNext,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final String text;
  final Color color;
  final IconData icon;

  const _ResultRow({
    required this.label,
    required this.text,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      color: AppColors.textHint, fontSize: 10)),
              Text(text,
                  style: TextStyle(
                      color: color,
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Word comparison ─────────────────────────────────────────────────────────
class _WordComparison extends StatelessWidget {
  final String spoken;
  final String correct;

  const _WordComparison({required this.spoken, required this.correct});

  @override
  Widget build(BuildContext context) {
    final correctWords =
        correct.toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '').split(' ');
    final spokenWords =
        spoken.toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '').split(' ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'So\'z tahlili:',
          style: TextStyle(color: AppColors.textHint, fontSize: 10),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: correctWords.where((w) => w.isNotEmpty).map((word) {
            final matched =
                spokenWords.any((w) => w == word || _close(w, word));
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              color: matched
                  ? AppColors.success.withOpacity(0.15)
                  : AppColors.error.withOpacity(0.15),
              child: Text(
                word,
                style: TextStyle(
                  color: matched ? AppColors.success : AppColors.error,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  bool _close(String a, String b) {
    if ((a.length - b.length).abs() > 2) return false;
    int diff = 0;
    final min = a.length < b.length ? a : b;
    final max = a.length < b.length ? b : a;
    for (int i = 0; i < min.length; i++) {
      if (min[i] != max[i]) diff++;
    }
    return diff <= 1;
  }
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        color: color,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 6),
            Text(label,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
