import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/models.dart';

class SentenceDisplay extends StatelessWidget {
  final SentenceModel sentence;
  final String levelCode;
  final Color levelColor;
  final void Function(String word) onWordTap;
  final VoidCallback onSpeakTap;

  const SentenceDisplay({
    super.key,
    required this.sentence,
    required this.levelCode,
    required this.levelColor,
    required this.onWordTap,
    required this.onSpeakTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        border: Border.all(color: AppColors.cardBorder),
        // qirrasiz to'rtburchak
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.cardBorder),
              ),
              color: levelColor.withOpacity(0.05),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  color: levelColor.withOpacity(0.15),
                  child: Text(
                    levelCode,
                    style: TextStyle(
                      color: levelColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'O\'zbek gapini inglizcha ayting',
                  style: TextStyle(
                    color: AppColors.textHint,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          // Uzbek sentence (BIG)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Text(
              sentence.uzbek,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 26,
                fontWeight: FontWeight.w700,
                height: 1.4,
              ),
            ),
          ),

          // Hint if exists
          if (sentence.hint != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb_outline,
                      color: AppColors.warning, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    sentence.hint!,
                    style: const TextStyle(
                        color: AppColors.warning, fontSize: 12),
                  ),
                ],
              ),
            ),

          // Divider
          const Divider(color: AppColors.cardBorder, height: 1),

          // English answer (tappable words)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Inglizcha javob:',
                  style: TextStyle(
                    color: AppColors.textHint,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 6),
                _TappableWords(
                  text: sentence.english,
                  onWordTap: onWordTap,
                  color: levelColor,
                ),
              ],
            ),
          ),

          // Speak button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: GestureDetector(
              onTap: onSpeakTap,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    color: levelColor.withOpacity(0.12),
                    child: Icon(Icons.volume_up, color: levelColor, size: 16),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Talaffuzni tinglang',
                    style: TextStyle(
                      color: levelColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
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
}

// ── Tappable Words ──────────────────────────────────────────────────────────
class _TappableWords extends StatelessWidget {
  final String text;
  final void Function(String) onWordTap;
  final Color color;

  const _TappableWords({
    required this.text,
    required this.onWordTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final words = text.split(' ');
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: words.map((word) {
        final clean = word.replaceAll(RegExp(r"[^\w]"), '');
        return GestureDetector(
          onTap: () {
            if (clean.isNotEmpty) onWordTap(clean);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              border: Border.all(color: color.withOpacity(0.2)),
            ),
            child: Text(
              word,
              style: TextStyle(
                color: color,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
