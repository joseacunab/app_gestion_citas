import 'package:flutter/material.dart';

class ColoresUtil {
  static Color desdeHex(String hex) {
    var valor = hex.replaceAll('#', '');
    if (valor.length == 6) valor = 'FF$valor';
    return Color(int.parse(valor, radix: 16));
  }

  static Color fondoOscuro(String hex) {
    final base = desdeHex(hex);
    return Color.lerp(base, Colors.black, 0.75)!;
  }
}
