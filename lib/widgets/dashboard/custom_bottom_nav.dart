import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class CustomBottomNav extends StatelessWidget {
  const CustomBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();
    final items = [
      _NavItem(icon: Icons.home_rounded, label: 'Accueil'),
      _NavItem(icon: Icons.credit_card_rounded, label: 'Cartes'),
      _NavItem(icon: Icons.bar_chart_rounded, label: 'Stats'),
      _NavItem(icon: Icons.person_rounded, label: 'Profil'),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated.withAlpha(240),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: AppColors.border, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(12),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                // -- Sliding active pill --
                AnimatedAlign(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  alignment: Alignment(
                    -1 + (provider.activeNavIndex / (items.length - 1)) * 2,
                    0,
                  ),
                  child: FractionallySizedBox(
                    widthFactor: 1 / items.length,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.gradientStart, AppColors.gradientEnd],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ),
                // -- Nav items --
                Row(
                  children: List.generate(items.length, (i) {
                    final isActive = i == provider.activeNavIndex;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => provider.setActiveNav(i),
                        behavior: HitTestBehavior.opaque,
                        child: AnimatedScale(
                          scale: isActive ? 1.05 : 1.0,
                          duration: const Duration(milliseconds: 200),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                child: Icon(
                                  items[i].icon,
                                  key: ValueKey(isActive),
                                  color: isActive ? Colors.white : AppColors.textMuted,
                                  size: isActive ? 24 : 22,
                                ),
                              ),
                              const SizedBox(height: 2),
                              AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 200),
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: isActive ? Colors.white : AppColors.textMuted,
                                  fontSize: 10,
                                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                                ),
                                child: Text(items[i].label),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
