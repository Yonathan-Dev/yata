import 'package:flutter/material.dart';

import '../../../core/app_exports.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key, required this.titulo, required this.icono});

  final String titulo;
  final IconData icono;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(7),
      color: Tema.primaryColor.withValues(
        alpha: Constantes.transparenciaPrimaria,
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icono,
                        color: isDarkMode ? Tema.blanco : Tema.negro,
                        size: 24,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        titulo,
                        style: Theme.of(context).textTheme.titleMedium!
                            .copyWith(
                              color: isDarkMode ? Tema.blanco : Tema.negro,
                              fontSize: 18,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
