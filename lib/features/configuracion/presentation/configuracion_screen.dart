import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/app_exports.dart';
import '../../../shared/shared_exports.dart';

class ConfiguracionScreen extends ConsumerWidget {
  const ConfiguracionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final authState = ref.watch(authProvider);
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.isAuthenticated == false) {
        context.go('/pin');
      }
    });

    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.all(Constantes.padding),
          children: [
            _buildPerfilHeader(context, authState),
            const SizedBox(height: Constantes.separacion * 2),
            _buildSeccionTitulo(context, 'Apariencia'),
            _buildTarjetaConfiguracion(
              context: context,
              children: [_buildOpcionTema(context, ref, themeMode)],
            ),
            const SizedBox(height: Constantes.separacion * 2),
            _buildSeccionTitulo(context, 'Cuenta'),
            _buildTarjetaConfiguracion(
              context: context,
              children: [
                _buildOpcionModificarPerfil(context),
                _buildOpcionCambiarContrasenaPin(context),
              ],
            ),
            const SizedBox(height: Constantes.separacion * 2),
            _buildSeccionTitulo(context, 'Notificaciones'),
            _buildTarjetaConfiguracion(
              context: context,
              children: [_buildOpcionNotificaciones(context)],
            ),
            const SizedBox(height: Constantes.separacion * 2),
            _buildSeccionTitulo(context, 'Soporte'),
            _buildTarjetaConfiguracion(
              context: context,
              children: [_buildOpcionSoporteWhatsapp(context)],
            ),
            const SizedBox(height: Constantes.separacion * 4),
            _buildTarjetaConfiguracion(
              context: context,
              children: [_buildOpcionCerrarSesion(context, ref)],
            ),
            const SizedBox(height: Constantes.separacion * 2),
            _buildVersionInfo(context, ref),
          ],
        ),
        _buildLoadingIndicator(context, ref),
      ],
    );
  }

  Widget _buildLoadingIndicator(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    if (authState.isLoading) {
      return LoadingWidget(mensaje: authState.mensaje);
    }
    return const SizedBox.shrink();
  }

  Widget _buildPerfilHeader(BuildContext context, AuthState authState) {
    final user = authState.user;
    return Container(
      padding: const EdgeInsets.all(Constantes.padding),
      decoration: BoxDecoration(
        color: Tema.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: Tema.primaryColor,
            child: Text(
              user?.apellidosyNombres.substring(0, 1).toUpperCase() ?? 'U',
              style: const TextStyle(fontSize: 28, color: Tema.blanco),
            ),
          ),
          const SizedBox(width: Constantes.separacion),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.apellidosyNombres ?? 'Usuario',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  user?.correoInstitucional ?? 'Sin correo',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeccionTitulo(BuildContext context, String titulo) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        titulo,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(color: Tema.primaryColor),
      ),
    );
  }

  Widget _buildTarjetaConfiguracion({
    required BuildContext context,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Tema.negro.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildOpcionTema(
    BuildContext context,
    WidgetRef ref,
    String currentTheme,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: Constantes.padding,
        vertical: 8,
      ),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Tema.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          currentTheme == 'dark' ? Icons.dark_mode : Icons.light_mode,
          color: Tema.primaryColor,
        ),
      ),
      title: const Text('Tema', style: TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(
        currentTheme == 'dark' ? 'Oscuro' : 'Claro',
        style: TextStyle(color: Colors.grey[600]),
      ),
      trailing: Switch(
        value: currentTheme == 'dark',
        onChanged: (value) {
          ref.read(themeProvider.notifier).toggleTheme();
        },
        activeThumbColor: Tema.primaryColor,
      ),
    );
  }

  Widget _buildOpcionCerrarSesion(BuildContext context, WidgetRef ref) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: Constantes.padding,
        vertical: 8,
      ),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Tema.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.logout, color: Tema.primaryColor),
      ),
      title: const Text(
        'Cerrar sesión',
        style: TextStyle(fontWeight: FontWeight.w500, color: Tema.primaryColor),
      ),
      subtitle: Text(
        'Salir de tu cuenta',
        style: TextStyle(color: Colors.grey[600]),
      ),
      trailing: const Icon(Icons.chevron_right, color: Tema.primaryColor),
      onTap: () => _mostrarDialogoCerrarSesion(context, ref),
    );
  }

  Widget _buildVersionInfo(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        children: [
          Text(
            'yate',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'v${ref.watch(dispositivoProvider.select((d) => d.versionApp))}',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoCerrarSesion(BuildContext context, WidgetRef ref) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Cerrar sesión',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => const SizedBox(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );

        return ScaleTransition(
          scale: curvedAnimation,
          child: FadeTransition(
            opacity: animation,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.elasticOut,
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Tema.primaryColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Tema.primaryColor.withValues(
                                    alpha: 0.3,
                                  ),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.logout_rounded,
                              color: Tema.blanco,
                              size: 36,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    Text(
                      '¿Cerrar sesión?',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Tendrás que volver a iniciar sesión para acceder a tu cuenta y tus datos.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.grey[700],
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: BorderSide(color: Colors.grey[300]!),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text(
                              'Cancelar',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              final authNotifier = ref.read(
                                authProvider.notifier,
                              );

                              authNotifier.setLoading(
                                isLoading: true,
                                mensaje: 'Cerrando sesión...',
                              );

                              try {
                                ref.invalidate(logoutProvider);
                                await ref.read(logoutProvider.future);

                                if (!context.mounted) return;
                                authNotifier.logout();
                                context.go('/pin');
                              } catch (e) {
                                if (!context.mounted) return;
                                SnackbarUtil.snackbarError(
                                  context,
                                  message: e.toString(),
                                );
                              } finally {
                                authNotifier.setLoading(
                                  isLoading: false,
                                  mensaje: '',
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Tema.primaryColor,
                              foregroundColor: Tema.blanco,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text(
                              'Cerrar sesión',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOpcionModificarPerfil(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.person_outline, color: Colors.blue),
      title: const Text('Modificar datos'),
      onTap: () {
        // Navegación o lógica futura
      },
    );
  }

  Widget _buildOpcionCambiarContrasenaPin(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.lock_outline, color: Colors.orange),
      title: const Text('Cambiar contraseña y PIN'),
      onTap: () {
        // Navegación o lógica futura
      },
    );
  }

  Widget _buildOpcionNotificaciones(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.notifications_outlined, color: Colors.green),
      title: const Text('Gestión de notificaciones'),
      onTap: () {
        // Navegación o lógica futura
      },
    );
  }

  Widget _buildOpcionSoporteWhatsapp(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.chat, color: Colors.green),
      title: const Text('Enlace con soporte por WhatsApp'),
      onTap: () {
        // Navegación o lógica futura
      },
    );
  }
}
