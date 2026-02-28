import 'package:flutter/material.dart';
import 'constantes.dart';

class Responsive {
  final BuildContext context;
  late final double screenHeight; // Altura total de la pantalla
  late final double screenWidth; // Ancho total de la pantalla
  late final bool
  isSmallScreen; // True si la altura es menor a 700px, ideal para móviles pequeños
  late final bool
  isMediumScreen; // True si la altura está entre 700px y 900px, ideal para móviles grandes y tablets pequeños
  late final bool
  isLargeScreen; // True si la altura es mayor a 900px, ideal para tablets grandes y desktops
  late final bool
  isLandscape; // True si el ancho es mayor que la altura, útil para ajustar layouts en landscape
  late final bool
  isTablet; // True si el ancho es mayor o igual a 600px, útil para ajustar layouts en tablets

  // Breakpoints
  static const double smallScreenBreakpoint =
      700; // Altura menor a 700px se considera pantalla pequeña
  static const double mediumScreenBreakpoint =
      900; // Altura entre 700px y 900px se considera pantalla mediana
  static const double tabletBreakpoint =
      600; // Ancho mayor o igual a 600px se considera tablet
  static const double smallWidthBreakpoint =
      400; // Ancho menor a 400px se considera pantalla muy pequeña (ej. móviles compactos)

  Responsive(this.context) {
    final mediaQuery = MediaQuery.of(context);
    screenHeight = mediaQuery.size.height;
    screenWidth = mediaQuery.size.width;
    isSmallScreen = screenHeight < smallScreenBreakpoint;
    isMediumScreen =
        screenHeight >= smallScreenBreakpoint &&
        screenHeight < mediumScreenBreakpoint;
    isLargeScreen = screenHeight >= mediumScreenBreakpoint;
    isLandscape = screenWidth > screenHeight;
    isTablet = screenWidth >= tabletBreakpoint;
  }

  /// Padding horizontal: 16 en pantallas pequeñas, 24 en grandes
  double get horizontalPadding =>
      screenWidth < smallWidthBreakpoint ? 16.0 : 24.0;

  /// Padding superior: 40 en pantallas pequeñas, 60 en grandes
  double get topPadding => isSmallScreen ? 40.0 : 60.0;

  /// Padding inferior: 16 en pantallas pequeñas, 24 en grandes
  double get bottomPadding => isSmallScreen ? 16.0 : 24.0;

  /// Padding por defecto adaptativo
  double get defaultPadding => isSmallScreen ? 12.0 : Constantes.defaultPadding;

  /// Espaciado entre elementos de formulario
  double get spacing => isSmallScreen ? 12.0 : Constantes.separacionFormulario;

  /// Espaciado pequeño
  double get smallSpacing => isSmallScreen ? 4.0 : 8.0;

  /// Espaciado grande
  double get largeSpacing => isSmallScreen ? 16.0 : 24.0;

  /// Altura del logo adaptativa
  double get logoHeight => isSmallScreen ? 80.0 : 120.0;

  /// Altura de botones
  double get buttonHeight => isSmallScreen ? 42.0 : Constantes.alturaFormulario;

  /// Tamaño de fuente para títulos
  double get titleFontSize => isSmallScreen ? 20.0 : 24.0;

  /// Tamaño de fuente para subtítulos
  double get subtitleFontSize => isSmallScreen ? 16.0 : 18.0;

  /// Tamaño de fuente para texto normal
  double get bodyFontSize => isSmallScreen ? 14.0 : 16.0;

  /// Ancho máximo para contenido en landscape/tablet
  double get maxContentWidth => isLandscape ? screenWidth * 0.6 : screenWidth;

  /// EdgeInsets para formularios
  EdgeInsets get formPadding => EdgeInsets.only(
    top: topPadding,
    left: horizontalPadding,
    right: horizontalPadding,
    bottom: bottomPadding,
  );

  /// EdgeInsets horizontales
  EdgeInsets get horizontalPaddingInsets =>
      EdgeInsets.symmetric(horizontal: horizontalPadding);

  /// EdgeInsets para cards
  EdgeInsets get cardPadding => EdgeInsets.all(isSmallScreen ? 12.0 : 16.0);

  // Retorna un valor según el tamaño de pantalla
  T valueByScreenSize<T>({required T small, T? medium, required T large}) {
    if (isSmallScreen) return small;
    if (isMediumScreen) return medium ?? large;
    return large;
  }

  /// Retorna un widget según la orientación
  Widget byOrientation({required Widget portrait, required Widget landscape}) {
    return isLandscape ? landscape : portrait;
  }

  /// SizedBox con spacing responsive
  SizedBox get spacingBox => SizedBox(height: spacing);

  /// SizedBox con spacing pequeño responsive
  SizedBox get smallSpacingBox => SizedBox(height: smallSpacing);

  /// SizedBox con spacing grande responsive
  SizedBox get largeSpacingBox => SizedBox(height: largeSpacing);
}
