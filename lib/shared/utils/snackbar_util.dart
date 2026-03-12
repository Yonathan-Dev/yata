import 'package:flutter/material.dart';

import '../../core/app_exports.dart';

class SnackbarUtil {
  /// Snackbar Error
  static void snackbarError(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: _buildSnackbarContent(
          context: context,
          icon: Icons.error_outline_rounded,
          title: title ?? 'Error',
          message: message,
          iconColor: Tema.blanco,
          textColor: Tema.blanco,
        ),
        backgroundColor: Tema.rojo,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constantes.borderRadius),
        ),
        margin: const EdgeInsets.all(Constantes.padding),
        duration: duration,
        dismissDirection: DismissDirection.horizontal,
      ),
    );
  }

  /// Snackbar Éxito
  static void snackbarSuccess(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: _buildSnackbarContent(
          context: context,
          icon: Icons.check_circle_outline,
          title: title ?? 'Éxito',
          message: message,
          iconColor: Tema.blanco,
          textColor: Tema.blanco,
        ),
        backgroundColor: Tema.verde,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constantes.borderRadius),
        ),
        margin: const EdgeInsets.all(Constantes.padding),
        duration: duration,
        dismissDirection: DismissDirection.horizontal,
      ),
    );
  }

  /// Snackbar Notificación
  static void snackbarNotification(
    BuildContext context, {
    String? title,
    String? message,
    Duration duration = const Duration(seconds: 5),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: _buildSnackbarContent(
          context: context,
          icon: Icons.notifications_active_outlined,
          title: title ?? 'Notificación',
          message: message ?? '',
          iconColor: Tema.blanco,
          textColor: Tema.blanco,
        ),
        backgroundColor: Tema.naranja,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constantes.borderRadius),
        ),
        margin: EdgeInsets.only(
          left: Constantes.padding,
          right: Constantes.padding,
          top: Constantes.padding,
          bottom: MediaQuery.of(context).size.height - 200,
        ),
        duration: duration,
      ),
    );
  }

  /// Snackbar Advertencia
  static void snackbarWarning(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 4),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: _buildSnackbarContent(
          context: context,
          icon: Icons.warning_amber_rounded,
          title: title ?? 'Advertencia',
          message: message,
          iconColor: Tema.negro,
          textColor: Tema.negro,
        ),
        backgroundColor: Tema.amarillo,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constantes.borderRadius),
        ),
        margin: const EdgeInsets.all(Constantes.padding),
        duration: duration,
        dismissDirection: DismissDirection.horizontal,
      ),
    );
  }

  /// Snackbar Información
  static void snackbarInfo(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: _buildSnackbarContent(
          context: context,
          icon: Icons.info_outline_rounded,
          title: title ?? 'Información',
          message: message,
          iconColor: Tema.blanco,
          textColor: Tema.blanco,
        ),
        backgroundColor: Tema.azul,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constantes.borderRadius),
        ),
        margin: const EdgeInsets.all(Constantes.padding),
        duration: duration,
        dismissDirection: DismissDirection.horizontal,
      ),
    );
  }

  static void snackbarNotificationPush(
    BuildContext context, {
    String? title,
    String? message,
    Duration duration = const Duration(seconds: 5),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: _buildSnackbarContent(
          context: context,
          icon: Icons.notifications_active_outlined,
          title: title ?? 'Notificación',
          message: message ?? '',
          iconColor: Tema.blanco,
          textColor: Tema.blanco,
        ),
        backgroundColor: Tema.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constantes.borderRadius),
          side: BorderSide(color: Tema.blanco.withValues(alpha: 0.5), width: 1),
        ),

        margin: EdgeInsets.only(
          left: Constantes.padding,
          right: Constantes.padding,
          bottom: Constantes.padding,
        ),
        duration: duration,
      ),
    );
  }

  /// Snackbar Builder
  static Widget _buildSnackbarContent({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String message,
    required Color iconColor,
    required Color textColor,
  }) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 30),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                message,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: textColor),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
