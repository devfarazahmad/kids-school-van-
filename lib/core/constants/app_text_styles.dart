import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';


class AppTextStyles {
static TextStyle heading1 = GoogleFonts.poppins(
fontSize: 28,
fontWeight: FontWeight.w700,
color: AppColors.textPrimary,
);
static TextStyle heading2 = GoogleFonts.poppins(
fontSize: 22,
fontWeight: FontWeight.w600,
color: AppColors.textPrimary,
);
static TextStyle subtitle = GoogleFonts.inter(
fontSize: 14,
fontWeight: FontWeight.w500,
color: AppColors.textSecondary,
);
static TextStyle body = GoogleFonts.inter(
fontSize: 14,
color: AppColors.textPrimary,
);
static TextStyle button = GoogleFonts.poppins(
fontSize: 16,
fontWeight: FontWeight.w600,
color: Colors.white,
);
}