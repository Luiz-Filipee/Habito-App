import 'package:flutter_test/flutter_test.dart';
import 'package:habitoapp/models/medalha_model.dart';

void main() {
  test('Medalha - fromMap e toMap funcionam corretamente', () {
    final map = {
      'nome': 'Persistente',
      'descricao': 'Complete 7 dias seguidos de hábito',
      'imagem': 'persistente.png',
      'requisitos': '7 dias consecutivos'
    };

    final medalha = Medalha.fromMap(map, 'm1');

    expect(medalha.id, 'm1');
    expect(medalha.nome, 'Persistente');
    expect(medalha.descricao, 'Complete 7 dias seguidos de hábito');
    expect(medalha.imagem, 'persistente.png');
    expect(medalha.requisitos, '7 dias consecutivos');

    final map2 = medalha.toMap();

    expect(map2['nome'], 'Persistente');
    expect(map2['descricao'], 'Complete 7 dias seguidos de hábito');
    expect(map2['imagem'], 'persistente.png');
    expect(map2['requisitos'], '7 dias consecutivos');
  });
}
