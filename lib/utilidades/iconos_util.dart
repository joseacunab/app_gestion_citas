import 'package:flutter/material.dart';

class IconosUtil {
  static IconData desdeNombre(String nombre) {
    const mapa = <String, IconData>{
      'fitness_center': Icons.fitness_center,
      'subscriptions': Icons.subscriptions,
      'school': Icons.school,
      'favorite': Icons.favorite,
      'favorite_border': Icons.favorite_border,
      'lightbulb': Icons.lightbulb_outline,
      'code': Icons.code,
      'event': Icons.event,
      'category': Icons.category,
      'health_and_safety': Icons.health_and_safety,
      'account_balance': Icons.account_balance,
      'work': Icons.work,
      'person': Icons.person,
      'description': Icons.description,
      'payments': Icons.payments,
    };
    return mapa[nombre] ?? Icons.circle;
  }
}
