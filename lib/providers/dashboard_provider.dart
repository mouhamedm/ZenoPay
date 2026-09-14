import 'package:flutter/foundation.dart';
import '../models/visa_card_model.dart';
import '../models/transaction_model.dart';
import '../utils/mock_data.dart';

class DashboardProvider extends ChangeNotifier {
  int _activeCardIndex = 0;
  final Set<int> _revealedCardIndices = {};
  int _activeNavIndex = 0;
  bool _balanceVisible = true;

  final List<VisaCardModel> _cards = MockData.cards;
  final List<TransactionModel> _transactions = MockData.transactions;

  int get activeCardIndex => _activeCardIndex;
  bool get cardNumberRevealed => isCardRevealed(_activeCardIndex);
  bool isCardRevealed(int index) => _revealedCardIndices.contains(index);
  int get activeNavIndex => _activeNavIndex;
  bool get balanceVisible => _balanceVisible;
  List<VisaCardModel> get cards => _cards;
  List<TransactionModel> get transactions => _transactions;

  VisaCardModel get activeCard => _cards[_activeCardIndex];

  // Card interactions
  void setActiveCard(int index) {
    if (_activeCardIndex != index) {
      _activeCardIndex = index;
      notifyListeners();
    }
  }

  void toggleCardReveal([int? index]) {
    final idx = index ?? _activeCardIndex;
    if (_revealedCardIndices.contains(idx)) {
      _revealedCardIndices.remove(idx);
    } else {
      _revealedCardIndices.add(idx);
    }
    notifyListeners();
  }

  void toggleBalanceVisibility() {
    _balanceVisible = !_balanceVisible;
    notifyListeners();
  }

  // Bottom nav
  void setActiveNav(int index) {
    if (_activeNavIndex != index) {
      _activeNavIndex = index;
      notifyListeners();
    }
  }
}
