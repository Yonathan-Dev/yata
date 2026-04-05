import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../core/app_exports.dart';
import '../../../shared/shared_exports.dart';

class LecturaQrScreen extends ConsumerStatefulWidget {
  const LecturaQrScreen({super.key});

  @override
  ConsumerState<LecturaQrScreen> createState() => _LecturaQrScreenState();
}

class _LecturaQrScreenState extends ConsumerState<LecturaQrScreen>
    with WidgetsBindingObserver {
  MobileScannerController? _scannerController;
  final ImagePicker _imagePicker = ImagePicker();
  final PermissionsService _permissionsService = PermissionsService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeScanner();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scannerController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_scannerController == null) return;

    switch (state) {
      case AppLifecycleState.resumed:
        _scannerController?.start();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        _scannerController?.stop();
        break;
    }
  }

  Future<void> _initializeScanner() async {
    final hasPermission = await _permissionsService.ensureCameraPermission();
    if (!hasPermission) {
      if (mounted) {
        _showPermissionDeniedDialog();
      }
      return;
    }

    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      torchEnabled: false,
    );

    if (mounted) {
      setState(() {});
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permiso de cámara requerido'),
        content: const Text(
          'Para escanear códigos QR, necesitamos acceso a la cámara. '
          'Por favor, habilita el permiso en la configuración de la aplicación.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.pop();
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _permissionsService.requestCameraPermission();
            },
            child: const Text('Abrir configuración'),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleFlashlight() async {
    if (_scannerController == null) return;

    final currentState = ref.read(flashlightProvider);
    await _scannerController!.toggleTorch();
    ref.read(flashlightProvider.notifier).state = !currentState;
  }

  Future<void> _pickImageFromGallery() async {
    try {
      // En Android 13+ y iOS, ImagePicker maneja los permisos automáticamente
      // Solo verificamos permisos en Android < 13
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );

      if (image == null) return;

      if (_scannerController != null) {
        final barcodes = await _scannerController!.analyzeImage(image.path);

        if (barcodes != null && barcodes.barcodes.isNotEmpty) {
          final qrData = barcodes.barcodes.first.rawValue;
          if (qrData != null && qrData.isNotEmpty) {
            _handleQrResult(qrData);
          } else {
            if (mounted) {
              SnackbarUtil.snackbarError(
                context,
                message: 'No se encontró un código QR válido en la imagen',
              );
            }
          }
        } else {
          if (mounted) {
            SnackbarUtil.snackbarError(
              context,
              message: 'No se detectó ningún código QR en la imagen',
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        SnackbarUtil.snackbarError(
          context,
          message: 'Error al procesar la imagen: ${e.toString()}',
        );
      }
    }
  }

  void _handleQrResult(String qrData) async {
    final isProcessing = ref.read(isProcessingProvider);
    if (isProcessing) return;

    ref.read(isProcessingProvider.notifier).state = true;

    // Guardar resultado en el provider
    ref.read(qrResultProvider.notifier).state = qrData;

    // Navegar a la pantalla de resultado
    context.go('/resultado-qr', extra: qrData);

    // Resetear el estado de procesamiento
    ref.read(isProcessingProvider.notifier).state = false;
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(inactivityProvider);
    final isFlashlightOn = ref.watch(flashlightProvider);

    return InactivityListener(
      child: Scaffold(
        backgroundColor: Tema.blanco,
        body: Stack(
          children: [
            // Scanner de cámara
            if (_scannerController != null)
              MobileScanner(
                controller: _scannerController,
                onDetect: (capture) {
                  final List<Barcode> barcodes = capture.barcodes;
                  if (barcodes.isNotEmpty) {
                    final qrData = barcodes.first.rawValue;
                    if (qrData != null && qrData.isNotEmpty) {
                      _handleQrResult(qrData);
                    }
                  }
                },
              )
            else
              const Center(
                child: CircularProgressIndicator(color: Tema.blanco),
              ),
            _buildScannerOverlay(),
            _buildCustomAppBar(context),
            _buildBottomControls(context, isFlashlightOn),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomAppBar(BuildContext context) {
    return SafeArea(
      child: FadeInDown(
        duration: const Duration(milliseconds: 500),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Botón de regresar
              Container(
                decoration: BoxDecoration(
                  color: Tema.blanco.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Tema.primaryColor,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Título
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Tema.blanco.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    'Escanear código QR',
                    style: TextStyle(
                      color: Tema.primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScannerOverlay() {
    return Center(
      child: FadeIn(
        duration: const Duration(milliseconds: 800),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Tema.blanco.withValues(alpha: 0.5),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            SizedBox(
              width: 300,
              height: 300,
              child: Stack(
                children: [
                  // Esquina superior izquierda
                  Positioned(top: 0, left: 0, child: _buildCorner(true, true)),
                  // Esquina superior derecha
                  Positioned(
                    top: 0,
                    right: 0,
                    child: _buildCorner(true, false),
                  ),
                  // Esquina inferior izquierda
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: _buildCorner(false, true),
                  ),
                  // Esquina inferior derecha
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: _buildCorner(false, false),
                  ),
                ],
              ),
            ),
            // Línea de escaneo animada
            Positioned(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: -140.0, end: 140.0),
                duration: const Duration(seconds: 2),
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(0, value),
                    child: Container(
                      width: 260,
                      height: 3,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Tema.primaryColor.withValues(alpha: 0.8),
                            Colors.transparent,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Tema.primaryColor.withValues(alpha: 0.5),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  );
                },
                onEnd: () {
                  ref.read(isProcessingProvider.notifier).state = false;
                },
              ),
            ),
            Positioned(
              bottom: -80,
              child: FadeInUp(
                duration: const Duration(milliseconds: 800),
                delay: const Duration(milliseconds: 300),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Tema.negro.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    'Coloca el QR dentro del marco',
                    style: TextStyle(
                      color: Tema.blanco,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCorner(bool isTop, bool isLeft) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        border: Border(
          top: isTop
              ? const BorderSide(color: Tema.primaryColor, width: 5)
              : BorderSide.none,
          bottom: !isTop
              ? const BorderSide(color: Tema.primaryColor, width: 5)
              : BorderSide.none,
          left: isLeft
              ? const BorderSide(color: Tema.primaryColor, width: 5)
              : BorderSide.none,
          right: !isLeft
              ? const BorderSide(color: Tema.primaryColor, width: 5)
              : BorderSide.none,
        ),
        borderRadius: BorderRadius.only(
          topLeft: isTop && isLeft ? const Radius.circular(20) : Radius.zero,
          topRight: isTop && !isLeft ? const Radius.circular(20) : Radius.zero,
          bottomLeft: !isTop && isLeft
              ? const Radius.circular(20)
              : Radius.zero,
          bottomRight: !isTop && !isLeft
              ? const Radius.circular(20)
              : Radius.zero,
        ),
      ),
    );
  }

  Widget _buildBottomControls(BuildContext context, bool isFlashlightOn) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: FadeInUp(
          duration: const Duration(milliseconds: 800),
          delay: const Duration(milliseconds: 400),
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: Tema.blanco,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Tema.negro.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildControlButton(
                  icon: isFlashlightOn ? Icons.flash_on : Icons.flash_off,
                  label: 'Flash',
                  onTap: _toggleFlashlight,
                  isActive: isFlashlightOn,
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Tema.negro.withValues(alpha: 0.1),
                ),
                _buildControlButton(
                  icon: Icons.photo_library_rounded,
                  label: 'Galería',
                  onTap: _pickImageFromGallery,
                  isActive: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isActive,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isActive
                      ? Tema.primaryColor
                      : Tema.primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: isActive ? Tema.blanco : Tema.primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isActive ? Tema.primaryColor : Tema.negro,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
