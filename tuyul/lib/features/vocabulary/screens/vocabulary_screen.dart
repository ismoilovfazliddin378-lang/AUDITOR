import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/vocabulary_provider.dart';
import '../../../core/models/models.dart';
import '../widgets/word_card.dart';

class VocabularyScreen extends StatefulWidget {
  const VocabularyScreen({super.key});

  @override
  State<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  String _selectedLevel = 'Hammasi';
  String _searchQuery = '';
  final _searchCtrl = TextEditingController();

  final List<String> _levels = ['Hammasi', 'A1', 'A2', 'B1', 'B2', 'C1', 'C2'];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vocabProvider = context.watch<VocabularyProvider>();
    final allWords = vocabProvider.savedWords;

    // Filter
    var filtered = allWords.where((w) {
      final matchLevel =
          _selectedLevel == 'Hammasi' || w.levelCode == _selectedLevel;
      final matchSearch = _searchQuery.isEmpty ||
          w.word.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          w.translation.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchLevel && matchSearch;
    }).toList()
      ..sort((a, b) => b.savedAt.compareTo(a.savedAt));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── App Bar ─────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.background,
            automaticallyImplyLeading: false,
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppColors.background,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.bookmark,
                                color: AppColors.secondary, size: 22),
                            const SizedBox(width: 8),
                            const Text(
                              'Mening lug\'atim',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              color: AppColors.secondary.withOpacity(0.15),
                              child: Text(
                                '${allWords.length} so\'z',
                                style: const TextStyle(
                                  color: AppColors.secondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Search bar
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant,
                            border: Border.all(color: AppColors.cardBorder),
                          ),
                          child: TextField(
                            controller: _searchCtrl,
                            style: const TextStyle(
                                color: AppColors.textPrimary, fontSize: 14),
                            decoration: const InputDecoration(
                              hintText: 'So\'z qidirish...',
                              hintStyle: TextStyle(
                                  color: AppColors.textHint, fontSize: 13),
                              prefixIcon: Icon(Icons.search,
                                  color: AppColors.textHint, size: 18),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 10),
                            ),
                            onChanged: (v) =>
                                setState(() => _searchQuery = v),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Level filter chips ───────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              height: 44,
              margin: const EdgeInsets.only(top: 4),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _levels.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final level = _levels[i];
                  final isSelected = _selectedLevel == level;
                  final color = level == 'Hammasi'
                      ? AppColors.primary
                      : AppTheme.getLevelColor(level);
                  return GestureDetector(
                    onTap: () => setState(() => _selectedLevel = level),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? color.withOpacity(0.15)
                            : AppColors.cardBg,
                        border: Border.all(
                          color: isSelected
                              ? color.withOpacity(0.5)
                              : AppColors.cardBorder,
                        ),
                      ),
                      child: Text(
                        level,
                        style: TextStyle(
                          color: isSelected ? color : AppColors.textHint,
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // ── Empty state ──────────────────────────────────────────────
          if (allWords.isEmpty)
            const SliverFillRemaining(
              child: _EmptyVocabulary(),
            )
          else if (filtered.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.search_off,
                        color: AppColors.textHint, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      '"$_searchQuery" topilmadi',
                      style: const TextStyle(color: AppColors.textHint),
                    ),
                  ],
                ),
              ),
            )
          else ...[
            // Count
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Text(
                  '${filtered.length} ta so\'z',
                  style: const TextStyle(
                      color: AppColors.textHint, fontSize: 12),
                ),
              ),
            ),

            // Word list
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) => WordCard(
                    word: filtered[i],
                    onDelete: () => context
                        .read<VocabularyProvider>()
                        .removeWord(filtered[i].id),
                  ),
                  childCount: filtered.length,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EmptyVocabulary extends StatelessWidget {
  const _EmptyVocabulary();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              color: AppColors.surfaceVariant,
              child: const Icon(Icons.bookmark_border,
                  color: AppColors.textHint, size: 36),
            ),
            const SizedBox(height: 20),
            const Text(
              'Lug\'at bo\'sh',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Mashq paytida so\'zga bosib\nlug\'atga saqlashingiz mumkin',
              style: TextStyle(
                  color: AppColors.textHint, fontSize: 13, height: 1.5),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
