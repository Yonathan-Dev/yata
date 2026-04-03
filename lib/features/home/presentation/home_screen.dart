import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/app_exports.dart';
import '../../../shared/widgets/inactivity_listener.dart';
import '../../../shared/providers/inactivity_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    ref.watch(inactivityProvider);
    final currentTheme = ref.watch(themeProvider);
    final selectedIndex = ref.watch(navigationIndexProvider);
    final esperandoRespuesta = ref.watch(
      registrarProvider.select((state) => state.isLoading),
    );

    return InactivityListener(
      child: Scaffold(
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                ref.read(navigationBarExpandedProvider.notifier).state = !ref
                    .read(navigationBarExpandedProvider);
              },
              child: Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  color: Tema.primaryColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Center(
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
            // NavigationBar que se muestra/oculta
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
                      ref.read(navigationIndexProvider.notifier).state = index;
                      ref.read(navigationBarExpandedProvider.notifier).state =
                          false;
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
        body: Stack(
          children: [
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  AppBarWidget(
                    title:
                        ref
                            .watch(authProvider)
                            .user
                            ?.apellidosyNombres
                            .split(',')
                            .last
                            .trim() ??
                        'Usuario',
                  ),
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
