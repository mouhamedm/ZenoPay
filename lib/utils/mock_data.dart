import '../models/visa_card_model.dart';
import '../models/transaction_model.dart';
import '../theme/app_colors.dart';

class MockData {
  // -- Visa cards --
  static List<VisaCardModel> get cards => [
        VisaCardModel(
          cardholderName: 'Koné Moussa',
          cardNumber: '5425233430109903',
          expiryDate: '03/27',
          cvv: '319',
          balance: 1_450_000,
          gradientColors: AppColors.cardGradient2,
          cardType: 'Mastercard',
        ),
        VisaCardModel(
          cardholderName: 'Koné Moussa',
          cardNumber: '4716338360022140',
          expiryDate: '12/26',
          cvv: '551',
          balance: 875_500,
          gradientColors: AppColors.cardGradient3,
        ),
        VisaCardModel(
          cardholderName: 'Koné Moussa',
          cardNumber: '4532015112830366',
          expiryDate: '09/28',
          cvv: '742',
          balance: 325_000,
          gradientColors: AppColors.cardGradient1,
        ),
      ];

  // -- Transactions --
  static List<TransactionModel> get transactions => [
        TransactionModel(
          id: 't1',
          title: 'Restaurant Maquis Chez Tata',
          subtitle: 'Abidjan, Cocody',
          amount: 12_500,
          date: DateTime.now().subtract(const Duration(hours: 3)),
          category: TransactionCategory.food,
          isCredit: false,
        ),
        TransactionModel(
          id: 't2',
          title: 'Virement reçu',
          subtitle: 'De: Diallo Ibrahim',
          amount: 250_000,
          date: DateTime.now().subtract(const Duration(days: 1)),
          category: TransactionCategory.transfer,
          isCredit: true,
        ),
        TransactionModel(
          id: 't3',
          title: 'Mall de Cocody',
          subtitle: 'Vêtements & Accessoires',
          amount: 87_500,
          date: DateTime.now().subtract(const Duration(days: 2)),
          category: TransactionCategory.shopping,
          isCredit: false,
        ),
        TransactionModel(
          id: 't4',
          title: 'Taxi Yango',
          subtitle: 'Plateau → Cocody',
          amount: 3_500,
          date: DateTime.now().subtract(const Duration(days: 2)),
          category: TransactionCategory.transport,
          isCredit: false,
        ),
        TransactionModel(
          id: 't5',
          title: 'Netflix Premium',
          subtitle: 'Abonnement mensuel',
          amount: 7_900,
          date: DateTime.now().subtract(const Duration(days: 5)),
          category: TransactionCategory.entertainment,
          isCredit: false,
        ),
        TransactionModel(
          id: 't6',
          title: 'Épargne mensuelle',
          subtitle: 'Compte épargne',
          amount: 100_000,
          date: DateTime.now().subtract(const Duration(days: 7)),
          category: TransactionCategory.savings,
          isCredit: false,
        ),
        TransactionModel(
          id: 't7',
          title: 'Salaire Août',
          subtitle: 'Entreprise ABC SARL',
          amount: 850_000,
          date: DateTime.now().subtract(const Duration(days: 14)),
          category: TransactionCategory.transfer,
          isCredit: true,
        ),
      ];
}
