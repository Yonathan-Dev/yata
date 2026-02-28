import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _authTokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _themeKey = 'theme';
  static const String _languageKey = 'language';

  // Token de autenticación
  Future<void> saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authTokenKey, token);
  }

  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_authTokenKey);
  }

  Future<void> removeAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authTokenKey);
  }

  // ID de usuario
  Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  Future<void> removeUserId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
  }

  // Guardar nombre de usuario para "Recordarme"
  Future<void> saveSavedUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_username', username);
  }

  Future<String?> getSavedUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('saved_username');
  }

  Future<void> removeSavedUsername() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('saved_username');
  }

  // Guardar contraseña para "Recordarme"
  Future<void> saveSavedPassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_password', password);
  }

  Future<String?> getSavedPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('saved_password');
  }

  Future<void> removeSavedPassword() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('saved_password');
  }

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
