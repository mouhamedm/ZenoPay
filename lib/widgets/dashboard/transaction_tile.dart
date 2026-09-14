import 'package:flutter/material.dart';
import '../../models/transaction_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionTile({super.key, required this.transaction});

  Color get _categoryColor {
    switch (transaction.category) {
      case TransactionCategory.food:
        return const Color(0xFFFF6B6B);
      case TransactionCategory.transfer:
        return AppColors.gradientStart;
      case TransactionCategory.shopping:
        return const Color(0xFFFFB340);
      case TransactionCategory.transport:
        return const Color(0xFF1ABCFE);
      case TransactionCategory.entertainment:
        return const Color(0xFFE040FB);
      case TransactionCategory.savings:
        return AppColors.success;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Row(
        children: [
          // -- Category icon --
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: _categoryColor.withAlpha(25),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(transaction.icon, color: _categoryColor, size: 22),
          ),
          const SizedBox(width: 14),
          // -- Title & subtitle --
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: AppTextStyles.titleMedium.copyWith(fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  transaction.subtitle,
                  style: AppTextStyles.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // -- Amount & date --
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                transaction.formattedAmount,
                style: AppTextStyles.labelLarge.copyWith(
                  color: transaction.isCredit ? AppColors.success : AppColors.textPrimary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 3),
              Text(transaction.formattedDate, style: AppTextStyles.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}
