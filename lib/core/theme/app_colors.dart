import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Base ──────────────────────────────────────────────────────────────────
  static const Color obsidian   = Color(0xFF0C0C0C); // hero backgrounds
  static const Color ink        = Color(0xFF1A1A1A); // primary text
  static const Color graphite   = Color(0xFF525252); // secondary text
  static const Color stone      = Color(0xFF9A9A9A); // tertiary / hints
  static const Color border     = Color(0xFFE8E8E8); // card borders
  static const Color surface    = Color(0xFFFFFFFF); // card / modal backgrounds
  static const Color background = Color(0xFFF7F7F5); // page background

  // ── Single accent ─────────────────────────────────────────────────────────
  // Used ONLY for CTAs, active states and key labels — nowhere else as fill
  static const Color accent     = Color(0xFFC4441A); // terracota

  // ── Legacy aliases (for gradual migration — use sparingly) ────────────────
  static const Color terracota     = accent;
  static const Color verdeSelva    = Color(0xFF2D6A4F);
  static const Color arena         = Color(0xFFF3F3F1);
  static const Color blancoHueso   = background;
  static const Color neutralDark   = ink;
  static const Color neutralMedium = graphite;
  static const Color neutralLight  = border;
}
