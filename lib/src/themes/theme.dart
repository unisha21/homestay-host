import 'package:flutter/material.dart';

ThemeData lightTheme() => ThemeData(
      useMaterial3: false,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: Colors.black,
        onPrimary: Colors.white,
        primaryContainer: const Color(0xff989898),
        onPrimaryContainer: const Color(0xff050505),
        secondary: const Color(0xffFFE100),
        onSecondary: Colors.black,
        secondaryContainer: const Color(0xffFFFFB4),
        onSecondaryContainer: const Color(0xff000000),
        tertiary: const Color(0xff4885ED),
        onTertiary: Colors.white,
        tertiaryContainer: const Color(0xff4885ED),
        onTertiaryContainer: Colors.white,
        error: const Color(0xffBA1B1B),
        onError: Colors.white,
        errorContainer: const Color(0xffF9DEDC),
        onErrorContainer: const Color(0xff410E0B),
        surface: Colors.white,
        onSurface: Colors.black,
        surfaceContainerHighest: const Color(0xffE9E9E9),
        onSurfaceVariant: const Color(0xff606060),
        outline: const Color(0xff79747E),
        outlineVariant: const Color(0xffCAC4D0),
      ),
      fontFamily: 'Poppins',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 57,
          fontWeight: FontWeight.normal,
        ),
        displayMedium: TextStyle(
          fontSize: 45,
          fontWeight: FontWeight.normal,
        ),
        displaySmall: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.normal,
        ),
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.normal,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.normal,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.normal,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );

ThemeData darkTheme() => ThemeData(
      useMaterial3: false,
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: Colors.white,
        onPrimary: Colors.black,
        primaryContainer: const Color(0xff989898),
        onPrimaryContainer: const Color(0xff050505),
        secondary: const Color(0xffFFE100),
        onSecondary: Colors.black,
        secondaryContainer: const Color(0xffFFFFB4),
        onSecondaryContainer: const Color(0xff000000),
        tertiary: const Color(0xff4885ED),
        onTertiary: Colors.white,
        tertiaryContainer: const Color(0xff4885ED),
        onTertiaryContainer: Colors.white,
        error: const Color(0xffBA1B1B),
        onError: Colors.white,
        errorContainer: const Color(0xffF9DEDC),
        onErrorContainer: const Color(0xff410E0B),
        surface: Colors.black,
        onSurface: Colors.white,
        surfaceContainerHighest: const Color(0xffE9E9E9),
        onSurfaceVariant: const Color(0xff606060),
        outline: const Color(0xff79747E),
        outlineVariant: const Color(0xffCAC4D0),
      ),
      fontFamily: 'Poppins',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 57,
          fontWeight: FontWeight.normal,
        ),
        displayMedium: TextStyle(
          fontSize: 45,
          fontWeight: FontWeight.normal,
        ),
        displaySmall: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.normal,
        ),
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.normal,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.normal,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.normal,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
