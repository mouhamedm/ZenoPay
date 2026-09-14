import 'package:flutter/foundation.dart';

enum AuthStatus { idle, loading, success, error }

class AuthProvider extends ChangeNotifier {
  AuthStatus _status = AuthStatus.idle;
  String _errorMessage = '';
  String _phoneNumber = '';
  bool _isAuthenticated = false;

  AuthStatus get status => _status;
  String get errorMessage => _errorMessage;
  String get phoneNumber => _phoneNumber;
  bool get isAuthenticated => _isAuthenticated;

  // -- Signup flow (Phone only) --
  Future<bool> signUp(String phone) async {
    _status = AuthStatus.loading;
    _phoneNumber = phone;
    notifyListeners();

    // Simulate network call
    await Future.delayed(const Duration(milliseconds: 1800));

    _status = AuthStatus.success;
    notifyListeners();
    return true;
  }

  // -- OTP verification --
  Future<bool> verifyOtp(String otp) async {
    _status = AuthStatus.loading;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1500));

    // Accept any 6-digit code or the fixed code "123456"
    final isValid = otp.length == 6 && RegExp(r'^\d+$').hasMatch(otp);
    if (isValid) {
      _status = AuthStatus.success;
    } else {
      _status = AuthStatus.error;
      _errorMessage = 'Code OTP invalide. Veuillez réessayer.';
    }
    notifyListeners();
    return isValid;
  }

  // -- PIN Login flow --
  Future<bool> loginWithPin(String pin) async {
    _status = AuthStatus.loading;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1500));

    // Accept any 6-digit PIN in mock
    final isValid = pin.length == 6 && RegExp(r'^\d+$').hasMatch(pin);
    if (isValid) {
      _status = AuthStatus.success;
      _isAuthenticated = true;
      notifyListeners();
      return true;
    } else {
      _status = AuthStatus.error;
      _errorMessage = 'Code PIN invalide.';
      notifyListeners();
      return false;
    }
  }

  // -- Legacy Login flow (unused in new flow) --
  Future<bool> login(String phone, String password) async {
    return true; // Dummy to keep compilation alive
  }

  void resetStatus() {
    _status = AuthStatus.idle;
    _errorMessage = '';
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    _status = AuthStatus.idle;
    notifyListeners();
  }
}
