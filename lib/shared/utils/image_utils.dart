import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

Future<XFile> comprimirArchivo(
  XFile file, {
  TipoImagen tipo = TipoImagen.perfil,
}) async {
  final directory = await getApplicationDocumentsDirectory();
  final targetDir = Directory('${directory.path}/imagenes_yatas');
  if (!await targetDir.exists()) {
    await targetDir.create(recursive: true);
  }

  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final fileName = 'img_$timestamp.jpg';
  final outPath = '${targetDir.path}/$fileName';

  final config = _getConfig(tipo);

  var result = await FlutterImageCompress.compressAndGetFile(
    file.path,
    outPath,
    format: CompressFormat.jpeg,
    quality: config.quality,
    minWidth: config.maxWidth,
    minHeight: config.maxHeight,
  );

  if (result != null) {
    final size = await result.length();

    if (size > config.maxBytes) {
      final tempPath = result.path;
      final outPath2 = '${targetDir.path}/img_${timestamp}_v2.jpg';

      result = await FlutterImageCompress.compressAndGetFile(
        tempPath,
        outPath2,
        format: CompressFormat.jpeg,
        quality: config.quality - 20, // baja 20 puntos en segunda pasada
        minWidth: config.maxWidth,
        minHeight: config.maxHeight,
      );

      try {
        await File(tempPath).delete();
      } catch (_) {}
    }

    try {
      if (!file.path.contains('imagenes_yatas')) {
        await File(file.path).delete();
      }
    } catch (_) {}
  }

  return result!;
}

_ImageConfig _getConfig(TipoImagen tipo) {
  switch (tipo) {
    case TipoImagen.perfil:
      return _ImageConfig(
        quality: 80,
        maxWidth: 400,
        maxHeight: 400,
        maxBytes: 200 * 1024,
      );
    case TipoImagen.documento:
      return _ImageConfig(
        quality: 85,
        maxWidth: 1000,
        maxHeight: 1000,
        maxBytes: 500 * 1024,
      );
    case TipoImagen.facial:
      return _ImageConfig(
        quality: 80,
        maxWidth: 600,
        maxHeight: 600,
        maxBytes: 300 * 1024,
      );
  }
}

enum TipoImagen { perfil, documento, facial }

class _ImageConfig {
  final int quality;
  final int maxWidth;
  final int maxHeight;
  final int maxBytes;
  _ImageConfig({
    required this.quality,
    required this.maxWidth,
    required this.maxHeight,
    required this.maxBytes,
  });
}
