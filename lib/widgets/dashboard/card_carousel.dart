import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../theme/app_colors.dart';
import 'visa_card_widget.dart';

class CardCarousel extends StatefulWidget {
  const CardCarousel({super.key});

  @override
  State<CardCarousel> createState() => _CardCarouselState();
}

class _CardCarouselState extends State<CardCarousel> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.92);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();

    return Column(
      children: [
        // -- Card PageView --
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            itemCount: provider.cards.length,
            onPageChanged: provider.setActiveCard,
            itemBuilder: (context, index) {
              final card = provider.cards[index];
              final isActive = index == provider.activeCardIndex;
              return AnimatedScale(
                scale: isActive ? 1.0 : 0.94,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                child: VisaCardWidget(
                  card: card,
                  revealed: isActive && provider.isCardRevealed(index),
                  onToggleReveal: () => provider.toggleCardReveal(index),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        // -- Page indicator dots --
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(provider.cards.length, (i) {
            final isActive = i == provider.activeCardIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isActive ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: isActive ? AppColors.gradientStart : AppColors.border,
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }
}
