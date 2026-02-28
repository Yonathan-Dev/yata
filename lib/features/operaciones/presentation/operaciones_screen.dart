import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app_exports.dart';

class OperacionesScreen extends ConsumerStatefulWidget {
  const OperacionesScreen({super.key});

  @override
  ConsumerState<OperacionesScreen> createState() => _OperacionesScreenState();
}

class _OperacionesScreenState extends ConsumerState<OperacionesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                '¡Hola,',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w400,
                  color: Tema.negro,
                ),
              ),
              Text(
                '¡Ingresa tu referencia y paga!',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Tema.negro,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
              _buildLabel('Número de referencia de pago'),
              _buildInput(hint: 'Monto de la orden'),
              const SizedBox(height: 12),
              _buildLabel('Monto de la orden'),
              _buildInput(hint: 'Monto de la orden'),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF830ACE),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Selecciona el método de pago',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              _buildMetodoPagoCard(
                context,
                title: 'Billetera electrónica',
                children: [
                  _buildMetodoOpcion('Yape', 'assets/iconos/yape.png'),
                  _buildMetodoOpcion('Plin', 'assets/iconos/plin.png'),
                ],
              ),
              _buildMetodoPagoCard(context, title: 'Depósito / Transferencia'),
              _buildMetodoPagoCard(context, title: 'Efectivo'),
              _buildMetodoPagoCard(context, title: 'Pagar con cripto'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 2),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.black87,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _buildInput({required String hint}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: const Color(0xFFF1F1F1),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildMetodoPagoCard(
    BuildContext context, {
    required String title,
    List<Widget>? children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Tema.blanco,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Tema.negro.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        trailing: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Tema.negro,
        ),
        children: children ?? [],
      ),
    );
  }

  Widget _buildMetodoOpcion(String label, String asset) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: Image.asset(asset, width: 36, height: 36),
          title: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          onTap: () {},
        ),
      ),
    );
  }
}
