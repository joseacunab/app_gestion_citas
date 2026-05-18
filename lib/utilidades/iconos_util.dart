import 'package:flutter/material.dart';

import 'iconos_categoria_catalogo.dart';

class IconosUtil {
  static IconData desdeNombre(String nombre) {
    const mapa = <String, IconData>{
      'fitness_center': Icons.fitness_center,
      'subscriptions': Icons.subscriptions,
      'school': Icons.school,
      'school_outlined': Icons.school_outlined,
      'favorite': Icons.favorite,
      'favorite_border': Icons.favorite_border,
      'lightbulb': Icons.lightbulb_outline,
      'code': Icons.code,
      'event': Icons.event,
      'event_outlined': Icons.event_outlined,
      'category': Icons.category,
      'health_and_safety': Icons.health_and_safety,
      'account_balance': Icons.account_balance,
      'account_balance_wallet_outlined': Icons.account_balance_wallet_outlined,
      'work': Icons.work,
      'work_outline': Icons.work_outline,
      'person': Icons.person,
      'person_outline': Icons.person_outline,
      'description': Icons.description,
      'description_outlined': Icons.description_outlined,
      'payments': Icons.payments,
      'payments_outlined': Icons.payments_outlined,
      'menu_book_outlined': Icons.menu_book_outlined,
      'auto_awesome_outlined': Icons.auto_awesome_outlined,
      'local_cafe_outlined': Icons.local_cafe_outlined,
      'flight_outlined': Icons.flight_outlined,
      'music_note_outlined': Icons.music_note_outlined,
      'camera_alt_outlined': Icons.camera_alt_outlined,
      'shopping_bag_outlined': Icons.shopping_bag_outlined,
      'home_outlined': Icons.home_outlined,
      'directions_car_outlined': Icons.directions_car_outlined,
      'card_giftcard_outlined': Icons.card_giftcard_outlined,
      'star_outline': Icons.star_outline,
      'notifications_none_outlined': Icons.notifications_none_outlined,
      'bookmark_border': Icons.bookmark_border,
      'local_fire_department_outlined': Icons.local_fire_department_outlined,
      'eco_outlined': Icons.eco_outlined,
      'wb_sunny_outlined': Icons.wb_sunny_outlined,
      'dark_mode_outlined': Icons.dark_mode_outlined,
      'cloud_outlined': Icons.cloud_outlined,
      'bolt_outlined': Icons.bolt_outlined,
      'restaurant_outlined': Icons.restaurant_outlined,
      'self_improvement': Icons.self_improvement,
    };
    return mapa[nombre] ?? Icons.circle;
  }

  static List<String> get catalogoCategoria => IconosCategoriaCatalogo.nombres;
}
