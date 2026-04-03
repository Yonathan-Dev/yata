import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app_exports.dart';

class AppBarWidget extends ConsumerWidget {
  final String title;
  const AppBarWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Tema.primaryColor,
      child: Row(
        children: [
          // Menú hamburguesa
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu, color: Tema.blanco, size: 28),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 12),
          // Título
          Expanded(
            child: Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge!.copyWith(color: Tema.blanco),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none,
              color: Tema.blanco,
              size: 30,
            ),
            constraints: const BoxConstraints(),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings, color: Tema.blanco, size: 30),
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
