import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/progress_provider.dart';

class StatsRow extends StatelessWidget {
  final ProgressProvider progressProvider;
  const StatsRow({super.key, required this.progressProvider});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatChip(
          icon: Icons.mic,
          label: '${progressProvider.totalPracticed}',
          sublabel: 'Mashq',
          color: AppColors.primary,
        ),
        const SizedBox(width: 8),
        _StatChip(
          icon: Icons.local_fire_department,
          label: '${progressProvider.streak}',
          sublabel: 'Kun',
          color: AppColors.accent,
        ),
        const SizedBox(width: 8),
        _StatChip(
          icon: Icons.emoji_events,
          label: _getTotalCompletedSections(progressProvider).toString(),
          sublabel: 'Bo\'lim',
          color: AppColors.secondary,
        ),
      ],
    );
  }

  int _getTotalCompletedSections(ProgressProvider p) {
    return ['A1', 'A2', 'B1', 'B2', 'C1', 'C2']
        .fold(0, (sum, l) => sum + p.getCompletedSections(l));
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sublabel;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.25)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label,
                  style: TextStyle(
                      color: color, fontSize: 13, fontWeight: FontWeight.w700)),
              Text(sublabel,
                  style: const TextStyle(
                      color: AppColors.textHint, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}
