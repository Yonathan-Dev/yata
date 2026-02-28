## Pantallas principales

- SplashScreen
- AuthScreen
- HomeScreen
- InicioScreen
- RegisterScreen
- ConfiguracionScreen
- OperacionesScreen
- ParatiScreen

## Características principales

- Gestión de estado con Riverpod
- Navegación con GoRouter
- Temas claro y oscuro
- Manejo centralizado de permisos (cámara, galería, almacenamiento) con PermissionsService
- Widgets reutilizables y utilidades compartidas

## Servicios principales

- permissions_service.dart: Lógica para solicitar/verificar permisos de cámara, galería, almacenamiento.
```


## Estructura principal
lib/
  core/                # Temas, rutas, constantes
  features/            # Módulos: auth, home, inicio, operaciones, parati, register, splash, configuracion
    .../presentation/  # Pantallas de cada módulo
    .../widgets/       # Widgets de cada módulo
    .../data/          # Datasources y modelos
  shared/              # Servicios, widgets y utilidades compartidas
    services/          # permissions_service.dart, preferences_service.dart
    widgets/           # loading_widget.dart, error_widget.dart, appbar_widget.dart
    utils/             # snackbar_util.dart, image_utils.dart, dialog_utils.dart
    providers/         # Providers globales
```


## 🚀 Características

### ✅ Implementado

- **Gestión de Estado con Riverpod**: Providers para lógica y UI
- **Navegación**: GoRouter
- **Temas**: Claro/Oscuro
- **Persistencia**: SharedPreferences
- **API**: Dio para HTTP
- **Autenticación**: Login/logout
- **Permisos centralizados**: Uso de PermissionsService para cámara, galería, etc.
- **UI/UX**: Widgets reutilizables y diseño consistente
## 🔒 Manejo de Permisos

El manejo de permisos (cámara, galería, almacenamiento) se realiza a través de la clase `PermissionsService` ubicada en `lib/shared/services/permissions_service.dart`. Esto permite reutilizar la lógica de permisos en cualquier pantalla y mantener el código desacoplado.

Ejemplo de uso:

```dart
final permissionsService = PermissionsService();
final cameraGranted = await permissionsService.ensureCameraPermission();
if (!cameraGranted) {
  // Mostrar diálogo personalizado
}
```

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

### PermissionsService
- Verificación y solicitud de permisos de cámara, galería, almacenamiento
- Lógica multiplataforma (Android/iOS)
- Métodos reutilizables para toda la app

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

## 📝 Notas

- Los providers y servicios están organizados por funcionalidad
- Los modelos usan constructores simples (puedes migrar a Freezed)
- Navegación con GoRouter
- El tema y preferencias se persisten automáticamente
- Los errores y permisos se manejan de forma centralizada

Esta estructura proporciona una base sólida para aplicaciones Flutter escalables, con gestión de estado, permisos y servicios desacoplados.
