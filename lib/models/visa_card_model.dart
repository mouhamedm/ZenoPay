import 'package:flutter/material.dart';

class VisaCardModel {
  final String cardholderName;
  final String cardNumber;
  final String expiryDate;
  final String cvv;
  final double balance;
  final List<Color> gradientColors;
  final String cardType;

  const VisaCardModel({
    required this.cardholderName,
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
    required this.balance,
    required this.gradientColors,
    this.cardType = 'Visa',
  });

  String get maskedNumber {
    final last4 = cardNumber.substring(cardNumber.length - 4);
    return '•••• •••• •••• $last4';
  }

  String get formattedNumber {
    final clean = cardNumber.replaceAll(' ', '');
    return '${clean.substring(0, 4)} ${clean.substring(4, 8)} ${clean.substring(8, 12)} ${clean.substring(12)}';
  }

  String get formattedBalance {
    final formatted = balance.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]} ',
        );
    return '$formatted FCFA';
  }
}
