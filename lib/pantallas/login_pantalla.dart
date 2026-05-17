import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controladores/proveedores.dart';
import '../entidades/usuario.dart';
class LoginPantalla extends ConsumerStatefulWidget {
  const LoginPantalla({super.key});

  @override
  ConsumerState<LoginPantalla> createState() => _LoginPantallaState();
}

class _LoginPantallaState extends ConsumerState<LoginPantalla> {
  final _formKey = GlobalKey<FormState>();
  final _correo = TextEditingController();
  final _contrasena = TextEditingController();
  final _nombre = TextEditingController();
  final _apellido = TextEditingController();
  bool _registro = false;
  bool _cargando = false;
  String? _error;

  @override
  void dispose() {
    _correo.dispose();
    _contrasena.dispose();
    _nombre.dispose();
    _apellido.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _cargando = true;
      _error = null;
    });

    final auth = ref.read(authControladorProvider);
    final usuarioCtrl = ref.read(usuarioControladorProvider);
    try {
      if (_registro) {
        final uid = await auth.registrar(
          correo: _correo.text,
          contrasena: _contrasena.text,
          nombre: _nombre.text.trim(),
          apellido: _apellido.text.trim(),
        );
        await usuarioCtrl.crearPerfil(
          Usuario(
            id: uid,
            nombre: _nombre.text.trim(),
            apellido: _apellido.text.trim(),
            correo: _correo.text.trim(),
            tema: 'light',
            notificaciones: true,
          ),
        );
      } else {
        await auth.iniciarSesion(
          correo: _correo.text,
          contrasena: _contrasena.text,
        );
      }
    } catch (e) {
      setState(() => _error = 'No se pudo completar. Revisá tus datos.');
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 48),
                Text(
                  'Plan',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tu día, organizado con estilo.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.5),
                      ),
                ),
                const SizedBox(height: 40),
                if (_registro) ...[
                  TextFormField(
                    controller: _nombre,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Requerido' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _apellido,
                    decoration: const InputDecoration(labelText: 'Apellido'),
                  ),
                  const SizedBox(height: 12),
                ],
                TextFormField(
                  controller: _correo,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Correo'),
                  validator: (v) =>
                      v == null || !v.contains('@') ? 'Correo inválido' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _contrasena,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Contraseña'),
                  validator: (v) =>
                      v == null || v.length < 6 ? 'Mínimo 6 caracteres' : null,
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(_error!, style: const TextStyle(color: Colors.red)),
                ],
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _cargando ? null : _enviar,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: _cargando
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(_registro ? 'Crear cuenta' : 'Iniciar sesión'),
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() => _registro = !_registro),
                  child: Text(
                    _registro
                        ? '¿Ya tenés cuenta? Iniciá sesión'
                        : '¿No tenés cuenta? Registrate',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
