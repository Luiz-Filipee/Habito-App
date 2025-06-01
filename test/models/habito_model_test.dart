import 'package:flutter_test/flutter_test.dart';
import 'package:habitoapp/models/habito_model.dart';
import 'package:habitoapp/models/registroHabito_model.dart';

void main() {
  test('Criação de hábito via Map', () {
    final map = {
      'nome': 'Beber água',
      'frequencia': 'Diária',
      'notificacoes': ['08:00', '20:00'],
      'progresso': [
        {'id': 'r1', 'data': '2025-05-31', 'feito': true},
        {'id': 'r2', 'data': '2025-06-01', 'feito': false},
      ],
      'categoria': 'Saude',
      'usuarioId': 'u1',
    };
    final habito = Habito.fromMap(map, 'h1');

    expect(habito.id, 'h1');
    expect(habito.nome, 'Beber água');
    expect(habito.frequencia, 'Diária');
    expect(habito.notificacoes, ['08:00', '20:00']);
    expect(habito.progresso.length, 1);
    expect(habito.categoria, 'Saude');
    expect(habito.usuarioId, 'u1');
  });

  test('Conversão de hábito para Map', () {
    final registro = RegistroHabito(
      id: 'r1',
      data: DateTime.parse('2025-05-31T10:00:00Z'),
      concluido: true,
    );

    final habito = Habito(
      id: 'h1',
      nome: 'Ler livro',
      frequencia: 'Ler 20 páginas por dia',
      notificacoes: ['09:00'],
      progresso: [registro],
      categoria: 'Leitura',
      usuarioId: 'u2',
    );

    final map = habito.toMap();

    expect(map['nome'], 'Ler livro');
    expect(map['frequencia'], 'Ler 20 páginas por dia');
    expect(map['notificacoes'], ['09:00']);
    expect(map['progresso'], isA<List>());
    expect(map['categoria'], 'Leitura');
    expect(map['usuarioId'], 'u2');
  });
}
