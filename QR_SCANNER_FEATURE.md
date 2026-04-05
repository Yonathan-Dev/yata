# 📱 Funcionalidad de Lectura de Código QR

## 🎯 Descripción

La pantalla `LecturaQrScreen` proporciona una solución completa para escanear códigos QR con las siguientes características:

- ✅ **Escaneo en tiempo real** usando la cámara del dispositivo
- ✅ **Carga de QR desde galería** para escanear imágenes guardadas
- ✅ **Control de linterna/flash** para escanear en condiciones de poca luz
- ✅ **Interfaz moderna y animada** con feedback visual
- ✅ **Manejo de permisos** automático y amigable

## 📦 Dependencias

La funcionalidad utiliza el paquete `mobile_scanner: ^7.2.0` que proporciona:

- Escaneo de códigos QR y barcodes usando MLKit (Android) y AVFoundation (iOS)
- Análisis de imágenes desde la galería
- Control de linterna integrado
- Soporte multiplataforma (Android, iOS, macOS, Web)

## 🚀 Navegación

### Desde el código:
```dart
context.push('/paga-con-qr');
```

### Desde la pantalla de inicio:
1. Usuario hace clic en el botón "Escanear QR" en la parte inferior de `InicioScreen`
2. Usuario hace clic en la tarjeta "Paga con QR" en la cuadrícula de acciones

## 🎨 Características de la UI

### 1. **Marco de Escaneo Animado**
- Marco rectangular con esquinas destacadas en color primario
- Línea de escaneo animada que se mueve verticalmente
- Texto instructivo: "Coloca el QR dentro del marco"

### 2. **Controles Inferiores**
Dos botones principales:

#### Flash/Linterna
- Icono: `flash_off` / `flash_on`
- Alterna el flash de la cámara
- Indicador visual de estado activo (fondo color primario)

#### Galería
- Icono: `photo_library_rounded`
- Abre el selector de imágenes
- Analiza la imagen seleccionada en busca de códigos QR

### 3. **AppBar Personalizada**
- Botón de regreso circular semi-transparente
- Título centrado: "Escanear código QR"
- Fondo oscuro para mejor contraste con la cámara

## 🔧 Implementación Técnica

### Providers

```dart
// Control del estado de la linterna
final flashlightProvider = StateProvider<bool>((ref) => false);

// Almacena el resultado del QR escaneado
final qrResultProvider = StateProvider<String?>((ref) => null);
```

### Controlador del Scanner

```dart
MobileScannerController(
  detectionSpeed: DetectionSpeed.normal,
  facing: CameraFacing.back,
  torchEnabled: false,
)
```

### Métodos Principales

#### `_initializeScanner()`
- Verifica y solicita permisos de cámara
- Inicializa el controlador del scanner
- Muestra diálogo si los permisos son denegados

#### `_toggleFlashlight()`
- Alterna el estado del flash
- Actualiza el provider de estado

#### `_pickImageFromGallery()`
- Verifica permisos de galería
- Abre el selector de imágenes
- Analiza la imagen con `analyzeImage()`
- Muestra resultado o error

#### `_handleQrResult(String qrData)`
- Previene procesamiento múltiple
- Guarda el resultado en el provider
- Muestra diálogo con el contenido del QR

### Ciclo de Vida

```dart
@override
void didChangeAppLifecycleState(AppLifecycleState state) {
  switch (state) {
    case AppLifecycleState.resumed:
      _scannerController?.start();
      break;
    case AppLifecycleState.paused:
      _scannerController?.stop();
      break;
  }
}
```

## 📋 Flujo de Usuario

### Escaneo con Cámara:
1. Usuario abre la pantalla
2. Se solicitan permisos de cámara (si es necesario)
3. La cámara se activa automáticamente
4. Usuario coloca el QR dentro del marco
5. El scanner detecta automáticamente el código
6. Se muestra un diálogo con el contenido
7. Usuario puede "Escanear otro" o "Continuar"

### Escaneo desde Galería:
1. Usuario toca el botón "Galería"
2. Se solicitan permisos de galería (si es necesario)
3. Se abre el selector de imágenes
4. Usuario selecciona una imagen con QR
5. La imagen se analiza automáticamente
6. Se muestra el resultado o mensaje de error

### Control de Flash:
1. Usuario toca el botón "Flash"
2. Se alterna el estado del flash
3. El icono cambia visualmente (on/off)
4. El fondo del botón se activa/desactiva

## ⚠️ Manejo de Permisos

### Cámara
```dart
await _permissionsService.ensureCameraPermission()
```

- Si es denegado: muestra diálogo explicativo
- Si es permanentemente denegado: ofrece abrir configuración

### Galería
```dart
await _permissionsService.ensurePhotosPermission()
```

- Maneja permisos según versión de Android (API 33+)
- Muestra mensaje de error si es denegado

## 🎨 Animaciones

Todas las animaciones usan `animate_do`:

- **AppBar**: `FadeInDown` (500ms)
- **Marco de escaneo**: `FadeIn` (800ms)
- **Texto instructivo**: `FadeInUp` (800ms + 300ms delay)
- **Controles inferiores**: `FadeInUp` (800ms + 400ms delay)
- **Línea de escaneo**: `TweenAnimationBuilder` (2s loop)

## 📊 Diálogo de Resultado

### Características:
- Título con icono de QR
- Contenido seleccionable (para copiar)
- Formato monoespaciado para mejor legibilidad
- Fondo con color primario al 10%
- Dos acciones:
  - **Escanear otro**: Cierra el diálogo y permite escanear nuevamente
  - **Continuar**: Cierra la pantalla y retorna el resultado

## 🔄 Retorno de Datos

Cuando el usuario presiona "Continuar", la pantalla se cierra y retorna el contenido del QR:

```dart
context.pop(qrData);
```

La pantalla que llamó puede recibir este resultado:

```dart
final result = await context.push('/paga-con-qr');
if (result != null) {
  // Procesar el código QR escaneado
  print('QR escaneado: $result');
}
```

## 🛠️ Personalización

### Colores
- Marco de escaneo: `Tema.blanco.withValues(alpha: 0.5)`
- Esquinas: `Tema.primaryColor`
- Línea de escaneo: `Tema.primaryColor.withValues(alpha: 0.8)`
- Controles activos: `Tema.primaryColor`
- Controles inactivos: `Tema.primaryColor.withValues(alpha: 0.1)`

### Dimensiones
- Marco de escaneo: 280x280
- Esquinas decorativas: 40x40
- Grosor de esquinas: 5px
- Línea de escaneo: 260x3

## 📱 Compatibilidad

- ✅ Android (API 21+)
- ✅ iOS (11.0+)
- ✅ macOS
- ✅ Web (con ZXing)

## 🐛 Manejo de Errores

### Errores Comunes:

1. **Permisos denegados**
   - Muestra diálogo explicativo
   - Ofrece abrir configuración

2. **No se detecta QR en imagen**
   - Muestra SnackBar con mensaje claro
   - Permite intentar con otra imagen

3. **Error al procesar imagen**
   - Captura excepción
   - Muestra mensaje de error detallado

4. **Cámara no disponible**
   - Detectado en `_initializeScanner()`
   - Previene crashes con verificación de null

## 💡 Mejoras Futuras Sugeridas

1. **Vibración háptica** al detectar QR (descomentar HapticFeedback)
2. **Historial de QRs** escaneados
3. **Compartir contenido** del QR
4. **Validación de formato** de QR específico
5. **Zoom** para QRs pequeños
6. **Múltiples códigos** en una sola imagen
7. **Modo noche** ajustable
8. **Sonido de confirmación** al escanear

## 📝 Ejemplo de Uso

```dart
// En cualquier pantalla:
final qrContent = await context.push('/paga-con-qr');

if (qrContent != null) {
  // Procesar el contenido del QR
  if (qrContent.startsWith('http')) {
    // Es una URL
    await launchUrl(Uri.parse(qrContent));
  } else {
    // Procesar según formato esperado
    procesarPago(qrContent);
  }
}
```

## 🔗 Archivos Relacionados

- **Pantalla**: `lib/features/inicio/presentation/lectura_qr_scree.dart`
- **Permisos**: `lib/shared/services/permissions_service.dart`
- **Router**: `lib/core/router.dart`
- **Exports**: `lib/features/inicio/inicio_exports.dart`

---

**Desarrollado con ❤️ para una experiencia de escaneo fluida y moderna**
