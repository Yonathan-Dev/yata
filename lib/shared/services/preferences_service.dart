import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _themeKey = 'theme';
  static const String _languageKey = 'language';

  // Tema
  Future<void> saveTheme(String theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, theme);
  }

  Future<String> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_themeKey) ?? 'light';
  }

  // Idioma
  Future<void> saveLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, language);
  }

  Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey) ?? 'es';
  }

  // Splash visto
  static const String _hasSeenSplashKey = 'has_seen_splash';

  Future<void> setHasSeenSplash(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasSeenSplashKey, value);
  }

  Future<bool> getHasSeenSplash() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasSeenSplashKey) ?? false;
  }

  // Limpiar todas las preferencias
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
