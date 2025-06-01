import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habitoapp/models/registroHabito_model.dart';

void main() {
  test('RegistroHabito - fromMap e toMap funcionam corretamente', () {
    final now = DateTime.now();
    final timestamp = Timestamp.fromDate(now);

    final map = {
      'data': timestamp,
      'concluido': true,
    };

    final registro = RegistroHabito.fromMap(map, 'r1');

    expect(registro.id, 'r1');
    expect(registro.data, now);
    expect(registro.concluido, true);

    final map2 = registro.toMap();

    expect(map2['data'], isA<Timestamp>());
    expect((map2['data'] as Timestamp).toDate(), registro.data);
    expect(map2['concluido'], registro.concluido);
  });
}
