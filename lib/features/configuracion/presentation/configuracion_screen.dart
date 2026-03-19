import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/app_exports.dart';
import '../../../shared/shared_exports.dart';

class ConfiguracionScreen extends ConsumerWidget {
  const ConfiguracionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final authState = ref.watch(authProvider);

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.isAuthenticated == false) context.go('/pin');
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
            _buildSeccionTitulo(context, 'Seguridad'),
            _buildTarjetaConfiguracion(
              context: context,
              children: [
                _buildOpcionContrasena(context),
                _buildOpcionCambiarPin(context),
                _buildOpcionDispositivoVinculado(context, ref),
                _buildOpcionDesvincularDispositivo(context, ref),
              ],
            ),
            const SizedBox(height: Constantes.separacion * 2),
            _buildSeccionTitulo(context, 'Cuenta'),
            _buildTarjetaConfiguracion(
              context: context,
              children: [_buildOpcionModificarPerfil(context)],
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
            const SizedBox(height: Constantes.separacion * 2),
            _buildSeccionTitulo(context, 'Zona de riesgo'),
            _buildTarjetaConfiguracion(
              context: context,
              children: [_buildOpcionCancelarCuenta(context, ref)],
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
    if (authState.isLoading) return LoadingWidget(mensaje: authState.mensaje);
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

  Widget _buildOpcionTema(BuildContext context, WidgetRef ref, String current) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: Constantes.padding,
        vertical: 8,
      ),
      leading: _iconBox(
        color: Tema.primaryColor.withValues(alpha: 0.1),
        icon: current == 'dark' ? Icons.dark_mode : Icons.light_mode,
        iconColor: Tema.primaryColor,
      ),
      title: const Text('Tema', style: TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(
        current == 'dark' ? 'Oscuro' : 'Claro',
        style: TextStyle(color: Colors.grey[600]),
      ),
      trailing: Switch(
        value: current == 'dark',
        onChanged: (_) => ref.read(themeProvider.notifier).toggleTheme(),
        activeThumbColor: Tema.primaryColor,
      ),
    );
  }

  Widget _buildOpcionContrasena(BuildContext context) {
    return _buildTile(
      context: context,
      iconBg: Tema.naranja.withValues(alpha: 0.12),
      icon: Icons.lock_outline_rounded,
      iconColor: Colors.orange[800]!,
      title: 'Contraseña',
      subtitle: 'Actualiza tu contraseña de acceso',
      onTap: () {},
    );
  }

  Widget _buildOpcionCambiarPin(BuildContext context) {
    return _buildTile(
      context: context,
      iconBg: Tema.primaryColor.withValues(alpha: 0.1),
      icon: Icons.pin_outlined,
      iconColor: Tema.primaryColor,
      title: 'Cambiar PIN',
      subtitle: 'PIN de 6 dígitos de acceso rápido',
      onTap: () {},
    );
  }

  Widget _buildOpcionDispositivoVinculado(BuildContext context, WidgetRef ref) {
    final dispositivo = ref.watch(dispositivoProvider);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: Constantes.padding,
        vertical: 6,
      ),
      leading: _iconBox(
        color: Tema.azul.withValues(alpha: 0.1),
        icon: Icons.smartphone_rounded,
        iconColor: Colors.blue[700]!,
      ),
      title: const Text(
        'Dispositivo vinculado',
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        '${dispositivo.modelo} - ${dispositivo.versionOs}',
        style: TextStyle(color: Colors.grey[600], fontSize: 12),
      ),
      trailing: _badge(
        label: 'Activo',
        bgColor: Colors.blue.withValues(alpha: 0.1),
        textColor: Colors.blue[800]!,
      ),
    );
  }

  Widget _buildOpcionDesvincularDispositivo(
    BuildContext context,
    WidgetRef ref,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: Constantes.padding,
        vertical: 6,
      ),
      leading: _iconBox(
        color: Colors.amber.withValues(alpha: 0.12),
        icon: Icons.mobile_off_rounded,
        iconColor: Colors.amber[800]!,
      ),
      title: const Text(
        'Desvincular dispositivo',
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        'Cierra el acceso desde este equipo',
        style: TextStyle(color: Colors.grey[600], fontSize: 12),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
      onTap: () => _mostrarDialogoDesvincular(context, ref),
    );
  }

  void _mostrarDialogoDesvincular(BuildContext context, WidgetRef ref) {
    _showAnimatedDialog(
      context: context,
      child: _dialogContenido(
        context: context,
        iconColor: Colors.amber[700]!,
        icon: Icons.mobile_off_rounded,
        titulo: '¿Desvincular dispositivo?',
        descripcion:
            'Tu sesión quedará cerrada en este equipo. Podrás volver a vincularlo al iniciar sesión.',
        labelConfirmar: 'Desvincular',
        colorConfirmar: Colors.amber[700]!,
        onConfirmar: () async {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildOpcionModificarPerfil(BuildContext context) {
    return _buildTile(
      context: context,
      iconBg: Tema.primaryColor.withValues(alpha: 0.1),
      icon: Icons.person_outline_rounded,
      iconColor: Tema.primaryColor,
      title: 'Modificar datos del perfil',
      subtitle: 'Nombre, correo, teléfono y más',
      onTap: () {
        context.push('/configuracion/perfil-datos');
      },
    );
  }

  Widget _buildOpcionNotificaciones(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: Constantes.padding,
        vertical: 6,
      ),
      leading: _iconBox(
        color: Colors.blue.withValues(alpha: 0.1),
        icon: Icons.notifications_outlined,
        iconColor: Colors.blue[700]!,
      ),
      title: const Text(
        'Gestión de notificaciones',
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        'Alertas, avisos y recordatorios',
        style: TextStyle(color: Colors.grey[600], fontSize: 12),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Tema.primaryColor,
              shape: BoxShape.circle,
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: Colors.grey),
        ],
      ),
      onTap: () {},
    );
  }

  Widget _buildOpcionSoporteWhatsapp(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: Constantes.padding,
        vertical: 6,
      ),
      leading: _iconBox(
        color: const Color(0xFF25D366).withValues(alpha: 0.12),
        icon: Icons.chat_rounded,
        iconColor: const Color(0xFF25D366),
      ),
      title: const Text(
        'Soporte por WhatsApp',
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        'Chatea con nuestro equipo de ayuda',
        style: TextStyle(color: Colors.grey[600], fontSize: 12),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _badge(
            label: 'En línea',
            bgColor: Tema.primaryColor.withValues(alpha: 0.1),
            textColor: Tema.primaryColor,
          ),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right_rounded, color: Colors.grey),
        ],
      ),
      onTap: () async {
        const phone = '966105060';
        final url = Uri.parse('https://wa.me/$phone');
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se pudo abrir WhatsApp')),
          );
        }
      },
    );
  }

  Widget _buildOpcionCancelarCuenta(BuildContext context, WidgetRef ref) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: Constantes.padding,
        vertical: 6,
      ),
      leading: _iconBox(
        color: Colors.red.withValues(alpha: 0.1),
        icon: Icons.delete_outline_rounded,
        iconColor: Colors.red[700]!,
      ),
      title: Text(
        'Cancelar cuenta',
        style: TextStyle(fontWeight: FontWeight.w500, color: Colors.red[700]),
      ),
      subtitle: Text(
        'Elimina permanentemente tu cuenta y datos',
        style: TextStyle(color: Colors.grey[600], fontSize: 12),
      ),
      trailing: _badge(
        label: 'Irreversible',
        bgColor: Colors.red.withValues(alpha: 0.1),
        textColor: Colors.red[700]!,
      ),
      onTap: () => _mostrarDialogoCancelarCuenta(context, ref),
    );
  }

  void _mostrarDialogoCancelarCuenta(BuildContext context, WidgetRef ref) {
    _showAnimatedDialog(
      context: context,
      child: _dialogContenido(
        context: context,
        iconColor: Colors.red[600]!,
        icon: Icons.warning_amber_rounded,
        titulo: '¿Cancelar tu cuenta?',
        descripcion:
            'Esta acción es permanente e irreversible. Se eliminarán todos tus datos, historial y configuraciones.',
        labelConfirmar: 'Sí, cancelar',
        colorConfirmar: Colors.red[600]!,
        onConfirmar: () async {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildOpcionCerrarSesion(BuildContext context, WidgetRef ref) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: Constantes.padding,
        vertical: 8,
      ),
      leading: _iconBox(
        color: Tema.primaryColor.withValues(alpha: 0.1),
        icon: Icons.logout_rounded,
        iconColor: Tema.primaryColor,
      ),
      title: const Text(
        'Cerrar sesión',
        style: TextStyle(fontWeight: FontWeight.w500, color: Tema.primaryColor),
      ),
      subtitle: Text(
        'Salir de tu cuenta actual',
        style: TextStyle(color: Colors.grey[600]),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: Tema.primaryColor,
      ),
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
    _showAnimatedDialog(
      context: context,
      child: _dialogContenido(
        context: context,
        iconColor: Tema.primaryColor,
        icon: Icons.logout_rounded,
        titulo: '¿Cerrar sesión?',
        descripcion:
            'Tendrás que volver a iniciar sesión para acceder a tu cuenta y tus datos.',
        labelConfirmar: 'Cerrar sesión',
        colorConfirmar: Tema.primaryColor,
        onConfirmar: () async {
          final authNotifier = ref.read(authProvider.notifier);
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
            SnackbarUtil.snackbarError(context, message: e.toString());
          } finally {
            authNotifier.setLoading(isLoading: false, mensaje: '');
          }
        },
      ),
    );
  }

  Widget _buildTile({
    required BuildContext context,
    required Color iconBg,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: Constantes.padding,
        vertical: 6,
      ),
      leading: _iconBox(color: iconBg, icon: icon, iconColor: iconColor),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.grey[600], fontSize: 12),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _iconBox({
    required Color color,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Icon(icon, color: iconColor, size: 20),
    );
  }

  Widget _badge({
    required String label,
    required Color bgColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  void _showAnimatedDialog({
    required BuildContext context,
    required Widget child,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) => const SizedBox(),
      transitionBuilder: (context, animation, _, __) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );
        return ScaleTransition(
          scale: curved,
          child: FadeTransition(
            opacity: animation,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: child,
            ),
          ),
        );
      },
    );
  }

  Widget _dialogContenido({
    required BuildContext context,
    required Color iconColor,
    required IconData icon,
    required String titulo,
    required String descripcion,
    required String labelConfirmar,
    required Color colorConfirmar,
    required Future<void> Function() onConfirmar,
  }) {
    return Container(
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
            builder: (context, value, _) => Transform.scale(
              scale: value,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: iconColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: iconColor.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Icon(icon, color: Tema.blanco, size: 36),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            titulo,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            descripcion,
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
                  onPressed: onConfirmar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorConfirmar,
                    foregroundColor: Tema.blanco,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    labelConfirmar,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
