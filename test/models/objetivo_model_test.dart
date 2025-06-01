import 'package:flutter_test/flutter_test.dart';
import 'package:habitoapp/models/objetivo_model.dart';

void main() {
  test('Objetivo - fromMap e toMap funcionam corretamente', () {
    final map = {
      'nome': 'Criar app',
      'descricao': 'Finalizar desenvolvimento do Hábito+',
      'categoria': 'Produtividade'
    };

    final objetivo = Objetivo.fromMap(map, 'o1');

    expect(objetivo.id, 'o1');
    expect(objetivo.nome, 'Criar app');
    expect(objetivo.descricao, 'Finalizar desenvolvimento do Hábito+');
    expect(objetivo.categoria, 'Produtividade');

    final map2 = objetivo.toMap();
    expect(map2['nome'], 'Criar app');
    expect(map2['descricao'], 'Finalizar desenvolvimento do Hábito+');
    expect(map2['categoria'], 'Produtividade');
  });
}
