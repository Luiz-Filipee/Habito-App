import 'package:flutter_test/flutter_test.dart';
import 'package:habitoapp/models/categoria_model.dart';

void main() {
  test('Categoria - fromMap e toMap funcionam corretamente', () {
    final map = {
      'nome': 'Saúde',
      'descricao': 'Hábitos relacionados à saúde física e mental',
    };

    final categoria = Categoria.fromMap(map, 'c1');

    expect(categoria.id, 'c1');
    expect(categoria.nome, 'Saúde');
    expect(categoria.descricao, 'Hábitos relacionados à saúde física e mental');

    final map2 = categoria.toMap();
    expect(map2['nome'], 'Saúde');
    expect(map2['descricao'], 'Hábitos relacionados à saúde física e mental');
  });
}
