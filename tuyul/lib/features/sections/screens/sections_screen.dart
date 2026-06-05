import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/providers/progress_provider.dart';
import '../../../core/models/models.dart';
import '../../practice/screens/practice_screen.dart';

class SectionsScreen extends StatelessWidget {
  final String levelCode;
  const SectionsScreen({super.key, required this.levelCode});

  @override
  Widget build(BuildContext context) {
    final appProvider = context.read<AppProvider>();
    final progressProvider = context.watch<ProgressProvider>();
    final sections = appProvider.getSectionsForLevel(levelCode);
    final level = appProvider.getLevelByCode(levelCode);
    final color = AppTheme.getLevelColor(levelCode);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── App Bar ───────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 140,
            pinned: true,
            backgroundColor: AppColors.background,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 18),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [color.withOpacity(0.15), AppColors.background],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 50, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              color: color.withOpacity(0.2),
                              child: Text(
                                levelCode,
                                style: TextStyle(
                                  color: color,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              level.name,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${level.totalSections} bo\'lim · ${level.totalSentences} gap',
                          style: const TextStyle(
                            color: AppColors.textHint,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Level progress summary ────────────────────────────────────
          SliverToBoxAdapter(
            child: _LevelProgressBar(
              levelCode: levelCode,
              color: color,
              progressProvider: progressProvider,
              totalSections: level.totalSections,
            ),
          ),

          // ── Section list ──────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final section = sections[index];
                  final progress = progressProvider.getProgress(levelCode, section.id);
                  return _SectionTile(
                    section: section,
                    progress: progress,
                    color: color,
                    index: index,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PracticeScreen(
                          levelCode: levelCode,
                          sectionId: section.id,
                        ),
                      ),
                    ),
                  );
                },
                childCount: sections.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Level Progress Bar ──────────────────────────────────────────────────────
class _LevelProgressBar extends StatelessWidget {
  final String levelCode;
  final Color color;
  final ProgressProvider progressProvider;
  final int totalSections;

  const _LevelProgressBar({
    required this.levelCode,
    required this.color,
    required this.progressProvider,
    required this.totalSections,
  });

  @override
  Widget build(BuildContext context) {
    final progress = progressProvider.getLevelProgress(levelCode);
    final completed = progressProvider.getCompletedSections(levelCode);
    final pct = (progress * 100).toInt();

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      padding: const EdgeInsets.all(14),
      color: AppColors.cardBg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Umumiy progress',
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 12),
              ),
              Text(
                '$completed/$totalSections bo\'lim · $pct%',
                style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 6,
            color: color.withOpacity(0.15),
            child: FractionallySizedBox(
              widthFactor: progress.clamp(0.0, 1.0),
              alignment: Alignment.centerLeft,
              child: Container(color: color),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section Tile ─────────────────────────────────────────────────────────────
class _SectionTile extends StatelessWidget {
  final SectionModel section;
  final ProgressModel? progress;
  final Color color;
  final int index;
  final VoidCallback onTap;

  const _SectionTile({
    required this.section,
    required this.progress,
    required this.color,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = progress?.isCompleted ?? false;
    final pct = progress != null
        ? (progress!.completedSentences / progress!.totalSentences * 100).toInt()
        : 0;
    final isStarted = (progress?.completedSentences ?? 0) > 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isCompleted
              ? color.withOpacity(0.08)
              : AppColors.cardBg,
          border: Border.all(
            color: isCompleted
                ? color.withOpacity(0.4)
                : isStarted
                    ? color.withOpacity(0.2)
                    : AppColors.cardBorder,
          ),
          // qirrasiz to'rtburchak
        ),
        child: Row(
          children: [
            // Section number badge
            Container(
              width: 36,
              height: 36,
              color: isCompleted
                  ? color.withOpacity(0.2)
                  : AppColors.surfaceVariant,
              child: Center(
                child: isCompleted
                    ? Icon(Icons.check, color: color, size: 18)
                    : Text(
                        '${section.id}',
                        style: TextStyle(
                          color: isStarted ? color : AppColors.textHint,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),

            const SizedBox(width: 12),

            // Title & topic
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.title,
                    style: TextStyle(
                      color: isCompleted ? color : AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${section.sentences.length} gap',
                    style: const TextStyle(
                      color: AppColors.textHint,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),

            // Progress indicator
            if (isStarted) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$pct%',
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 40,
                    height: 3,
                    color: color.withOpacity(0.2),
                    child: FractionallySizedBox(
                      widthFactor: (pct / 100).clamp(0.0, 1.0),
                      alignment: Alignment.centerLeft,
                      child: Container(color: color),
                    ),
                  ),
                ],
              ),
            ] else ...[
              const Icon(
                Icons.chevron_right,
                color: AppColors.textHint,
                size: 20,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
