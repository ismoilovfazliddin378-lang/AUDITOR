import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/models.dart';

class WordCard extends StatefulWidget {
  final SavedWordModel word;
  final VoidCallback onDelete;

  const WordCard({super.key, required this.word, required this.onDelete});

  @override
  State<WordCard> createState() => _WordCardState();
}

class _WordCardState extends State<WordCard> {
  bool _expanded = false;
  final FlutterTts _tts = FlutterTts();

  Future<void> _speak() async {
    HapticFeedback.selectionClick();
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.45);
    await _tts.speak(widget.word.word);
  }

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.getLevelColor(widget.word.levelCode);

    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          children: [
            // Main row
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  // Level badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    color: color.withOpacity(0.15),
                    child: Text(
                      widget.word.levelCode,
                      style: TextStyle(
                        color: color,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.word.word,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          widget.word.translation,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Speak button
                  GestureDetector(
                    onTap: _speak,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      color: color.withOpacity(0.1),
                      child: Icon(Icons.volume_up, color: color, size: 16),
                    ),
                  ),

                  const SizedBox(width: 6),

                  // Expand button
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.textHint,
                    size: 18,
                  ),
                ],
              ),
            ),

            // Expanded details
            if (_expanded) ...[
              Container(
                width: double.infinity,
                color: AppColors.surfaceVariant,
                height: 1,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sentence context
                    if (widget.word.sentenceEnglish != null) ...[
                      const Text(
                        'Kontekst gap:',
                        style: TextStyle(
                            color: AppColors.textHint, fontSize: 10),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.all(10),
                        color: color.withOpacity(0.06),
                        child: _HighlightedText(
                          text: widget.word.sentenceEnglish!,
                          highlight: widget.word.word,
                          color: color,
                        ),
                      ),
                    ],

                    // Note
                    if (widget.word.example != null &&
                        widget.word.example!.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.sticky_note_2,
                              color: AppColors.warning, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            widget.word.example!,
                            style: const TextStyle(
                                color: AppColors.textSecondary, fontSize: 12),
                          ),
                        ],
                      ),
                    ],

                    // Saved date + delete
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Saqlangan: ${_formatDate(widget.word.savedAt)}',
                          style: const TextStyle(
                              color: AppColors.textHint, fontSize: 10),
                        ),
                        GestureDetector(
                          onTap: () => _confirmDelete(context),
                          child: const Row(
                            children: [
                              Icon(Icons.delete_outline,
                                  color: AppColors.error, size: 14),
                              SizedBox(width: 4),
                              Text('O\'chirish',
                                  style: TextStyle(
                                      color: AppColors.error, fontSize: 11)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: const RoundedRectangleBorder(),
        title: const Text('O\'chirishni tasdiqlang',
            style: TextStyle(color: AppColors.textPrimary, fontSize: 16)),
        content: Text(
          '"${widget.word.word}" so\'zini lug\'atdan o\'chirmoqchimisiz?',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Bekor qilish',
                style: TextStyle(color: AppColors.textHint)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onDelete();
            },
            child: const Text("O'chirish",
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year}';
  }
}

// Highlighted text widget
class _HighlightedText extends StatelessWidget {
  final String text;
  final String highlight;
  final Color color;

  const _HighlightedText({
    required this.text,
    required this.highlight,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final lowerText = text.toLowerCase();
    final lowerHighlight = highlight.toLowerCase();
    final idx = lowerText.indexOf(lowerHighlight);

    if (idx == -1) {
      return Text(text,
          style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontStyle: FontStyle.italic));
    }

    return RichText(
      text: TextSpan(
        style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
            fontStyle: FontStyle.italic),
        children: [
          TextSpan(text: text.substring(0, idx)),
          TextSpan(
            text: text.substring(idx, idx + highlight.length),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
            ),
          ),
          TextSpan(text: text.substring(idx + highlight.length)),
        ],
      ),
    );
  }
}
