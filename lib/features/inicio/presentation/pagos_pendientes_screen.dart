import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/app_exports.dart';
import '../../../shared/shared_exports.dart';

class PagosPendientesScreen extends ConsumerStatefulWidget {
  const PagosPendientesScreen({super.key});

  @override
  ConsumerState<PagosPendientesScreen> createState() =>
      _PagosPendientesScreenState();
}

class _PagosPendientesScreenState extends ConsumerState<PagosPendientesScreen> {
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
    ref.watch(inactivityProvider);
    final selectedIndex = ref.watch(navigationIndexProvider);
    final esperandoRespuesta = ref.watch(
      registrarProvider.select((state) => state.isLoading),
    );

    return InactivityListener(
      child: Scaffold(
        backgroundColor: Tema.blanco,
        bottomNavigationBar: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Tema.primaryColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: SizedBox(
                    height: ref.watch(navigationBarExpandedProvider) ? 70 : 0,
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        navigationBarTheme: NavigationBarThemeData(
                          iconTheme: WidgetStateProperty.all(
                            const IconThemeData(color: Tema.blanco),
                          ),
                          labelTextStyle: WidgetStateProperty.all(
                            const TextStyle(color: Tema.blanco, fontSize: 12),
                          ),
                        ),
                      ),
                      child: NavigationBar(
                        onDestinationSelected: (int index) {
                          if (esperandoRespuesta) {
                            return;
                          }
                          ref.read(navigationIndexProvider.notifier).state =
                              index;
                          ref
                                  .read(navigationBarExpandedProvider.notifier)
                                  .state =
                              false;
                          Navigator.of(context).pop();
                        },
                        height: 70,
                        backgroundColor: Tema.primaryColor,
                        indicatorColor: Tema.primaryColor,
                        selectedIndex: selectedIndex,
                        destinations: const <NavigationDestination>[
                          NavigationDestination(
                            icon: Icon(Icons.double_arrow),
                            selectedIcon: Icon(Icons.double_arrow_outlined),
                            label: 'Inicio',
                          ),
                          NavigationDestination(
                            icon: Icon(Icons.compare_arrows),
                            selectedIcon: Icon(Icons.compare_arrows_outlined),
                            label: 'Operaciones',
                          ),
                          NavigationDestination(
                            icon: Icon(Icons.shopping_cart),
                            selectedIcon: Icon(Icons.shopping_cart_outlined),
                            label: 'Para ti',
                          ),
                          NavigationDestination(
                            icon: Icon(Icons.menu),
                            selectedIcon: Icon(Icons.menu_open_outlined),
                            label: 'Más',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Botón circular flotante en el centro
            Positioned(
              top: -20,
              child: GestureDetector(
                onTap: () {
                  ref.read(navigationBarExpandedProvider.notifier).state = !ref
                      .read(navigationBarExpandedProvider);
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Tema.primaryColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    ref.watch(navigationBarExpandedProvider)
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up,
                    color: Tema.blanco,
                    size: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              _buildCustomAppBar(context),
              _buildCustomPendientes(context),
              Expanded(child: _buildMovimientosList(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                'Pagos pendientes',
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

  Widget _buildCustomPendientes(BuildContext context) {
    return FadeInUp(
      duration: Constantes.standardAnimation,
      delay: const Duration(milliseconds: 300),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(color: Tema.blanco),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Comercio',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Tema.negro,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Pagar servicio',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium!.copyWith(color: Tema.negro),
                  ),
                  Text(
                    'Titular: Lilly Ann Mateos Chavez',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Tema.negro.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovimientosList(BuildContext context2) {
    return FadeInUp(
      duration: Constantes.standardAnimation,
      delay: const Duration(milliseconds: 300),
      child: Column(
        children: [
          _buildSaldoSection(),
          const SizedBox(height: Constantes.alturaFormulario),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildTransactionCard(),
                const SizedBox(height: 12),
                _buildTransactionCard(),
                const SizedBox(height: 12),
                _buildTransactionCard(),
              ],
            ),
          ),
          // Action buttons
          FadeInUp(
            duration: Constantes.standardAnimation,
            delay: const Duration(milliseconds: 300),
            child: _buildActionButtons(),
          ),
          FadeInUp(
            duration: Constantes.standardAnimation,
            delay: const Duration(milliseconds: 300),
            child: Image.asset(
              'assets/iconos/yata_reco.png',
              width: 80,
              height: 80,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaldoSection() {
    return FadeInUp(
      duration: Constantes.standardAnimation,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Tema.blanco,
          borderRadius: BorderRadius.circular(10),
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

  Widget _buildTransactionCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Comercio',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Tema.negro,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '01 mar. 2026',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Tema.negro.withValues(alpha: 0.7),
                  ),
                ),
                Text(
                  'Nº OR99384',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Tema.negro.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                's/ 2.00',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Tema.negro,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF00BCD4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Pendiente',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Tema.blanco,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // Action for Paga con Yata
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Tema.primaryColor,
                foregroundColor: Tema.blanco,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Paga con Yata',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Tema.blanco,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // Action for Paga con Yata
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Tema.negro,
                foregroundColor: Tema.blanco,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Regresar',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Tema.blanco,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
