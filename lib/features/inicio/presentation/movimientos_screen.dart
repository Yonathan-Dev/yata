import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/app_exports.dart';
import '../../../shared/shared_exports.dart';

class MovimientosScreen extends ConsumerStatefulWidget {
  const MovimientosScreen({super.key});

  @override
  ConsumerState<MovimientosScreen> createState() => _MovimientosScreenState();
}

class _MovimientosScreenState extends ConsumerState<MovimientosScreen> {
  int _selectedMonthIndex = 3;

  @override
  void initState() {
    super.initState();
    // Llamar después de que el widget esté completamente montado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMovimientos();
    });
  }

  Future<void> _loadMovimientos() async {
    if (!mounted) return;

    final newCount = await ref
        .read(movimientosNotifierProvider.notifier)
        .loadInitial();

    if (!mounted) return;

    if (newCount == 0 && ref.read(movimientosNotifierProvider).items.isEmpty) {
      SnackbarUtil.snackbarNotificationPush(
        context,
        title: 'No se encontraron movimientos',
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
                'Movimientos',
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

  Widget _buildMovimientosList(BuildContext context2) {
    final state = ref.watch(movimientosNotifierProvider);

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Error al cargar movimientos',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(color: Tema.negro),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadMovimientos,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (state.items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'No hay movimientos',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(color: Tema.negro),
          ),
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        // Gráfico de consumos
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: _buildConsumosChart(context, state),
          ),
        ),

        // Lista de movimientos agrupados por fecha
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: _buildGroupedMovimientos(state),
        ),

        // Info de paginación
        SliverToBoxAdapter(child: _buildPaginationInfo(state)),

        // Botón cargar más
        if (state.isLoadingMore)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
          )
        else if (state.hasNext)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TextButton(
                onPressed: () async {
                  if (!mounted) return;

                  final newCount = await ref
                      .read(movimientosNotifierProvider.notifier)
                      .loadMore();

                  if (!mounted) return;

                  if (newCount == 0) {
                    SnackbarUtil.snackbarNotificationPush(
                      context,
                      title: 'No se encontraron nuevos movimientos',
                    );
                  }
                },
                child: const Text('Cargar más'),
              ),
            ),
          ),

        const SliverToBoxAdapter(child: SizedBox(height: 16)),
      ],
    );
  }

  Widget _buildConsumosChart(BuildContext context, dynamic state) {
    final now = DateTime.now();
    final months = _getLast4Months(now);
    final consumosPorMes = _calcularConsumosPorMes(state.items, months);

    // Calcular el total del mes seleccionado
    final totalConsumos = consumosPorMes[_selectedMonthIndex];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Tema.blanco,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Consumos en ${months[_selectedMonthIndex]['label']}',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Tema.negro,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'S/${totalConsumos.toStringAsFixed(2)}',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall!.copyWith(color: Tema.negro),
          ),
          const SizedBox(height: 30),
          _buildBarChart(consumosPorMes),
          const SizedBox(height: 20),
          _buildMonthLabels(months),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getLast4Months(DateTime now) {
    final months = <Map<String, dynamic>>[];
    final monthNames = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];
    final shortMonthNames = [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic',
    ];

    for (int i = 0; i < 4; i++) {
      final monthDate = DateTime(now.year, now.month - i, 1);
      months.add({
        'date': monthDate,
        'label': monthNames[monthDate.month - 1],
        'shortLabel': shortMonthNames[monthDate.month - 1],
        'year': monthDate.year,
      });
    }

    return months.reversed
        .toList(); // Invertir para mostrar de más antiguo a más reciente
  }

  List<double> _calcularConsumosPorMes(
    List<dynamic> items,
    List<Map<String, dynamic>> months,
  ) {
    final consumos = List<double>.filled(4, 0.0);

    for (var item in items) {
      if (item.tipo?.toUpperCase() == 'RECARGA') continue;

      DateTime? fecha;
      if (item.fechaTransaccion is DateTime) {
        fecha = item.fechaTransaccion;
      } else if (item.fechaTransaccion is String) {
        try {
          fecha = DateTime.parse(item.fechaTransaccion);
        } catch (e) {
          continue;
        }
      }

      if (fecha == null) continue;

      // Buscar en qué mes cae esta transacción
      for (int i = 0; i < months.length; i++) {
        final monthDate = months[i]['date'] as DateTime;
        if (fecha.year == monthDate.year && fecha.month == monthDate.month) {
          consumos[i] += item.monto ?? 0.0;
          break;
        }
      }
    }

    return consumos;
  }

  Widget _buildBarChart(List<double> consumosPorMes) {
    // Encontrar el máximo para normalizar las alturas
    final maxConsumo = consumosPorMes.reduce((a, b) => a > b ? a : b);
    const double minVisibleHeight =
        0.05; // 5% altura mínima solo para ver la barra

    return SizedBox(
      height: 150,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(4, (index) {
          final consumo = consumosPorMes[index];
          // Si hay consumo, calcular proporción real; si es 0, usar altura mínima visible
          final normalizedHeight = maxConsumo > 0
              ? (consumo > 0 ? (consumo / maxConsumo) : minVisibleHeight)
              : minVisibleHeight;
          final isSelected = index == _selectedMonthIndex;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedMonthIndex = index;
              });
            },
            child: Container(
              width: 60,
              height: 150 * normalizedHeight,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF9D7EF2)
                    : const Color(0xFFD4C5F9),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildMonthLabels(List<Map<String, dynamic>> months) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: months.map((month) {
        return SizedBox(
          width: 60,
          child: Text(
            month['shortLabel'],
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Tema.negro.withValues(alpha: 0.6),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGroupedMovimientos(dynamic state) {
    // Agrupar movimientos por fecha
    Map<String, List<dynamic>> groupedByDate = {};

    for (var movimiento in state.items) {
      final dateKey = _getDateKey(movimiento.fechaTransaccion);
      if (!groupedByDate.containsKey(dateKey)) {
        groupedByDate[dateKey] = [];
      }
      groupedByDate[dateKey]!.add(movimiento);
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final dateKeys = groupedByDate.keys.toList();
        final dateKey = dateKeys[index];
        final movimientos = groupedByDate[dateKey]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25, top: 16),
              child: Text(
                dateKey,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Tema.negro,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
            ...movimientos.map((mov) => _buildMovimientoItem(mov)),
          ],
        );
      }, childCount: groupedByDate.length),
    );
  }

  String _getDateKey(dynamic dateValue) {
    if (dateValue == null) return 'Fecha desconocida';

    try {
      DateTime date;

      if (dateValue is DateTime) {
        date = dateValue;
      } else if (dateValue is String) {
        date = DateTime.parse(dateValue);
      } else {
        return 'Fecha desconocida';
      }

      final months = [
        'Enero',
        'Febrero',
        'Marzo',
        'Abril',
        'Mayo',
        'Junio',
        'Julio',
        'Agosto',
        'Septiembre',
        'Octubre',
        'Noviembre',
        'Diciembre',
      ];

      return '${date.day} de ${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return 'Fecha desconocida';
    }
  }

  Widget _buildPaginationInfo(dynamic state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Text(
        'Mostrando ${state.items.length} de ${state.totalRegistros} (Página ${state.page} de ${state.totalPaginas})',
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
          color: Tema.negro.withValues(alpha: 0.6),
          fontSize: 12,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildMovimientoItem(dynamic movimiento) {
    // Determinar si es ingreso o egreso basado en el tipo
    final bool isIngreso = movimiento.tipo?.toUpperCase() == 'RECARGA';
    final String montoStr = isIngreso
        ? '+S/${movimiento.monto.toStringAsFixed(2)}'
        : '-S/${movimiento.monto.toStringAsFixed(2)}';

    return Container(
      margin: const EdgeInsets.fromLTRB(25, 8, 25, 8),
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
      decoration: BoxDecoration(
        color: const Color(0xFFE8E8E8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 25,
            height: 25,
            decoration: const BoxDecoration(
              color: Tema.negro,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Tema.blanco, size: 15),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movimiento.descripcion ?? 'Sin descripción',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Tema.negro,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  movimiento.referencia ?? movimiento.tipo ?? '',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Tema.negro.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          Text(
            montoStr,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(color: Tema.negro, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
