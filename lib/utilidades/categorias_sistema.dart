import '../entidades/categoria.dart';

/// Categorías predeterminadas del sistema (en memoria, sin Firebase).
class CategoriasSistema {
  CategoriasSistema._();

  static const List<Categoria> todas = [
    Categoria(
      id: 'sys_salud',
      nombre: 'Salud',
      icono: 'favorite_border',
      color: '#2ECC71',
    ),
    Categoria(
      id: 'sys_finanzas',
      nombre: 'Finanzas',
      icono: 'account_balance_wallet_outlined',
      color: '#F39C12',
    ),
    Categoria(
      id: 'sys_estudios',
      nombre: 'Estudios',
      icono: 'menu_book_outlined',
      color: '#9B59B6',
    ),
    Categoria(
      id: 'sys_gym',
      nombre: 'Gym',
      icono: 'fitness_center',
      color: '#E74C3C',
    ),
    Categoria(
      id: 'sys_tramites',
      nombre: 'Trámites',
      icono: 'description_outlined',
      color: '#1ABC9C',
    ),
    Categoria(
      id: 'sys_personal',
      nombre: 'Personal',
      icono: 'auto_awesome_outlined',
      color: '#E84393',
    ),
    Categoria(
      id: 'sys_trabajo',
      nombre: 'Trabajo',
      icono: 'work_outline',
      color: '#5C6BC0',
    ),
  ];

  static Categoria? buscarPorId(String id) {
    for (final c in todas) {
      if (c.id == id) return c;
    }
    return null;
  }
}
