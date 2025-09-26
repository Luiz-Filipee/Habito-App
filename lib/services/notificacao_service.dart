import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:habitoapp/main.dart';
import 'package:habitoapp/utils/hora.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';

class NotificacaoService {
  static final FlutterLocalNotificationsPlugin _notificacoes =
      FlutterLocalNotificationsPlugin();

  static Future<void> inicializar() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
        InitializationSettings(android: androidSettings);

    await _notificacoes.initialize(settings);
  }

  static Future<void> agendarNotificacaoHabito({
    required int id,
    required String nomeHabito,
    required String lembrete,
  }) async {
    final horaMinuto = HoraUtils.parseHora(lembrete);

    if (horaMinuto == null) {
      print('Horário inválido: $lembrete');
      return;
    }

    final int hora = horaMinuto['hora']!;
    final int minuto = horaMinuto['minuto']!;
    final tz.TZDateTime agora = tz.TZDateTime.now(tz.local);

    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      agora.year,
      agora.month,
      agora.day,
      hora,
      minuto,
    );

    if (scheduledDate.isBefore(agora)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _notificacoes.zonedSchedule(
      id,
      'Lembrete de Hábito',
      'Não esqueça de realizar o hábito "$nomeHabito"',
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'habito_channel',
          'Lembretes de Hábito',
          channelDescription: 'Notificações para lembrar de completar hábitos',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
