import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/habito_model.dart';

class HabitoService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> criarHabito(Habito habito) async {
    await _db.collection('habitos').add(habito.toMap());
  }

  Future<List<Habito>> obterHabitos(String usuarioId) async {
    QuerySnapshot snapshot = await _db
        .collection('habitos')
        .where('usuarioId', isEqualTo: usuarioId)
        .get();

    return snapshot.docs.map((doc) {
      return Habito.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  Future<void> atualizarHabito(Habito habito) async {
    await _db.collection('habitos').doc(habito.id).update(habito.toMap());
  }

  Future<void> deletarHabito(String id) async {
    await _db.collection('habitos').doc(id).delete();
  }
}