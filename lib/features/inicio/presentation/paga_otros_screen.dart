import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/app_exports.dart';
import '../../../shared/shared_exports.dart';

class PagaOtrosScreen extends ConsumerStatefulWidget {
  const PagaOtrosScreen({super.key});

  @override
  ConsumerState<PagaOtrosScreen> createState() => _PagaOtrosScreenState();
}

class _PagaOtrosScreenState extends ConsumerState<PagaOtrosScreen> {
  @override
  Widget build(BuildContext context) {
    ref.watch(inactivityProvider);

    return InactivityListener(
      child: Scaffold(
        backgroundColor: Tema.blanco,
        body: SafeArea(
          child: Column(
            children: [_buildCustomAppBar(context), _buildContent(context)],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            _buildMetodoPagoCard(
              context,
              title: 'Billetera Electrónica / QR',
              icon: Icons.qr_code_2_rounded,
              iconColor: Tema.primaryColor,
              isExpanded: ref.watch(billeteraExpandedProvider),
              onTap: () {
                ref.read(billeteraExpandedProvider.notifier).state = !ref.watch(
                  billeteraExpandedProvider,
                );
              },
              children: [
                _buildMetodoOpcion('YAPE', 'assets/iconos/yape.png'),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFE8E8E8),
                ),
                _buildMetodoOpcion('PLIN', 'assets/iconos/plin.png'),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFE8E8E8),
                ),
                _buildMetodoOpcion(
                  'Otros',
                  null,
                  iconData: Icons.qr_code_2_rounded,
                  iconColor: Tema.primaryColor,
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildMetodoPagoCard(
              context,
              title: 'Depósito / Transferencia',
              icon: Icons.account_balance,
              iconColor: Tema.primaryColor,
              isExpanded: false,
              onTap: () {
                context.go(
                  '/pago-exitoso',
                  extra: {'metodoPago': 'Depósito / Transferencia'},
                );
              },
            ),
            const SizedBox(height: 12),
            _buildMetodoPagoCard(
              context,
              title: 'Efectivo',
              icon: Icons.attach_money_rounded,
              iconColor: Tema.primaryColor,
              isExpanded: false,
              onTap: () {
                context.go('/pago-exitoso', extra: {'metodoPago': 'Efectivo'});
              },
            ),
            const SizedBox(height: 12),
            _buildMetodoPagoCard(
              context,
              title: 'Tarjeta de Crédito /\nDébito',
              icon: Icons.credit_card,
              iconColor: Tema.primaryColor,
              isExpanded: false,
              onTap: () {
                context.go(
                  '/pago-exitoso',
                  extra: {'metodoPago': 'Tarjeta de Crédito / Débito'},
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: const BoxDecoration(
        color: Tema.primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => {
              ref.read(navigationBarExpandedProvider.notifier).state = false,
              Navigator.of(context).pop(),
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Tema.blanco,
              size: 20,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Selecciona método de pago',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge!.copyWith(color: Tema.blanco),
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert, color: Tema.blanco, size: 24),
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildMetodoPagoCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color iconColor,
    required bool isExpanded,
    required VoidCallback onTap,
    List<Widget>? children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Tema.blanco,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1.5),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: iconColor, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Color(0xFF2D2D2D),
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: Tema.primaryColor,
                    size: 28,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded && children != null) ...children,
        ],
      ),
    );
  }

  Widget _buildMetodoOpcion(
    String label,
    String? assetPath, {
    IconData? iconData,
    Color? iconColor,
  }) {
    return InkWell(
      onTap: () {
        String metodoPago = label;
        if (label == 'Otros') {
          metodoPago = 'Billetera Electrónica / QR - Otros';
        }
        context.go('/pago-exitoso', extra: {'metodoPago': metodoPago});
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            if (assetPath != null) ...[
              Expanded(
                child: Center(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Color(0xFF2D2D2D),
                    ),
                  ),
                ),
              ),

              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  assetPath,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey[400],
                      ),
                    );
                  },
                ),
              ),
            ] else if (iconData != null) ...[
              Expanded(
                child: Center(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Color(0xFF2D2D2D),
                    ),
                  ),
                ),
              ),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: (iconColor ?? Tema.primaryColor).withValues(
                    alpha: 0.1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  iconData,
                  color: iconColor ?? Tema.primaryColor,
                  size: 28,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
