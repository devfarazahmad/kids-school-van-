import 'package:flutter/material.dart';
import '../constants/app_colors.dart';


ThemeData buildAppTheme() {
final base = ThemeData.light(useMaterial3: true);
return base.copyWith(
scaffoldBackgroundColor: AppColors.background,
colorScheme: base.colorScheme.copyWith(
primary: AppColors.primary,
secondary: AppColors.accent,
surface: AppColors.surface,
),
appBarTheme: AppBarTheme(
backgroundColor: AppColors.surface,
foregroundColor: AppColors.textPrimary,
elevation: 0,
centerTitle: false,
titleTextStyle: const TextStyle(
fontSize: 20,
fontWeight: FontWeight.w700,
),
),
inputDecorationTheme: InputDecorationTheme(
filled: true,
fillColor: Colors.white,
contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(14),
borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
),
enabledBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(14),
borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
),
focusedBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(14),
borderSide: const BorderSide(color: AppColors.primary, width: 2),
),
hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
),
elevatedButtonTheme: ElevatedButtonThemeData(
style: ElevatedButton.styleFrom(
backgroundColor: AppColors.primary,
foregroundColor: Colors.white,
padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
),
),
chipTheme: base.chipTheme.copyWith(
color: WidgetStateProperty.all(Colors.white),
side: const BorderSide(color: Color(0xFFE5E7EB)),
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
),
);
}