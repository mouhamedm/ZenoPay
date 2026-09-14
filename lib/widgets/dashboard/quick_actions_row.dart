import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      _QuickAction(icon: Icons.send_rounded, label: 'Envoyer', color: AppColors.secondary),
      _QuickAction(icon: Icons.add_rounded, label: 'Recharger', color: AppColors.gradientMid),
      _QuickAction(icon: Icons.arrow_downward_rounded, label: 'Retirer', color: AppColors.accent),
      _QuickAction(icon: Icons.grid_view_rounded, label: 'Plus', color: const Color(0xFFF59E0B)),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: actions.map((a) => _QuickActionButton(action: a)).toList(),
    );
  }
}

class _QuickAction {
  final IconData icon;
  final String label;
  final Color color;
  const _QuickAction({required this.icon, required this.label, required this.color});
}

class _QuickActionButton extends StatefulWidget {
  final _QuickAction action;
  const _QuickActionButton({required this.action});

  @override
  State<_QuickActionButton> createState() => _QuickActionButtonState();
}

class _QuickActionButtonState extends State<_QuickActionButton> with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(vsync: this, duration: const Duration(milliseconds: 120));
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.88).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _scaleController.forward(),
      onTapUp: (_) => _scaleController.reverse(),
      onTapCancel: () => _scaleController.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (context, child) => Transform.scale(scale: _scaleAnim.value, child: child),
        child: Column(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: widget.action.color.withAlpha(25),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: widget.action.color.withAlpha(80), width: 1),
              ),
              child: Icon(widget.action.icon, color: widget.action.color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(widget.action.label, style: AppTextStyles.labelMedium),
          ],
        ),
      ),
    );
  }
}
