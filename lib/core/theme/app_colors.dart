import 'package:flutter/material.dart';

class AppColors {
  // Background colors
  static const Color bg = Color(0xFF0A0E1A);
  static const Color surface = Color(0xFF1E293B);
  static const Color cardBg = Color(0xFF1E293B);
  static const Color cardBg2 = Color(0xFF2A3441);
  
  // Brand colors
  static const Color cyan = Color(0xFF00E5FF);
  static const Color purple = Color(0xFF8B5CF6);
  static const Color green = Color(0xFF10B981);
  static const Color orange = Color(0xFFF97316);
  
  // Text colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textTertiary = Color(0xFF64748B);
  
  // Rank colors
  static const Color rankD = Color(0xFF6B7280); // Gray
  static const Color rankC = Color(0xFF10B981); // Green
  static const Color rankB = Color(0xFF3B82F6); // Blue
  static const Color rankA = Color(0xFF8B5CF6); // Purple
  static const Color rankS = Color(0xFFF59E0B); // Orange
  
  // Stat colors
  static const Color statStr = Color(0xFFEF4444); // Red
  static const Color statVit = Color(0xFF10B981); // Green
  static const Color statIntel = Color(0xFF3B82F6); // Blue
  static const Color statCha = Color(0xFF8B5CF6); // Purple
  
  // UI colors
  static const Color border = Color(0xFF334155);
  static const Color divider = Color(0xFF475569);
  static const Color shadow = Color(0xFF000000);
  
  // Gradient
  static const LinearGradient brandGradient = LinearGradient(
    colors: [cyan, purple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient successGradient = LinearGradient(
    colors: [green, cyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient warningGradient = LinearGradient(
    colors: [orange, red],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
