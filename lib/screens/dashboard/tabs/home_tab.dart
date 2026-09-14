import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/dashboard_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/dashboard/card_carousel.dart';
import '../../../widgets/dashboard/quick_actions_row.dart';
import '../../../widgets/dashboard/transaction_tile.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with SingleTickerProviderStateMixin {
  late AnimationController _countUpController;
  late Animation<double> _countUpAnim;
  double _displayedBalance = 0;

  @override
  void initState() {
    super.initState();
    _countUpController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800));
    _countUpAnim = CurvedAnimation(parent: _countUpController, curve: Curves.easeOutCubic);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<DashboardProvider>();
      final targetBalance = provider.activeCard.balance;

      _countUpAnim.addListener(() {
        setState(() => _displayedBalance = _countUpAnim.value * targetBalance);
      });

      _countUpController.forward();
    });
  }

  @override
  void dispose() {
    _countUpController.dispose();
    super.dispose();
  }

  String _formatBalance(double amount) {
    final formatted = amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]} ',
        );
    return '$formatted FCFA';
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();

    return CustomScrollView(
      slivers: [
        // -- App bar --
        SliverToBoxAdapter(child: _buildAppBar(provider)),
        // -- Balance section --
        SliverToBoxAdapter(child: _buildBalanceSection(provider)),
        // -- Card carousel --
        const SliverToBoxAdapter(child: CardCarousel()),
        const SliverToBoxAdapter(child: SizedBox(height: 28)),
        // -- Quick actions --
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: const QuickActionsRow(),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 28)),
        // -- Transactions header --
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Transactions récentes', style: AppTextStyles.titleLarge),
                Text(
                  'Voir tout',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.gradientEnd),
                ),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        // -- Transaction list --
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => TransactionTile(transaction: provider.transactions[index]),
              childCount: provider.transactions.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(DashboardProvider provider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Avatar Profile at the left
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceElevated,
              border: Border.all(color: AppColors.border, width: 1),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: AppColors.textPrimary,
              size: 24,
            ),
          ),
          // Notification at the right
          _AppBarIcon(icon: Icons.notifications_outlined, onTap: () {}),
        ],
      ),
    );
  }

  Widget _buildBalanceSection(DashboardProvider provider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Solde total', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // -- Animated count-up balance --
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    provider.balanceVisible ? _formatBalance(_displayedBalance) : '••••• FCFA',
                    key: ValueKey(provider.balanceVisible),
                    style: AppTextStyles.balanceAmount,
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: provider.toggleBalanceVisibility,
                  child: Icon(
                    provider.balanceVisible ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                    color: AppColors.textSecondary,
                    size: 20,
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

class _AppBarIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _AppBarIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(icon, color: AppColors.textSecondary, size: 20),
      ),
    );
  }
}
