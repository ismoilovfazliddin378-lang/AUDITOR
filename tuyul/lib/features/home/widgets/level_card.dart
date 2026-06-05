import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/models.dart';

class LevelCard extends StatelessWidget {
  final LevelModel level;
  final double progress;
  final int completedSections;
  final VoidCallback onTap;

  const LevelCard({
    super.key,
    required this.level,
    required this.progress,
    required this.completedSections,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.getLevelColor(level.code);
    final pct = (progress * 100).toInt();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          border: Border.all(color: AppColors.cardBorder),
          // qirrasiz to'rtburchak
        ),
        child: Stack(
          children: [
            // Background accent
            Positioned(
              top: -12,
              right: -12,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(0.08),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Level badge
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        color: color.withOpacity(0.15),
                        child: Text(
                          level.code,
                          style: TextStyle(
                            color: color,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (pct == 100)
                        const Icon(Icons.check_circle, color: AppColors.success, size: 16),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Name
                  Text(
                    level.name,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 2),

                  // Description
                  Text(
                    level.description,
                    style: const TextStyle(
                      color: AppColors.textHint,
                      fontSize: 10,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const Spacer(),

                  // Progress bar
                  ClipRect(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '$completedSections/${level.totalSections}',
                              style: const TextStyle(
                                  color: AppColors.textSecondary, fontSize: 10),
                            ),
                            Text(
                              '$pct%',
                              style: TextStyle(
                                  color: color,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // Custom progress bar (qirrasiz)
                        Container(
                          height: 4,
                          color: color.withOpacity(0.15),
                          child: FractionallySizedBox(
                            widthFactor: progress.clamp(0.0, 1.0),
                            alignment: Alignment.centerLeft,
                            child: Container(color: color),
                          ),
                        ),
                      ],
                    ),
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
