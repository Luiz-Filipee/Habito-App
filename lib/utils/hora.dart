import 'package:intl/intl.dart';

class HoraUtils {
  static Map<String, int>? parseHora(String horaString) {
    try {
      try {
        final DateFormat amPmFormat = DateFormat.jm();
        final DateTime dt = amPmFormat.parse(horaString);
        return {'hora': dt.hour, 'minuto': dt.minute};
      } catch (_) {}

      if (horaString.contains(':')) {
        final partes = horaString.split(':');
        final int hora = int.parse(partes[0]);
        final int minuto = int.parse(partes[1]);
        return {'hora': hora, 'minuto': minuto};
      }

      final int hora = int.parse(horaString);
      return {'hora': hora, 'minuto': 0};
    } catch (e) {
      print('Erro ao converter hora: $e');
      return null;
    }
  }
}
