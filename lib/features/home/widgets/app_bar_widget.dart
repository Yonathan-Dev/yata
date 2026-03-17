import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app_exports.dart';

class AppBarWidget extends ConsumerWidget {
  const AppBarWidget({super.key});

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
              'Payment Latam Wallet',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Tema.blanco,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Tema.blanco,
              shape: BoxShape.circle,
              border: Border.all(color: Tema.primaryColor, width: 2),
            ),
            child: ClipOval(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Image.asset(
                  'assets/iconos/icono.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
