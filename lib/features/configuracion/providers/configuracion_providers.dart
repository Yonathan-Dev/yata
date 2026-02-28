import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/providers/shared_providers.dart';

// Notifier para manejar el tema
class ThemeNotifier extends Notifier<String> {
  @override
  String build() {
    _loadTheme();
    return 'light';
  }

  Future<void> _loadTheme() async {
    try {
      final prefsService = ref.read(preferencesServiceProvider);
      final savedTheme = await prefsService.getTheme();
      state = savedTheme;
    } catch (e) {
      state = 'light';
    }
  }

  Future<void> setTheme(String theme) async {
    try {
      final prefsService = ref.read(preferencesServiceProvider);
      await prefsService.saveTheme(theme);
      state = theme;
    } catch (e) {
      // Manejar error
    }
  }

  void toggleTheme() {
    final newTheme = state == 'light' ? 'dark' : 'light';
    setTheme(newTheme);
  }
}

// Provider para el tema de la aplicación
final themeProvider = NotifierProvider<ThemeNotifier, String>(() {
  return ThemeNotifier();
});
