import 'package:flutter/material.dart';

enum TransactionCategory { food, transfer, shopping, transport, entertainment, savings }

class TransactionModel {
  final String id;
  final String title;
  final String subtitle;
  final double amount;
  final DateTime date;
  final TransactionCategory category;
  final bool isCredit;

  const TransactionModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.date,
    required this.category,
    required this.isCredit,
  });

  IconData get icon {
    switch (category) {
      case TransactionCategory.food:
        return Icons.restaurant_rounded;
      case TransactionCategory.transfer:
        return Icons.swap_horiz_rounded;
      case TransactionCategory.shopping:
        return Icons.shopping_bag_rounded;
      case TransactionCategory.transport:
        return Icons.directions_car_rounded;
      case TransactionCategory.entertainment:
        return Icons.movie_filter_rounded;
      case TransactionCategory.savings:
        return Icons.savings_rounded;
    }
  }

  String get formattedAmount {
    final sign = isCredit ? '+' : '-';
    final formatted = amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]} ',
        );
    return '$sign$formatted F';
  }

  String get formattedDate {
    final now = DateTime.now();
    final diff = now.difference(date).inDays;
    if (diff == 0) return "Aujourd'hui";
    if (diff == 1) return 'Hier';
    final months = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin', 'Juil', 'Août', 'Sep', 'Oct', 'Nov', 'Déc'];
    return '${date.day} ${months[date.month - 1]}';
  }
}
