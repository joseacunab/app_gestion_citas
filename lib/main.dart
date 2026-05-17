import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'controladores/proveedores.dart';
import 'firebase_options.dart';
import 'navegacion/shell_navegacion.dart';
import 'pantallas/login_pantalla.dart';
import 'temas/app_tema.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es', null);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: PlanApp()));
}

class PlanApp extends ConsumerWidget {
  const PlanApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(usuarioAuthProvider);
    final usuario = ref.watch(usuarioProvider);
    final oscuro = ref.watch(temaOscuroProvider);

    ref.listen(usuarioProvider, (prev, next) {
      final u = next.valueOrNull;
      if (u != null) {
        ref.read(temaOscuroProvider.notifier).state = u.tema == 'dark';
      }
    });

    return MaterialApp(
      title: 'Plan',
      debugShowCheckedModeBanner: false,
      theme: AppTema.claro(),
      darkTheme: AppTema.oscuro(),
      themeMode: oscuro ? ThemeMode.dark : ThemeMode.light,
      locale: const Locale('es'),
      supportedLocales: const [Locale('es')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: auth.when(
        data: (user) {
          if (user == null) return const LoginPantalla();
          return usuario.when(
            data: (_) => const ShellNavegacion(),
            loading: () => const _Cargando(),
            error: (_, __) => const ShellNavegacion(),
          );
        },
        loading: () => const _Cargando(),
        error: (_, __) => const LoginPantalla(),
      ),
    );
  }
}

class _Cargando extends StatelessWidget {
  const _Cargando();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
