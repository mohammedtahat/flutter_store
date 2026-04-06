// lib/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Primary Palette
  static const Color primary       = Color(0xFF6C63FF);
  static const Color primaryLight  = Color(0xFF9C8FFF);
  static const Color primaryDark   = Color(0xFF4B44CC);

  // Accent
  static const Color secondary     = Color(0xFFFF6584);
  static const Color accent        = Color(0xFF43E97B);
  static const Color gold          = Color(0xFFFFB830);

  // Dark Backgrounds
  static const Color bg            = Color(0xFF0E0E1A);
  static const Color bgCard        = Color(0xFF1A1A2E);
  static const Color bgCardLight   = Color(0xFF242440);
  static const Color bgSurface     = Color(0xFF2A2A4A);

  // Text
  static const Color textPrimary   = Color(0xFFF0F0FF);
  static const Color textSecondary = Color(0xFFB0B0CC);
  static const Color textMuted     = Color(0xFF6E6E8E);
  static const Color textHint      = Color(0xFF44445A);

  // Status
  static const Color success       = Color(0xFF43E97B);
  static const Color error         = Color(0xFFFF4D6D);
  static const Color warning       = Color(0xFFFFB830);
  static const Color info          = Color(0xFF00D2FF);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFF9C63FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, Color(0xFFFF9A8B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, Color(0xFF38F9D7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient darkGradient = LinearGradient(
    colors: [bg, bgCard],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

class AppTheme {
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bg,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.bgCard,
        background: AppColors.bg,
        error: AppColors.error,
      ),
      textTheme: GoogleFonts.cairoTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge:  GoogleFonts.cairo(fontSize: 32, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
        displayMedium: GoogleFonts.cairo(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
        titleLarge:    GoogleFonts.cairo(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        titleMedium:   GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        titleSmall:    GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
        bodyLarge:     GoogleFonts.cairo(fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.textPrimary),
        bodyMedium:    GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.textSecondary),
        bodySmall:     GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.w400, color: AppColors.textMuted),
        labelLarge:    GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.bg,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        titleTextStyle: GoogleFonts.cairo(
          fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.bgCard,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF2A2A4A), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        labelStyle: GoogleFonts.cairo(color: AppColors.textMuted, fontSize: 14),
        hintStyle: GoogleFonts.cairo(color: AppColors.textHint, fontSize: 14),
        prefixIconColor: AppColors.textMuted,
        suffixIconColor: AppColors.textMuted,
        errorStyle: GoogleFonts.cairo(color: AppColors.error, fontSize: 11),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.bgCard,
        labelStyle: GoogleFonts.cairo(color: AppColors.textSecondary, fontSize: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: const BorderSide(color: Color(0xFF2A2A4A)),
      ),
      dividerTheme: const DividerThemeData(color: Color(0xFF2A2A4A), thickness: 1),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.bgCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.bgCardLight,
        contentTextStyle: GoogleFonts.cairo(color: AppColors.textPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF5F5FF),
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: Colors.white,
        background: Color(0xFFF5F5FF),
      ),
      textTheme: GoogleFonts.cairoTextTheme(ThemeData.light().textTheme).copyWith(
        displayLarge:  GoogleFonts.cairo(fontSize: 32, fontWeight: FontWeight.w900, color: const Color(0xFF1A1A2E)),
        titleLarge:    GoogleFonts.cairo(fontSize: 20, fontWeight: FontWeight.w700, color: const Color(0xFF1A1A2E)),
        bodyMedium:    GoogleFonts.cairo(fontSize: 13, color: const Color(0xFF6E6E8E)),
      ),
    );
  }
}