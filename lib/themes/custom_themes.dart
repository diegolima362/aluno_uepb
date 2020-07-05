import 'package:flutter/material.dart';

class CustomThemes {
  static const PRIMARY_COLOR = Color(0xFF3E206D);
  static const PRIMARY_LIGHT_COLOR = Color(0xFFF1E6FF);

  static ThemeData get light => ThemeData(
        primaryColor: Color(0xFF3E206D),
        accentColor: Color(0xFF3E206D),
        backgroundColor: Color(0xFFFFFFFF),
        primarySwatch: Colors.deepPurple,
      );

  static ThemeData get dark => ThemeData(
        primaryColor: Color(0xFF191919),
        accentColor: Color(0xFFFFFFFF),
        backgroundColor: Color(0xFF000000),
      );
}
