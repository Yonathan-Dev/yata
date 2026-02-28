import 'dart:developer';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class PermissionsService {
  // Verificar permisos de cámara
  Future<bool> checkCameraPermission() async {
    try {
      final status = await Permission.camera.status;
      return status == PermissionStatus.granted;
    } catch (e) {
      log('Error al verificar estado de permisos de cámara: $e');
      return false;
    }
  }

  // Solicitar permisos de cámara
  Future<bool> requestCameraPermission() async {
    try {
      log('Solicitando permisos de cámara...');
      final status = await Permission.camera.request();
      switch (status) {
        case PermissionStatus.granted:
          log('Permisos de cámara concedidos');
          return true;
        case PermissionStatus.denied:
          log('Permisos de cámara denegados');
          return false;
        case PermissionStatus.permanentlyDenied:
          log(
            'Permisos de cámara denegados permanentemente - abriendo configuración',
          );
          await openAppSettings();
          return false;
        default:
          return false;
      }
    } catch (e) {
      log('Error al solicitar permisos de cámara: $e');
      return false;
    }
  }

  // Verificar y solicitar permisos si es necesario
  Future<bool> ensureCameraPermission() async {
    try {
      bool hasPermission = await checkCameraPermission();

      if (!hasPermission) {
        hasPermission = await requestCameraPermission();
      }

      return hasPermission;
    } catch (e) {
      log('Error al asegurar permisos de cámara: $e');
      return false;
    }
  }

  // Verificar permisos de fotos/galería según la versión de Android
  Future<bool> checkPhotosPermission() async {
    try {
      // En iOS siempre usa Permission.photos
      if (Platform.isIOS) {
        final status = await Permission.photos.status;
        return status == PermissionStatus.granted;
      }

      // En Android, depende de la versión del SDK
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        final sdkInt = androidInfo.version.sdkInt;

        // Android 13+ (API 33+) usa permisos granulares
        if (sdkInt >= 33) {
          final status = await Permission.photos.status;
          return status == PermissionStatus.granted;
        } else {
          // Android 12 y anteriores usa storage
          final status = await Permission.storage.status;
          return status == PermissionStatus.granted;
        }
      }

      return false;
    } catch (e) {
      log('Error al verificar estado de permisos de fotos: $e');
      return false;
    }
  }

  // Solicitar permisos de fotos/galería según la versión de Android
  Future<bool> requestPhotosPermission() async {
    try {
      log('Solicitando permisos de galería...');

      // En iOS siempre usa Permission.photos
      if (Platform.isIOS) {
        final status = await Permission.photos.request();
        return _handlePermissionStatus(status, 'fotos iOS');
      }

      // En Android, depende de la versión del SDK
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        final sdkInt = androidInfo.version.sdkInt;

        // Android 13+ (API 33+) usa permisos granulares
        if (sdkInt >= 33) {
          final status = await Permission.photos.request();
          return _handlePermissionStatus(status, 'photos Android 13+');
        } else {
          // Android 12 y anteriores usa storage
          final status = await Permission.storage.request();
          return _handlePermissionStatus(status, 'storage Android <13');
        }
      }

      return false;
    } catch (e) {
      log('Error al solicitar permisos de galería: $e');
      return false;
    }
  }

  // Manejar el estado de permisos de manera unificada
  bool _handlePermissionStatus(PermissionStatus status, String permissionName) {
    switch (status) {
      case PermissionStatus.granted:
      case PermissionStatus.limited: // iOS puede dar acceso limitado
        log('Permisos de $permissionName concedidos');
        return true;
      case PermissionStatus.denied:
        log('Permisos de $permissionName denegados');
        return false;
      case PermissionStatus.permanentlyDenied:
        log('Permisos de $permissionName denegados permanentemente');
        return false;
      default:
        return false;
    }
  }

  // Verificar y solicitar permisos de fotos si es necesario
  Future<bool> ensurePhotosPermission() async {
    try {
      bool hasPermission = await checkPhotosPermission();

      if (!hasPermission) {
        hasPermission = await requestPhotosPermission();
      }

      return hasPermission;
    } catch (e) {
      log('Error al asegurar permisos de fotos: $e');
      return false;
    }
  }

  // Abrir configuración de la app
  Future<void> openSettings() async {
    try {
      await openAppSettings();
    } catch (e) {
      log('Error al abrir configuración: $e');
    }
  }
}
