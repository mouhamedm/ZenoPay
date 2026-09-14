import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/dashboard_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    context.watch<DashboardProvider>();

    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
          child: SizedBox(height: 40),
        ),
        
        // Avatar and Name
        SliverToBoxAdapter(
          child: Column(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surfaceElevated,
                  border: Border.all(color: AppColors.border, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gradientStart.withAlpha(50),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: AppColors.textPrimary,
                  size: 50,
                ),
              ),
              const SizedBox(height: 16),
              Text('MMD.Dev', style: AppTextStyles.displayMedium.copyWith(fontSize: 24)),
              const SizedBox(height: 4),
              Text('@mmd.dev', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.gradientStart.withAlpha(30),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Compte Vérifié',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.gradientStart,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
        
        // Options List
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final options = [
                  {'title': 'Mon Compte', 'icon': Icons.account_circle_outlined},
                  {'title': 'Sécurité et Confidentialité', 'icon': Icons.lock_outline_rounded},
                  {'title': 'Notifications', 'icon': Icons.notifications_none_rounded},
                  {'title': 'Aide et Support', 'icon': Icons.help_outline_rounded},
                  {'title': 'Déconnexion', 'icon': Icons.logout_rounded, 'color': AppColors.error},
                ];
                
                final option = options[index];
                final isLast = index == options.length - 1;
                final color = option['color'] as Color? ?? AppColors.textPrimary;
                
                return Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceElevated,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Icon(option['icon'] as IconData, color: color, size: 20),
                      ),
                      title: Text(
                        option['title'] as String,
                        style: AppTextStyles.titleMedium.copyWith(color: color),
                      ),
                      trailing: Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                      onTap: () {},
                    ),
                    if (!isLast)
                      Divider(color: AppColors.border, height: 16),
                  ],
                );
              },
              childCount: 5,
            ),
          ),
        ),
      ],
    );
  }
}
