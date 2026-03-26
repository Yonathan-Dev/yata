import 'package:flutter/material.dart';

class Tema {
  static const Color primaryColor = violeta;
  static const Color negro = Color(0xFF231F20);
  static const Color amarillo = Color(0xFFFEDD3C);
  static const Color blanco = Color(0xFFFFFFFF);
  static const Color rojo = Color(0xFFF06177);
  static const Color rojoCoral = Color(0xFFFF5252);
  static const Color rojoClaro = Color(0xFFF497A2);
  static const Color verde = Color(0xFF8BDC64);
  static const Color naranja = Color(0xFFFF9F43);
  static const Color celeste = Color(0XFF40C4EB);
  static const Color gris = Color(0xFFA8AAAE);
  static const Color grisClaro = Color(0xFFF1F4F8);
  static const Color azul = Color(0xFF1E88E5);
  static const Color violeta = Color(0xFF830ACE);
  static const Color pendiente = Color(0xFFFFA000);
  static const Color guardado = Color(0xFFE53935);
  static const Color enviado = Color(0xFF43A047);
  static const Color borrar = Color(0xFF424242);
  static const Color editar = Color(0xFF1E88E5);
  static const Color sincronizar = Color(0xFF00ACC1);

  static const Color backgroundDark = Color(0xFF25293C);
  static const Color surfaceDark = Color(0xFF2F3349);
  static const Color borderDark = Color(0xFFA8AAAE);
  static const Color backgroundLight = Color(0xFFF1F4F8);
  static const Color surfaceLight = Color(0xFFFFFFFF);

  static const Color borderLight = Color(0xFFE0E0E0);

  static const Color textLight = Color(0xFF231F20);
  static const Color textDark = Color(0xFFFFFFFF);

  static Color getColor(String codigoColor) {
    return Color(int.parse(codigoColor.substring(1), radix: 16) + 0xFF000000);
  }

  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    fontFamily: 'Gilroy',
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: backgroundLight,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.fromSeed(
      primary: primaryColor,
      seedColor: surfaceLight,
      surface: surfaceLight, // Cambia el color de fondo aquí
      brightness: Brightness.light,
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: surfaceLight,
      surfaceTintColor: surfaceLight,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primaryColor,
      circularTrackColor: Colors.transparent,
      refreshBackgroundColor: Colors.transparent,
    ),
    cardTheme: CardThemeData(
      color: surfaceLight,
      surfaceTintColor: surfaceLight,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: borderLight, width: 1.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      elevation: 0,
      backgroundColor: surfaceLight,
      surfaceTintColor: surfaceLight,
      indicatorColor: primaryColor,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(color: textLight, fontSize: 12);
        }
        return const TextStyle(color: textLight, fontSize: 12);
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(
            color: negro,
            size: 24,
          ); // Color cuando el checkbox está seleccionado
        }
        return const IconThemeData(color: negro, size: 24); // Color por defecto
      }),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: textLight),
      displayMedium: TextStyle(color: textLight),
      displaySmall: TextStyle(color: textLight),
      headlineLarge: TextStyle(color: textLight),
      headlineMedium: TextStyle(color: textLight),
      headlineSmall: TextStyle(color: textLight),
      titleLarge: TextStyle(color: textLight),
      titleMedium: TextStyle(color: textLight),
      titleSmall: TextStyle(color: textLight),
      bodyLarge: TextStyle(color: textLight),
      bodyMedium: TextStyle(color: textLight),
      bodySmall: TextStyle(color: textLight),
      labelMedium: TextStyle(color: textLight),
      labelSmall: TextStyle(color: textLight),
    ),
    inputDecorationTheme: InputDecorationTheme(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 12.0,
        horizontal: 12.0,
      ),
      suffixStyle: const TextStyle(color: textLight),
      labelStyle: const TextStyle(color: textLight, fontSize: 14),
      floatingLabelStyle: const TextStyle(color: textLight),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(
          color: borderLight, // Color del borde
          width: 1.0, // Ancho del borde
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: borderLight, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: primaryColor, width: 1.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: primaryColor, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: primaryColor, width: 1.0),
      ),
      errorStyle: const TextStyle(color: primaryColor, fontSize: 12),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryColor; // Color cuando el checkbox está seleccionado
        }
        return backgroundLight; // Color por defecto
      }),
      checkColor: WidgetStateProperty.all(
        negro,
      ), // Color de la marca de verificación
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          2,
        ), // Forma con bordes ligeramente redondeados
      ),
      side: const BorderSide(
        color: borderLight, // Color del borde
        width: 1.0, // Grosor del borde
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: negro,
        elevation: 0,
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: primaryColor,
        elevation: 0,
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        side: const BorderSide(color: primaryColor),
      ),
    ),
    iconTheme: const IconThemeData(color: textLight),
    dividerTheme: const DividerThemeData(color: borderLight, thickness: 1),
    switchTheme: SwitchThemeData(
      trackOutlineWidth: WidgetStateProperty.all(1),
      trackOutlineColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return borderLight; // Color cuando está activado
        }
        return borderLight.withValues(
          alpha: 0.5,
        ); // Color cuando está desactivado
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return backgroundLight; // Color cuando está activado
        }
        return backgroundLight; // Color cuando está desactivado
      }),
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryColor; // Color cuando está activado
        } else if (states.contains(WidgetState.hovered)) {
          return primaryColor.withValues(
            alpha: 0.5,
          ); // Color cuando está activado
        }
        return gris; // Color cuando está desactivado
      }),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: surfaceLight,
      surfaceTintColor: surfaceLight,
      elevation: 20.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundLight,
      surfaceTintColor: backgroundLight,
      elevation: 0,
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    fontFamily: 'Gilroy',
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: backgroundDark,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.fromSeed(
      primary: primaryColor,
      seedColor: surfaceDark,
      surface: surfaceDark, // Cambia el color de fondo aquí
      brightness: Brightness.dark,
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: surfaceDark,
      surfaceTintColor: surfaceDark,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primaryColor,
      circularTrackColor: Colors.transparent,
      refreshBackgroundColor: Colors.transparent,
    ),
    cardTheme: CardThemeData(
      color: surfaceDark,
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    ),
    navigationBarTheme: NavigationBarThemeData(
      elevation: 0,
      backgroundColor: backgroundDark,
      surfaceTintColor: surfaceDark,
      indicatorColor: primaryColor,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(color: primaryColor, fontSize: 12);
        }
        return const TextStyle(color: textDark, fontSize: 12);
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(
            color: negro,
            size: 24,
          ); // Color cuando el checkbox está seleccionado
        }
        return const IconThemeData(
          color: blanco,
          size: 24,
        ); // Color por defecto
      }),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: textDark),
      displayMedium: TextStyle(color: textDark),
      displaySmall: TextStyle(color: textDark),
      headlineLarge: TextStyle(color: textDark),
      headlineMedium: TextStyle(color: textDark),
      headlineSmall: TextStyle(color: textDark),
      titleLarge: TextStyle(color: textDark),
      titleMedium: TextStyle(color: textDark),
      titleSmall: TextStyle(color: textDark),
      bodyLarge: TextStyle(color: textDark),
      bodyMedium: TextStyle(color: textDark),
      bodySmall: TextStyle(color: textDark),
      labelMedium: TextStyle(color: textDark),
      labelSmall: TextStyle(color: textDark),
    ),
    inputDecorationTheme: InputDecorationTheme(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 12.0,
        horizontal: 12,
      ),
      suffixStyle: const TextStyle(color: textDark),
      labelStyle: const TextStyle(color: textDark, fontSize: 14),
      floatingLabelStyle: const TextStyle(color: textDark),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(
          color: borderDark, // Color del borde
          width: 1.0, // Ancho del borde
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: borderDark, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: primaryColor, width: 1.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: primaryColor, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: primaryColor, width: 1.0),
      ),
      errorStyle: const TextStyle(color: primaryColor, fontSize: 12),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryColor; // Color cuando el checkbox está seleccionado
        }
        return backgroundDark; // Color por defecto
      }),
      checkColor: WidgetStateProperty.all(
        negro,
      ), // Color de la marca de verificación
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          2,
        ), // Forma con bordes ligeramente redondeados
      ),
      side: const BorderSide(
        color: borderDark, // Color del borde
        width: 1.0, // Grosor del borde
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: negro,
        elevation: 0,
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: primaryColor,
        elevation: 0,
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        side: const BorderSide(color: primaryColor),
      ),
    ),
    iconTheme: const IconThemeData(color: blanco),
    dividerTheme: const DividerThemeData(color: gris, thickness: 1),
    switchTheme: SwitchThemeData(
      trackOutlineWidth: WidgetStateProperty.all(2),
      trackOutlineColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return gris; // Color cuando está activado
        }
        return gris; // Color cuando está desactivado
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return backgroundDark; // Color cuando está activado
        }
        return backgroundDark; // Color cuando está desactivado
      }),
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryColor; // Color cuando está activado
        }
        return gris; // Color cuando está desactivado
      }),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: surfaceDark,
      surfaceTintColor: surfaceDark,
      elevation: 20.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundDark,
      surfaceTintColor: backgroundDark,
      elevation: 0,
    ),
  );
}
