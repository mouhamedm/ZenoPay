import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/dashboard/custom_bottom_nav.dart';
import 'tabs/home_tab.dart';
import 'tabs/cards_tab.dart';
import 'tabs/stats_tab.dart';
import 'tabs/profile_tab.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // -- Background glow --
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [AppColors.gradientStart.withAlpha(40), Colors.transparent],
                ),
              ),
            ),
          ),
          
          SafeArea(
            bottom: false,
            child: IndexedStack(
              index: provider.activeNavIndex,
              children: const [
                HomeTab(),
                CardsTab(),
                StatsTab(),
                ProfileTab(),
              ],
            ),
          ),
          
          // -- Floating bottom nav --
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: const CustomBottomNav(),
          ),
        ],
      ),
    );
  }
}
