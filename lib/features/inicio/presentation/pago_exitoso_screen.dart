import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/app_exports.dart';
import '../../../shared/shared_exports.dart';

class PagoExitosoScreen extends ConsumerStatefulWidget {
  final String metodoPago;
  const PagoExitosoScreen({super.key, required this.metodoPago});

  @override
  ConsumerState<PagoExitosoScreen> createState() => _PagoExitosoScreenState();
}

class _PagoExitosoScreenState extends ConsumerState<PagoExitosoScreen> {
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
        body: SafeArea(child: _buildPaymentConfirmation(context)),
      ),
    );
  }

  Widget _buildPaymentConfirmation(BuildContext context) {
    return FadeInUp(
      duration: Constantes.standardAnimation,
      delay: const Duration(milliseconds: 300),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 50, 150, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'S/300.00',
                                style: const TextStyle(
                                  fontSize: 35,
                                  color: Tema.negro,
                                  letterSpacing: -1.5,
                                  height: 1.1,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '¡Pago exitoso por ${widget.metodoPago}!',
                                style: Theme.of(context).textTheme.titleMedium!
                                    .copyWith(color: Tema.negro, fontSize: 18),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '01 abril 2026 -  03:45 hs.',
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(color: Tema.negro, fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE8E8E8),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Image.asset(
                            'assets/iconos/icono.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    height: 2,
                    thickness: 2,
                    color: Color(0xFFEEEEEE),
                  ),
                  const SizedBox(height: 28),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Detalles',
                            style: const TextStyle(
                              fontSize: 20,
                              color: Tema.negro,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildDetailRow(
                            'Nombre / Comercio',
                            'Lilly Ann Mateos Chavez',
                          ),
                          const SizedBox(height: 12),
                          _buildDetailRow('Nº de teléfono', '979543744'),
                          const SizedBox(height: 12),
                          _buildDetailRow('Destino', 'No Especificado'),
                          const SizedBox(height: 12),
                          _buildDetailRow('Total', 's/300.00'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Nº de operación',
                            style: TextStyle(fontSize: 20, color: Tema.negro),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '202603478574363339596857575',
                                  style: Theme.of(context).textTheme.bodyMedium!
                                      .copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                      ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              InkWell(
                                onTap: () {
                                  SnackbarUtil.snackbarSuccess(
                                    context,
                                    message: 'Número de operación copiado',
                                  );
                                },
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Tema.negro.withValues(alpha: 0.2),
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.copy_outlined,
                                    color: Colors.black,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── Cinta clickable ────────────────────────────────
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      // Acción al hacer clic en la cinta
                    },
                    child: Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        border: Border.all(
                          color: const Color(0xFFCCCCCC),
                          width: 0.5,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Ver constancia',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildActionButtons(),
          const SizedBox(height: 8),
          Image.asset('assets/iconos/yata_reco.png', width: 80, height: 80),
          const SizedBox(height: 14),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(width: 16),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                ref.read(navigationBarExpandedProvider.notifier).state = false;
                context.go('/pagos-pendientes');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Tema.primaryColor,
                foregroundColor: Tema.blanco,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Nuevo yata',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                ref.read(navigationBarExpandedProvider.notifier).state = false;
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/pagos-pendientes');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Regresar',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
