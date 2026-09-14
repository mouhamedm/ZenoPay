import 'dart:ui';

class AppColors {
  // -- Background shades (Light greyish white) --
  static const background = Color(0xFFF5F7FA);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceElevated = Color(0xFFFFFFFF);
  static const border = Color(0xFFE2E8F0);

  // -- Royal Blue Brand Palette (From Card 2 - No Cyan on UI buttons) --
  static const gradientStart = Color(0xFF1E3A8A); // Deep Royal Blue
  static const gradientMid = Color(0xFF1D4ED8);   // Medium Blue
  static const gradientEnd = Color(0xFF2563EB);   // Vivid Royal Blue

  // -- Accents --
  static const primary = Color(0xFF1E3A8A);       // Primary Royal Blue
  static const secondary = Color(0xFF2563EB);     // Secondary Blue
  static const accent = Color(0xFF2563EB);        // Vivid Blue Accent
  static const accentDark = Color(0xFF0F172A);    // Dark Navy
  static const accentSoft = Color(0x1F2563EB);

  // -- Text (Dark slate) --
  static const textPrimary = Color(0xFF0F172A);
  static const textSecondary = Color(0xFF475569);
  static const textMuted = Color(0xFF94A3B8);

  // -- Status --
  static const success = Color(0xFF10B981);
  static const error = Color(0xFFEF4444);
  static const warning = Color(0xFFF59E0B);

  // -- Card gradients --
  static const cardGradient1 = [Color(0xFF0077B6), Color(0xFF00E5C5)];
  static const cardGradient2 = [Color(0xFF0F172A), Color(0xFF1E3A8A), Color(0xFF2563EB)];
  static const cardGradient3 = [Color(0xFF064E3B), Color(0xFF059669), Color(0xFF00E5C5)];
  static const cardGradient4 = [Color(0xFF0F172A), Color(0xFF1E3A8A), Color(0xFF3B82F6)];
}
