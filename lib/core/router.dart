import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'app_exports.dart';

final navigatorKey = GlobalKey<NavigatorState>();

// Provider para GoRouter
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/auth',
        name: 'auth',
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: '/pin',
        name: 'pin',
        builder: (context, state) => const PinScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgotPassword',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/inicio',
        name: 'inicio',
        builder: (context, state) => const InicioScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/verify-code',
        name: 'verifyCode',
        builder: (context, state) => const VerifyCodeScreen(),
      ),
      GoRoute(
        path: '/create-pin',
        name: 'createPin',
        builder: (context, state) => const CreatePinScreen(),
      ),
      GoRoute(
        path: '/confirm-pin',
        name: 'confirmPin',
        builder: (context, state) => const ConfirmPinScreen(),
      ),
      GoRoute(
        path: '/verification-otp',
        name: 'verificationOtp',
        builder: (context, state) => const VerificationOtpScreen(),
      ),
      GoRoute(
        path: '/change-password',
        name: 'changePassword',
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: '/forgot-pin',
        name: 'forgotPin',
        builder: (context, state) => const ForgotPinScreen(),
      ),
      GoRoute(
        path: '/configuracion/perfil-datos',
        name: 'perfilDatos',
        builder: (context, state) => const PerfilDatosScreen(),
      ),
      GoRoute(
        path: '/configuracion/cambiar-contrasena',
        name: 'cambiarContrasena',
        builder: (context, state) => const CambiarContrasenaScreen(),
      ),
      GoRoute(
        path: '/configuracion/cambiar-pin',
        name: 'cambiarPin',
        builder: (context, state) => const CambiarPinScreen(),
      ),
      GoRoute(
        path: '/configuracion/verify-code',
        name: 'verifyCodeConfiguracion',
        builder: (context, state) {
          final extra = state.extra;
          bool isPin = false;
          if (extra is Map && extra['isPin'] is bool) {
            isPin = extra['isPin'] as bool;
          }
          return VerifyCodeConfiguracionScreen(isPin: isPin);
        },
      ),
      GoRoute(
        path: '/configuracion/solicitar-otp',
        name: 'solicitarOtp',
        builder: (context, state) {
          final extra = state.extra;
          bool isPin = false;
          if (extra is Map && extra['isPin'] is bool) {
            isPin = extra['isPin'] as bool;
          }
          return SolicitarOtpScreen(isPin: isPin);
        },
      ),
      GoRoute(
        path: '/movimientos',
        name: 'movimientos',
        builder: (context, state) => const MovimientosScreen(),
      ),
      GoRoute(
        path: '/pagos-pendientes',
        name: 'pagosPendientes',
        builder: (context, state) => const PagosPendientesScreen(),
      ),
      GoRoute(
        path: '/pago-exitoso',
        name: 'pagoExitoso',
        builder: (context, state) {
          final extra = state.extra;
          String metodoPago = '';
          if (extra is Map && extra['metodoPago'] is String) {
            metodoPago = extra['metodoPago'] as String;
          }
          return PagoExitosoScreen(metodoPago: metodoPago);
        },
      ),
      GoRoute(
        path: '/paga-otros',
        name: 'pagaOtros',
        builder: (context, state) => const PagaOtrosScreen(),
      ),
      GoRoute(
        path: '/transferencias',
        name: 'transferencias',
        builder: (context, state) => const TransferenciasScreen(),
      ),
    ],
  );
});
