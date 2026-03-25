import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/app_exports.dart';
import '../../../shared/shared_exports.dart';

class InicioScreen extends ConsumerStatefulWidget {
  const InicioScreen({super.key});

  @override
  ConsumerState<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends ConsumerState<InicioScreen> {
  @override
  void initState() {
    super.initState();
    _handleConsultarSaldo();
  }

  Future<void> _handleConsultarSaldo() async {
    try {
      final response = await ref.read(consultarSaldoProvider.future);
      if (response?.success ?? false) {
        ref.read(inicioProvider.notifier).setSaldo(response?.saldo ?? 0.00);
        ref
            .read(inicioProvider.notifier)
            .setSaldoReservado(response?.saldoReservado ?? 0.00);
        ref
            .read(inicioProvider.notifier)
            .setSaldoDisponible(response?.saldoDisponible ?? 0.00);
        ref.read(inicioProvider.notifier).setSuccess(true);
      } else {
        if (!mounted) return;
        SnackbarUtil.snackbarError(
          context,
          message: 'Error al consultar el saldo',
        );
      }
    } catch (error) {
      if (!mounted) return;
      SnackbarUtil.snackbarError(
        context,
        message: 'Error al consultar el saldo',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Tema.blanco,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildSaludo(context),
                    const SizedBox(height: 20),
                    _buildSaldoCard(context),
                    const SizedBox(height: 24),
                    _buildPreguntaAcciones(context),
                    const SizedBox(height: 16),
                    _buildAccionesGrid(context),
                    const SizedBox(height: 24),
                    _buildMovimientosCard(context),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          // Bottom Navigation
        ],
      ),
    );
  }

  Widget _buildSaludo(BuildContext context) {
    return FadeInLeft(
      duration: Constantes.standardAnimation,
      child: Row(
        children: [
          Icon(Icons.person_outline, color: Tema.negro, size: 24),
          const SizedBox(width: 8),
          Text(
            '¡Hola, ${ref.watch(authProvider).user?.apellidosyNombres.split(',').last.trim()}!',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Tema.negro,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_outlined, color: Tema.negro),
          ),
        ],
      ),
    );
  }

  Widget _buildSaldoCard(BuildContext context) {
    return FadeInUp(
      duration: Constantes.standardAnimation,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Tema.blanco,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Tema.primaryColor),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                ref.read(mostrarSaldo.notifier).state = !ref
                    .read(mostrarSaldo.notifier)
                    .state;
              },
              child: Row(
                children: [
                  Icon(
                    ref.watch(mostrarSaldo)
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Tema.negro,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Mostrar saldo',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge!.copyWith(color: Tema.negro),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Text(
              ref.watch(mostrarSaldo)
                  ? '${ref.watch(inicioProvider).saldo.toStringAsFixed(2)} PEN'
                  : '••••• PEN',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Tema.negro,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreguntaAcciones(BuildContext context) {
    return Text(
      '¿Que te gustaría hacer?',
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
        color: Tema.negro,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildAccionesGrid(BuildContext context) {
    final acciones = [
      {
        'icono': Icons.account_balance_wallet_outlined,
        'texto': 'Recargar\nsaldo',
      },
      {'icono': Icons.output_outlined, 'texto': 'Retirar\nsaldo'},
      {'icono': Icons.qr_code_scanner, 'texto': 'Paga con\nQR'},
      {'icono': Icons.attach_money, 'texto': 'Cobrar'},
      {'icono': Icons.store_outlined, 'texto': 'Tienda'},
      {'icono': Icons.receipt_long_outlined, 'texto': 'Referencias'},
      {'icono': Icons.swap_horiz, 'texto': 'Transferir'},
      {'icono': Icons.monetization_on_outlined, 'texto': 'Cobrar'},
    ];

    return FadeInUp(
      duration: Constantes.standardAnimation,
      delay: const Duration(milliseconds: 100),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 0.85,
          crossAxisSpacing: 8,
          mainAxisSpacing: 16,
        ),
        itemCount: acciones.length,
        itemBuilder: (context, index) {
          final accion = acciones[index];
          return _buildAccionItem(
            context,
            icono: accion['icono'] as IconData,
            texto: accion['texto'] as String,
          );
        },
      ),
    );
  }

  Widget _buildAccionItem(
    BuildContext context, {
    required IconData icono,
    required String texto,
  }) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Tema.negro,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Tema.negro, width: 1.2),
            ),
            child: Icon(icono, color: Tema.blanco, size: 22),
          ),
          const SizedBox(height: 4),
          Text(
            texto,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Tema.negro,
              fontSize: 12,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovimientosCard(BuildContext context) {
    return FadeInUp(
      duration: Constantes.standardAnimation,
      delay: const Duration(milliseconds: 200),
      child: Container(
        decoration: BoxDecoration(
          color: Tema.blanco,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Tema.primaryColor.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            // Header
            GestureDetector(
              onTap: () {
                ref.read(mostrarMovimientos.notifier).state = !ref
                    .read(mostrarMovimientos.notifier)
                    .state;
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.receipt_outlined, color: Tema.negro, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Mostrar movimientos',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Tema.negro,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      ref.watch(mostrarMovimientos)
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Tema.negro,
                    ),
                  ],
                ),
              ),
            ),
            // Lista de movimientos
            if (ref.watch(mostrarMovimientos)) ...[
              const Divider(height: 1),
              _buildMovimientoItem('Rosa Mendez', '10.00'),
              _buildMovimientoItem('Rosa Mendez', '10.00'),
              _buildMovimientoItem('Rosa Mendez', '10.00'),
              _buildMovimientoItem('Rosa Mendez', '10.00'),
              _buildMovimientoItem('Rosa Mendez', '10.00'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMovimientoItem(String nombre, String monto) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              nombre,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(color: Tema.negro),
            ),
          ),
          Text(
            monto,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Tema.negro,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
