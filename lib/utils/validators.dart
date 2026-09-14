class Validators {
  // Phone validation
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer votre numéro de téléphone';
    }
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 8) {
      return 'Numéro de téléphone invalide';
    }
    return null;
  }

  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez créer un mot de passe';
    }
    if (value.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    return null;
  }

  static String? validateLoginPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer votre mot de passe';
    }
    return null;
  }

  // OTP validation
  static bool isOtpComplete(String otp, {int length = 6}) {
    return otp.length == length && RegExp(r'^\d+$').hasMatch(otp);
  }
}
