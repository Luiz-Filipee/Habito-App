import 'package:flutter_test/flutter_test.dart';
import 'package:habitoapp/models/notificacao_model.dart';
import 'package:habitoapp/models/habito_model.dart';

void main() {
  test('Notificacao - fromMap e toMap funcionam corretamente', () {
    final habito = Habito(
      id: 'h1',
      nome: 'Beber água',
      frequencia: 'Diário',
      notificacoes: ['08:00'],
      progresso: [],
      categoria: 'Saúde',
      usuarioId: 'u1',
    );

    final notificacao = Notificacao(
      id: 'n1',
      horario: '08:00',
      mensagem: 'Hora de beber água!',
      habitoRelacionado: habito,
    );

    final map = notificacao.toMap();
    final nova = Notificacao.fromMap(map, 'n1');

    expect(nova.id, 'n1');
    expect(nova.horario, '08:00');
    expect(nova.mensagem, 'Hora de beber água!');
    expect(nova.habitoRelacionado.nome, 'Beber água');
  });
}
