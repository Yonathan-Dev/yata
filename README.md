# Mi Presencia - Estructura con Riverpod

Una aplicación Flutter estructurada para trabajar con Riverpod, diseñada para aplicaciones pequeñas a medianas.

## 📁 Estructura del Proyecto

```
lib/
├── main.dart                    # Punto de entrada de la aplicación
├── app_exports.dart            # Archivo de exportaciones centralizadas
├── core/                       # Configuración y utilidades centrales
│   ├── constants.dart          # Constantes de la aplicación
│   ├── themes.dart             # Temas claro y oscuro
│   └── router.dart             # Configuración de rutas con GoRouter
├── models/                     # Modelos de datos
│   ├── user.dart               # Modelo de usuario
│   └── app_state.dart          # Estado global de la aplicación
├── providers/                  # Providers de Riverpod
│   ├── app_providers.dart      # Providers generales (servicios, loading, error)
│   ├── user_providers.dart     # Providers relacionados con usuarios
│   └── theme_providers.dart    # Providers para tema e idioma
├── services/                   # Servicios externos
│   ├── api_service.dart        # Servicio para llamadas a API
│   └── preferences_service.dart # Servicio para SharedPreferences
├── views/                      # Pantallas de la aplicación
│   ├── home_screen.dart        # Pantalla principal
│   ├── login_screen.dart       # Pantalla de login
│   ├── profile_screen.dart     # Pantalla de perfil
│   └── settings_screen.dart    # Pantalla de configuración
└── widgets/                    # Widgets reutilizables
    ├── loading_widget.dart     # Widget de carga
    ├── error_widget.dart       # Widget de error
    └── user_card.dart          # Card de usuario
```

## 🚀 Características

### ✅ Implementado

- **Gestión de Estado con Riverpod**: Uso de diferentes tipos de providers
- **Navegación**: GoRouter para manejo de rutas
- **Temas**: Soporte para tema claro y oscuro
- **Persistencia**: SharedPreferences para datos locales
- **API**: Configuración con Dio para llamadas HTTP
- **Autenticación**: Sistema básico de login/logout
- **UI/UX**: Widgets reutilizables y diseño consistente

### 🔧 Providers Incluidos

#### App Providers (`app_providers.dart`)
- `apiServiceProvider`: Singleton del servicio de API
- `preferencesServiceProvider`: Singleton del servicio de preferencias
- `loadingProvider`: Estado de carga global
- `errorProvider`: Manejo de errores globales

#### User Providers (`user_providers.dart`)
- `currentUserProvider`: Usuario actualmente autenticado
- `usersProvider`: Lista de usuarios
- `fetchUsersProvider`: Provider para obtener usuarios de la API
- `userByIdProvider`: Provider para obtener usuario por ID
- `authStateProvider`: Estado de autenticación completo

#### Theme Providers (`theme_providers.dart`)
- `themeProvider`: Gestión del tema (claro/oscuro)
- `languageProvider`: Gestión del idioma

## 🛠️ Uso de Providers

### Lectura de Estado
```dart
// En un ConsumerWidget
final authState = ref.watch(authStateProvider);
final currentTheme = ref.watch(themeProvider);

// En un ConsumerStatefulWidget
final users = ref.watch(usersProvider);
```

### Modificación de Estado
```dart
// Cambiar tema
ref.read(themeProvider.notifier).toggleTheme();

// Login
ref.read(authStateProvider.notifier).login(email, password);

// Logout
ref.read(authStateProvider.notifier).logout();
```

### Escuchar Cambios
```dart
ref.listen<AuthState>(authStateProvider, (previous, next) {
  if (next.isAuthenticated) {
    // Navegar a home
  }
  if (next.error != null) {
    // Mostrar error
  }
});
```

## 📱 Pantallas

### LoginScreen
- Formulario de autenticación
- Validación de campos
- Manejo de estados de carga y error
- Navegación automática después del login

### HomeScreen
- Lista de usuarios
- Manejo de estados asíncronos
- Barra de aplicación con opciones

### ProfileScreen
- Información del usuario actual
- Opciones para editar perfil
- Botón de cerrar sesión

### SettingsScreen
- Cambio de tema
- Cambio de idioma
- Información de la aplicación
- Cerrar sesión

## 🎨 Widgets Reutilizables

### LoadingWidget
```dart
const LoadingWidget(
  message: 'Cargando...',
  size: 32.0,
)
```

### AppErrorWidget
```dart
AppErrorWidget(
  message: 'Error al cargar datos',
  onRetry: () => ref.refresh(someProvider),
)
```

### UserCard
```dart
UserCard(
  user: user,
  onTap: () => Navigator.push(...),
)
```

## 🔧 Servicios

### ApiService
- Configuración de Dio
- Interceptores para logging
- Métodos CRUD para usuarios
- Manejo de errores

### PreferencesService
- Gestión de tokens de autenticación
- Preferencias de usuario (tema, idioma)
- Métodos para limpiar datos

## 🎯 Patrones de Uso

### 1. StateProvider
Para estado simple:
```dart
final counterProvider = StateProvider<int>((ref) => 0);
```

### 2. StateNotifierProvider
Para estado complejo:
```dart
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});
```

### 3. FutureProvider
Para operaciones asíncronas:
```dart
final usersProvider = FutureProvider<List<User>>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  return await apiService.getUsers();
});
```

### 4. Provider.family
Para providers parametrizados:
```dart
final userByIdProvider = FutureProvider.family<User, String>((ref, userId) async {
  final apiService = ref.read(apiServiceProvider);
  return await apiService.getUserById(userId);
});
```

## 🚀 Comandos Útiles

```bash
# Instalar dependencias
flutter pub get

# Ejecutar la aplicación
flutter run

# Generar código (si usas Freezed en el futuro)
flutter packages pub run build_runner build

# Limpiar proyecto
flutter clean
```

## 🔮 Próximos Pasos

Para expandir la aplicación, considera:

1. **Freezed**: Para modelos inmutables
2. **Auto Route**: Para navegación más avanzada
3. **Hive/Isar**: Para base de datos local
4. **Firebase**: Para backend
5. **Testing**: Unit tests con Riverpod
6. **Internacionalización**: Soporte multiidioma completo
7. **Notificaciones Push**: Con Firebase Messaging
8. **Offline Support**: Con connectivity_plus

## 📝 Notas

- Los providers están organizados por funcionalidad
- Los modelos usan constructores simples (se puede migrar a Freezed)
- La navegación usa rutas nombradas con GoRouter
- El tema se persiste automáticamente
- Los errores se manejan de forma centralizada

Esta estructura proporciona una base sólida para aplicaciones Flutter de tamaño pequeño a mediano, con un patrón de gestión de estado consistente y escalable.
