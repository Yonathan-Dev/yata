import 'package:flutter/material.dart';

class DialogUtils {
  static Future<bool?> mostrarDialogConfirmacion(
    BuildContext context, {
    required String titulo,
    required String mensaje,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    String textoConfirmar = 'Confirmar',
    String textoCancelar = 'Cancelar',
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(mensaje),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                if (onCancel != null) {
                  onCancel();
                }
              },
              child: Text(textoCancelar),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
                onConfirm();
              },
              child: Text(textoConfirmar),
            ),
          ],
        );
      },
    );
  }
}
