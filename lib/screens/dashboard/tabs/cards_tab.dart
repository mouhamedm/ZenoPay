import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/dashboard_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/dashboard/visa_card_widget.dart';

class CardsTab extends StatelessWidget {
  const CardsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            child: Text('Mes Cartes', style: AppTextStyles.displayMedium),
          ),
        ),
        // Display cards
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final card = provider.cards[index];
                final isRevealed = provider.isCardRevealed(index);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: VisaCardWidget(
                    card: card,
                    margin: EdgeInsets.zero,
                    revealed: isRevealed,
                    onToggleReveal: () => provider.toggleCardReveal(index),
                  ),
                );
              },
              childCount: provider.cards.length,
            ),
          ),
        ),
        
        // Add new card button
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border, width: 1.5),
                color: AppColors.surfaceElevated.withAlpha(100),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.gradientStart.withAlpha(40),
                        ),
                        child: const Icon(
                          Icons.add_rounded,
                          color: AppColors.gradientStart,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Ajouter une carte',
                        style: AppTextStyles.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Virtuelle ou Physique',
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
