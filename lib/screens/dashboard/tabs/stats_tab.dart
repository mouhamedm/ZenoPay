import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

class StatsTab extends StatelessWidget {
  const StatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            child: Text('Statistiques', style: AppTextStyles.displayMedium),
          ),
        ),
        
        // Income vs Expenses
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'Revenus',
                    amount: '+ 325 000 FCFA',
                    icon: Icons.arrow_downward_rounded,
                    color: Colors.greenAccent.shade400,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _StatCard(
                    title: 'Dépenses',
                    amount: '- 145 000 FCFA',
                    icon: Icons.arrow_upward_rounded,
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
        
        // Mock Bar Chart
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text('Aperçu hebdomadaire', style: AppTextStyles.titleLarge),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              height: 200,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _ChartBar(label: 'Lun', heightFactor: 0.4),
                  _ChartBar(label: 'Mar', heightFactor: 0.7),
                  _ChartBar(label: 'Mer', heightFactor: 0.3),
                  _ChartBar(label: 'Jeu', heightFactor: 0.9, isToday: true),
                  _ChartBar(label: 'Ven', heightFactor: 0.6),
                  _ChartBar(label: 'Sam', heightFactor: 0.8),
                  _ChartBar(label: 'Dim', heightFactor: 0.5),
                ],
              ),
            ),
          ),
        ),
        
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
        
        // Categories
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text('Par catégorie', style: AppTextStyles.titleLarge),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final categories = [
                  {'name': 'Alimentation', 'amount': '45 000 FCFA', 'icon': Icons.restaurant_rounded, 'color': Colors.orangeAccent},
                  {'name': 'Transport', 'amount': '25 000 FCFA', 'icon': Icons.directions_car_rounded, 'color': Colors.blueAccent},
                  {'name': 'Factures', 'amount': '30 000 FCFA', 'icon': Icons.receipt_long_rounded, 'color': Colors.purpleAccent},
                  {'name': 'Loisirs', 'amount': '45 000 FCFA', 'icon': Icons.sports_esports_rounded, 'color': Colors.pinkAccent},
                ];
                final cat = categories[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: (cat['color'] as Color).withAlpha(30),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(cat['icon'] as IconData, color: cat['color'] as Color),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(cat['name'] as String, style: AppTextStyles.titleMedium),
                      ),
                      Text(cat['amount'] as String, style: AppTextStyles.titleMedium),
                    ],
                  ),
                );
              },
              childCount: 4,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String amount;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withAlpha(30),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              const SizedBox(width: 8),
              Text(title, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted)),
            ],
          ),
          const SizedBox(height: 12),
          Text(amount, style: AppTextStyles.titleLarge.copyWith(fontSize: 16)),
        ],
      ),
    );
  }
}

class _ChartBar extends StatelessWidget {
  final String label;
  final double heightFactor;
  final bool isToday;

  const _ChartBar({
    required this.label,
    required this.heightFactor,
    this.isToday = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: FractionallySizedBox(
            heightFactor: heightFactor,
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutQuart,
              width: 12,
              decoration: BoxDecoration(
                color: isToday ? AppColors.gradientStart : AppColors.border,
                borderRadius: BorderRadius.circular(6),
                boxShadow: isToday ? [
                  BoxShadow(
                    color: AppColors.gradientStart.withAlpha(100),
                    blurRadius: 10,
                  )
                ] : [],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: isToday ? AppColors.textPrimary : AppColors.textMuted,
            fontWeight: isToday ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
