import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitoapp/firebase_options.dart';
import 'package:habitoapp/models/notificacao_model.dart';
import 'package:habitoapp/models/habito_model.dart';
import 'package:habitoapp/services/notificacao_service.dart';

void main() {
  final service = NotificacaoService();
  const testId = 'notif_teste_001';

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  });

  test('Criar, obter e deletar notificação no Firestore real', () async {
    final habito = Habito(
      id: 'h2',
      nome: 'Meditar',
      frequencia: 'Diário',
      notificacoes: ['07:00'],
      progresso: [],
      categoria: 'Saúde',
      usuarioId: 'u1',
    );

    final notificacao = Notificacao(
      id: testId,
      horario: '07:00',
      mensagem: 'Hora de meditar!',
      habitoRelacionado: habito,
    );

    await service.criarNotificacao(notificacao);

    final lista = await service.obterNotificacoes();
    final existe = lista.any((n) => n.id == testId && n.habitoRelacionado.nome == 'Meditar');
    expect(existe, true);

    await service.deletarNotificacao(testId);
  });
}
