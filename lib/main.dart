import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/tema.dart';
import 'core/router.dart';
import 'features/configuracion/providers/configuracion_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeProvider);

    return MaterialApp.router(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale('es', 'ES')],
      locale: Locale('es', 'ES'),
      debugShowCheckedModeBanner: false,
      title: 'yata',
      theme: Tema.lightTheme,
      darkTheme: Tema.darkTheme,
      themeMode: currentTheme == 'dark' ? ThemeMode.dark : ThemeMode.light,
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
