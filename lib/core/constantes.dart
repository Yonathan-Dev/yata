// Constantes de la aplicación
class Constantes {
  // API
  static const String apiBaseUrl = 'https://api.ejemplo.com';
  static const Duration apiTimeout = Duration(seconds: 30);

  // Almacenamiento local
  static const String authTokenKey = 'auth_token';
  static const String userDataKey = 'user_data';

  // Temas
  static const String lightTheme = 'light';
  static const String darkTheme = 'dark';

  // Idiomas soportados
  static const String spanishLanguage = 'es';
  static const String englishLanguage = 'en';

  // Tamaños y espaciado
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 10;
  static const double borderRadiusTab = 1;
  static const double padding = 25;
  static const double paddingAlto = 10;
  static const double paddingCard = 10;
  static const double paddingActividad = 15;
  static const double separacionFormulario = 20;
  static const double separacionLogin = 30;
  static const double paddingHorizontal = 40;
  static const double separacion = 10;
  static const double separacionCard = 4;
  static const double alturaFormulario = 46;
  static const double separacionFicha = 10;
  static const double separacionRadioGroup = 10;
  static const double espacioSuperiorLogin = 40;
  static const double paddingAcceso = 10;
  static const double transparenciaPrimaria = 1.0;
  static const double botonHeight = 50;
  static const double botonHeightMedium = 40;
  static const double botonHeightSmall = 30;
  static const double imagenHeight = 75;

  // Duración de animaciones
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 800);
  static const Duration standardAnimation = Duration(milliseconds: 1000);
  static const Duration veryLongAnimation = Duration(milliseconds: 2000);
  static const Duration extraLongAnimation = Duration(milliseconds: 4000);

  // Validaciones
  static const int minPasswordLength = 8;
  static const int maxUsernameLength = 30;

  // Paginación
  static const int defaultPageSize = 20;
}
