import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'app_exports.dart';

// Provider para GoRouter
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
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
    ],
  );
});
