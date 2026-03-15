# yate — Flutter App

> Aplicación móvil desarrollada con Flutter, billetera digital.

---

## 📋 Tabla de contenidos

- [Requisitos previos](#-requisitos-previos)
- [Guía para principiantes](#-guía-para-levantar-el-proyecto-desde-cero)
- [Instalación](#-instalación)
- [Configuración del entorno](#-configuración-del-entorno)
- [Levantar el proyecto](#-levantar-el-proyecto)
- [Arquitectura](#-arquitectura)
- [Gestión de estado](#-gestión-de-estado)
- [Navegación](#-navegación)
- [Dependencias principales](#-dependencias-principales)
- [Estructura del proyecto](#-estructura-del-proyecto)
- [Pantallas](#-pantallas)
- [Permisos](#-permisos)

---

## ✅ Requisitos previos

Asegúrate de tener instalado lo siguiente antes de clonar el proyecto:

| Herramienta | Versión mínima |
|---|---|
| Flutter | 3.35.7 (SDK `^3.9.0`) |
| Dart | incluido con Flutter |
| Android Studio / Xcode | última versión estable |
| Git | cualquier versión reciente |

Verifica tu entorno con:
```bash
flutter doctor
```

---

## 🚀 Guía para levantar el proyecto desde cero

### Paso 1 — Instala Flutter

1. Ve a https://docs.flutter.dev/get-started/install
2. Elige tu sistema operativo (Windows / Mac / Linux)
3. Sigue exactamente los pasos que indica la página oficial
4. Al terminar, abre una terminal y ejecuta:
```bash
flutter doctor
```

Todos los ítems deben aparecer en ✅ verde antes de continuar. Si alguno está en rojo, resuélvelo antes de avanzar.

---

### Paso 2 — Instala Android Studio

1. Descárgalo desde https://developer.android.com/studio
2. Instálalo con las opciones por defecto
3. Abre Android Studio → `More Actions` → `Virtual Device Manager`
4. Crea un emulador (elige cualquier Pixel con Android 13 o superior)
5. Inícialo con el botón ▶️

---

### Paso 3 — Clona el proyecto
```bash
git clone <url-del-repositorio>
cd yate
```

---

### Paso 4 — Crea el archivo `.env`

En la carpeta raíz del proyecto crea un archivo llamado exactamente `.env` (sin extensión) y escribe dentro:
```env
BASE_URL=https://payment.servicios.com
```

> ⚠️ Este paso es crítico. Sin este archivo la app no compila.

**¿Cómo crear el archivo?**

- **Windows:** clic derecho en la carpeta → Nuevo archivo de texto → nómbralo `.env` (asegúrate que no quede `.env.txt`)
- **Mac / Linux:** en la terminal dentro de la carpeta del proyecto:
```bash
touch .env
echo "BASE_URL=https://payment.servicios.com" >> .env
```

---

### Paso 5 — Instala las dependencias
```bash
flutter pub get
```

Espera a que termine sin errores.

---

### Paso 6 — Genera el código automático
```bash
dart run build_runner build --delete-conflicting-outputs
```

Esto puede tardar 1-2 minutos. Es obligatorio, no lo saltes.

---

### Paso 7 — Corre la app

Asegúrate de que el emulador del Paso 2 está corriendo, luego:
```bash
flutter run
```

Si te pregunta en qué dispositivo, elige el emulador que creaste.

---

### ❌ Si algo sale mal

**Error con `build_runner` o código generado:**
```bash
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

**Flutter no reconoce el dispositivo:**
```bash
flutter devices
```

Verifica que el emulador aparece en la lista.

**Cualquier error rojo en `flutter doctor`:**

Cópialo y búscalo en Google, casi siempre tiene solución en el primer resultado de Stack Overflow.

---

## 📦 Instalación
```bash
# 1. Clona el repositorio
git clone <url-del-repositorio>
cd yate

# 2. Instala las dependencias
flutter pub get

# 3. Genera el código automático (Freezed + JSON serializable)
dart run build_runner build --delete-conflicting-outputs
```

---

## ⚙️ Configuración del entorno

El proyecto utiliza variables de entorno mediante `flutter_dotenv`. Debes crear un archivo `.env` en la raíz del proyecto antes de ejecutar la app.
```bash
# Crea el archivo .env en la raíz del proyecto
touch .env
```

Agrega las variables necesarias dentro de `.env`:
```env
API_BASE_URL=https://payment.servicios.com
```

> ⚠️ **Importante:** El archivo `.env` está incluido en el `pubspec.yaml` como asset. Sin este archivo, la app no compilará correctamente.

### Íconos de la app

Para regenerar los íconos (si cambias `assets/iconos/icono.png`):
```bash
dart run icons_launcher:create
```

---

## 🚀 Levantar el proyecto
```bash
# Ejecutar en modo debug
flutter run

# Ejecutar en un dispositivo/emulador específico
flutter run -d <device_id>

# Ver dispositivos disponibles
flutter devices

# Compilar para release (Android)
flutter build apk --release
```

### Limpiar y reconstruir

Si experimentas errores de compilación:
```bash
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

---

## 🏛️ Arquitectura

El proyecto sigue una arquitectura **Feature-First** con separación por capas dentro de cada módulo. Cada feature contiene sus propias capas de datos, presentación y lógica, lo que facilita el mantenimiento y la escalabilidad.
```
feature/
  ├── data/
  │   ├── datasources/   # Fuentes de datos (API, local)
  │   └── models/        # Modelos de datos (Freezed / JSON)
  ├── repositories/      # Abstracción entre datasource y lógica
  ├── providers/         # Estado con Riverpod
  ├── presentation/      # Pantallas (Screens)
  └── widgets/           # Widgets específicos del feature
```

El código compartido entre features vive en `shared/`, y la configuración global (rutas, temas, constantes) en `core/`.

---

## 🧠 Gestión de estado

Se utiliza **[flutter_riverpod](https://riverpod.dev/) v3** como gestor de estado. Los providers están organizados por feature y por tipo:

- `StateProvider` — estado simple (booleanos, contadores)
- `StateNotifierProvider` — estado complejo con lógica (auth, usuario)
- `FutureProvider` — operaciones asíncronas (llamadas a API)
- `Provider.family` — providers parametrizados

Los providers globales se encuentran en `lib/shared/providers/`.

---

## 🧭 Navegación

La navegación está manejada con **[GoRouter](https://pub.dev/packages/go_router) v17**. La configuración de rutas se encuentra en:
```
lib/core/router.dart
```

---

## 📚 Dependencias principales

| Paquete | Uso |
|---|---|
| `flutter_riverpod` | Gestión de estado |
| `go_router` | Navegación declarativa |
| `dio` | Cliente HTTP |
| `shared_preferences` | Persistencia simple |
| `flutter_secure_storage` | Almacenamiento seguro (tokens) |
| `freezed` + `json_serializable` | Modelos inmutables y serialización |
| `camera` + `image_picker` | Cámara y galería |
| `local_auth` | Autenticación biométrica |
| `qr_flutter` | Generación de códigos QR |
| `flutter_dotenv` | Variables de entorno |
| `permission_handler` | Gestión de permisos |
| `intl` + `flutter_localizations` | Internacionalización |

---

## 🗂️ Estructura del proyecto
```
lib/
├── core/
│   ├── app_exports.dart
│   ├── constantes.dart
│   ├── responsive.dart
│   ├── router.dart
│   ├── secure.dart
│   └── tema.dart
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   └── models/
│   │   ├── repositories/
│   │   ├── providers/
│   │   ├── presentation/
│   │   ├── widgets/
│   │   └── auth_exports.dart
│   ├── configuracion/
│   ├── home/
│   ├── inicio/
│   ├── operaciones/
│   ├── parati/
│   ├── register/
│   └── splash/
└── shared/
    ├── interceptors/
    ├── models/
    ├── providers/
    ├── services/
    │   ├── permissions_service.dart
    │   └── preferences_service.dart
    ├── utils/
    │   ├── dialog_utils.dart
    │   ├── image_utils.dart
    │   └── snackbar_util.dart
    └── widgets/
        ├── appbar_widget.dart
        ├── error_widget.dart
        └── loading_widget.dart
```

---

## 📱 Pantallas

| Pantalla | Descripción |
|---|---|
| `SplashScreen` | Pantalla de carga inicial |
| `AuthScreen` | Login / autenticación |
| `RegisterScreen` | Registro de usuario |
| `HomeScreen` | Pantalla principal |
| `InicioScreen` | Vista de inicio |
| `OperacionesScreen` | Módulo de operaciones |
| `ParatiScreen` | Contenido personalizado |
| `ConfiguracionScreen` | Ajustes de la app |

---

## 🔒 Permisos

Los permisos (cámara, galería, almacenamiento) se gestionan de forma centralizada desde `lib/shared/services/permissions_service.dart`, lo que mantiene el código desacoplado y reutilizable en cualquier pantalla.

Permisos requeridos por la app:

- **Cámara** — captura de fotos
- **Galería / almacenamiento** — selección de imágenes

> Los permisos en Android/iOS deben estar declarados en `AndroidManifest.xml` y `Info.plist` respectivamente.

---

## 🎨 Assets y fuentes

| Recurso | Ruta |
|---|---|
| Imágenes | `assets/imagenes/` |
| Íconos | `assets/iconos/` |
| Fuente principal | `Gilroy` (Medium / MediumItalic) |
| Variables de entorno | `.env` (raíz del proyecto) |