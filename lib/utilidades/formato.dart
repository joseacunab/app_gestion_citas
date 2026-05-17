import 'package:intl/intl.dart';

class Formato {
  static final _hora = DateFormat('HH:mm');
  static final _fechaCorta = DateFormat('d MMM', 'es');
  static final _fechaLarga = DateFormat("EEEE d 'de' MMMM", 'es');
  static final _fechaMayus = DateFormat('d MMM', 'es');
  static final _mesAnio = DateFormat('MMMM yyyy', 'es');
  static final _diaSemanaMayus = DateFormat('EEEE d \'de\' MMMM', 'es');

  static String hora(DateTime fecha) => _hora.format(fecha);

  static String fechaCorta(DateTime fecha) =>
      _fechaCorta.format(fecha).toLowerCase();

  static String fechaLarga(DateTime fecha) =>
      _fechaLarga.format(fecha).toLowerCase();

  static String fechaNota(DateTime fecha) =>
      _fechaMayus.format(fecha).toUpperCase();

  static String mesAnio(DateTime fecha) {
    final texto = _mesAnio.format(fecha);
    return '${texto[0].toUpperCase()}${texto.substring(1)}';
  }

  static String encabezadoDia(DateTime fecha) =>
      _diaSemanaMayus.format(fecha).toLowerCase();

  static String encabezadoSuperior(DateTime fecha) {
    final texto = DateFormat('EEEE d \'de\' MMMM', 'es').format(fecha);
    return texto.toUpperCase();
  }

  static String proximoEvento(DateTime fecha) {
    final dia = DateFormat('EEE d MMM', 'es').format(fecha).toLowerCase();
    return dia;
  }

  static String proximoConHora(DateTime fecha) =>
      '${proximoEvento(fecha)} · ${hora(fecha)}';

  static String moneda(num valor) {
    final formateado = NumberFormat('#,###', 'es').format(valor);
    return '\$$formateado';
  }

  static String estadoVencimiento(DateTime vence) {
    final hoy = DateTime.now();
    final hoySolo = DateTime(hoy.year, hoy.month, hoy.day);
    final venceSolo =
        DateTime(vence.year, vence.month, vence.day);
    final diff = venceSolo.difference(hoySolo).inDays;
    if (diff == 0) return 'Vence hoy';
    if (diff == 1) return 'Vence mañana';
    if (diff < 0) return 'Vencido';
    return 'Vence ${fechaCorta(vence)}';
  }
}
