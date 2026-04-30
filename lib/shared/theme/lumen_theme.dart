import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color kBg        = Color(0xFF050403);
const Color kSheet     = Color(0xFF0A0806);
const Color kPanelBg   = Color(0xD10E0B08);
const Color kText      = Color(0xFFF1E7D6);
const Color kMute      = Color(0x80F1E7D6);
const Color kAmber     = Color(0xFFF0A94A);
const Color kAmberSoft = Color(0x1FF0A94A);
const Color kHair      = Color(0x17F1E7D6);
const Color kRed       = Color(0xFFE04B3A);
const Color kTeal      = Color(0xFF3AC8C0);

TextStyle displayStyle({
  double size = 18,
  Color color = kText,
  bool italic = true,
  FontWeight weight = FontWeight.w400,
  double letterSpacing = 0,
}) =>
    GoogleFonts.cormorantGaramond(
      fontSize: size,
      color: color,
      fontStyle: italic ? FontStyle.italic : FontStyle.normal,
      fontWeight: weight,
      letterSpacing: letterSpacing,
    );

TextStyle sansStyle({
  double size = 12,
  Color color = kText,
  FontWeight weight = FontWeight.w400,
  double letterSpacing = 0,
}) =>
    GoogleFonts.interTight(
      fontSize: size,
      color: color,
      fontWeight: weight,
      letterSpacing: letterSpacing,
    );

TextStyle monoStyle({
  double size = 9,
  Color color = kMute,
  FontWeight weight = FontWeight.w400,
  double letterSpacing = 2.0,
}) =>
    GoogleFonts.jetBrainsMono(
      fontSize: size,
      color: color,
      fontWeight: weight,
      letterSpacing: letterSpacing,
    );
