import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/vocabulary_provider.dart';

class SaveWordDialog extends StatefulWidget {
  final String word;
  final String sentenceEnglish;
  final String levelCode;

  const SaveWordDialog({
    super.key,
    required this.word,
    required this.sentenceEnglish,
    required this.levelCode,
  });

  @override
  State<SaveWordDialog> createState() => _SaveWordDialogState();
}

class _SaveWordDialogState extends State<SaveWordDialog> {
  final _translationCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  bool _saving = false;
  bool _saved = false;

  @override
  void dispose() {
    _translationCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_translationCtrl.text.trim().isEmpty) return;
    setState(() => _saving = true);

    await context.read<VocabularyProvider>().addWord(
          word: widget.word,
          translation: _translationCtrl.text.trim(),
          example: _noteCtrl.text.trim().isNotEmpty ? _noteCtrl.text.trim() : null,
          sentenceEnglish: widget.sentenceEnglish,
          levelCode: widget.levelCode,
        );

    setState(() {
      _saving = false;
      _saved = true;
    });

    await Future.delayed(const Duration(milliseconds: 700));
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.getLevelColor(widget.levelCode);
    final vocabProvider = context.watch<VocabularyProvider>();
    final alreadySaved = vocabProvider.isWordSaved(widget.word);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                color: AppColors.cardBorder,
              ),
            ),
            const SizedBox(height: 16),

            // Word
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  color: color.withOpacity(0.15),
                  child: Text(
                    widget.word,
                    style: TextStyle(
                      color: color,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                if (alreadySaved)
                  const Row(
                    children: [
                      Icon(Icons.bookmark, color: AppColors.secondary, size: 16),
                      SizedBox(width: 4),
                      Text('Saqlangan',
                          style: TextStyle(
                              color: AppColors.secondary, fontSize: 12)),
                    ],
                  ),
              ],
            ),

            const SizedBox(height: 8),

            // Context sentence
            Container(
              padding: const EdgeInsets.all(10),
              color: AppColors.surfaceVariant,
              child: Text(
                widget.sentenceEnglish,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),

            if (!alreadySaved) ...[
              const SizedBox(height: 16),

              // Translation field
              const Text('O\'zbekcha tarjima *',
                  style: TextStyle(
                      color: AppColors.textHint, fontSize: 12)),
              const SizedBox(height: 6),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: TextField(
                  controller: _translationCtrl,
                  style: const TextStyle(
                      color: AppColors.textPrimary, fontSize: 15),
                  decoration: const InputDecoration(
                    hintText: 'Masalan: salom, yaxshi...',
                    hintStyle: TextStyle(color: AppColors.textHint),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  autofocus: true,
                ),
              ),

              const SizedBox(height: 10),

              // Note field
              const Text('Eslatma (ixtiyoriy)',
                  style: TextStyle(
                      color: AppColors.textHint, fontSize: 12)),
              const SizedBox(height: 6),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: TextField(
                  controller: _noteCtrl,
                  style: const TextStyle(
                      color: AppColors.textPrimary, fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: 'Qo\'shimcha eslatma...',
                    hintStyle: TextStyle(color: AppColors.textHint),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Save button
              GestureDetector(
                onTap: _saving || _saved ? null : _save,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  color: _saved
                      ? AppColors.success
                      : _saving
                          ? color.withOpacity(0.6)
                          : color,
                  child: Center(
                    child: _saving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _saved ? Icons.check : Icons.bookmark_add,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _saved ? 'Saqlandi!' : 'Lug\'atga saqlash',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ] else ...[
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  color: AppColors.surfaceVariant,
                  child: const Center(
                    child: Text('Yopish',
                        style: TextStyle(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
