import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

Future<XFile> comprimirArchivo(XFile file) async {
  final directory = await getApplicationDocumentsDirectory();
  final targetDir = Directory('${directory.path}/imagenes_yatas');
  if (!await targetDir.exists()) {
    await targetDir.create(recursive: true);
  }

  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final fileName = 'img_$timestamp.jpg';
  String outPath = '${targetDir.path}/$fileName';

  CompressFormat format = CompressFormat.jpeg;

  var result = await FlutterImageCompress.compressAndGetFile(
    file.path,
    outPath,
    format: format,
    quality: 70,
  );

  if (result != null) {
    final firstCompressionSize = await result.length();

    // Si sigue siendo muy grande, comprime más
    if (firstCompressionSize > 500 * 1024) {
      final tempPath = result.path;
      final outPath2 = '${targetDir.path}/img_${timestamp}_v2.jpg';

      result = await FlutterImageCompress.compressAndGetFile(
        tempPath,
        outPath2,
        format: format,
        quality: 50,
      );

      if (result != null) {
        // Eliminar primera versión
        try {
          await File(tempPath).delete();
        } catch (e) {
          debugPrint('No se pudo eliminar archivo temporal: $e');
        }
      }
    }

    try {
      if (!file.path.contains('imagenes_comprimidas')) {
        await File(file.path).delete();
      }
    } catch (e) {
      debugPrint('No se pudo eliminar archivo original: $e');
    }
  }

  return result!;
}
