import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
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
    ref.watch(inactivityProvider);
    return InactivityListener(
      child: Scaffold(
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
                      _buildPreguntaAcciones(context),
                      const SizedBox(height: 16),
                      _buildAccionesGrid(context),
                      const SizedBox(height: 10),
                      _buildSaldoCard(context),
                      //const SizedBox(height: 20),
                      //_buildMovimientosCard(context),
                      const SizedBox(height: 50),
                      _buildActionButtons(context),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            // Bottom Navigation
          ],
        ),
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
        'svg': 'assets/iconos/icono_1.svg',
      },
      {
        'icono': Icons.qr_code_scanner,
        'texto': 'Paga con\nQR',
        'svg': 'assets/iconos/icono_3.svg',
      },
      {
        'icono': Icons.attach_money,
        'texto': 'Pagos\npendientes',
        'svg': 'assets/iconos/icono_4.svg',
      },
      /*{
        'icono': Icons.output_outlined,
        'texto': 'Retirar\nsaldo',
        'svg': 'assets/iconos/icono_2.svg',
      },*/
      {
        'icono': Icons.store_outlined,
        'texto': 'Tienda',
        'svg': 'assets/iconos/icono_5.svg',
      },
      {
        'icono': Icons.receipt_long_outlined,
        'texto': 'Referencias',
        'svg': 'assets/iconos/icono_6.svg',
      },
      {
        'icono': Icons.swap_horiz,
        'texto': 'Transferir',
        'svg': 'assets/iconos/icono_7.svg',
      },
      /*{
        'icono': Icons.monetization_on_outlined,
        'texto': 'Cobrar',
        'svg': 'assets/iconos/icono_8.svg',
      },*/
    ];

    return FadeInUp(
      duration: Constantes.standardAnimation,
      delay: const Duration(milliseconds: 100),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 0,
        ),
        itemCount: acciones.length,
        itemBuilder: (context, index) {
          final accion = acciones[index];
          return _buildAccionItem(
            context,
            icono: accion['icono'] as IconData,
            texto: accion['texto'] as String,
            svg: accion['svg'] as String,
          );
        },
      ),
    );
  }

  Widget _buildAccionItem(
    BuildContext context, {
    required IconData icono,
    required String texto,
    required String svg,
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
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Tema.negro, width: 1.2),
            ),
            child: Padding(
              padding: const EdgeInsets.all(1),
              child: SvgPicture.asset(svg, fit: BoxFit.contain),
            ),
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

  Widget _buildActionButtons(BuildContext context) {
    const double cardHeight = 120.0;
    const double spacing = 12.0;
    const double totalHeight = cardHeight * 2 + spacing; // 252

    return FadeInUp(
      duration: Constantes.standardAnimation,
      delay: const Duration(milliseconds: 300),
      child: SizedBox(
        height: totalHeight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: cardHeight,
                    child: GestureDetector(
                      onTap: () {
                        context.push('/movimientos');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFFE8D9FF), Color(0xFFC4A8FF)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              bottom: 15,
                              left: 5,
                              right: 5,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  _buildBar(35, const Color(0xFFB399E8)),
                                  _buildBar(40, const Color(0xFFA68DD9)),
                                  _buildBar(45, const Color(0xFFB399E8)),
                                  _buildBar(35, const Color(0xFFA68DD9)),
                                  _buildBar(40, const Color(0xFFB399E8)),
                                  _buildBar(55, const Color(0xFFB399E8)),
                                  _buildBar(35, const Color(0xFFA68DD9)),
                                  _buildBar(40, const Color(0xFFB399E8)),
                                  _buildBar(45, const Color(0xFFB399E8)),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Movimientos',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(color: Tema.negro),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Color(0xFF2D1B4E),
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: spacing),
                  SizedBox(
                    height: cardHeight,
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFFE8D9FF), Color(0xFFC4A8FF)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              bottom: 15,
                              left: 20,
                              right: 20,
                              child: CustomPaint(
                                size: const Size(double.infinity, 50),
                                painter: LineChartPainter(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                'Paga tus\nservicios',
                                style: Theme.of(context).textTheme.titleMedium!
                                    .copyWith(color: Tema.negro, height: 1.2),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  height: totalHeight, // mismo alto que la columna izquierda
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFE5E5E5), Color(0xFFD0D0D0)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(painter: DotPatternPainter()),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Promociones',
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium!.copyWith(color: Tema.negro),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBar(double height, Color color) {
    return Container(
      width: 16,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

// Patrón de puntos
class DotPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    final colors = [
      const Color(0xFF9B7FE0).withValues(alpha: 0.3),
      const Color(0xFF7FB8E0).withValues(alpha: 0.3),
      const Color(0xFFB8A3E8).withValues(alpha: 0.3),
    ];

    const dotRadius = 2.0;
    const spacing = 12.0;

    for (double x = spacing; x < size.width; x += spacing) {
      for (double y = spacing; y < size.height; y += spacing) {
        paint.color = colors[(x ~/ spacing + y ~/ spacing) % colors.length];
        canvas.drawCircle(Offset(x, y), dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Gráfico de líneas
class LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final nodes = [
      Offset(size.width * 0.05, size.height * 0.85), // izquierda abajo
      Offset(size.width * 0.25, size.height * 0.60), // centro-izq medio
      Offset(size.width * 0.45, size.height * 0.75), // centro abajo
      Offset(size.width * 0.60, size.height * 0.55), // centro medio
      Offset(size.width * 0.78, size.height * 0.70), // derecha abajo
      Offset(size.width * 0.95, size.height * 0.15), // derecha arriba (GRANDE)
    ];

    final connections = [
      [0, 1],
      [1, 2],
      [2, 3],
      [3, 4],
      [3, 5],
    ];

    final linePaint = Paint()
      ..color = const Color(0xFF1A1A1A).withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    for (final conn in connections) {
      canvas.drawLine(nodes[conn[0]], nodes[conn[1]], linePaint);
    }

    final nodePaint = Paint()
      ..color = const Color(0xFF1A1A1A).withValues(alpha: 0.75)
      ..style = PaintingStyle.fill;

    final nodeSizes = [
      4.0,
      4.0,
      4.0,
      4.0,
      4.0,
      9.0,
    ]; // solo el último es grande
    for (int i = 0; i < nodes.length; i++) {
      canvas.drawCircle(nodes[i], nodeSizes[i], nodePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
