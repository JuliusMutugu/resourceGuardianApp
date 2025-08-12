import 'package:flutter/material.dart';

class AppColors {
  // Modern Youth-Focused Colors - Vibrant and Trendy
  static const Color primary = Color(0xFF7C3AED); // Vibrant Purple
  static const Color primaryDark = Color(0xFF5B21B6);
  static const Color primaryLight = Color(0xFF8B5CF6);

  static const Color secondary = Color(0xFF06B6D4); // Electric Cyan
  static const Color secondaryDark = Color(0xFF0891B2);
  static const Color secondaryLight = Color(0xFF22D3EE);

  static const Color accent = Color(0xFFFF6B6B); // Coral Pink
  static const Color accentLight = Color(0xFFFF8A8A);
  static const Color accentDark = Color(0xFFE74C3C);

  // Status Colors - More vibrant
  static const Color success = Color(0xFF10B981); // Emerald
  static const Color successLight = Color(0xFF34D399);
  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color warningLight = Color(0xFFFBBF24);
  static const Color error = Color(0xFFEF4444); // Red
  static const Color errorLight = Color(0xFFF87171);
  static const Color info = Color(0xFF3B82F6); // Blue
  static const Color infoLight = Color(0xFF60A5FA);

  // Modern Grays with better contrast
  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray300 = Color(0xFFD1D5DB);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray600 = Color(0xFF4B5563);
  static const Color gray700 = Color(0xFF374151);
  static const Color gray800 = Color(0xFF1F2937);
  static const Color gray900 = Color(0xFF111827);

  // Background with modern feel
  static const Color background = Color(0xFFFFFFFF);
  static const Color backgroundSecondary = Color(0xFFF8FAFC);
  static const Color backgroundTertiary = Color(0xFFF1F5F9);

  // Dark theme backgrounds
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color backgroundDarkSecondary = Color(0xFF1E293B);
  static const Color backgroundDarkTertiary = Color(0xFF334155);

  // Text with better accessibility
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textTertiary = Color(0xFF64748B);
  static const Color textLight = Color(0xFF94A3B8);
  static const Color textDark = Color(0xFFF8FAFC);
  static const Color textDarkSecondary = Color(0xFFCBD5E1);
  static const Color textDarkTertiary = Color(0xFF94A3B8);

  // Card with modern shadows
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardBackgroundSecondary = Color(0xFFF8FAFC);
  static const Color cardBackgroundDark = Color(0xFF1E293B);
  static const Color cardBackgroundDarkSecondary = Color(0xFF334155);
  static const Color cardShadow = Color(0x0F000000);
  static const Color cardShadowDark = Color(0x30000000);

  // Modern gradient combinations for different purposes
  static const List<Color> gradientPrimary = [
    Color(0xFF6366F1),
    Color(0xFF8B5CF6)
  ];
  static const List<Color> gradientSecondary = [
    Color(0xFF06B6D4),
    Color(0xFF0EA5E9)
  ];
  static const List<Color> gradientSuccess = [
    Color(0xFF10B981),
    Color(0xFF059669)
  ];
  static const List<Color> gradientWarning = [
    Color(0xFFF59E0B),
    Color(0xFFD97706)
  ];
  static const List<Color> gradientError = [
    Color(0xFFEF4444),
    Color(0xFFDC2626)
  ];
  static const List<Color> gradientSunset = [
    Color(0xFFF59E0B),
    Color(0xFFEC4899)
  ];
  static const List<Color> gradientOcean = [
    Color(0xFF06B6D4),
    Color(0xFF3B82F6)
  ];
  static const List<Color> gradientForest = [
    Color(0xFF10B981),
    Color(0xFF059669)
  ];

  // Feature colors for financial app
  static const Color income = Color(0xFF10B981); // Green
  static const Color incomeLight = Color(0xFF34D399);
  static const Color expense = Color(0xFFEF4444); // Red
  static const Color expenseLight = Color(0xFFF87171);
  static const Color savings = Color(0xFF8B5CF6); // Purple
  static const Color savingsLight = Color(0xFFA78BFA);
  static const Color investment = Color(0xFF06B6D4); // Cyan
  static const Color investmentLight = Color(0xFF67E8F9);
  static const Color budget = Color(0xFFF59E0B); // Amber
  static const Color budgetLight = Color(0xFFFBBF24);

  // Interactive states
  static const Color hover = Color(0xFFF1F5F9);
  static const Color hoverDark = Color(0xFF334155);
  static const Color pressed = Color(0xFFE2E8F0);
  static const Color pressedDark = Color(0xFF475569);
  static const Color focus = Color(0xFF6366F1);
  static const Color disabled = Color(0xFF94A3B8);
  static const Color disabledDark = Color(0xFF64748B);

  // Border colors
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderSecondary = Color(0xFFF1F5F9);
  static const Color borderDark = Color(0xFF334155);
  static const Color borderDarkSecondary = Color(0xFF475569);

  // Glass morphism and modern effects
  static const Color glass = Color(0x1AFFFFFF);
  static const Color glassDark = Color(0x1A000000);
  static const Color glassBorder = Color(0x33FFFFFF);
  static const Color glassBorderDark = Color(0x33000000);

  // Brand colors for social features
  static const Color brandBlue = Color(0xFF1DA1F2);
  static const Color brandGreen = Color(0xFF25D366);
  static const Color brandPurple = Color(0xFF5865F2);
  static const Color brandOrange = Color(0xFFFF6B35);

  // Semantic colors for different transaction categories
  static const Color foodAndDining = Color(0xFFFF6B35);
  static const Color transportation = Color(0xFF3B82F6);
  static const Color shopping = Color(0xFFEC4899);
  static const Color entertainment = Color(0xFF8B5CF6);
  static const Color bills = Color(0xFFF59E0B);
  static const Color healthcare = Color(0xFF10B981);
  static const Color education = Color(0xFF06B6D4);
  static const Color travel = Color(0xFF14B8A6);
  static const Color personal = Color(0xFFF97316);
  static const Color business = Color(0xFF6366F1);

  // Icon Colors
  static const Color iconPrimary = Color(0xFF1F2937);
  static const Color iconSecondary = Color(0xFF6B7280);
  static const Color iconDarkPrimary = Color(0xFFF9FAFB);
  static const Color iconDarkSecondary = Color(0xFF9CA3AF);

  // Gradient Colors
  static const Color gradientStart = Color(0xFF6366F1);
  static const Color gradientEnd = Color(0xFF8B5CF6);
  static const Color gradientSecondaryStart = Color(0xFF06B6D4);
  static const Color gradientSecondaryEnd = Color(0xFF10B981);
}
