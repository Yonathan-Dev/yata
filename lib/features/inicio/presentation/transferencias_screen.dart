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

    return InactivityListener(
      child: Scaffold(
        backgroundColor: Tema.blanco,
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
                      context.go('/home');
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
