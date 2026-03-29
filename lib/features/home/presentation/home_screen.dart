import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/app_exports.dart';
import '../../../shared/widgets/inactivity_listener.dart';
import '../../../shared/providers/inactivity_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(inactivityProvider);
    final currentTheme = ref.watch(themeProvider);
    final selectedIndex = ref.watch(navigationIndexProvider);
    final esperandoRespuesta = ref.watch(
      registrarProvider.select((state) => state.isLoading),
    );

    return InactivityListener(
      child: Scaffold(
        bottomNavigationBar: Theme(
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
              ref.read(navigationIndexProvider.notifier).state = index;
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
                icon: Icon(Icons.shopping_cart_outlined),
                selectedIcon: Icon(Icons.shopping_cart),
                label: 'Para ti',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings),
                selectedIcon: Icon(Icons.settings_outlined),
                label: 'Configuración',
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const AppBarWidget(),
                  Expanded(
                    child: _getSelectedScreen(
                      selectedIndex,
                      currentTheme,
                      context,
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
}

Widget _getSelectedScreen(
  int index,
  String currentTheme,
  BuildContext context,
) {
  switch (index) {
    case 0:
      return const InicioScreen();
    case 1:
      return const OperacionesScreen();
    case 2:
      return const ParatiScreen();
    case 3:
      return const ConfiguracionScreen();
    default:
      return const InicioScreen();
  }
}
