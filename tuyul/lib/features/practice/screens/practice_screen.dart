import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/providers/progress_provider.dart';
import '../../../core/models/models.dart';
import '../widgets/sentence_display.dart';
import '../widgets/speech_button.dart';
import '../widgets/subtitle_box.dart';
import '../widgets/result_feedback.dart';
import '../widgets/save_word_dialog.dart';

enum PracticeState { idle, listening, checking, correct, wrong }

class PracticeScreen extends StatefulWidget {
  final String levelCode;
  final int sectionId;

  const PracticeScreen({
    super.key,
    required this.levelCode,
    required this.sectionId,
  });

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen>
    with TickerProviderStateMixin {
  // Speech
  final SpeechToText _speech = SpeechToText();
  final FlutterTts _tts = FlutterTts();
  bool _speechAvailable = false;

  // State
  PracticeState _state = PracticeState.idle;
  int _currentIndex = 0;
  String _spokenText = '';
  double _accuracy = 0.0;

  // Animation
  late AnimationController _pulseController;
  late AnimationController _slideController;
  late Animation<double> _pulseAnim;
  late Animation<Offset> _slideAnim;

  late SectionModel _section;
  late List<SentenceModel> _sentences;
  late Color _levelColor;

  @override
  void initState() {
    super.initState();
    _initSection();
    _initSpeech();
    _initTts();
    _initAnimations();
  }

  void _initSection() {
    final appProvider = context.read<AppProvider>();
    _section = appProvider.getSectionById(widget.levelCode, widget.sectionId);
    _sentences = _section.sentences;
    _levelColor = AppTheme.getLevelColor(widget.levelCode);
  }

  Future<void> _initSpeech() async {
    _speechAvailable = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          if (_state == PracticeState.listening) {
            _checkAnswer();
          }
        }
      },
      onError: (error) {
        if (mounted) setState(() => _state = PracticeState.idle);
      },
    );
    if (mounted) setState(() {});
  }

  Future<void> _initTts() async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.45);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
  }

  void _initAnimations() {
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));

    _slideController.forward();
    _pulseController.stop();
  }

  @override
  void dispose() {
    _speech.stop();
    _tts.stop();
    _pulseController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  // ─── Core Logic ───────────────────────────────────────────────────────────

  Future<void> _startListening() async {
    if (!_speechAvailable) {
      _showSnackBar('Mikrofon ruxsati kerak');
      return;
    }
    HapticFeedback.mediumImpact();
    setState(() {
      _state = PracticeState.listening;
      _spokenText = '';
    });
    _pulseController.repeat(reverse: true);

    await _speech.listen(
      onResult: (result) {
        if (mounted) {
          setState(() => _spokenText = result.recognizedWords);
        }
      },
      listenFor: const Duration(seconds: 15),
      pauseFor: const Duration(seconds: 3),
      localeId: 'en_US',
      listenOptions: SpeechListenOptions(
        partialResults: true,
        cancelOnError: false,
      ),
    );
  }

  Future<void> _stopListening() async {
    await _speech.stop();
    _pulseController.stop();
    _pulseController.reset();
    _checkAnswer();
  }

  void _checkAnswer() {
    if (_spokenText.isEmpty) {
      setState(() => _state = PracticeState.idle);
      return;
    }

    final expected = _sentences[_currentIndex].english.toLowerCase();
    final spoken = _spokenText.toLowerCase();

    _accuracy = _calculateAccuracy(expected, spoken);

    setState(() {
      _state = _accuracy >= 0.6 ? PracticeState.correct : PracticeState.wrong;
    });

    HapticFeedback.lightImpact();

    // Auto next after correct
    if (_state == PracticeState.correct) {
      _saveProgress();
      Future.delayed(const Duration(milliseconds: 1800), () {
        if (mounted) _nextSentence();
      });
    }
  }

  double _calculateAccuracy(String expected, String spoken) {
    // Remove punctuation
    final clean = (String s) =>
        s.replaceAll(RegExp(r"[^\w\s]"), '').trim().toLowerCase();

    final exp = clean(expected).split(' ').where((w) => w.isNotEmpty).toList();
    final spk = clean(spoken).split(' ').where((w) => w.isNotEmpty).toList();

    if (exp.isEmpty) return 1.0;

    int matches = 0;
    for (final word in exp) {
      if (spk.any((w) => w == word || _levenshtein(w, word) <= 1)) {
        matches++;
      }
    }
    return matches / exp.length;
  }

  int _levenshtein(String a, String b) {
    if (a == b) return 0;
    if (a.isEmpty) return b.length;
    if (b.isEmpty) return a.length;
    final dp = List.generate(
      a.length + 1,
      (i) => List.generate(b.length + 1, (j) => i == 0 ? j : (j == 0 ? i : 0)),
    );
    for (int i = 1; i <= a.length; i++) {
      for (int j = 1; j <= b.length; j++) {
        dp[i][j] = a[i - 1] == b[j - 1]
            ? dp[i - 1][j - 1]
            : 1 + [dp[i - 1][j], dp[i][j - 1], dp[i - 1][j - 1]].reduce((a, b) => a < b ? a : b);
      }
    }
    return dp[a.length][b.length];
  }

  void _saveProgress() {
    context.read<ProgressProvider>().updateProgress(
          widget.levelCode,
          widget.sectionId,
          _currentIndex,
          _sentences.length,
        );
  }

  void _nextSentence() {
    if (_currentIndex < _sentences.length - 1) {
      _slideController.reset();
      setState(() {
        _currentIndex++;
        _state = PracticeState.idle;
        _spokenText = '';
        _accuracy = 0.0;
      });
      _slideController.forward();
    } else {
      _showCompletionDialog();
    }
  }

  void _prevSentence() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _state = PracticeState.idle;
        _spokenText = '';
        _accuracy = 0.0;
      });
    }
  }

  Future<void> _speakSentence() async {
    HapticFeedback.selectionClick();
    await _tts.speak(_sentences[_currentIndex].english);
  }

  void _skipSentence() {
    _saveProgress();
    _nextSentence();
  }

  // ─── Dialogs ─────────────────────────────────────────────────────────────

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _CompletionDialog(
        sectionTitle: _section.title,
        levelCode: widget.levelCode,
        totalSentences: _sentences.length,
        color: _levelColor,
        onHome: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
        onNext: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showSaveWordDialog(String word) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(),
      isScrollControlled: true,
      builder: (_) => SaveWordDialog(
        word: word,
        sentenceEnglish: _sentences[_currentIndex].english,
        levelCode: widget.levelCode,
      ),
    );
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: AppColors.surfaceVariant,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(),
      ),
    );
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final sentence = _sentences[_currentIndex];
    final total = _sentences.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(total),
      body: Column(
        children: [
          // Progress bar
          _buildProgressBar(total),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                children: [
                  // Uzbek sentence card
                  SlideTransition(
                    position: _slideAnim,
                    child: SentenceDisplay(
                      sentence: sentence,
                      levelCode: widget.levelCode,
                      levelColor: _levelColor,
                      onWordTap: _showSaveWordDialog,
                      onSpeakTap: _speakSentence,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Subtitle (spoken text)
                  SubtitleBox(
                    spokenText: _spokenText,
                    state: _state,
                    levelColor: _levelColor,
                  ),

                  const SizedBox(height: 16),

                  // Result feedback
                  if (_state == PracticeState.correct ||
                      _state == PracticeState.wrong)
                    ResultFeedback(
                      state: _state,
                      accuracy: _accuracy,
                      spokenText: _spokenText,
                      correctText: sentence.english,
                      levelColor: _levelColor,
                      onNext: _nextSentence,
                      onRetry: () => setState(() {
                        _state = PracticeState.idle;
                        _spokenText = '';
                      }),
                    ),
                ],
              ),
            ),
          ),

          // Bottom controls
          _buildBottomControls(sentence),
        ],
      ),
    );
  }

  AppBar _buildAppBar(int total) {
    return AppBar(
      backgroundColor: AppColors.background,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, size: 18),
        onPressed: () => Navigator.pop(context),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _section.title,
            style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w700),
          ),
          Text(
            '${widget.levelCode} · ${_currentIndex + 1}/$total',
            style: const TextStyle(
                color: AppColors.textHint, fontSize: 11),
          ),
        ],
      ),
      actions: [
        // Skip button
        TextButton.icon(
          onPressed: _skipSentence,
          icon: const Icon(Icons.skip_next, size: 16, color: AppColors.textHint),
          label: const Text('O\'tkazib yubor',
              style: TextStyle(color: AppColors.textHint, fontSize: 11)),
        ),
      ],
    );
  }

  Widget _buildProgressBar(int total) {
    return Container(
      height: 3,
      color: _levelColor.withOpacity(0.15),
      child: FractionallySizedBox(
        widthFactor: ((_currentIndex + 1) / total).clamp(0.0, 1.0),
        alignment: Alignment.centerLeft,
        child: Container(color: _levelColor),
      ),
    );
  }

  Widget _buildBottomControls(SentenceModel sentence) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 16, 20, MediaQuery.of(context).padding.bottom + 16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.cardBorder)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Navigation row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _NavButton(
                icon: Icons.arrow_back,
                label: 'Oldingi',
                enabled: _currentIndex > 0 && _state == PracticeState.idle,
                onTap: _prevSentence,
              ),
              // Main mic button
              SpeechButton(
                state: _state,
                pulseAnim: _pulseAnim,
                levelColor: _levelColor,
                speechAvailable: _speechAvailable,
                onStart: _startListening,
                onStop: _stopListening,
              ),
              _NavButton(
                icon: Icons.arrow_forward,
                label: 'Keyingi',
                enabled: _state == PracticeState.idle ||
                    _state == PracticeState.correct,
                onTap: _nextSentence,
                isRight: true,
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Hint: tap on words to save
          const Text(
            'So\'zga bosib lug\'atga saqlang  •  🔊 tinglash uchun bosing',
            style: TextStyle(color: AppColors.textHint, fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ── Nav Button ─────────────────────────────────────────────────────────────
class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool enabled;
  final VoidCallback onTap;
  final bool isRight;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.enabled,
    required this.onTap,
    this.isRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.3,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.textSecondary, size: 20),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(
                    color: AppColors.textHint, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

// ── Completion Dialog ───────────────────────────────────────────────────────
class _CompletionDialog extends StatelessWidget {
  final String sectionTitle;
  final String levelCode;
  final int totalSentences;
  final Color color;
  final VoidCallback onHome;
  final VoidCallback onNext;

  const _CompletionDialog({
    required this.sectionTitle,
    required this.levelCode,
    required this.totalSentences,
    required this.color,
    required this.onHome,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              color: color.withOpacity(0.15),
              child: Icon(Icons.emoji_events, color: color, size: 36),
            ),
            const SizedBox(height: 16),
            const Text(
              'Bo\'lim yakunlandi!',
              style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              '"$sectionTitle" bo\'limini muvaffaqiyatli tugatdingiz!',
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              color: color.withOpacity(0.1),
              child: Text(
                '$totalSentences gap aytdingiz ✓',
                style: TextStyle(
                    color: color, fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: onHome,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      color: AppColors.surfaceVariant,
                      child: const Center(
                        child: Text('Asosiy sahifa',
                            style: TextStyle(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: onNext,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      color: color,
                      child: const Center(
                        child: Text('Keyingi bo\'lim',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
