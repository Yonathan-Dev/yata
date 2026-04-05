import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/app_exports.dart';
import '../../../shared/shared_exports.dart';

class TransferenciasScreen extends ConsumerStatefulWidget {
  const TransferenciasScreen({super.key});

  @override
  ConsumerState<TransferenciasScreen> createState() =>
      _TransferenciasScreenState();
}

class _TransferenciasScreenState extends ConsumerState<TransferenciasScreen> {
  @override
  void initState() {
    super.initState();
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
        bottomNavigationBar: SafeArea(
          top: false,
          child: Stack(
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
                                    .read(
                                      navigationBarExpandedProvider.notifier,
                                    )
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
                    ref.read(navigationBarExpandedProvider.notifier).state =
                        !ref.read(navigationBarExpandedProvider);
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
        ),
        body: SafeArea(
          child: Column(
            children: [
              _buildCustomAppBar(context),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: _buildFormulario(context),
                ),
              ),
              const SizedBox(height: Constantes.separacionFormulario),
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
            onPressed: () {
              ref.read(navigationBarExpandedProvider.notifier).state = false;
              context.go('/home');
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
                'Transferencias',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge!.copyWith(color: Tema.blanco),
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_outlined,
              color: Tema.blanco,
              size: 24,
            ),
            constraints: const BoxConstraints(),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings, color: Tema.blanco, size: 24),
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildFormulario(BuildContext context) {
    return FadeInUp(
      duration: Constantes.standardAnimation,
      delay: const Duration(milliseconds: 300),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  if (!ref.watch(mostrarFormularioProvider)) ...[
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ref.read(mostrarFormularioProvider.notifier).state =
                              true;
                        },
                        icon: const Icon(Icons.add_circle_outline),
                        label: const Text(
                          'Agregar cuenta para futuros retiros',
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Tema.primaryColor,
                          side: BorderSide(
                            color: Tema.primaryColor.withValues(alpha: 0.5),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.wallet, size: 20, color: Colors.grey[700]),
                        const SizedBox(width: 8),
                        const Text(
                          'Mostrar a retirar*',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'S/. 0.00',
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Icon(Icons.pin, size: 20, color: Colors.grey[700]),
                        const SizedBox(width: 8),
                        const Text(
                          'Número de cuenta*',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Ingresa tu número',
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Banco
                    Row(
                      children: [
                        Icon(
                          Icons.account_balance,
                          size: 20,
                          color: Colors.grey[700],
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Selecciona tu banco*',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        hintText: 'Elige un banco',
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: const [],
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 16),

                    // Tipo de cuenta
                    Row(
                      children: [
                        Icon(
                          Icons.account_balance_wallet,
                          size: 20,
                          color: Colors.grey[700],
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Tipo de cuenta*',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        hintText: 'Elige tipo de cuenta',
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: const [],
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 16),

                    // CCI
                    Row(
                      children: [
                        Icon(
                          Icons.shield_outlined,
                          size: 20,
                          color: Colors.grey[700],
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'CCI*',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Código Interbancario',
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                  if (ref.watch(mostrarFormularioProvider)) ...[
                    Row(
                      children: [
                        Icon(Icons.wallet, size: 20, color: Colors.grey[700]),
                        const SizedBox(width: 8),
                        const Text(
                          'Alias de la cuenta*',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Ej: Mi cuenta personal',
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(
                          Icons.account_balance,
                          size: 20,
                          color: Colors.grey[700],
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Banco*',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        hintText: 'Elige un banco',
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: const [],
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 16),

                    // Tipo de cuenta
                    Row(
                      children: [
                        Icon(
                          Icons.account_balance_wallet,
                          size: 20,
                          color: Colors.grey[700],
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Tipo de cuenta*',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        hintText: 'Elige tipo de cuenta',
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: const [],
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 16),

                    // Número de cuenta
                    Row(
                      children: [
                        Icon(Icons.pin, size: 20, color: Colors.grey[700]),
                        const SizedBox(width: 8),
                        const Text(
                          'Número de cuenta*',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Ingresa tu número de cuenta',
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // CCI
                    Row(
                      children: [
                        Icon(
                          Icons.shield_outlined,
                          size: 20,
                          color: Colors.grey[700],
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'CCI*',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: '20 dígitos',
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Titular de la cuenta
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 20,
                          color: Colors.grey[700],
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Titular de la cuenta*',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Nombre del titular',
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(value: false, onChanged: (value) {}),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Establecer como cuenta principal',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'La cuenta principal se seleccionará automáticamente al retirar',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 80),
                  ],
                ],
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.push(
                        '/pago-exitoso',
                        extra: {
                          'metodoPago': 'transferencia',
                          'screen': '/transferencias',
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Tema.violeta,
                      foregroundColor: Tema.blanco,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Yata retiro',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(mostrarFormularioProvider.notifier).state =
                          false;
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      foregroundColor: Tema.blanco,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Regresar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
